import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';

class AlarmRuntimeGateway {
  AlarmRuntimeGateway({AlarmRuntimeApi? api}) : _api = api ?? AlarmRuntimeApi();

  final AlarmRuntimeApi _api;

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
  }) {
    return _api.scheduleAlarm(
      AlarmScheduleDto(
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
        volumeEscalationStepPercent:
            protocol?.volumeEscalationStepPercent ?? 10,
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
      ),
    );
  }

  Future<void> cancel(String alarmId) => _api.cancelAlarm(alarmId);
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
