import 'package:drift/drift.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/alarms/domain/alarm.dart' as domain;
import 'package:ryser/features/alarms/domain/next_occurrence.dart';
import 'package:ryser/features/wake_experiments/data/experiment_restoration_ledger.dart';

enum StableRestorationResult {
  scheduled,
  disabled,
  deleted,
  deferred,
  rejected,
}

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

  Future<StableRestorationResult> restoreStable(String alarmId) async {
    final alarm = await (_database.select(
      _database.alarms,
    )..where((r) => r.id.equals(alarmId))).getSingleOrNull();
    if (alarm == null) return StableRestorationResult.deleted;
    if (!alarm.enabled) return StableRestorationResult.disabled;
    if (await ExperimentRestorationLedger(_database).hasActiveWake(alarmId)) {
      return StableRestorationResult.deferred;
    }
    final protocol = await _protocols.ensureDefault(alarmId);
    if (!await _protocols.isValid(protocol)) {
      return StableRestorationResult.rejected;
    }
    final current = await _protocols.resolveForAlarm(alarmId);
    if (current?.id != protocol.id || current?.version != protocol.version) {
      return StableRestorationResult.deferred;
    }
    final latest = await (_database.select(
      _database.alarms,
    )..where((r) => r.id.equals(alarmId))).getSingleOrNull();
    if (latest == null) return StableRestorationResult.deleted;
    if (!latest.enabled) return StableRestorationResult.disabled;
    if (latest != alarm ||
        await ExperimentRestorationLedger(_database).hasActiveWake(alarmId)) {
      return StableRestorationResult.deferred;
    }
    final next = calculateNextOccurrence(
      now: _clock(),
      hour: alarm.localHour,
      minute: alarm.localMinute,
      recurrenceType: domain.AlarmRecurrenceType.values.byName(
        alarm.recurrenceType,
      ),
      repeatDaysMask: alarm.repeatDaysMask,
    );
    final result = await _runtime.schedule(
      alarmId: alarmId,
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
      allowExperiment: false,
    );
    return result.scheduled
        ? StableRestorationResult.scheduled
        : StableRestorationResult.rejected;
  }

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
    final recovery = ExperimentRestorationLedger(_database);
    final blocked = (await recovery.pending()).map((r) => r.alarmId).toSet();
    for (final id in ids) {
      try {
        if (blocked.contains(id) || await recovery.hasActiveWake(id)) continue;
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
