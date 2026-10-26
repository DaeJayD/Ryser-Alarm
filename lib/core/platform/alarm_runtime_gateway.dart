import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';

class AlarmRuntimeGateway {
  AlarmRuntimeGateway({
    AlarmRuntimeApi? api,
    this.prepareSchedule,
    this.didSchedule,
    this.didCancel,
  }) : _api = api ?? AlarmRuntimeApi();

  final AlarmRuntimeApi _api;
  final Future<AlarmScheduleDto> Function(AlarmScheduleDto)? prepareSchedule;
  final Future<void> Function(AlarmScheduleDto, AlarmApplyResult)? didSchedule;
  final Future<void> Function(String)? didCancel;

  Future<List<RingtoneDto>> getAlarmRingtones() async {
    return (await _api.getAlarmRingtones()).whereType<RingtoneDto>().toList();
  }

  Future<RingtoneDto?> pickAudioFile() => _api.pickAudioFile();
  Future<bool> isSoundAvailable(String uri) => _api.isSoundAvailable(uri);
  Future<bool> canVibrate() => _api.canVibrate();
  Future<bool> isMissionAvailable(String type) => _api.isMissionAvailable(type);

  Future<AlarmApplyResult> schedule({
    required String alarmId,
    required DateTime triggerAt,
    required String label,
    required String ringtoneUri,
    required bool vibrationEnabled,
    required bool snoozeEnabled,
    required int snoozeDurationMinutes,
    required bool adaptiveSoundRotation,
    required bool increasingVolume,
    required int localHour,
    required int localMinute,
    required String recurrenceType,
    required int repeatDaysMask,
    WakeProtocol? protocol,
  }) async {
    final stable = AlarmScheduleDto(
      alarmId: alarmId,
      triggerAtMs: triggerAt.millisecondsSinceEpoch,
      label: label,
      ringtoneUri: protocol?.ringtoneUri ?? ringtoneUri,
      vibrationEnabled: protocol?.vibrationEnabled ?? vibrationEnabled,
      snoozeEnabled: snoozeEnabled,
      snoozeDurationMinutes: snoozeDurationMinutes,
      adaptiveSoundRotation: adaptiveSoundRotation,
      increasingVolume: protocol?.volumeEscalationEnabled ?? increasingVolume,
      protocolId: protocol?.id ?? '',
      protocolVersion: protocol?.version ?? 0,
      protocolSnapshotJson: protocol == null
          ? '{}'
          : encodeWakeProtocolSnapshot(protocol),
      initialVolumePercent:
          protocol?.initialVolumePercent ?? (increasingVolume ? 30 : 100),
      maxVolumePercent: protocol?.maxVolumePercent ?? 100,
      volumeEscalationStepPercent: protocol?.volumeEscalationStepPercent ?? 10,
      volumeEscalationIntervalSeconds:
          protocol?.volumeEscalationIntervalSeconds ?? 5,
      vibrationPattern:
          protocol?.vibrationPattern.name ?? VibrationPattern.standard.name,
      sessionId: '',
      snoozeCount: 0,
      localHour: localHour,
      localMinute: localMinute,
      recurrenceType: recurrenceType,
      repeatDaysMask: repeatDaysMask,
    );
    var selected = stable;
    try {
      selected = await prepareSchedule?.call(stable) ?? stable;
    } catch (_) {
      // Optional learning/storage faults must not block native scheduling.
    }
    final result = await _api.scheduleAlarm(selected);
    try {
      await didSchedule?.call(selected, result);
    } catch (_) {
      // Native acceptance is authoritative even if optional audit logging fails.
    }
    return result;
  }

  Future<void> cancel(String alarmId) async {
    await _api.cancelAlarm(alarmId);
    try {
      await didCancel?.call(alarmId);
    } catch (_) {
      // Optional experiment bookkeeping cannot undo a native cancellation.
    }
  }

  Future<bool> canScheduleExactAlarms() => _api.canScheduleExactAlarms();
  Future<bool> canPostNotifications() => _api.canPostNotifications();
  Future<void> openExactAlarmSettings() => _api.openExactAlarmSettings();
  Future<void> requestNotificationPermission() =>
      _api.requestNotificationPermission();
  Future<List<RuntimeEventDto>> getRuntimeEvents() async =>
      (await _api.getRuntimeEvents()).whereType<RuntimeEventDto>().toList();
  Future<void> acknowledgeRuntimeEvents(List<String> ids) =>
      _api.acknowledgeRuntimeEvents(ids);
  Future<AlarmHealthDto> getAlarmHealth() => _api.getAlarmHealth();
  Future<void> openNotificationSettings() => _api.openNotificationSettings();
  Future<void> openFullScreenSettings() => _api.openFullScreenSettings();
  Future<void> openBatterySettings() => _api.openBatterySettings();
  Future<void> openAlarmVolumeSettings() => _api.openAlarmVolumeSettings();
}
