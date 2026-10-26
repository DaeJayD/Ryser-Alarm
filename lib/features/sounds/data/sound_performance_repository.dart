import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/adaptive_wake/domain/adaptive_thresholds.dart';
import 'package:ryser/features/wake_experiments/data/experiment_evidence_filter.dart';

class SoundPerformance {
  const SoundPerformance({
    required this.soundUri,
    required this.timesUsed,
    required this.averageResponseLatencyMs,
    required this.snoozeCount,
    required this.medianResponseLatencyMs,
    required this.recentMedianResponseLatencyMs,
    required this.sessionSuccessRate,
    required this.wakeCheckFailureRate,
    required this.effectivenessDeclining,
    this.snoozeRate = 0,
    this.lastUsedAtMs,
    this.consecutiveUses = 0,
  });

  final String soundUri;
  final int timesUsed;
  final double? averageResponseLatencyMs;
  final int snoozeCount;
  final double? medianResponseLatencyMs;
  final double? recentMedianResponseLatencyMs;
  final double sessionSuccessRate;
  final double wakeCheckFailureRate;
  final bool effectivenessDeclining;
  final double snoozeRate;
  final int? lastUsedAtMs;
  final int consecutiveUses;
}

class SoundPerformanceRepository {
  SoundPerformanceRepository(
    this._database, {
    this.thresholds = const AdaptiveThresholds(),
  });

  final AppDatabase _database;
  final AdaptiveThresholds thresholds;

  Future<List<SoundPerformance>> load({
    String? alarmId,
    int? throughMs,
    bool excludeExperiments = false,
  }) async {
    final rows =
        await (_database.select(_database.wakeSessions)
              ..where(
                (row) =>
                    row.completedAtMs.isNotNull() &
                    (excludeExperiments
                        ? outsideExperimentOccurrences(_database, row)
                        : const Constant(true)) &
                    (throughMs == null
                        ? const Constant(true)
                        : row.completedAtMs.isSmallerOrEqualValue(throughMs)) &
                    row.outcome.isNotIn(const [
                      'active',
                      'incomplete',
                      'cancelled',
                      'bypassed',
                      'manualTermination',
                    ]) &
                    (alarmId == null
                        ? const Constant(true)
                        : row.alarmId.equals(alarmId)),
              )
              ..orderBy([(row) => OrderingTerm.asc(row.triggeredAtMs)]))
            .get();
    final grouped = <String, List<WakeSession>>{};
    for (final row in rows) {
      grouped.putIfAbsent(row.initialSoundId, () => []).add(row);
    }
    final result = <SoundPerformance>[];
    for (final entry in grouped.entries) {
      final sessions = entry.value;
      final latencies = sessions
          .where((item) => item.responseLatencyMs != null)
          .map((item) => item.responseLatencyMs!)
          .toList(growable: false);
      // Keep other executed settings constant when attributing a sound trend.
      final trend = sessions
          .where(
            (s) =>
                s.protocolId == sessions.last.protocolId &&
                s.responseLatencyMs != null,
          )
          .map((s) => s.responseLatencyMs!)
          .toList();
      final recent = trend.length <= thresholds.declineRecentUses
          ? trend
          : trend.sublist(trend.length - thresholds.declineRecentUses);
      final historical = trend.length <= thresholds.declineRecentUses
          ? const <int>[]
          : trend.sublist(0, trend.length - thresholds.declineRecentUses);
      final historicalMedian = _median(historical);
      final recentMedian = _median(recent);
      final declining =
          historical.length >= thresholds.declineBaselineUses &&
          recent.length == thresholds.declineRecentUses &&
          historicalMedian != null &&
          recentMedian != null &&
          recentMedian - historicalMedian >= thresholds.declineDifferenceMs &&
          recentMedian >= historicalMedian * thresholds.declineRatio;
      result.add(
        SoundPerformance(
          soundUri: entry.key,
          timesUsed: sessions.length,
          averageResponseLatencyMs: latencies.isEmpty
              ? null
              : latencies.reduce((a, b) => a + b) / latencies.length,
          medianResponseLatencyMs: _median(latencies),
          recentMedianResponseLatencyMs: recentMedian,
          snoozeCount: sessions.fold(0, (sum, item) => sum + item.snoozeCount),
          sessionSuccessRate:
              sessions.where((item) => item.outcome == 'wakeConfirmed').length /
              sessions.length,
          wakeCheckFailureRate:
              sessions.where((item) => item.wakeCheckFailureCount > 0).length /
              sessions.length,
          effectivenessDeclining: declining,
          snoozeRate:
              sessions.where((s) => s.snoozeCount > 0).length / sessions.length,
          lastUsedAtMs: sessions.last.triggeredAtMs,
          consecutiveUses: rows.reversed
              .takeWhile((s) => s.initialSoundId == entry.key)
              .length,
        ),
      );
    }
    result.sort((a, b) => b.timesUsed.compareTo(a.timesUsed));
    return result;
  }

  double? _median(List<int> values) {
    if (values.isEmpty) return null;
    final sorted = [...values]..sort();
    final middle = sorted.length ~/ 2;
    if (sorted.length.isOdd) return sorted[middle].toDouble();
    return (sorted[middle - 1] + sorted[middle]) / 2;
  }
}
