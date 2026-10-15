import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/adaptive_wake/domain/adaptive_wake_engine.dart';
import 'package:ryser/features/adaptive_wake/domain/protocol_validator.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_session_analyzer.dart';
import 'package:ryser/features/wake_check/domain/wake_check_protocol.dart';

import 'adaptive_test_fixtures.dart';

void main() {
  const engine = AdaptiveWakeEngine();
  test('older baseline cannot drown repeated recent slow responses', () {
    final recent = [
      analysis(response: ResponseLatencyClassification.slow),
      analysis(response: ResponseLatencyClassification.slow),
      analysis(),
      for (var i = 0; i < 27; i++) analysis(),
    ];
    final result = engine.decide(
      AdaptiveContext(
        current: protocol(),
        policy: adaptivePolicy,
        recent: recent,
      ),
    );
    expect(result.reasonCode, AdaptiveReasonCode.slowResponseRepeated);
  });
  test('severe no response bypasses baseline but respects user cap', () {
    final result = engine.decide(
      AdaptiveContext(
        current: protocol(volume: 85),
        policy: adaptivePolicy,
        recent: [
          analysis(
            failure: WakeFailureMode.noResponse,
            response: ResponseLatencyClassification.unavailable,
          ),
        ],
      ),
    );
    expect(result.reasonCode, AdaptiveReasonCode.noResponse);
    expect(result.severity, 'severe');
    expect(result.changes.single.newValue, 90);
  });
  test(
    'no response wins conflict; all other matches receive real rejection trace',
    () {
      final result = engine.decide(
        AdaptiveContext(
          current: protocol(
            missionRequired: true,
            missionConfiguration: '{"requiredSteps":20}',
          ),
          policy: adaptivePolicy,
          recent: [
            analysis(failure: WakeFailureMode.noResponse),
            analysis(failure: WakeFailureMode.wakeCheckFailure),
            analysis(failure: WakeFailureMode.wakeCheckFailure),
          ],
        ),
      );
      expect(result.selectedRuleId, 'no_response_repeated');
      expect(result.rulesMatched, contains('wake_check_failure_repeated'));
      expect(
        result.rejectedRules['wake_check_failure_repeated'],
        contains('Higher-priority'),
      );
      expect(result.changes, hasLength(1));
    },
  );
  test('repeated high snoozes cause one justified permitted adjustment', () {
    final result = engine.decide(
      AdaptiveContext(
        current: protocol(),
        policy: adaptivePolicy,
        recent: [
          analysis(snoozes: SnoozeClassification.high),
          analysis(snoozes: SnoozeClassification.high),
          analysis(),
        ],
      ),
    );
    expect(result.reasonCode, AdaptiveReasonCode.highSnoozeCount);
    expect(result.changes, hasLength(1));
  });
  test('minimum delay strengthens only Wake Check hold, never early sound or volume', () {
    final result = engine.decide(
      AdaptiveContext(
        current: protocol(
          wakeCheckDelay: 5,
          missionRequired: true,
          missionConfiguration: '{"requiredSteps":20}',
        ),
        policy: adaptivePolicy,
        alternativeSoundId: 'urgent-a',
        alternativeSoundFamily: 'URGENT',
        alternativeRingtoneUri:
            'android.resource://com.ryser.ryser/raw/urgent_a',
        recent: [
          analysis(failure: WakeFailureMode.wakeCheckFailure),
          analysis(failure: WakeFailureMode.wakeCheckFailure),
          analysis(),
        ],
      ),
    );
    expect(result.changes.single.dimension, AdaptiveDimension.wakeCheck);
    expect(result.changes.single.field, 'wakeCheckHoldMilliseconds');
    expect(result.changes.single.newValue, 2500);
  });
  test(
    'repeated emergency bypass requests review without automatic escalation',
    () {
      final result = engine.decide(
        AdaptiveContext(
          current: protocol(),
          policy: adaptivePolicy,
          recent: [
            analysis(failure: WakeFailureMode.emergencyBypass),
            analysis(failure: WakeFailureMode.emergencyBypass),
          ],
        ),
      );
      expect(result.reasonCode, AdaptiveReasonCode.emergencyBypassRepeated);
      expect(result.shouldApplyAutomatically, isFalse);
      expect(result.changes, isEmpty);
    },
  );
  test('intensity corresponds to configuration and can decrease', () {
    final initial = protocol(volume: 90);
    final reduced = initial.copyWith(initialVolumePercent: 30);
    expect(
      calculateWakeIntensity(initial).index,
      greaterThan(calculateWakeIntensity(reduced).index),
    );
  });
  const fixed = AlarmAdaptationPolicy(
    enabled: true,
    sound: AdaptiveMode.fixed,
    volume: AdaptiveMode.fixed,
    vibration: AdaptiveMode.fixed,
    wakeCheck: AdaptiveMode.fixed,
    mission: AdaptiveMode.fixed,
    userMaxVolumePercent: 100,
  );
  for (final mutation in <(String, WakeProtocol Function(WakeProtocol))>[
    (
      'fixed_volume_changed',
      (p) => p.copyWith(volumeEscalationIntervalSeconds: 30),
    ),
    (
      'fixed_volume_changed',
      (p) => p.copyWith(volumeEscalationStepPercent: 15),
    ),
    ('fixed_vibration_changed', (p) => p.copyWith(vibrationEnabled: false)),
    ('fixed_mission_changed', (p) => p.copyWith(missionRequired: true)),
    (
      'fixed_wake_check_changed',
      (p) => p.copyWith(wakeCheckHoldMilliseconds: 3000),
    ),
    (
      'fixed_wake_check_changed',
      (p) => p.copyWith(
        reactivationSoundPolicy: ReactivationSoundPolicy.alternateFamily,
      ),
    ),
  ]) {
    test('validator rejects ${mutation.$1} for ${mutation.$2}', () {
      final original = protocol();
      final result = const WakeProtocolValidator().validate(
        mutation.$2(original),
        policy: fixed,
        soundExists: true,
        missionAvailable: true,
        previous: original,
      );
      expect(result.errors, contains(mutation.$1));
    });
  }
  for (final config in [
    '[]',
    'null',
    '{"requiredSteps":0}',
    '{"requiredSteps":"20"}',
  ]) {
    test('validator rejects non-executable mission $config', () {
      final result = const WakeProtocolValidator().validate(
        protocol(missionRequired: true, missionConfiguration: config),
        policy: adaptivePolicy,
        soundExists: true,
        missionAvailable: true,
      );
      expect(result.isValid, isFalse);
    });
  }
  test('device resource and vibration unavailability are rejected', () {
    final result = const WakeProtocolValidator().validate(
      protocol(),
      policy: adaptivePolicy,
      soundExists: false,
      missionAvailable: true,
      vibrationSupported: false,
    );
    expect(
      result.errors,
      containsAll(['sound_unavailable', 'vibration_unavailable']),
    );
  });
  test(
    'non-default Wake Check settings parse and malformed data safely defaults',
    () {
      final settings = WakeCheckProtocol.fromSnapshot(
        '{"wakeCheckHoldMilliseconds":3500,"maxWakeCheckFailures":3}',
      );
      expect(settings.holdMilliseconds, 3500);
      expect(settings.maximumFailures, 3);
      expect(WakeCheckProtocol.fromSnapshot('[]').maximumFailures, 2);
      expect(WakeCheckProtocol.fromSnapshot('{').holdMilliseconds, 2000);
    },
  );
}
