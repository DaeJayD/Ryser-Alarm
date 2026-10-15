import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_session_analyzer.dart';

void main() {
  const analyzer = WakeSessionAnalyzer();

  test('prioritizes Wake Check failure over a slow initial response', () {
    final result = analyzer.analyze(
      const WakeSessionEvidence(
        sessionId: 'one',
        outcome: 'retryLimitReached',
        responseLatencyMs: 50000,
        snoozeCount: 0,
        missionFailureCount: 0,
        wakeCheckFailureCount: 1,
        reactivationCount: 1,
        emergencyBypass: false,
        completed: true,
      ),
      comparableValidSessionCount: 4,
    );
    expect(result.primaryFailureMode, WakeFailureMode.wakeCheckFailure);
    expect(
      result.secondaryFailureModes,
      contains(WakeFailureMode.slowInitialResponse),
    );
    expect(result.dataSufficiency, DataSufficiency.limited);
  });

  test('incomplete sessions never drive adaptation', () {
    final result = analyzer.analyze(
      const WakeSessionEvidence(
        sessionId: 'two',
        outcome: 'active',
        responseLatencyMs: null,
        snoozeCount: 0,
        missionFailureCount: 0,
        wakeCheckFailureCount: 0,
        reactivationCount: 0,
        emergencyBypass: false,
        completed: false,
      ),
      comparableValidSessionCount: 10,
    );
    expect(result.primaryFailureMode, WakeFailureMode.unknown);
    expect(result.validForAdaptation, isFalse);
  });

  test('emergency bypass is recorded but cannot train adaptation', () {
    final result = analyzer.analyze(
      const WakeSessionEvidence(
        sessionId: 'bypass',
        outcome: 'bypassed',
        responseLatencyMs: null,
        snoozeCount: 0,
        missionFailureCount: 1,
        wakeCheckFailureCount: 0,
        reactivationCount: 0,
        emergencyBypass: true,
        completed: true,
      ),
      comparableValidSessionCount: 7,
    );
    expect(result.primaryFailureMode, WakeFailureMode.emergencyBypass);
    expect(result.validForAdaptation, isFalse);
  });

  test('mission failure is prioritized over slow response and snoozes', () {
    final result = analyzer.analyze(
      const WakeSessionEvidence(
        sessionId: 'mission',
        outcome: 'wakeConfirmed',
        responseLatencyMs: 61000,
        snoozeCount: 3,
        missionFailureCount: 2,
        wakeCheckFailureCount: 0,
        reactivationCount: 0,
        emergencyBypass: false,
        completed: true,
      ),
      comparableValidSessionCount: 3,
    );
    expect(result.primaryFailureMode, WakeFailureMode.missionFailure);
    expect(
      result.secondaryFailureModes,
      containsAll([
        WakeFailureMode.slowInitialResponse,
        WakeFailureMode.excessiveSnooze,
      ]),
    );
    expect(result.validForAdaptation, isTrue);
  });
}
