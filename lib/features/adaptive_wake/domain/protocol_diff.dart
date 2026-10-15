import 'dart:convert';

import 'package:ryser/features/adaptive_wake/domain/adaptive_decision.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

/// Public audit values deliberately omit QR payload hashes and configuration JSON.
Map<String, Object?> protocolDisplayValues(WakeProtocol p) => {
  'sound': p.initialSoundId,
  'soundFamily': p.initialSoundFamily,
  'initialVolumePercent': p.initialVolumePercent,
  'maxVolumePercent': p.maxVolumePercent,
  'volumeEscalationEnabled': p.volumeEscalationEnabled,
  'volumeEscalationStepPercent': p.volumeEscalationStepPercent,
  'volumeEscalationIntervalSeconds': p.volumeEscalationIntervalSeconds,
  'vibrationEnabled': p.vibrationEnabled,
  'vibrationPattern': p.vibrationPattern.name,
  'missionRequired': p.missionRequired,
  'missionType': p.missionType,
  'missionDifficulty': p.missionDifficulty,
  'missionSteps': _missionCount(p, 'requiredSteps'),
  'missionJumps': _missionCount(p, 'requiredJumps'),
  'wakeCheckRequired': p.wakeCheckRequired,
  'wakeCheckDelayMinutes': p.wakeCheckDelayMinutes,
  'wakeCheckHoldMilliseconds': p.wakeCheckHoldMilliseconds,
  'maxWakeCheckFailures': p.maxWakeCheckFailures,
  'reactivationSoundPolicy': p.reactivationSoundPolicy.name,
  'intensityLevel': p.intensity.index + 1,
};

Object? _missionCount(WakeProtocol p, String key) {
  try {
    return (jsonDecode(p.missionConfigurationJson)
        as Map<String, dynamic>)[key];
  } catch (_) {
    return null;
  }
}

List<AdaptiveChange> protocolDiff(
  WakeProtocol before,
  WakeProtocol after,
  String reason,
) {
  final old = protocolDisplayValues(before),
      next = protocolDisplayValues(after);
  return [
    for (final key in old.keys)
      if (old[key] != next[key])
        AdaptiveChange(
          dimension:
              key.startsWith('wakeCheck') ||
                  key == 'maxWakeCheckFailures' ||
                  key == 'reactivationSoundPolicy'
              ? AdaptiveDimension.wakeCheck
              : key.startsWith('mission')
              ? AdaptiveDimension.mission
              : key.startsWith('vibration')
              ? AdaptiveDimension.vibration
              : key.startsWith('sound')
              ? AdaptiveDimension.sound
              : AdaptiveDimension.volume,
          field: key,
          oldValue: old[key],
          newValue: next[key],
          evidence: reason,
          reasonCode: after.reasonCode,
          major: key != 'intensityLevel',
        ),
  ];
}
