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
