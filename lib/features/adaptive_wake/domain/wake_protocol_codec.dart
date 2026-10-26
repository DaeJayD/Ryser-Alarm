import 'dart:convert';

import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

String encodeWakeProtocolSnapshot(WakeProtocol value) => jsonEncode({
  'id': value.id,
  'version': value.version,
  'soundId': value.initialSoundId,
  'soundFamily': value.initialSoundFamily,
  'ringtoneUri': value.ringtoneUri,
  'initialVolumePercent': value.initialVolumePercent,
  'maxVolumePercent': value.maxVolumePercent,
  'volumeEscalationEnabled': value.volumeEscalationEnabled,
  'volumeEscalationStepPercent': value.volumeEscalationStepPercent,
  'volumeEscalationIntervalSeconds': value.volumeEscalationIntervalSeconds,
  'vibrationEnabled': value.vibrationEnabled,
  'vibrationPattern': value.vibrationPattern.name,
  'vibrationEscalationEnabled': value.vibrationEscalationEnabled,
  'missionRequired': value.missionRequired,
  'missionType': value.missionType,
  'missionDifficulty': value.missionDifficulty,
  'missionConfiguration': jsonDecode(value.missionConfigurationJson),
  'wakeCheckRequired': value.wakeCheckRequired,
  'wakeCheckDelayMinutes': value.wakeCheckDelayMinutes,
  'wakeCheckHoldMilliseconds': value.wakeCheckHoldMilliseconds,
  'maxWakeCheckFailures': value.maxWakeCheckFailures,
  'reactivationSoundPolicy': value.reactivationSoundPolicy.name,
  'intensityLevel': value.intensity.index + 1,
});

/// Decode immutable experimental settings without inventing missing values.
/// Runtime safety/capability validation remains mandatory before scheduling.
WakeProtocol decodeExperimentProtocolSnapshot(
  String snapshot, {
  required String alarmId,
  required DateTime createdAt,
}) {
  final p = jsonDecode(snapshot) as Map<String, dynamic>;
  final level = p['intensityLevel'] as int;
  if (level < 1 ||
      level > 5 ||
      p['missionConfiguration'] is! Map<String, dynamic>) {
    throw const FormatException('Invalid experimental protocol snapshot.');
  }
  return WakeProtocol(
    id: p['id'] as String,
    alarmId: alarmId,
    version: p['version'] as int,
    source: WakeProtocolSource.defaultValue,
    status: WakeProtocolStatus.archived,
    initialSoundId: p['soundId'] as String,
    initialSoundFamily: p['soundFamily'] as String?,
    ringtoneUri: p['ringtoneUri'] as String,
    initialVolumePercent: p['initialVolumePercent'] as int,
    maxVolumePercent: p['maxVolumePercent'] as int,
    volumeEscalationEnabled: p['volumeEscalationEnabled'] as bool,
    volumeEscalationStepPercent: p['volumeEscalationStepPercent'] as int,
    volumeEscalationIntervalSeconds:
        p['volumeEscalationIntervalSeconds'] as int,
    vibrationEnabled: p['vibrationEnabled'] as bool,
    vibrationPattern: VibrationPattern.values.byName(
      p['vibrationPattern'] as String,
    ),
    vibrationEscalationEnabled: p['vibrationEscalationEnabled'] as bool,
    missionRequired: p['missionRequired'] as bool,
    missionType: p['missionType'] as String?,
    missionDifficulty: p['missionDifficulty'] as String?,
    missionConfigurationJson: jsonEncode(p['missionConfiguration']),
    wakeCheckRequired: p['wakeCheckRequired'] as bool,
    wakeCheckDelayMinutes: p['wakeCheckDelayMinutes'] as int,
    wakeCheckHoldMilliseconds: p['wakeCheckHoldMilliseconds'] as int,
    maxWakeCheckFailures: p['maxWakeCheckFailures'] as int,
    reactivationSoundPolicy: ReactivationSoundPolicy.values.byName(
      p['reactivationSoundPolicy'] as String,
    ),
    intensity: WakeIntensity.values[level - 1],
    reasonCode: AdaptiveReasonCode.insufficientData,
    technicalExplanation:
        'Immutable protocol variant reserved for a controlled experiment.',
    userExplanation: 'This plan tries one change to your usual alarm.',
    basedOnSessionId: null,
    supersedesProtocolId: null,
    createdAt: createdAt,
    effectiveFrom: createdAt,
  );
}
