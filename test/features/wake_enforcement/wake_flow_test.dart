import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/wake_enforcement/domain/wake_flow.dart';

void main() {
  test('allows the QR vertical-slice success path', () {
    final reducer = WakeFlowReducer();
    var state = WakeFlowState.idle;
    for (final next in [
      WakeFlowState.alarmActive,
      WakeFlowState.dismissRequested,
      WakeFlowState.missionPreparing,
      WakeFlowState.missionActive,
      WakeFlowState.missionCompleted,
      WakeFlowState.wakeCheckPending,
      WakeFlowState.wakeCheckActive,
      WakeFlowState.wakeCheckPassed,
      WakeFlowState.wakeConfirmed,
      WakeFlowState.completed,
    ]) {
      state = reducer.transition(state, next);
    }
    expect(state, WakeFlowState.completed);
  });

  test('rejects passing a wake check before it is active', () {
    expect(
      () => WakeFlowReducer().transition(
        WakeFlowState.missionCompleted,
        WakeFlowState.wakeCheckPassed,
      ),
      throwsA(isA<WakeFlowTransitionError>()),
    );
  });

  test('reactivation returns to mission preparation', () {
    final reducer = WakeFlowReducer();
    expect(
      reducer.transition(
        WakeFlowState.alarmReactivating,
        WakeFlowState.missionPreparing,
      ),
      WakeFlowState.missionPreparing,
    );
  });
}
