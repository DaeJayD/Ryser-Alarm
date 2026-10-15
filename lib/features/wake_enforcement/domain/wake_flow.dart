enum WakeFlowState {
  idle,
  alarmActive,
  dismissRequested,
  missionPreparing,
  missionActive,
  missionFailed,
  missionCompleted,
  wakeCheckPending,
  wakeCheckActive,
  wakeCheckPassed,
  wakeCheckFailed,
  alarmReactivating,
  wakeConfirmed,
  completed,
  emergencyBypass,
  cancelled,
}

class WakeFlowTransitionError extends StateError {
  WakeFlowTransitionError(this.from, this.to)
    : super('Illegal wake-flow transition: $from -> $to');

  final WakeFlowState from;
  final WakeFlowState to;
}

class WakeFlowReducer {
  static const _legal = <WakeFlowState, Set<WakeFlowState>>{
    WakeFlowState.idle: {WakeFlowState.alarmActive, WakeFlowState.cancelled},
    WakeFlowState.alarmActive: {
      WakeFlowState.dismissRequested,
      WakeFlowState.cancelled,
    },
    WakeFlowState.dismissRequested: {
      WakeFlowState.missionPreparing,
      WakeFlowState.completed,
    },
    WakeFlowState.missionPreparing: {
      WakeFlowState.missionActive,
      WakeFlowState.emergencyBypass,
    },
    WakeFlowState.missionActive: {
      WakeFlowState.missionCompleted,
      WakeFlowState.missionFailed,
      WakeFlowState.emergencyBypass,
    },
    WakeFlowState.missionFailed: {WakeFlowState.alarmReactivating},
    WakeFlowState.missionCompleted: {
      WakeFlowState.wakeCheckPending,
      WakeFlowState.completed,
    },
    WakeFlowState.wakeCheckPending: {WakeFlowState.wakeCheckActive},
    WakeFlowState.wakeCheckActive: {
      WakeFlowState.wakeCheckPassed,
      WakeFlowState.wakeCheckFailed,
    },
    WakeFlowState.wakeCheckPassed: {WakeFlowState.wakeConfirmed},
    WakeFlowState.wakeCheckFailed: {WakeFlowState.alarmReactivating},
    WakeFlowState.alarmReactivating: {WakeFlowState.missionPreparing},
    WakeFlowState.wakeConfirmed: {WakeFlowState.completed},
    WakeFlowState.emergencyBypass: {WakeFlowState.completed},
    WakeFlowState.completed: {},
    WakeFlowState.cancelled: {},
  };

  WakeFlowState transition(WakeFlowState from, WakeFlowState to) {
    if (!(_legal[from]?.contains(to) ?? false)) {
      throw WakeFlowTransitionError(from, to);
    }
    return to;
  }
}
