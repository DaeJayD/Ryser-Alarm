import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/adaptive_wake/domain/protocol_validator.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

import 'adaptive_test_fixtures.dart';

void main() {
  const validator = WakeProtocolValidator();

  test('accepts a valid bounded protocol', () {
    final result = validator.validate(
      protocol(),
      policy: adaptivePolicy,
      soundExists: true,
      missionAvailable: true,
    );
    expect(result.isValid, isTrue);
  });

  test('rejects values above the user volume cap', () {
    final result = validator.validate(
      protocol().copyWith(initialVolumePercent: 100),
      policy: adaptivePolicy,
      soundExists: true,
      missionAvailable: true,
    );
    expect(result.errors, contains('initial_volume_out_of_bounds'));
  });

  test('fixed volume cannot be changed automatically', () {
    const fixed = AlarmAdaptationPolicy(
      enabled: true,
      sound: AdaptiveMode.adaptive,
      volume: AdaptiveMode.fixed,
      vibration: AdaptiveMode.adaptive,
      wakeCheck: AdaptiveMode.adaptive,
      mission: AdaptiveMode.fixed,
      userMaxVolumePercent: 100,
    );
    final original = protocol();
    final result = validator.validate(
      original.copyWith(initialVolumePercent: 60),
      policy: fixed,
      soundExists: true,
      missionAvailable: true,
      previous: original,
    );
    expect(result.errors, contains('fixed_volume_changed'));
  });
}
