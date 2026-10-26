import 'package:drift/drift.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/alarms/domain/alarm.dart' as domain;
import 'package:ryser/features/alarms/domain/next_occurrence.dart';

/// Native recurrence remains stable when Dart is absent. Once Flutter resumes,
/// prepare the next occurrence, or replace a revoked pending trial with stable.
class ExperimentSchedulingService {
  ExperimentSchedulingService(
    this._database,
    this._protocols,
    this._runtime, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;
  final AppDatabase _database;
  final WakeProtocolRepository _protocols;
  final AlarmRuntimeGateway _runtime;
  final DateTime Function() _clock;

  Future<int> rearmNextOccurrences() async {
    final now = _clock();
    final open = await (_database.select(
      _database.wakeExperiments,
    )..where((r) => r.status.isIn(['ready', 'running', 'paused']))).get();
    final pending =
        await (_database.select(_database.experimentSessions)..where(
              (r) => r.scheduledTimeMs.isBiggerThanValue(
                now.millisecondsSinceEpoch,
              ),
            ))
            .get();
    final ids = {
      ...open.map((r) => r.alarmId),
      ...pending.map((r) => r.alarmId),
    };
    var scheduled = 0;
    for (final id in ids) {
      try {
        final alarm = await (_database.select(
          _database.alarms,
        )..where((r) => r.id.equals(id))).getSingleOrNull();
        if (alarm == null || !alarm.enabled) continue;
        final protocol = await _protocols.ensureDefault(id);
        final next = calculateNextOccurrence(
          now: now,
          hour: alarm.localHour,
          minute: alarm.localMinute,
          recurrenceType: domain.AlarmRecurrenceType.values.byName(
            alarm.recurrenceType,
          ),
          repeatDaysMask: alarm.repeatDaysMask,
        );
        final result = await _runtime.schedule(
          alarmId: id,
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
        if (result.scheduled) scheduled++;
      } catch (_) {
        // Existing native recurrence is already armed; optional re-preparation
        // must not block other alarms or the current wake interaction.
      }
    }
    return scheduled;
  }
}
