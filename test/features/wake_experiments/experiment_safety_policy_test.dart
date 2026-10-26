import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_safety_policy.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

import '../adaptive_wake/adaptive_test_fixtures.dart';

void main() {
  final control = protocol();
  final candidate = control.copyWith(
    id: 'protocol-2',
    version: 2,
    initialSoundId: 'melodic-a',
    initialSoundFamily: 'MELODIC',
    ringtoneUri: 'content://sound/2',
  );
  List<String> validate(
    WakeProtocol next, {
    AlarmAdaptationPolicy policy = adaptivePolicy,
    ExperimentDimension dimension = ExperimentDimension.soundFamily,
  }) => const ExperimentSafetyPolicy().validate(
    control: control,
    candidate: next,
    dimension: dimension,
    policy: policy,
    controlSoundAvailable: true,
    candidateSoundAvailable: true,
    missionAvailable: true,
  );

  test('a sound family changes the asset and family as one variable', () {
    expect(validate(candidate), isEmpty);
    expect(
      validate(candidate.copyWith(initialVolumePercent: 60)),
      contains('exactly_one_experiment_dimension_required'),
    );
    expect(
      validate(candidate.copyWith(vibrationEscalationEnabled: true)),
      contains('exactly_one_experiment_dimension_required'),
    );
  });
  test(
    'unchanged playback, malformed JSON and missing version are rejected',
    () {
      expect(
        validate(candidate.copyWith(ringtoneUri: control.ringtoneUri)),
        contains('sound_change_must_change_playback'),
      );
      expect(
        validate(candidate.copyWith(missionConfigurationJson: '{broken')),
        contains('invalid_protocol_snapshot'),
      );
      expect(
        validate(candidate.copyWith(version: control.version)),
        contains('variants_must_have_distinct_versions_for_same_alarm'),
      );
      expect(
        validate(control.copyWith(id: 'other', version: 2)),
        contains('exactly_one_experiment_dimension_required'),
      );
    },
  );
  test('fixed dimensions and volume bounds remain enforced', () {
    const fixed = AlarmAdaptationPolicy(
      enabled: true,
      sound: AdaptiveMode.fixed,
      volume: AdaptiveMode.fixed,
      vibration: AdaptiveMode.fixed,
      wakeCheck: AdaptiveMode.fixed,
      mission: AdaptiveMode.fixed,
      userMaxVolumePercent: 90,
    );
    expect(
      validate(candidate, policy: fixed),
      contains('candidate_fixed_sound_changed'),
    );
    expect(
      validate(candidate.copyWith(maxVolumePercent: 100)),
      contains('candidate_max_volume_out_of_bounds'),
    );
  });
  test(
    'JSON key ordering is immaterial but hidden configuration changes are not',
    () {
      expect(
        sameExperimentSettings(
          '{"a":1,"b":{"x":2,"y":3}}',
          '{"b":{"y":3,"x":2},"a":1}',
        ),
        isTrue,
      );
      expect(sameExperimentSettings('{bad', '{}'), isFalse);
      expect(
        validate(
          candidate.copyWith(
            missionConfigurationJson: '{"payloadHash":"changed"}',
          ),
        ),
        contains('exactly_one_experiment_dimension_required'),
      );
    },
  );
  test(
    'assignment is deterministic and terminal experiments stay terminal',
    () {
      expect(List.generate(6, variantForAssignment), [
        ExperimentVariant.control,
        ExperimentVariant.candidate,
        ExperimentVariant.control,
        ExperimentVariant.candidate,
        ExperimentVariant.control,
        ExperimentVariant.candidate,
      ]);
      expect(() => variantForAssignment(-1), throwsArgumentError);
      for (final terminal in [
        ExperimentStatus.completed,
        ExperimentStatus.cancelled,
        ExperimentStatus.invalidated,
      ]) {
        for (final next in ExperimentStatus.values) {
          expect(canTransitionExperiment(terminal, next), isFalse);
        }
      }
    },
  );
}
