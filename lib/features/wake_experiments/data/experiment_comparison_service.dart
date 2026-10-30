import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';
import 'package:ryser/features/wake_experiments/data/wake_experiment_repository.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_evaluator.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_safety_policy.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

/// A consistent read of experiment evidence. No status changes or scheduling.
/// Safety recommendations remain advisory until the lifecycle controller lands.
class ExperimentComparisonService {
  ExperimentComparisonService(
    this._database,
    this._experiments, {
    this.evaluator = const ExperimentEvaluator(),
  });

  final AppDatabase _database;
  final WakeExperimentRepository _experiments;
  final ExperimentEvaluator evaluator;

  Future<ExperimentComparison> load(String experimentId) =>
      _database.transaction(() async {
        final experiment = await _experiments.findById(experimentId);
        if (experiment == null) throw StateError('Experiment does not exist.');
        if (experiment.status == ExperimentStatus.invalidated ||
            experiment.status == ExperimentStatus.cancelled) {
          throw StateError(
            'A cancelled or invalidated test cannot choose a winner.',
          );
        }
        final trials = <ExperimentTrialEvidence>[];
        for (final assignment in await _experiments.sessions(experimentId)) {
          trials.add(await _evidence(experiment, assignment));
        }
        return evaluator.evaluate(
          evidence: trials,
          minimumSessions: experiment.minimumSessionsPerVariant,
          preferredSessions: experiment.preferredSessionsPerVariant,
          maximumSessions: experiment.maximumSessionsPerVariant,
        );
      });

