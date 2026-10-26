import 'dart:convert';

import 'package:ryser/features/adaptive_wake/domain/protocol_validator.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol_codec.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

/// Includes every executable setting, unlike the intentionally abbreviated UI diff.
Map<String, dynamic> experimentSettings(WakeProtocol protocol) =>
    (jsonDecode(encodeWakeProtocolSnapshot(protocol)) as Map<String, dynamic>)
      ..remove('id')
      ..remove('version')
      ..remove('intensityLevel');

Object? _canonical(Object? value) {
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    return {for (final key in keys) key: _canonical(value[key])};
  }
  if (value is List) return value.map(_canonical).toList();
  return value;
}

/// JSON object ordering never changes experiment equivalence.
bool sameExperimentSettings(String firstSnapshot, String secondSnapshot) {
  try {
    return jsonEncode(_canonical(jsonDecode(firstSnapshot))) ==
        jsonEncode(_canonical(jsonDecode(secondSnapshot)));
  } on FormatException {
    return false;
  }
}

class ExperimentSafetyPolicy {
  const ExperimentSafetyPolicy();

  bool dimensionAllowed(
    ExperimentDimension dimension,
    AlarmAdaptationPolicy policy,
  ) =>
      policy.enabled &&
      switch (dimension) {
        ExperimentDimension.sound || ExperimentDimension.soundFamily =>
          policy.sound == AdaptiveMode.adaptive,
        ExperimentDimension.initialVolume ||
        ExperimentDimension.volumeEscalation =>
          policy.volume == AdaptiveMode.adaptive,
        ExperimentDimension.vibrationPattern =>
          policy.vibration == AdaptiveMode.adaptive,
        ExperimentDimension.missionType ||
        ExperimentDimension.missionDifficulty =>
          policy.mission == AdaptiveMode.adaptive,
        _ => policy.wakeCheck == AdaptiveMode.adaptive,
      };

  List<String> validate({
    required WakeProtocol control,
    required WakeProtocol candidate,
    required ExperimentDimension dimension,
    required AlarmAdaptationPolicy policy,
    required bool controlSoundAvailable,
    required bool candidateSoundAvailable,
    required bool missionAvailable,
    bool vibrationSupported = true,
  }) {
    final errors = <String>[];
    if (!policy.enabled) errors.add('adaptation_disabled');
    if (control.alarmId != candidate.alarmId ||
        control.id == candidate.id ||
        control.version == candidate.version) {
      errors.add('variants_must_have_distinct_versions_for_same_alarm');
    }
    const validator = WakeProtocolValidator();
    errors.addAll(
      validator
          .validate(
            control,
            policy: policy,
            soundExists: controlSoundAvailable,
            missionAvailable: missionAvailable,
            vibrationSupported: vibrationSupported,
          )
          .errors
          .map((e) => 'control_$e'),
    );
    errors.addAll(
      validator
          .validate(
            candidate,
            policy: policy,
            previous: control,
            soundExists: candidateSoundAvailable,
            missionAvailable: missionAvailable,
            vibrationSupported: vibrationSupported,
          )
          .errors
          .map((e) => 'candidate_$e'),
    );
    try {
      final before = experimentSettings(control),
          after = experimentSettings(candidate);
      final changed = before.keys
          .where(
            (key) =>
                jsonEncode(_canonical(before[key])) !=
                jsonEncode(_canonical(after[key])),
          )
          .toSet();
      final allowed = switch (dimension) {
        ExperimentDimension.sound => {'soundId', 'ringtoneUri'},
        ExperimentDimension.soundFamily => {
          'soundId',
          'soundFamily',
          'ringtoneUri',
        },
        ExperimentDimension.initialVolume => {'initialVolumePercent'},
        ExperimentDimension.volumeEscalation => {
          'volumeEscalationEnabled',
          'volumeEscalationStepPercent',
          'volumeEscalationIntervalSeconds',
        },
        ExperimentDimension.vibrationPattern => {'vibrationPattern'},
        ExperimentDimension.wakeCheckDelay => {'wakeCheckDelayMinutes'},
        ExperimentDimension.wakeCheckHold => {'wakeCheckHoldMilliseconds'},
        ExperimentDimension.missionType => {
          'missionType',
          'missionDifficulty',
          'missionConfiguration',
        },
        ExperimentDimension.missionDifficulty => {
          'missionDifficulty',
          'missionConfiguration',
        },
        ExperimentDimension.reactivationPolicy => {'reactivationSoundPolicy'},
      };
      if (changed.isEmpty || !allowed.containsAll(changed)) {
        errors.add('exactly_one_experiment_dimension_required');
      }
      if ((dimension == ExperimentDimension.soundFamily &&
              (control.initialSoundFamily == null ||
                  candidate.initialSoundFamily == null ||
                  control.initialSoundFamily ==
                      candidate.initialSoundFamily)) ||
          ((dimension == ExperimentDimension.sound ||
                  dimension == ExperimentDimension.soundFamily) &&
              control.ringtoneUri == candidate.ringtoneUri)) {
        errors.add('sound_change_must_change_playback');
      }
      if (dimension == ExperimentDimension.vibrationPattern &&
          !control.vibrationEnabled) {
        errors.add('vibration_not_enabled');
      }
      if ({
            ExperimentDimension.wakeCheckDelay,
            ExperimentDimension.wakeCheckHold,
            ExperimentDimension.reactivationPolicy,
          }.contains(dimension) &&
          !control.wakeCheckRequired) {
        errors.add('wake_check_not_enabled');
      }
      if ({
            ExperimentDimension.missionType,
            ExperimentDimension.missionDifficulty,
          }.contains(dimension) &&
          (!control.missionRequired ||
              (dimension == ExperimentDimension.missionType &&
                  control.missionType == candidate.missionType))) {
        errors.add('mission_dimension_not_executable');
      }
    } on FormatException {
      errors.add('invalid_protocol_snapshot');
    }
    return errors;
  }
}
