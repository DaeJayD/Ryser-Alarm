import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/wake_experiments/data/experiment_comparison_service.dart';
import 'package:ryser/features/wake_experiments/data/experiment_restoration_ledger.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_evaluator.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

/// Evaluates and persists within one transaction; native recovery happens later.
class ExperimentLifecycleService {
  ExperimentLifecycleService(
    this._database,
    this._comparisons,
    this._ledger, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;
  final AppDatabase _database;
  final ExperimentComparisonService _comparisons;
  final ExperimentRestorationLedger _ledger;
  final DateTime Function() _clock;

  Future<int> processPending() async {
    final rows = await (_database.select(
      _database.wakeExperiments,
    )..where((r) => r.status.equals('running'))).get();
    var changed = 0;
    for (final row in rows) {
      if (await apply(row.id)) changed++;
    }
    return changed;
  }

  Future<bool> apply(String id) => _database.transaction(() async {
    final current = await (_database.select(
      _database.wakeExperiments,
    )..where((r) => r.id.equals(id))).getSingleOrNull();
    if (current == null || current.status != 'running') return false;
    // Nested reads use the same Drift transaction: no stale caller result.
    final comparison = await _comparisons.load(id);
    final action = comparison.recommendation;
    if (action == ExperimentRecommendation.collectMore) return false;
    final status = comparison.outcome == ExperimentOutcome.invalidated
        ? ExperimentStatus.invalidated
        : action == ExperimentRecommendation.pauseAll ||
              action == ExperimentRecommendation.reviewRequired
        ? ExperimentStatus.paused
        : ExperimentStatus.completed;
    final terminal = status != ExperimentStatus.paused;
    final now = _clock().millisecondsSinceEpoch;
    final winner = action != ExperimentRecommendation.conclude
        ? null
        : switch (comparison.outcome) {
            ExperimentOutcome.controlBetter => current.controlProtocolId,
            ExperimentOutcome.candidateBetter => current.candidateProtocolId,
            _ => null,
          };
    await (_database.update(
      _database.wakeExperiments,
    )..where((r) => r.id.equals(id))).write(
      WakeExperimentsCompanion(
        status: Value(status.name),
        result: Value(comparison.outcome.name),
        confidence: Value(comparison.confidence.name),
        winnerProtocolId: Value(winner),
        updatedAtMs: Value(now),
        completedAtMs: terminal ? Value(now) : const Value.absent(),
      ),
    );
    // Never rewrite finalized evidence or a reservation linked to a ringing wake.
    await (_database.update(_database.experimentSessions)..where(
          (r) =>
              r.experimentId.equals(id) &
              r.validity.equals('partial') &
              r.completedAtMs.isNull() &
              r.wakeSessionId.isNull() &
              r.scheduledTimeMs.isBiggerThanValue(now),
        ))
        .write(
          ExperimentSessionsCompanion(
            validity: const Value('invalid'),
            completedAtMs: Value(now),
            invalidReason: Value('Test stopped: ${comparison.reason}'),
          ),
        );
    final decision = await _ledger.append(id, 'comparisonApplied', {
      ...comparison.toJson(),
      'from': current.status,
      'to': status.name,
      'winnerProtocolId': winner,
      'protocolPromoted': false,
    }, policyVersion: comparison.policyVersion);
    await _ledger.append(id, 'stableRestoreRequested', {
      'decisionId': decision,
      'alarmId': current.alarmId,
    }, policyVersion: comparison.policyVersion);
    return true;
  });
}
