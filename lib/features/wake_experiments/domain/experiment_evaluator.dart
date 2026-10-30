import 'dart:math' as math;

import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

/// Coverage labels describe sample size, not statistical confidence or causality.
enum ExperimentRecommendation {
  collectMore,
  conclude,
  stopCandidate,
  pauseAll,
  reviewRequired,
}

/// Versioned product heuristics. Changes require a new version and boundary tests.
class ExperimentComparisonPolicy {
  const ExperimentComparisonPolicy();

  int get version => 1;
  int get maximumAttemptsPerVariant => 10;
  double get meaningfulRateDifference => 0.20;
  int get meaningfulLatencyMs => 5000;
  double get meaningfulLatencyFraction => 0.20;
  double get meaningfulSnoozeDifference => 0.50;
  int get severeCheckFailures => 2;
}

/// One original occurrence, not an event, snooze, retry, or subjective rating.
class ExperimentTrialEvidence {
  const ExperimentTrialEvidence({
    required this.assignmentId,
    required this.variant,
    required this.validity,
    required this.scheduledTimeMs,
    required this.completed,
    this.wakeSessionId,
    this.outcome,
    this.wakeEnforcementEnabled = false,
    this.responseLatencyMs,
    this.snoozeCount = 0,
    this.wakeCheckFailureCount = 0,
    this.missionFailureCount = 0,
    this.reactivationCount = 0,
    this.bypassed = false,
    this.configuredIntensity,
    this.confirmedAwakeDurationMs,
    this.invalidReason,
  });

  final String assignmentId;
  final ExperimentVariant variant;
  final SessionValidity validity;
  final int scheduledTimeMs;
  final bool completed, wakeEnforcementEnabled, bypassed;
  final String? wakeSessionId, outcome, invalidReason;
  final int? responseLatencyMs, configuredIntensity, confirmedAwakeDurationMs;
  final int snoozeCount,
      wakeCheckFailureCount,
      missionFailureCount,
      reactivationCount;

  bool get usable =>
      validity == SessionValidity.valid &&
      completed &&
      wakeSessionId != null &&
      const {
        'wakeConfirmed',
        'dismissed',
        'noResponse',
        'bypassed',
      }.contains(outcome) &&
      !(wakeEnforcementEnabled && outcome == 'dismissed') &&
      (responseLatencyMs == null || responseLatencyMs! >= 0) &&
      (confirmedAwakeDurationMs == null || confirmedAwakeDurationMs! >= 0) &&
      snoozeCount >= 0 &&
      wakeCheckFailureCount >= 0 &&
      missionFailureCount >= 0 &&
      reactivationCount >= 0 &&
      (configuredIntensity == null ||
          (configuredIntensity! >= 1 && configuredIntensity! <= 5));

  bool get isBypass => bypassed || outcome == 'bypassed';
  bool get successful =>
      !isBypass && (outcome == 'wakeConfirmed' || outcome == 'dismissed');
}

class ExperimentVariantMetrics {
  ExperimentVariantMetrics(Iterable<ExperimentTrialEvidence> trials)
    : _trials = List.unmodifiable(trials);

  final List<ExperimentTrialEvidence> _trials;
  List<ExperimentTrialEvidence> get _valid =>
      _trials.where((t) => t.usable).toList(growable: false);

  int get attempts => _trials.length;
  int get validSessions => _valid.length;
  int get partialSessions =>
      _trials.where((t) => t.validity == SessionValidity.partial).length;
  int get excludedSessions => attempts - validSessions - partialSessions;
  int get successfulWakes => _valid.where((t) => t.successful).length;
  int get responseSamples =>
      _valid.where((t) => t.responseLatencyMs != null).length;
  int get confirmedAwakeSamples =>
      _valid.where((t) => t.confirmedAwakeDurationMs != null).length;
  int get configuredIntensitySamples =>
      _valid.where((t) => t.configuredIntensity != null).length;
  double? get successRate => _rate((t) => t.successful);
  double? get snoozedSessionRate => _rate((t) => t.snoozeCount > 0);
  double? get checkFailureRate => _rate((t) => t.wakeCheckFailureCount > 0);
  double? get missionFailureRate => _rate((t) => t.missionFailureCount > 0);
  double? get reactivationRate => _rate((t) => t.reactivationCount > 0);
  double? get bypassRate => _rate((t) => t.isBypass);
  double? get meanSnoozes => _mean(_valid.map((t) => t.snoozeCount));
  double? get meanResponseMs =>
      _mean(_valid.map((t) => t.responseLatencyMs).nonNulls);
  double? get medianResponseMs =>
      _median(_valid.map((t) => t.responseLatencyMs).nonNulls);
  double? get meanConfiguredIntensity =>
      _mean(_valid.map((t) => t.configuredIntensity).nonNulls);
  double? get medianConfirmedAwakeMs =>
      _median(_valid.map((t) => t.confirmedAwakeDurationMs).nonNulls);

