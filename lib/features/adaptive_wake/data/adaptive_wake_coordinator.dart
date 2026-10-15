import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/database/app_database.dart' hide WakeProtocol;
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/adaptive_decision.dart';
import 'package:ryser/features/adaptive_wake/domain/adaptive_thresholds.dart';
import 'package:ryser/features/adaptive_wake/domain/adaptive_wake_engine.dart';
import 'package:ryser/features/adaptive_wake/domain/protocol_validator.dart';
import 'package:ryser/features/adaptive_wake/domain/protocol_diff.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_session_analyzer.dart';
import 'package:ryser/features/alarms/domain/alarm.dart' as domain;
import 'package:ryser/features/alarms/domain/next_occurrence.dart';
import 'package:ryser/features/sounds/data/sound_performance_repository.dart';
import 'package:ryser/features/sounds/domain/bundled_sound_catalog.dart';
import 'package:uuid/uuid.dart';

class AdaptiveWakeCoordinator {
  AdaptiveWakeCoordinator(
    this._database,
    this._protocols,
    this._runtime, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final AppDatabase _database;
  final WakeProtocolRepository _protocols;
  final AlarmRuntimeGateway _runtime;
  final DateTime Function() _clock;
  final WakeSessionAnalyzer _analyzer = const WakeSessionAnalyzer();
  final AdaptiveWakeEngine _engine = const AdaptiveWakeEngine();
  final WakeProtocolValidator _validator = const WakeProtocolValidator();

  Future<int> processPending() async {
    final sessions =
        await (_database.select(_database.wakeSessions)
              ..where(
                (row) =>
                    row.completedAtMs.isNotNull() &
                    row.analysisStatus.equals('pending'),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.completedAtMs)]))
            .get();
    var processed = 0;
    for (final session in sessions) {
      if (await _process(session)) processed++;
    }
    return processed;
  }

  Future<bool> _process(WakeSession session) async {
    final duplicate = await (_database.select(
      _database.protocolEvaluations,
    )..where((row) => row.wakeSessionId.equals(session.id))).getSingleOrNull();
    if (duplicate != null) {
      await _markAnalyzed(session.id);
      return false;
    }
    // V2 sessions have no immutable protocol snapshot and are not eligible to
    // drive adaptive decisions. Preserve them without fabricating provenance.
    if (session.protocolId == null || session.protocolVersion == null) {
      await _markAnalyzed(session.id);
      return false;
    }
    final current = await _protocols.findById(session.protocolId!);
    if (current == null) {
      await _markAnalyzed(session.id);
      return false;
    }
    final active = await _protocols.activeForAlarm(session.alarmId);
    final policy = await _protocols.policyForAlarm(session.alarmId);
    final recentRows =
        await (_database.select(_database.wakeSessions)
              ..where(
                (row) =>
                    row.alarmId.equals(session.alarmId) &
                    row.completedAtMs.isNotNull() &
                    row.completedAtMs.isSmallerOrEqualValue(
                      session.completedAtMs!,
                    ) &
                    row.triggeredAtMs.isSmallerOrEqualValue(
                      session.triggeredAtMs,
                    ),
              )
              ..orderBy([(row) => OrderingTerm.desc(row.triggeredAtMs)])
              ..limit(30))
            .get();
    final analyses = <WakeSessionAnalysis>[];
    for (var index = 0; index < recentRows.length; index++) {
      analyses.add(
        _analyzer.analyze(
          await _evidence(recentRows[index]),
          comparableValidSessionCount: recentRows
              .skip(index)
              .where(
                (row) =>
                    row.completedAtMs != null &&
                    row.protocolId == current.id &&
                    !const {
                      'active',
                      'incomplete',
                      'cancelled',
                      'bypassed',
                      'manualTermination',
                    }.contains(row.outcome),
              )
              .length,
        ),
      );
    }
    final eligibleAnalyses = <WakeSessionAnalysis>[
      for (var index = 0; index < recentRows.length; index++)
        if (recentRows[index].protocolId == current.id) analyses[index],
    ];
    final soundStats = await SoundPerformanceRepository(_database)
        .load(alarmId: session.alarmId, throughMs: session.completedAtMs);
    final alternatives = BundledSoundCatalog.sounds
        .where((s) => s.family != current.initialSoundFamily)
        .toList();
    double rank(String uri) {
      final stats = soundStats.where((s) => s.soundUri == uri).firstOrNull;
      if (stats == null) return -1;
      return (stats.recentMedianResponseLatencyMs ?? 30000) / 1000 +
          stats.snoozeRate * 10 +
          stats.wakeCheckFailureRate * 20 +
          (stats.effectivenessDeclining ? 30 : 0) +
          stats.consecutiveUses * 2;
    }

    alternatives.sort((a, b) {
      final score = rank(a.uri).compareTo(rank(b.uri));
      return score != 0 ? score : a.id.compareTo(b.id);
    });
    final alternative = alternatives.firstOrNull;
    final soundDeclining = soundStats.any(
      (item) =>
          item.soundUri == current.ringtoneUri && item.effectivenessDeclining,
    );
    final currentEvidence = await _evidence(
      session,
      soundDeclining: soundDeclining,
    );
    final currentAnalysis = _analyzer.analyze(
      currentEvidence,
      comparableValidSessionCount: eligibleAnalyses
          .where((s) => s.validForAdaptation)
          .length,
    );
    var decision = _engine.decide(
      AdaptiveContext(
        current: current,
        policy: active?.id == current.id
            ? policy
            : AlarmAdaptationPolicy(
                enabled: false,
                sound: policy.sound,
                volume: policy.volume,
                vibration: policy.vibration,
                wakeCheck: policy.wakeCheck,
                mission: policy.mission,
                userMaxVolumePercent: policy.userMaxVolumePercent,
              ),
        recent: eligibleAnalyses,
        alternativeSoundId: alternative?.id,
        alternativeSoundFamily: alternative?.family,
        alternativeRingtoneUri: alternative?.uri,
        soundDeclining: soundDeclining,
      ),
    );
    WakeProtocol? next;
    if (!currentAnalysis.validForAdaptation && decision.hasChange) {
      decision = _validationRejected(decision, const [
        'session_not_eligible_for_training',
      ]);
    }
    final revertTarget =
        currentAnalysis.validForAdaptation &&
            active?.id == current.id &&
            policy.enabled
        ? await _findRevertTarget(current, session.completedAtMs!)
        : null;
    if (revertTarget != null) {
      decision = AdaptiveDecision(
        selectedRuleId: 'performance_worsened_revert',
        reasonCode: AdaptiveReasonCode.performanceWorsened,
        changes: protocolDiff(
          current,
          revertTarget,
          'Two comparable uses worsened the metric targeted by this change.',
        ),
        technicalExplanation: 'The current adaptive protocol repeatedly performed worse than its predecessor.',
        userExplanation: 'The recent change did not help, so Ryser will return to the previous setup.',
        rulesEvaluated: const ['performance_worsened_revert'],
        rulesMatched: const ['performance_worsened_revert'],
        shouldApplyAutomatically: true,
      );
      final now = _clock();
      next = revertTarget.copyWith(
        id: const Uuid().v4(),
        version: current.version + 1,
        source: WakeProtocolSource.recovery,
        status: WakeProtocolStatus.active,
        reasonCode: AdaptiveReasonCode.performanceWorsened,
        technicalExplanation: decision.technicalExplanation,
        userExplanation: decision.userExplanation,
        basedOnSessionId: session.id,
        supersedesProtocolId: current.id,
        createdAt: now,
        effectiveFrom: now,
      );
      final validation = _validator.validate(
        next,
        policy: policy,
        soundExists: await _runtime.isSoundAvailable(next.ringtoneUri),
        vibrationSupported: await _runtime.canVibrate(),
        missionAvailable:
            !next.missionRequired ||
            await (_database.select(_database.missions)..where(
                      (row) =>
                          row.alarmId.equals(current.alarmId) &
                          row.enabled.equals(true),
                    ))
                    .getSingleOrNull() !=
                null,
        previous: current,
      );
      if (!validation.isValid) {
        next = null;
        decision = _validationRejected(decision, validation.errors);
      }
    } else if (decision.hasChange && decision.shouldApplyAutomatically) {
      final proposed = _applyDecision(current, decision, session.id);
      final missionAvailable =
          !proposed.missionRequired ||
          await (_database.select(_database.missions)..where(
                    (row) =>
                        row.alarmId.equals(proposed.alarmId) &
                        row.enabled.equals(true),
                  ))
                  .getSingleOrNull() !=
              null;
      final validation = _validator.validate(
        proposed,
        policy: policy,
        soundExists: await _runtime.isSoundAvailable(proposed.ringtoneUri),
        vibrationSupported: await _runtime.canVibrate(),
        missionAvailable:
            missionAvailable &&
            (!proposed.missionRequired ||
                await _runtime.isMissionAvailable(proposed.missionType ?? '')),
        previous: current,
      );
      if (validation.isValid) {
        next = proposed;
      } else {
        decision = _validationRejected(decision, validation.errors);
      }
    }

    if (next != null) {
      try {
        if (!await _scheduleNext(next)) {
          next = null;
          decision = _scheduleRejected(decision);
        }
      } catch (_) {
        next = null;
        decision = _scheduleRejected(decision);
      }
    }

    try {
      await _database.transaction(() async {
        if (next != null) {
          await _protocols.insertAndActivate(next);
          if (next?.reasonCode == AdaptiveReasonCode.performanceWorsened) {
            await (_database.update(_database.wakeProtocols)
                  ..where((p) => p.id.equals(current.id)))
                .write(const WakeProtocolsCompanion(status: Value('reverted')));
          }
        }
        await _database
            .into(_database.protocolEvaluations)
            .insert(
              ProtocolEvaluationsCompanion.insert(
                id: const Uuid().v4(),
                protocolId: current.id,
                wakeSessionId: session.id,
                result: next == null ? 'kept' : 'changed',
                primaryFailureMode: currentAnalysis.primaryFailureMode.name,
                analysisJson: jsonEncode({
                  ..._analysisJson(currentAnalysis),
                  'responseLatencyMs': currentEvidence.responseLatencyMs,
                  'snoozeCount': currentEvidence.snoozeCount,
                  'missionFailureCount': currentEvidence.missionFailureCount,
                  'wakeCheckFailureCount':
                      currentEvidence.wakeCheckFailureCount,
                  'reactivationCount': currentEvidence.reactivationCount,
                  'heuristicVersion': AdaptiveThresholds.version,
                  'outcome': session.outcome,
                  'protocolId': current.id,
                  'protocolVersion': current.version,
                  'comparisonSessionIds': eligibleAnalyses
                      .map((s) => s.sessionId)
                      .toList(),
                  'evidenceThroughMs': session.completedAtMs,
                  'userExplanation': decision.userExplanation,
                  'severity': decision.severity,
                  'nextProtocolId': next?.id,
                  'nextProtocolVersion': next?.version,
                }),
                selectedRuleId: Value(decision.selectedRuleId),
                ruleTraceJson: Value(
                  jsonEncode({
                    'evaluated': decision.rulesEvaluated,
                    'matched': decision.rulesMatched,
                    'rejected': decision.rejectedRules,
                  }),
                ),
                changesJson: Value(jsonEncode(_changesJson(decision.changes))),
                evaluationNotes: Value(decision.technicalExplanation),
                createdAtMs: _clock().millisecondsSinceEpoch,
              ),
            );
        await (_database.update(
          _database.wakeSessions,
        )..where((row) => row.id.equals(session.id))).write(
          const WakeSessionsCompanion(analysisStatus: Value('completed')),
        );
      });
    } catch (_) {
      // A native schedule may have succeeded before the database transaction.
      // Restore the last persisted protocol rather than leave an orphaned
      // protocol snapshot scheduled as the next alarm.
      if (next != null) {
        try {
          await _scheduleNext(current);
        } catch (_) {
          // The alarm's native fallback remains responsible for ringing.
        }
      }
      rethrow;
    }
    return true;
  }

  AdaptiveDecision _validationRejected(
    AdaptiveDecision original,
    List<String> errors,
  ) => AdaptiveDecision(
    selectedRuleId: original.selectedRuleId,
    reasonCode: original.reasonCode,
    changes: const [],
    technicalExplanation:
        'Proposed protocol rejected: ${errors.join(', ')}. Existing alarm retained.',
    userExplanation: 'The proposed change is not executable within your settings. Your existing alarm remains active.',
    rulesEvaluated: original.rulesEvaluated,
    rulesMatched: original.rulesMatched,
    rejectedRules: {
      ...original.rejectedRules,
      if (original.selectedRuleId != null)
        original.selectedRuleId!: errors.join(', '),
    },
    shouldApplyAutomatically: false,
    severity: original.severity,
  );

  AdaptiveDecision _scheduleRejected(
    AdaptiveDecision original,
  ) => AdaptiveDecision(
    selectedRuleId: original.selectedRuleId,
    reasonCode: original.reasonCode,
    changes: const [],
    technicalExplanation:
        '${original.technicalExplanation} Android rejected the replacement schedule; the existing protocol remains active.',
    userExplanation: 'The proposed change could not be scheduled, so your existing alarm settings remain active.',
    rulesEvaluated: original.rulesEvaluated,
    rulesMatched: original.rulesMatched,
    rejectedRules: original.rejectedRules,
    severity: original.severity,
    shouldApplyAutomatically: false,
  );

  WakeProtocol _applyDecision(
    WakeProtocol current,
    AdaptiveDecision decision,
    String basedOnSessionId,
  ) {
    final change = decision.changes.single;
    var next = current.copyWith(
      id: const Uuid().v4(),
      version: current.version + 1,
      source: WakeProtocolSource.adaptiveEngine,
      status: WakeProtocolStatus.active,
      reasonCode: decision.reasonCode,
      technicalExplanation: decision.technicalExplanation,
      userExplanation: decision.userExplanation,
      basedOnSessionId: basedOnSessionId,
      supersedesProtocolId: current.id,
      createdAt: _clock(),
      effectiveFrom: _clock(),
    );
    switch (change.dimension) {
      case AdaptiveDimension.sound:
        next = next.copyWith(
          initialSoundId: change.newValue! as String,
          initialSoundFamily: change.soundFamily,
          ringtoneUri: change.soundUri!,
        );
        break;
      case AdaptiveDimension.volume:
        next = next.copyWith(initialVolumePercent: change.newValue! as int);
        break;
      case AdaptiveDimension.vibration:
        next = next.copyWith(
          vibrationPattern: VibrationPattern.values.byName(
            change.newValue! as String,
          ),
        );
        break;
      case AdaptiveDimension.mission:
        final config =
            jsonDecode(next.missionConfigurationJson) as Map<String, dynamic>;
        config['requiredSteps'] = change.newValue;
        if (change.field == 'requiredJumps') {
          config.remove('requiredSteps');
          config['requiredJumps'] = change.newValue;
        }
        next = next.copyWith(missionConfigurationJson: jsonEncode(config));
        break;
      case AdaptiveDimension.wakeCheck:
        next = switch (change.field) {
          'wakeCheckHoldMilliseconds' => next.copyWith(
            wakeCheckHoldMilliseconds: change.newValue! as int,
          ),
          'reactivationSoundPolicy' => next.copyWith(
            reactivationSoundPolicy: ReactivationSoundPolicy.values.byName(
              change.newValue! as String,
            ),
          ),
          _ => next.copyWith(wakeCheckDelayMinutes: change.newValue! as int),
        };
        break;
    }
    return next.copyWith(intensity: calculateWakeIntensity(next));
  }

  Future<bool> _scheduleNext(WakeProtocol protocol) async {
    final alarm = await (_database.select(
      _database.alarms,
    )..where((row) => row.id.equals(protocol.alarmId))).getSingle();
    if (!alarm.enabled || alarm.recurrenceType == 'oneTime') return true;
    final recurrence = domain.AlarmRecurrenceType.values.byName(
      alarm.recurrenceType,
    );
    final next = calculateNextOccurrence(
      now: _clock(),
      hour: alarm.localHour,
      minute: alarm.localMinute,
      recurrenceType: recurrence,
      repeatDaysMask: alarm.repeatDaysMask,
    );
    final result = await _runtime.schedule(
      alarmId: alarm.id,
      triggerAt: next,
      label: alarm.label ?? '',
      ringtoneUri: protocol.ringtoneUri,
      vibrationEnabled: protocol.vibrationEnabled,
      snoozeEnabled: alarm.snoozeEnabled,
      snoozeDurationMinutes: alarm.snoozeDurationMinutes,
      adaptiveSoundRotation: alarm.adaptiveSoundRotation,
      increasingVolume: protocol.volumeEscalationEnabled,
      localHour: alarm.localHour,
      localMinute: alarm.localMinute,
      recurrenceType: alarm.recurrenceType,
      repeatDaysMask: alarm.repeatDaysMask,
      protocol: protocol,
    );
    return result.scheduled;
  }

  Future<WakeSessionEvidence> _evidence(
    WakeSession row, {
    bool soundDeclining = false,
  }) async {
    final events =
        await (_database.select(_database.wakeEvents)
              ..where(
                (e) =>
                    e.wakeSessionId.equals(row.id) &
                    e.occurredAtMs.isSmallerOrEqualValue(row.completedAtMs!),
              )
              ..orderBy([(e) => OrderingTerm.asc(e.occurredAtMs)]))
            .get();
    final executions = await (_database.select(
      _database.missionExecutions,
    )..where((e) => e.wakeSessionId.equals(row.id))).get();
    final checks = await (_database.select(
      _database.wakeChecks,
    )..where((e) => e.wakeSessionId.equals(row.id))).get();
    final missionFailures = executions
        .where((e) => e.status == 'failed' || e.status == 'timedOut')
        .length;
    final checkFailures = checks
        .where((e) => e.status == 'failed' || e.status == 'missed')
        .length;
    final firstInteraction = events
        .where(
          (e) => const {
            'SNOOZED',
            'DISMISS_REQUESTED',
            'ALARM_DISMISSED',
          }.contains(e.eventType),
        )
        .firstOrNull;
    return WakeSessionEvidence(
      sessionId: row.id,
      outcome: row.outcome,
      responseLatencyMs:
          row.responseLatencyMs ??
          (firstInteraction == null
              ? null
              : (firstInteraction.occurredAtMs - row.triggeredAtMs).clamp(
                  0,
                  86400000,
                )),
      snoozeCount: row.snoozeCount,
      missionFailureCount: missionFailures > row.missionFailureCount
          ? missionFailures
          : row.missionFailureCount,
      wakeCheckFailureCount: checkFailures > row.wakeCheckFailureCount
          ? checkFailures
          : row.wakeCheckFailureCount,
      reactivationCount: row.escalationCount,
      emergencyBypass: row.outcome == 'bypassed',
      completed: row.completedAtMs != null,
      eventTypes: events.map((e) => e.eventType).toList(growable: false),
      soundDeclining: soundDeclining,
    );
  }

  Map<String, Object?> _analysisJson(WakeSessionAnalysis value) => {
    'primaryFailureMode': value.primaryFailureMode.name,
    'secondaryFailureModes': value.secondaryFailureModes
        .map((item) => item.name)
        .toList(),
    'response': value.response.name,
    'snoozes': value.snoozes.name,
    'dataSufficiency': value.dataSufficiency.name,
    'validForAdaptation': value.validForAdaptation,
    'confirmedWake': value.confirmedWake,
    'notes': value.notes,
  };

  List<Map<String, Object?>> _changesJson(List<AdaptiveChange> values) => values
      .map(
        (item) => {
          'dimension': item.dimension.name,
          'oldValue': item.oldValue,
          'newValue': item.newValue,
          'evidence': item.evidence,
          'major': item.major,
          'field': item.field,
          'priority': item.priority,
          'reasonCode': item.reasonCode?.name,
          if (item.soundFamily != null) 'soundFamily': item.soundFamily,
        },
      )
      .toList(growable: false);

  Future<void> _markAnalyzed(String id) =>
      (_database.update(
        _database.wakeSessions,
      )..where((row) => row.id.equals(id))).write(
        const WakeSessionsCompanion(analysisStatus: Value('completed')),
      );

  Future<WakeProtocol?> _findRevertTarget(
    WakeProtocol current,
    int throughMs,
  ) async {
    if (current.source != WakeProtocolSource.adaptiveEngine ||
        current.supersedesProtocolId == null) {
      return null;
    }
    final previous = await _protocols.findById(current.supersedesProtocolId!);
    if (previous == null) return null;
    final currentSessions =
        await (_database.select(_database.wakeSessions)..where(
              (row) =>
                  row.protocolId.equals(current.id) &
                  row.completedAtMs.isNotNull() &
                  row.completedAtMs.isSmallerOrEqualValue(throughMs) &
                  row.outcome.isNotIn(const [
                    'bypassed',
                    'manualTermination',
                    'cancelled',
                    'incomplete',
                  ]),
            ))
            .get();
    final previousSessions =
        await (_database.select(_database.wakeSessions)..where(
              (row) =>
                  row.protocolId.equals(previous.id) &
                  row.completedAtMs.isNotNull() &
                  row.completedAtMs.isSmallerOrEqualValue(throughMs) &
                  row.outcome.isNotIn(const [
                    'bypassed',
                    'manualTermination',
                    'cancelled',
                    'incomplete',
                  ]),
            ))
            .get();
    if (currentSessions.length < 2 || previousSessions.length < 2) return null;
    int metric(WakeSession s) => switch (current.reasonCode) {
      AdaptiveReasonCode.wakeCheckFailureRepeated =>
        s.wakeCheckFailureCount + s.escalationCount,
      AdaptiveReasonCode.missionFailureRepeated => s.missionFailureCount,
      AdaptiveReasonCode.highSnoozeCount => s.snoozeCount,
      _ => s.responseLatencyMs ?? 120000,
    };
    currentSessions.sort((a, b) => b.triggeredAtMs.compareTo(a.triggeredAtMs));
    final baseline = _median(previousSessions.map(metric).toList());
    final responseMetric = !const {
      AdaptiveReasonCode.wakeCheckFailureRepeated,
      AdaptiveReasonCode.missionFailureRepeated,
      AdaptiveReasonCode.highSnoozeCount,
    }.contains(current.reasonCode);
    final minimumWorsening = responseMetric ? 8000 : 1;
    final degraded = currentSessions
        .take(2)
        .every(
          (s) =>
              metric(s) - baseline >= minimumWorsening &&
              metric(s) >= baseline * 1.3,
        );
    return degraded ? previous : null;
  }

  double _median(List<int> values) {
    values.sort();
    final middle = values.length ~/ 2;
    return values.length.isOdd
        ? values[middle].toDouble()
        : (values[middle - 1] + values[middle]) / 2;
  }
}
