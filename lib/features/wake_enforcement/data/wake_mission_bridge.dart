import 'package:flutter/services.dart';

class PendingWakeMission {
  const PendingWakeMission({
    required this.alarmId,
    required this.sessionId,
    required this.scheduledAtMs,
    required this.ringtoneUri,
  });

  final String alarmId;
  final String sessionId;
  final int scheduledAtMs;
  final String ringtoneUri;
}

class WakeMissionBridge {
  static const _channel = MethodChannel('ryser/wake_enforcement');

  Future<PendingWakeMission?> takePending() async {
    final raw = await _channel.invokeMapMethod<String, Object?>(
      'takePendingMission',
    );
    if (raw == null) return null;
    return PendingWakeMission(
      alarmId: raw['alarmId']! as String,
      sessionId: raw['sessionId']! as String,
      scheduledAtMs: raw['scheduledAtMs']! as int,
      ringtoneUri: raw['ringtoneUri']! as String,
    );
  }

  Future<void> completeDismiss(PendingWakeMission mission) {
    return _channel.invokeMethod('completeDismiss', {
      'alarmId': mission.alarmId,
      'sessionId': mission.sessionId,
      'scheduledAtMs': mission.scheduledAtMs,
      'ringtoneUri': mission.ringtoneUri,
    });
  }

  Future<void> scheduleWakeCheck(
    PendingWakeMission mission, {
    required DateTime triggerAt,
    required String protocolId,
    required int protocolVersion,
    required String protocolSnapshotJson,
  }) {
    return _channel.invokeMethod('scheduleWakeCheck', {
      'alarmId': mission.alarmId,
      'sessionId': mission.sessionId,
      'triggerAtMs': triggerAt.millisecondsSinceEpoch,
      'scheduledAtMs': mission.scheduledAtMs,
      'ringtoneUri': mission.ringtoneUri,
      'protocolId': protocolId,
      'protocolVersion': protocolVersion,
      'protocolSnapshotJson': protocolSnapshotJson,
    });
  }

  Future<MissionHealth> getMissionHealth() async {
    final raw = await _channel.invokeMapMethod<String, Object?>(
      'getMissionHealth',
    );
    return MissionHealth(
      cameraAvailable: raw?['cameraAvailable'] as bool? ?? false,
      cameraPermission: raw?['cameraPermission'] as bool? ?? false,
      stepSensorAvailable: raw?['stepSensorAvailable'] as bool? ?? false,
      activityPermission: raw?['activityPermission'] as bool? ?? false,
    );
  }
}

class MissionHealth {
  const MissionHealth({
    required this.cameraAvailable,
    required this.cameraPermission,
    required this.stepSensorAvailable,
    required this.activityPermission,
  });

  final bool cameraAvailable;
  final bool cameraPermission;
  final bool stepSensorAvailable;
  final bool activityPermission;
}
