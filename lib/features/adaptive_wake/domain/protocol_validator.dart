import 'dart:convert';

import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

class ProtocolValidationResult {
  const ProtocolValidationResult(this.errors);
  final List<String> errors;
  bool get isValid => errors.isEmpty;
}

class WakeProtocolValidator {
  const WakeProtocolValidator();

  ProtocolValidationResult validate(
    WakeProtocol protocol, {
    required AlarmAdaptationPolicy policy,
    required bool soundExists,
    required bool missionAvailable,
    bool vibrationSupported = true,
    WakeProtocol? previous,
  }) {
    final errors = <String>[];
    if (protocol.id.isEmpty ||
        protocol.alarmId.isEmpty ||
        protocol.version < 1) {
      errors.add('protocol_identity_invalid');
    }
    if (!soundExists || protocol.ringtoneUri.isEmpty) {
      errors.add('sound_unavailable');
    }
    if (protocol.source == WakeProtocolSource.adaptiveEngine &&
        (protocol.basedOnSessionId == null ||
            protocol.userExplanation.trim().isEmpty ||
            protocol.technicalExplanation.trim().isEmpty)) {
      errors.add('adaptive_evidence_missing');
    }
    if (policy.userMaxVolumePercent < 30 ||
        policy.userMaxVolumePercent > 100 ||
        protocol.initialVolumePercent < 30 ||
        protocol.initialVolumePercent > policy.userMaxVolumePercent) {
      errors.add('initial_volume_out_of_bounds');
    }
    if (protocol.maxVolumePercent < protocol.initialVolumePercent ||
        protocol.maxVolumePercent > policy.userMaxVolumePercent) {
      errors.add('max_volume_out_of_bounds');
    }
    if (protocol.volumeEscalationEnabled &&
        (protocol.volumeEscalationStepPercent < 5 ||
            protocol.volumeEscalationStepPercent > 25 ||
            protocol.volumeEscalationIntervalSeconds < 5 ||
            protocol.volumeEscalationIntervalSeconds > 60)) {
      errors.add('volume_escalation_invalid');
    }
    if (protocol.missionRequired &&
        (!missionAvailable || protocol.missionType == null)) {
      errors.add('mission_unavailable');
    }
    if (protocol.vibrationEnabled && !vibrationSupported) {
      errors.add('vibration_unavailable');
    }
    if (protocol.wakeCheckRequired &&
        (!protocol.missionRequired ||
            protocol.wakeCheckDelayMinutes < 5 ||
            protocol.wakeCheckDelayMinutes > 10 ||
            protocol.wakeCheckHoldMilliseconds < 1500 ||
            protocol.wakeCheckHoldMilliseconds > 4000 ||
            protocol.maxWakeCheckFailures < 1 ||
            protocol.maxWakeCheckFailures > 3)) {
      errors.add('wake_check_invalid');
    }
    try {
      final config = jsonDecode(protocol.missionConfigurationJson);
      if (config is! Map<String, dynamic>) {
        errors.add('mission_configuration_invalid');
      } else if (protocol.missionRequired) {
        final executable = switch (protocol.missionType) {
          'movement' =>
            config['requiredSteps'] is int &&
                (config['requiredSteps'] as int) >= 10 &&
                (config['requiredSteps'] as int) <= 40,
          'jumping' =>
            config['requiredJumps'] is int &&
                (config['requiredJumps'] as int) >= 5 &&
                (config['requiredJumps'] as int) <= 20,
          'qr' =>
            config['payloadHash'] is String &&
                RegExp(r'^[a-fA-F0-9]{64}$')
                    .hasMatch(config['payloadHash'] as String) &&
                config['locationLabel'] is String &&
                (config['locationLabel'] as String).trim().isNotEmpty,
          _ => false,
        };
        if (!executable) errors.add('mission_configuration_not_executable');
      }
    } catch (_) {
      errors.add('mission_configuration_invalid');
    }
    if (previous != null) {
      if (policy.sound == AdaptiveMode.fixed &&
          (protocol.initialSoundId != previous.initialSoundId ||
              protocol.initialSoundFamily != previous.initialSoundFamily ||
              protocol.ringtoneUri != previous.ringtoneUri)) {
        errors.add('fixed_sound_changed');
      }
      if (policy.volume == AdaptiveMode.fixed &&
          (protocol.initialVolumePercent != previous.initialVolumePercent ||
              protocol.maxVolumePercent != previous.maxVolumePercent ||
              protocol.volumeEscalationEnabled !=
                  previous.volumeEscalationEnabled ||
              protocol.volumeEscalationStepPercent !=
                  previous.volumeEscalationStepPercent ||
              protocol.volumeEscalationIntervalSeconds !=
                  previous.volumeEscalationIntervalSeconds)) {
        errors.add('fixed_volume_changed');
      }
      if (policy.vibration == AdaptiveMode.fixed &&
          (protocol.vibrationPattern != previous.vibrationPattern ||
              protocol.vibrationEnabled != previous.vibrationEnabled ||
              protocol.vibrationEscalationEnabled !=
                  previous.vibrationEscalationEnabled)) {
        errors.add('fixed_vibration_changed');
      }
      if (policy.mission == AdaptiveMode.fixed &&
          (protocol.missionType != previous.missionType ||
              protocol.missionRequired != previous.missionRequired ||
              protocol.missionDifficulty != previous.missionDifficulty ||
              protocol.missionConfigurationJson !=
                  previous.missionConfigurationJson)) {
        errors.add('fixed_mission_changed');
      }
      if (policy.wakeCheck == AdaptiveMode.fixed &&
          (protocol.wakeCheckDelayMinutes != previous.wakeCheckDelayMinutes ||
              protocol.wakeCheckRequired != previous.wakeCheckRequired ||
              protocol.wakeCheckHoldMilliseconds !=
                  previous.wakeCheckHoldMilliseconds ||
              protocol.reactivationSoundPolicy !=
                  previous.reactivationSoundPolicy ||
              protocol.maxWakeCheckFailures != previous.maxWakeCheckFailures)) {
        errors.add('fixed_wake_check_changed');
      }
    }
    return ProtocolValidationResult(errors);
  }
}