  double? _rate(bool Function(ExperimentTrialEvidence) predicate) =>
      validSessions == 0
      ? null
      : _valid.where(predicate).length / validSessions;

  Map<String, Object?> toJson() => {
    'attempts': attempts,
    'validSessions': validSessions,
    'partialSessions': partialSessions,
    'excludedSessions': excludedSessions,
    'successfulWakes': successfulWakes,
    'successRate': successRate,
    'responseSamples': responseSamples,
    'meanResponseMs': meanResponseMs,
    'medianResponseMs': medianResponseMs,
    'meanSnoozes': meanSnoozes,
    'snoozedSessionRate': snoozedSessionRate,
    'checkFailureRate': checkFailureRate,
    'missionFailureRate': missionFailureRate,
    'reactivationRate': reactivationRate,
    'bypassRate': bypassRate,
    'meanConfiguredIntensity': meanConfiguredIntensity,
    'configuredIntensitySamples': configuredIntensitySamples,
    'confirmedAwakeSamples': confirmedAwakeSamples,
    'medianConfirmedAwakeMs': medianConfirmedAwakeMs,
  };
}

class ExperimentComparison {
  const ExperimentComparison({
    required this.control,
    required this.candidate,
    required this.outcome,
    required this.confidence,
    required this.recommendation,
    required this.reason,
    required this.policyVersion,
  });

  final ExperimentVariantMetrics control, candidate;
  final ExperimentOutcome outcome;
  final ExperimentConfidence confidence;
  final ExperimentRecommendation recommendation;
  final String reason;
  final int policyVersion;

  Map<String, Object?> toJson() => {
    'policyVersion': policyVersion,
    'outcome': outcome.name,
    'coverage': confidence.name,
    'recommendation': recommendation.name,
    'reason': reason,
    'control': control.toJson(),
    'candidate': candidate.toJson(),
  };
}

/// Read-only decisions: never changes a schedule, promotes a choice, or learns.
class ExperimentEvaluator {
  const ExperimentEvaluator({this.policy = const ExperimentComparisonPolicy()});

  final ExperimentComparisonPolicy policy;

