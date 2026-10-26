import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/wake_experiments/data/wake_experiment_repository.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

class ExperimentSessionReconciler {
  ExperimentSessionReconciler(this._database, this._experiments);
  final AppDatabase _database;
  final WakeExperimentRepository _experiments;

  Future<int> processPending() async {
    final assignments =
        await (_database.select(_database.experimentSessions)..where(
              (r) => r.validity.equals('partial') & r.wakeSessionId.isNotNull(),
            ))
            .get();
    var completed = 0;
    for (final a in assignments) {
      final wake = await (_database.select(
        _database.wakeSessions,
      )..where((r) => r.id.equals(a.wakeSessionId!))).getSingleOrNull();
      if (wake == null ||
          wake.completedAtMs == null ||
          wake.currentWakeFlowState != 'completed') {
        continue;
      }
      final checks =
          await (_database.select(_database.wakeChecks)..where(
                (r) =>
                    r.wakeSessionId.equals(wake.id) &
                    r.status.isIn(['pending', 'triggered']),
              ))
              .get();
      if (checks.isNotEmpty) continue;
      final trigger =
          await (_database.select(_database.wakeEvents)..where(
                (r) =>
                    r.wakeSessionId.equals(wake.id) &
                    r.eventType.equals('ALARM_TRIGGERED'),
              ))
              .get();
      final usable =
          trigger.isNotEmpty &&
          wake.completedAtMs! >= wake.triggeredAtMs &&
          (wake.responseLatencyMs == null || wake.responseLatencyMs! >= 0) &&
          wake.snoozeCount >= 0 &&
          wake.missionFailureCount >= 0 &&
          wake.wakeCheckFailureCount >= 0 &&
          {
            'wakeConfirmed',
            'dismissed',
            'noResponse',
            'bypassed',
          }.contains(wake.outcome);
      try {
        await _experiments.finishSession(
          a.id,
          validity: usable ? SessionValidity.valid : SessionValidity.invalid,
          invalidReason: usable
              ? null
              : 'Incomplete or inconsistent wake evidence.',
        );
      } on StateError {
        await _experiments.invalidateAssignment(
          a.id,
          'Executed settings changed after assignment.',
        );
      }
      completed++;
    }
    return completed;
  }
}
