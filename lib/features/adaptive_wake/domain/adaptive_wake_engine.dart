import 'dart:convert';

import 'package:ryser/features/adaptive_wake/domain/adaptive_decision.dart';
import 'package:ryser/features/adaptive_wake/domain/adaptive_thresholds.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_session_analyzer.dart';

class AdaptiveContext {
  const AdaptiveContext({
    required this.current,
    required this.policy,
    required this.recent,
    this.alternativeSoundId,
    this.alternativeSoundFamily,
    this.alternativeRingtoneUri,
    this.soundDeclining = false,
  });
  final WakeProtocol current;
  final AlarmAdaptationPolicy policy;

  /// Comparable session analyses in descending occurrence order.
  final List<WakeSessionAnalysis> recent;
  final String? alternativeSoundId;
  final String? alternativeSoundFamily;
  final String? alternativeRingtoneUri;
  final bool soundDeclining;

  List<WakeSessionAnalysis> get valid =>
      recent.where((s) => s.validForAdaptation).toList(growable: false);
  int recentCount(bool Function(WakeSessionAnalysis) matches) =>
      valid.take(3).where(matches).length;
  double weightedRate(bool Function(WakeSessionAnalysis) matches) {
    final rows = valid;
    var total = 0.0, matching = 0.0;
    // Group budgets prevent a large old history from drowning recent behavior.
    for (final group in [
      (0, 3, AdaptiveThresholds.recentWeight),
      (3, 4, AdaptiveThresholds.moderateWeight),
      (7, rows.length, AdaptiveThresholds.historicalWeight),
    ]) {
      final samples = rows.skip(group.$1).take(group.$2).toList();
      if (samples.isEmpty) continue;
      total += group.$3;
      matching += group.$3 * samples.where(matches).length / samples.length;
    }
    return total == 0 ? 0 : matching / total;
  }

  bool repeated(bool Function(WakeSessionAnalysis) matches) =>
      recentCount(matches) >= 2 && weightedRate(matches) + 1e-9 >= 0.4;
}

abstract interface class AdaptiveRule {
  String get id;
  int get priority;
  bool get permitsEarlyEvaluation;
  bool matches(AdaptiveContext context);
  RuleProposal? propose(AdaptiveContext context);
}

class RuleProposal {
  const RuleProposal(
    this.reason,
    this.explanation,
    this.change, {
    this.automatic = true,
    this.severity = 'ordinary',
  });
  final AdaptiveReasonCode reason;
  final String explanation;
  final AdaptiveChange? change;
  final bool automatic;
  final String severity;
}

class _Rule implements AdaptiveRule {
  const _Rule(
    this.id,
    this.priority,
    this.trigger,
    this.proposal, {
    this.permitsEarlyEvaluation = false,
  });
  @override
  final String id;
  @override
  final int priority;
  final bool Function(AdaptiveContext) trigger;
  final RuleProposal? Function(AdaptiveContext) proposal;
  @override
  final bool permitsEarlyEvaluation;
  @override
  bool matches(AdaptiveContext c) => trigger(c);
  @override
  RuleProposal? propose(AdaptiveContext c) => proposal(c);
}

bool _has(WakeSessionAnalysis s, WakeFailureMode f) =>
    s.primaryFailureMode == f || s.secondaryFailureModes.contains(f);
bool _slow(WakeSessionAnalysis s) =>
    s.response == ResponseLatencyClassification.slow ||
    s.response == ResponseLatencyClassification.verySlow;

class AdaptiveWakeEngine {
  const AdaptiveWakeEngine();

  List<AdaptiveRule> get rules => [
    _Rule(
      'no_response_repeated',
      0,
      (c) => c.valid.take(1).any((s) => _has(s, WakeFailureMode.noResponse)),
      _noResponse,
      permitsEarlyEvaluation: true,
    ),
    _Rule(
      'wake_check_failure_repeated',
      20,
      (c) => c.repeated((s) => _has(s, WakeFailureMode.wakeCheckFailure)),
      _wakeCheck,
    ),
    _Rule(
      'mission_failure_repeated',
      30,
      (c) => c.repeated((s) => _has(s, WakeFailureMode.missionFailure)),
      _mission,
    ),
    _Rule(
      'emergency_bypass_repeated',
      35,
      (c) =>
          c.recent
              .take(7)
              .where((s) => _has(s, WakeFailureMode.emergencyBypass))
              .length >=
          2,
      (_) => const RuleProposal(
        AdaptiveReasonCode.emergencyBypassRepeated,
        'Emergency stop was needed repeatedly. Review the mission or choose another practical mission type.',
        null,
        automatic: false,
        severity: 'review',
      ),
      permitsEarlyEvaluation: true,
    ),
    _Rule(
      'slow_response_repeated',
      40,
      (c) => c.repeated(_slow),
      _slowResponse,
    ),
    _Rule(
      'high_snooze_repeated',
      50,
      (c) => c.repeated((s) => s.snoozes == SnoozeClassification.high),
      _highSnooze,
    ),
    _Rule(
      'sound_effectiveness_decline',
      60,
      (c) =>
          c.soundDeclining &&
          !c.valid
              .take(3)
              .every((s) => s.response == ResponseLatencyClassification.fast),
      (c) => _sound(
        c,
        AdaptiveReasonCode.soundEffectivenessDecline,
        'Sound effectiveness may be declining. Repeated median response times worsened, so Ryser will try another family.',
      ),
    ),
    _Rule(
      'success_streak',
      70,
      (c) =>
          c.valid.length >= 3 &&
          c.valid
              .take(3)
              .every(
                (s) =>
                    s.confirmedWake &&
                    s.primaryFailureMode == WakeFailureMode.none &&
                    s.response == ResponseLatencyClassification.fast &&
                    s.snoozes != SnoozeClassification.moderate &&
                    s.snoozes != SnoozeClassification.high,
              ),
      _success,
    ),
  ]..sort((a, b) => a.priority.compareTo(b.priority));