  ExperimentComparison evaluate({
    required Iterable<ExperimentTrialEvidence> evidence,
    int minimumSessions = 3,
    int preferredSessions = 5,
    int maximumSessions = 10,
  }) {
    if (minimumSessions < 3 ||
        preferredSessions < minimumSessions ||
        maximumSessions < preferredSessions ||
        maximumSessions > 100) {
      throw ArgumentError(
        'Require 3 <= minimum <= preferred <= maximum <= 100.',
      );
    }
    final trials = evidence.toList()
      ..sort((a, b) {
        final time = a.scheduledTimeMs.compareTo(b.scheduledTimeMs);
        return time != 0 ? time : a.assignmentId.compareTo(b.assignmentId);
      });
    // Duplicate identity is structural corruption, never another valid sample.
    final assignments = <String>{}, sessions = <String>{};
    var duplicate = false;
    for (final t in trials) {
      if (!assignments.add(t.assignmentId) ||
          (t.wakeSessionId != null && !sessions.add(t.wakeSessionId!))) {
        duplicate = true;
      }
    }
    final controlTrials = trials
        .where((t) => t.variant == ExperimentVariant.control)
        .toList();
    final candidateTrials = trials
        .where((t) => t.variant == ExperimentVariant.candidate)
        .toList();
    final control = ExperimentVariantMetrics(controlTrials);
    final candidate = ExperimentVariantMetrics(candidateTrials);
    final coverage = math.min(control.validSessions, candidate.validSessions);
    final confidence = coverage < minimumSessions
        ? ExperimentConfidence.insufficient
        : coverage < preferredSessions
        ? ExperimentConfidence.limited
        : ExperimentConfidence.adequate;

    ExperimentComparison result(
      ExperimentOutcome outcome,
      ExperimentRecommendation action,
      String reason,
    ) => ExperimentComparison(
      control: control,
      candidate: candidate,
      outcome: outcome,
      confidence: confidence,
      recommendation: action,
      reason: reason,
      policyVersion: policy.version,
    );

    if (duplicate) {
      return result(
        ExperimentOutcome.invalidated,
        ExperimentRecommendation.reviewRequired,
        'A wake or assignment was included more than once. Review the evidence.',
      );
    }
    // Safety precedes sample counts. A stop is not a sufficiently sampled winner.
    bool unsafe(List<ExperimentTrialEvidence> rows) {
      var noResponseStreak = 0;
      for (final t in rows) {
        if (!t.usable) {
          // Missing evidence is not a successful response and cannot clear risk.
          continue;
        }
        if (t.isBypass ||
            t.wakeCheckFailureCount >= policy.severeCheckFailures) {
          return true;
        }
        noResponseStreak = t.outcome == 'noResponse' ? noResponseStreak + 1 : 0;
        if (noResponseStreak >= 2) return true;
      }
      return false;
    }

    if (unsafe(controlTrials)) {
      return result(
        ExperimentOutcome.insufficientData,
        ExperimentRecommendation.pauseAll,
        'The usual choice had a serious wake failure. Pause the test and review alarm safety.',
      );
    }
    if (unsafe(candidateTrials)) {
      return result(
        ExperimentOutcome.insufficientData,
        ExperimentRecommendation.stopCandidate,
        'The new choice had a serious wake failure. Stop trying it and use the usual choice.',
      );
    }
    final attemptCap = math.min(
      maximumSessions,
      policy.maximumAttemptsPerVariant,
    );
    final exhausted =
        control.attempts >= attemptCap || candidate.attempts >= attemptCap;
    if (coverage < minimumSessions) {
      return result(
        ExperimentOutcome.insufficientData,
        exhausted
            ? ExperimentRecommendation.reviewRequired
            : ExperimentRecommendation.collectMore,
        exhausted
            ? 'The attempt limit was reached without enough complete wakes. Review missing evidence.'
            : 'Not enough complete wakes for both choices yet.',
      );
    }
    if (trials.any((t) => t.validity == SessionValidity.partial)) {
      return result(
        ExperimentOutcome.insufficientData,
        exhausted
            ? ExperimentRecommendation.reviewRequired
            : ExperimentRecommendation.collectMore,
        'Some reserved wakes are still unfinished. Wait for their outcomes before choosing.',
      );
    }

    // A faster response cannot compensate for worse reliability on ANY axis.
    bool noWorse(ExperimentVariantMetrics a, ExperimentVariantMetrics b) =>
        a.successRate! >= b.successRate! &&
        a.checkFailureRate! <= b.checkFailureRate! &&
        a.missionFailureRate! <= b.missionFailureRate! &&
        a.reactivationRate! <= b.reactivationRate! &&
        a.bypassRate! <= b.bypassRate!;

    (int, String)? advantage(
      ExperimentVariantMetrics a,
      ExperimentVariantMetrics b,
    ) {
      if (!noWorse(a, b)) return null;
      const epsilon = 1e-9;
      if (a.successRate! - b.successRate! + epsilon >=
          policy.meaningfulRateDifference) {
        return (1, 'more successful wakes');
      }
      if (b.checkFailureRate! - a.checkFailureRate! + epsilon >=
          policy.meaningfulRateDifference) {
        return (2, 'fewer missed follow-up checks');
      }
      if (a.responseSamples == a.validSessions &&
          b.responseSamples == b.validSessions) {
        final reduction = b.medianResponseMs! - a.medianResponseMs!;
        if (reduction >= policy.meaningfulLatencyMs &&
            reduction + epsilon >=
                b.medianResponseMs! * policy.meaningfulLatencyFraction) {
          return (3, 'a meaningfully quicker first response');
        }
      }
      if (b.meanSnoozes! - a.meanSnoozes! + epsilon >=
          policy.meaningfulSnoozeDifference) {
        return (4, 'fewer snoozes');
      }
      return null;
    }

    final candidateAdvantage = advantage(candidate, control);
    final controlAdvantage = advantage(control, candidate);
    if (candidateAdvantage != null &&
        (controlAdvantage == null ||
            candidateAdvantage.$1 < controlAdvantage.$1)) {
      return result(
        ExperimentOutcome.candidateBetter,
        ExperimentRecommendation.conclude,
        'The new choice had ${candidateAdvantage.$2}, without worse recorded wake reliability.',
      );
    }
    if (controlAdvantage != null &&
        (candidateAdvantage == null ||
            controlAdvantage.$1 < candidateAdvantage.$1)) {
      return result(
        ExperimentOutcome.controlBetter,
        ExperimentRecommendation.conclude,
        'The usual choice had ${controlAdvantage.$2}, without worse recorded wake reliability.',
      );
    }
    return result(
      ExperimentOutcome.noClearWinner,
      exhausted || coverage >= maximumSessions
          ? ExperimentRecommendation.conclude
          : ExperimentRecommendation.collectMore,
      'Neither choice has a clear advantage. This does not prove they are equally effective.',
    );
  }
}

double? _mean(Iterable<int> values) {
  final list = values.toList();
  return list.isEmpty
      ? null
      : list.fold<double>(0, (sum, v) => sum + v) / list.length;
}

double? _median(Iterable<int> values) {
  final list = values.toList()..sort();
  if (list.isEmpty) return null;
  final middle = list.length ~/ 2;
  return list.length.isOdd
      ? list[middle].toDouble()
      : (list[middle - 1] + list[middle]) / 2;
}
