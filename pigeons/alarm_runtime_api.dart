import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/core/platform/generated/alarm_runtime_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut: 'android/app/src/main/kotlin/com/ryser/ryser/bridge/AlarmRuntimeApi.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.ryser.ryser.bridge'),
    dartPackageName: 'ryser',
  ),
)
class AlarmScheduleDto {
  AlarmScheduleDto({
    required this.alarmId,
    required this.triggerAtMs,
    required this.label,
    required this.ringtoneUri,
    required this.vibrationEnabled,
    required this.snoozeEnabled,
    required this.snoozeDurationMinutes,
    required this.adaptiveSoundRotation,
    required this.increasingVolume,
    required this.protocolId,
    required this.protocolVersion,
    required this.protocolSnapshotJson,
    required this.initialVolumePercent,
    required this.maxVolumePercent,
    required this.volumeEscalationStepPercent,
    required this.volumeEscalationIntervalSeconds,
    required this.vibrationPattern,
    required this.sessionId,
    required this.snoozeCount,
    required this.localHour,
    required this.localMinute,
    required this.recurrenceType,
    required this.repeatDaysMask,
  });

  String alarmId;
  int triggerAtMs;
  String label;
  String ringtoneUri;
  bool vibrationEnabled;
  bool snoozeEnabled;
  int snoozeDurationMinutes;
  bool adaptiveSoundRotation;
  bool increasingVolume;
  String protocolId;
  int protocolVersion;
  String protocolSnapshotJson;
  int initialVolumePercent;
  int maxVolumePercent;
  int volumeEscalationStepPercent;
  int volumeEscalationIntervalSeconds;
  String vibrationPattern;
  String sessionId;
  int snoozeCount;
  int localHour;
  int localMinute;
  String recurrenceType;
  int repeatDaysMask;
}

class AlarmApplyResult {
  AlarmApplyResult({required this.scheduled, this.errorCode, this.message});

  bool scheduled;
  String? errorCode;
  String? message;
}

class RingtoneDto {
  RingtoneDto({required this.uri, required this.title});

  String uri;
  String title;
}

class RuntimeEventDto {
  RuntimeEventDto({
    required this.id,
    required this.sessionId,
    required this.alarmId,
    required this.eventType,
    required this.occurredAtMs,
    required this.scheduledAtMs,
    required this.ringtoneUri,
    required this.metadataJson,
    required this.protocolId,
    required this.protocolVersion,
    required this.protocolSnapshotJson,
  });

  String id;
  String sessionId;
  String alarmId;
  String eventType;
  int occurredAtMs;
  int scheduledAtMs;
  String ringtoneUri;
  String metadataJson;
  String protocolId;
  int protocolVersion;
  String protocolSnapshotJson;
}

class AlarmHealthDto {
  AlarmHealthDto({
    required this.exactAlarmsReady,
    required this.notificationsReady,
    required this.fullScreenReady,
    required this.batteryUnrestricted,
    required this.alarmVolume,
    required this.alarmVolumeMax,
  });

  bool exactAlarmsReady;
  bool notificationsReady;
  bool fullScreenReady;
  bool batteryUnrestricted;
  int alarmVolume;
  int alarmVolumeMax;
}

@HostApi()
abstract class AlarmRuntimeApi {
  List<RingtoneDto> getAlarmRingtones();
  bool isSoundAvailable(String uri);
  bool canVibrate();
  bool isMissionAvailable(String missionType);
  @async
  RingtoneDto? pickAudioFile();
  AlarmApplyResult scheduleAlarm(AlarmScheduleDto schedule);
  void cancelAlarm(String alarmId);
  bool canScheduleExactAlarms();
  bool canPostNotifications();
  void openExactAlarmSettings();
  void requestNotificationPermission();
  List<RuntimeEventDto> getRuntimeEvents();
  void acknowledgeRuntimeEvents(List<String> eventIds);
  AlarmHealthDto getAlarmHealth();
  void openNotificationSettings();
  void openFullScreenSettings();
  void openBatterySettings();
  void openAlarmVolumeSettings();
}