  Future<ExperimentTrialEvidence> _evidence(
    WakeExperiment experiment,
    ExperimentSession a,
  ) async {
    final wake = a.wakeSessionId == null
        ? null
        : await (_database.select(
            _database.wakeSessions,
          )..where((r) => r.id.equals(a.wakeSessionId!))).getSingleOrNull();
    final snapshot = a.variant == ExperimentVariant.control
        ? experiment.controlSnapshotJson
        : experiment.candidateSnapshotJson;
    String? problem = a.invalidReason;
    int? intensity;
    try {
      final protocol = decodeExperimentProtocolSnapshot(
        snapshot,
        alarmId: experiment.alarmId,
        createdAt: DateTime.fromMillisecondsSinceEpoch(experiment.createdAtMs),
      );
      intensity = protocol.intensity.index + 1;
      if (protocol.id != a.protocolId ||
          protocol.version != a.protocolVersion ||
          a.alarmId != experiment.alarmId ||
          a.contextKey != experiment.contextKey ||
          a.assignedAtMs > a.scheduledTimeMs) {
        problem = 'The saved assignment does not match this test.';
      }
    } on Object {
      problem = 'The saved settings cannot be read.';
    }
    final events = wake == null
        ? <WakeEvent>[]
        : await (_database.select(_database.wakeEvents)
                ..where((r) => r.wakeSessionId.equals(wake.id))
                ..orderBy([(r) => OrderingTerm.asc(r.sequenceNumber)]))
              .get();
    final checks = wake == null
        ? <WakeCheck>[]
        : await (_database.select(
            _database.wakeChecks,
          )..where((r) => r.wakeSessionId.equals(wake.id))).get();
    final missions = wake == null
        ? <MissionExecution>[]
        : await (_database.select(
            _database.missionExecutions,
          )..where((r) => r.wakeSessionId.equals(wake.id))).get();
    final pending =
        checks.any((c) => c.status == 'pending' || c.status == 'triggered') ||
        missions.any(
          (m) => const {
            'pending',
            'active',
            'inProgress',
            'prepared',
            'running',
          }.contains(m.status),
        );
    if (a.validity == SessionValidity.valid) {
      if (wake != null &&
          (wake.snoozeCount < 0 ||
              wake.wakeCheckFailureCount < 0 ||
              wake.missionFailureCount < 0 ||
              wake.escalationCount < 0)) {
        problem = 'Wake counters are inconsistent.';
      }
      if (wake == null ||
          wake.completedAtMs == null ||
          a.completedAtMs == null ||
          wake.currentWakeFlowState != 'completed' ||
          pending) {
        problem = 'The wake is not fully finished.';
      } else if (wake.alarmId != a.alarmId ||
          wake.scheduledTimeMs != a.scheduledTimeMs ||
          wake.protocolId != a.protocolId ||
          wake.protocolVersion != a.protocolVersion ||
          wake.protocolSnapshotJson == null ||
          !sameExperimentSettings(snapshot, wake.protocolSnapshotJson!) ||
          wake.triggeredAtMs < a.assignedAtMs ||
          wake.completedAtMs! < wake.triggeredAtMs ||
          wake.completedAtMs != a.completedAtMs ||
          (wake.firstInteractionAtMs != null &&
              (wake.firstInteractionAtMs! < wake.triggeredAtMs ||
                  wake.firstInteractionAtMs! > wake.completedAtMs!)) ||
          (wake.responseLatencyMs != null &&
              (wake.responseLatencyMs! < 0 ||
                  wake.responseLatencyMs! >
                      wake.completedAtMs! - wake.triggeredAtMs)) ||
          (wake.confirmedAwakeAtMs != null &&
              (wake.confirmedAwakeAtMs! < wake.triggeredAtMs ||
                  wake.confirmedAwakeAtMs! > wake.completedAtMs!))) {
        problem = 'Wake timing or executed settings do not match the saved assignment.';
      } else {
        var previousTime = wake.triggeredAtMs;
        if (!events.any(
          (e) =>
              e.eventType == 'ALARM_TRIGGERED' &&
              e.occurredAtMs == wake.triggeredAtMs,
        )) {
          problem = 'The original alarm trigger is missing.';
        }
        for (final event in events) {
          if (event.occurredAtMs < previousTime ||
              event.occurredAtMs > wake.completedAtMs!) {
            problem =
                'Wake events are out of order or outside the completed wake.';
          }
          previousTime = event.occurredAtMs;
        }
        if (checks.any(
              (c) =>
                  c.completedAtMs != null &&
                  c.completedAtMs! > wake.completedAtMs!,
            ) ||
            missions.any(
              (m) =>
                  (m.completedAtMs != null &&
                      m.completedAtMs! > wake.completedAtMs!) ||
                  (m.failedAtMs != null && m.failedAtMs! > wake.completedAtMs!),
            )) {
          problem = 'A task or follow-up check continued after the recorded wake ended.';
        }
      }
    }
    final validity = problem == null ? a.validity : SessionValidity.invalid;
    return ExperimentTrialEvidence(
      assignmentId: a.id,
      variant: a.variant,
      validity: validity,
      scheduledTimeMs: a.scheduledTimeMs,
      completed:
          wake?.completedAtMs != null && a.completedAtMs != null && !pending,
      wakeSessionId: wake?.id,
      outcome: wake?.outcome,
      wakeEnforcementEnabled: wake?.wakeEnforcementEnabled ?? false,
      responseLatencyMs: wake?.responseLatencyMs,
      snoozeCount: wake?.snoozeCount ?? 0,
      wakeCheckFailureCount: math.max(
        wake?.wakeCheckFailureCount ?? 0,
        checks
            .where((c) => c.status == 'failed' || c.status == 'missed')
            .length,
      ),
      missionFailureCount: math.max(
        wake?.missionFailureCount ?? 0,
        missions
            .where((m) => m.status == 'failed' || m.status == 'timedOut')
            .length,
      ),
      reactivationCount: math.max(
        wake?.escalationCount ?? 0,
        events.where((e) => e.eventType == 'ALARM_REACTIVATED').length,
      ),
      bypassed:
          wake?.outcome == 'bypassed' ||
          events.any((e) => e.eventType == 'MISSION_BYPASSED') ||
          missions.any((m) => m.status == 'bypassed'),
      configuredIntensity: intensity,
      confirmedAwakeDurationMs: wake?.confirmedAwakeAtMs == null
          ? null
          : wake!.confirmedAwakeAtMs! - wake.triggeredAtMs,
      invalidReason: problem,
    );
  }
}