  AdaptiveDecision decide(AdaptiveContext context) {
    if (!context.policy.enabled) {
      return const AdaptiveDecision(
        selectedRuleId: null,
        reasonCode: AdaptiveReasonCode.manualUserOverride,
        changes: [],
        technicalExplanation: 'Adaptive Wake is paused.',
        userExplanation: 'Adaptive Wake is paused.',
        rulesEvaluated: [],
        rulesMatched: [],
        shouldApplyAutomatically: false,
      );
    }
    final evaluated = <String>[], matched = <String>[];
    final rejected = <String, String>{};
    AdaptiveRule? selected;
    RuleProposal? chosen;
    for (final rule in rules) {
      evaluated.add(rule.id);
      if (!rule.matches(context)) {
        rejected[rule.id] = 'Trigger not met by the recorded evidence.';
        continue;
      }
      matched.add(rule.id);
      if (context.valid.length < 3 && !rule.permitsEarlyEvaluation) {
        rejected[rule.id] = 'Collect at least three comparable valid wakes.';
        continue;
      }
      final proposal = rule.propose(context);
      if (proposal == null) {
        rejected[rule.id] = 'User lock, configured bound, or unavailable executable alternative.';
        continue;
      }
      if (selected != null) {
        rejected[rule.id] =
            'Higher-priority rule ${selected.id} selected; one major change allowed.';
        continue;
      }
      selected = rule;
      chosen = proposal;
    }
    final change = chosen?.change;
    return AdaptiveDecision(
      selectedRuleId: selected?.id,
      reasonCode: chosen?.reason ?? AdaptiveReasonCode.insufficientData,
      changes: change == null
          ? const []
          : [
              AdaptiveChange(
                dimension: change.dimension,
                oldValue: change.oldValue,
                newValue: change.newValue,
                evidence: change.evidence,
                soundUri: change.soundUri,
                soundFamily: change.soundFamily,
                field: change.field,
                priority: selected!.priority,
                reasonCode: chosen!.reason,
              ),
            ],
      technicalExplanation:
          chosen?.explanation ??
          'No repeated evidence justified an allowed change.',
      userExplanation: chosen?.explanation ?? 'No change: more comparable evidence or an allowed setting is needed.',
      rulesEvaluated: evaluated,
      rulesMatched: matched,
      rejectedRules: rejected,
      severity: chosen?.severity ?? 'none',
      shouldApplyAutomatically: chosen?.automatic == true && change != null,
    );
  }
}

RuleProposal? _volume(
  AdaptiveContext c,
  int amount,
  AdaptiveReasonCode reason,
  String why, {
  String severity = 'ordinary',
}) {
  if (c.policy.volume != AdaptiveMode.adaptive) return null;
  final old = c.current.initialVolumePercent;
  final next = (old + amount).clamp(30, c.policy.userMaxVolumePercent);
  if (old == next) return null;
  return RuleProposal(
    reason,
    why,
    AdaptiveChange(
      dimension: AdaptiveDimension.volume,
      oldValue: old,
      newValue: next,
      field: 'initialVolumePercent',
      evidence: why,
    ),
    severity: severity,
  );
}

RuleProposal? _sound(AdaptiveContext c, AdaptiveReasonCode reason, String why) {
  if (c.policy.sound != AdaptiveMode.adaptive ||
      c.alternativeSoundId == null ||
      c.alternativeRingtoneUri?.isNotEmpty != true ||
      c.alternativeSoundFamily == c.current.initialSoundFamily) {
    return null;
  }
  return RuleProposal(
    reason,
    why,
    AdaptiveChange(
      dimension: AdaptiveDimension.sound,
      oldValue: c.current.initialSoundId,
      newValue: c.alternativeSoundId,
      soundUri: c.alternativeRingtoneUri,
      soundFamily: c.alternativeSoundFamily,
      evidence: why,
    ),
  );
}

