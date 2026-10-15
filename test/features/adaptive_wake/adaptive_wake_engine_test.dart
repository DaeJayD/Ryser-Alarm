import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/adaptive_wake/domain/adaptive_wake_engine.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_session_analyzer.dart';

import 'adaptive_test_fixtures.dart';

void main() {
  const engine = AdaptiveWakeEngine();

  test('repeated Wake Check failure changes only Wake Check delay', () {
    final decision = engine.decide(
      AdaptiveContext(
        current: protocol(
          missionRequired: true,
          missionConfiguration: '{"requiredSteps":20}',
        ),
        policy: adaptivePolicy,
        recent: [
          analysis(failure: WakeFailureMode.wakeCheckFailure),
          analysis(failure: WakeFailureMode.wakeCheckFailure),
          analysis(),
        ],
      ),
    );
    expect(decision.reasonCode, AdaptiveReasonCode.wakeCheckFailureRepeated);
    expect(decision.changes, hasLength(1));
    expect(decision.changes.single.dimension, AdaptiveDimension.wakeCheck);
    expect(decision.changes.single.newValue, 7);
  });

  test('repeated slow response increases volume by one bounded step', () {
    final decision = engine.decide(
      AdaptiveContext(
        current: protocol(volume: 50),
        policy: adaptivePolicy,
        recent: [
          analysis(response: ResponseLatencyClassification.slow),
          analysis(response: ResponseLatencyClassification.verySlow),
          analysis(response: ResponseLatencyClassification.normal),
        ],
      ),
    );
    expect(decision.changes, hasLength(1));
    expect(decision.changes.single.dimension, AdaptiveDimension.volume);
    expect(decision.changes.single.newValue, 60);
  });

  test('validated alternative changes only the sound family', () {
    final decision = engine.decide(
      AdaptiveContext(
        current: protocol(),
        policy: adaptivePolicy,
        alternativeSoundId: 'sound-2',
        alternativeSoundFamily: 'melodic',
        alternativeRingtoneUri: 'content://sound/2',
        recent: [
          analysis(response: ResponseLatencyClassification.slow),
          analysis(response: ResponseLatencyClassification.slow),
          analysis(response: ResponseLatencyClassification.normal),
        ],
      ),
    );
    expect(decision.changes, hasLength(1));
    expect(decision.changes.single.dimension, AdaptiveDimension.sound);
    expect(decision.changes.single.newValue, 'sound-2');
    expect(decision.changes.single.soundUri, 'content://sound/2');
  });

  test('repeated absent responses raise only initial playback within cap', () {
    final decision = engine.decide(
      AdaptiveContext(
        current: protocol(volume: 85),
        policy: adaptivePolicy,
        recent: [
          analysis(
            failure: WakeFailureMode.noResponse,
            response: ResponseLatencyClassification.unavailable,
          ),
          analysis(
            failure: WakeFailureMode.noResponse,
            response: ResponseLatencyClassification.unavailable,
          ),
          analysis(),
        ],
      ),
    );
    expect(decision.reasonCode, AdaptiveReasonCode.noResponse);
    expect(decision.changes, hasLength(1));
    expect(decision.changes.single.newValue, 90);
  });

  test('three strong successes de-escalate one dimension', () {
    final decision = engine.decide(
      AdaptiveContext(
        current: protocol(volume: 60),
        policy: adaptivePolicy,
        recent: [analysis(), analysis(), analysis()],
      ),
    );
    expect(decision.reasonCode, AdaptiveReasonCode.successStreak);
    expect(decision.changes, hasLength(1));
    expect(decision.changes.single.newValue, 50);
  });

  test('fast dismissal without Wake Check confirmation is not a success', () {
    final decision = engine.decide(
      AdaptiveContext(
        current: protocol(volume: 60),
        policy: adaptivePolicy,
        recent: [
          analysis(confirmedWake: false),
          analysis(confirmedWake: false),
          analysis(confirmedWake: false),
        ],
      ),
    );
    expect(decision.hasChange, isFalse);
  });

  test('baseline period produces no change', () {
    final decision = engine.decide(
      AdaptiveContext(
        current: protocol(),
        policy: adaptivePolicy,
        recent: [analysis(), analysis()],
      ),
    );
    expect(decision.hasChange, isFalse);
  });

  test('at volume cap, slow response adapts vibration alone', () {
    final decision = engine.decide(
      AdaptiveContext(
        current: protocol(volume: 90),
        policy: adaptivePolicy,
        recent: [
          analysis(response: ResponseLatencyClassification.slow),
          analysis(response: ResponseLatencyClassification.slow),
          analysis(response: ResponseLatencyClassification.normal),
        ],
      ),
    );
    expect(decision.changes, hasLength(1));
    expect(decision.changes.single.dimension, AdaptiveDimension.vibration);
    expect(decision.changes.single.newValue, VibrationPattern.doublePulse.name);
  });
}