RuleProposal? _noResponse(AdaptiveContext c) => _volume(
  c,
  10,
  AdaptiveReasonCode.noResponse,
  'A completed alarm had no recorded response. Ryser will raise only the starting playback level within your cap.',
  severity: 'severe',
);
RuleProposal? _wakeCheck(AdaptiveContext c) {
  if (c.policy.wakeCheck != AdaptiveMode.adaptive ||
      !c.current.wakeCheckRequired) {
    return null;
  }
  final p = c.current;
  final String field;
  final Object old, next;
  if (p.wakeCheckDelayMinutes > 5) {
    field = 'wakeCheckDelayMinutes';
    old = p.wakeCheckDelayMinutes;
    next = p.wakeCheckDelayMinutes > 7 ? 7 : 5;
  } else if (p.wakeCheckHoldMilliseconds < 4000) {
    field = 'wakeCheckHoldMilliseconds';
    old = p.wakeCheckHoldMilliseconds;
    next = (p.wakeCheckHoldMilliseconds + 500).clamp(1500, 4000);
  } else if (p.reactivationSoundPolicy !=
      ReactivationSoundPolicy.alternateFamily) {
    field = 'reactivationSoundPolicy';
    old = p.reactivationSoundPolicy.name;
    next = ReactivationSoundPolicy.alternateFamily.name;
  } else {
    return null;
  }
  final why =
      'At least two of the last three comparable wakes missed verification. Ryser will adjust only $field ($old → $next).';
  return RuleProposal(
    AdaptiveReasonCode.wakeCheckFailureRepeated,
    why,
    AdaptiveChange(
      dimension: AdaptiveDimension.wakeCheck,
      oldValue: old,
      newValue: next,
      field: field,
      evidence: why,
    ),
  );
}

RuleProposal? _mission(AdaptiveContext c) {
  if (c.policy.mission != AdaptiveMode.adaptive || !c.current.missionRequired) {
    return null;
  }
  final config =
      jsonDecode(c.current.missionConfigurationJson) as Map<String, dynamic>;
  final field = c.current.missionType == 'jumping'
      ? 'requiredJumps'
      : 'requiredSteps';
  final old = config[field];
  if (old is! int) {
    return const RuleProposal(
      AdaptiveReasonCode.missionFailureRepeated,
      'The mission failed repeatedly. Review its placement or choose another practical mission type.',
      null,
      automatic: false,
      severity: 'review',
    );
  }
  final minimum = field == 'requiredJumps' ? 5 : 10;
  if (old <= minimum) {
    return const RuleProposal(
      AdaptiveReasonCode.missionFailureRepeated,
      'The mission failed repeatedly at minimum difficulty. Consider another mission type.',
      null,
      automatic: false,
      severity: 'review',
    );
  }
  final next = field == 'requiredJumps'
      ? (old - 5).clamp(5, 20)
      : old > 20
      ? 20
      : 10;
  final why =
      'Repeated mission failures justify reducing $field from $old to $next, without increasing alarm intensity.';
  return RuleProposal(
    AdaptiveReasonCode.missionFailureRepeated,
    why,
    AdaptiveChange(
      dimension: AdaptiveDimension.mission,
      oldValue: old,
      newValue: next,
      field: field,
      evidence: why,
    ),
  );
}

RuleProposal? _slowResponse(AdaptiveContext c) {
  final first = _sound(
    c,
    AdaptiveReasonCode.slowResponseRepeated,
    'At least two of the last three comparable wakes had slow initial responses. Ryser will try another sound family.',
  );
  if (first != null) return first;
  final volume = _volume(
    c,
    10,
    AdaptiveReasonCode.slowResponseRepeated,
    'Repeated slow initial responses justify a small increase in starting playback.',
  );
  if (volume != null) return volume;
  if (c.policy.vibration == AdaptiveMode.adaptive &&
      c.current.vibrationEnabled &&
      c.current.vibrationPattern == VibrationPattern.standard) {
    return const RuleProposal(
      AdaptiveReasonCode.slowResponseRepeated,
      'Repeated slow initial responses justify trying a different vibration pattern.',
      AdaptiveChange(
        dimension: AdaptiveDimension.vibration,
        oldValue: 'standard',
        newValue: 'doublePulse',
        evidence: 'Repeated slow initial responses.',
      ),
    );
  }
  return null;
}

RuleProposal? _highSnooze(AdaptiveContext c) =>
    _sound(
      c,
      AdaptiveReasonCode.highSnoozeCount,
      'At least two of the last three comparable wakes had three or more snoozes. Ryser will try another sound family.',
    ) ??
    _volume(
      c,
      5,
      AdaptiveReasonCode.highSnoozeCount,
      'Repeated high snooze counts justify a small increase in starting playback.',
    );
RuleProposal? _success(AdaptiveContext c) => _volume(
  c,
  -10,
  AdaptiveReasonCode.successStreak,
  'The last three comparable wakes were confirmed, fast, and had at most one snooze. Ryser will reduce only starting playback.',
);
