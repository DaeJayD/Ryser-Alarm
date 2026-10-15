import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/missions/domain/mission.dart' as domain;
import 'package:ryser/features/wake_enforcement/domain/wake_flow.dart';
import 'package:uuid/uuid.dart';

typedef MissionIdFactory = String Function();

class MissionService {
  MissionService(
    this._database, {
    DateTime Function()? clock,
    MissionIdFactory? idFactory,
  }) : _clock = clock ?? DateTime.now,
       _idFactory = idFactory ?? const Uuid().v4;

  final AppDatabase _database;
  final WakeFlowReducer _reducer = WakeFlowReducer();
  final DateTime Function() _clock;
  final MissionIdFactory _idFactory;

  Future<void> prepare(String wakeSessionId) {
    return _database.transaction(() async {
      final session = await _session(wakeSessionId);
      final current = WakeFlowState.values.byName(session.currentWakeFlowState);
      final now = _clock().millisecondsSinceEpoch;
      late final WakeFlowState preparing;
      if (current == WakeFlowState.missionFailed) {
        final reactivating = _reducer.transition(
          current,
          WakeFlowState.alarmReactivating,
        );
        preparing = _reducer.transition(
          reactivating,
          WakeFlowState.missionPreparing,
        );
        await _appendEvent(wakeSessionId, 'ALARM_REACTIVATED', now, const {
          'reason': 'mission_retry',
        });
      } else {
        final requested = _reducer.transition(
          current,
          WakeFlowState.dismissRequested,
        );
        preparing = _reducer.transition(
          requested,
          WakeFlowState.missionPreparing,
        );
        await _appendEvent(wakeSessionId, 'DISMISS_REQUESTED', now, const {});
      }
      await _updateSession(wakeSessionId, state: preparing);
      await _appendEvent(wakeSessionId, 'MISSION_PREPARED', now, const {});
    });
  }

  Future<String> start({
    required String wakeSessionId,
    required String missionId,
  }) {
    return _database.transaction(() async {
      final session = await _session(wakeSessionId);
      final mission = await (_database.select(
        _database.missions,
      )..where((row) => row.id.equals(missionId))).getSingle();
      final nextState = _reducer.transition(
        WakeFlowState.values.byName(session.currentWakeFlowState),
        WakeFlowState.missionActive,
      );
      final executionId = _idFactory();
      final attempt = session.missionAttemptCount + 1;
      final now = _clock().millisecondsSinceEpoch;
      await _database
          .into(_database.missionExecutions)
          .insert(
            MissionExecutionsCompanion.insert(
              id: executionId,
              wakeSessionId: wakeSessionId,
              missionId: missionId,
              missionType: mission.missionType,
              status: domain.MissionExecutionStatus.active.name,
              attemptNumber: attempt,
              startedAtMs: now,
            ),
          );
      await _updateSession(
        wakeSessionId,
        state: nextState,
        missionType: mission.missionType,
        attemptCount: attempt,
      );
      await _appendEvent(wakeSessionId, 'MISSION_STARTED', now, {
        'missionType': mission.missionType,
        'attempt': attempt,
      });
      return executionId;
    });
  }

  Future<void> complete(String executionId) => _finish(
    executionId,
    status: domain.MissionExecutionStatus.completed,
    nextState: WakeFlowState.missionCompleted,
    eventType: 'MISSION_COMPLETED',
  );

  Future<void> fail(String executionId, {required String reason}) => _finish(
    executionId,
    status: domain.MissionExecutionStatus.failed,
    nextState: WakeFlowState.missionFailed,
    eventType: 'MISSION_FAILED',
    reason: reason,
  );

  Future<void> timeOut(String executionId) => _finish(
    executionId,
    status: domain.MissionExecutionStatus.timedOut,
    nextState: WakeFlowState.missionFailed,
    eventType: 'MISSION_TIMED_OUT',
    reason: 'timeout',
  );

  Future<void> bypass(String executionId, {String? reason}) => _finish(
    executionId,
    status: domain.MissionExecutionStatus.bypassed,
    nextState: WakeFlowState.emergencyBypass,
    eventType: 'MISSION_BYPASSED',
    reason: reason,
  );

  Future<void> completeAfterWakeRetryLimit(String wakeSessionId) {
    return _database.transaction(() async {
      final session = await _session(wakeSessionId);
      final completed = _reducer.transition(
        WakeFlowState.values.byName(session.currentWakeFlowState),
        WakeFlowState.completed,
      );
      final now = _clock().millisecondsSinceEpoch;
      await (_database.update(
        _database.wakeSessions,
      )..where((row) => row.id.equals(wakeSessionId))).write(
        WakeSessionsCompanion(
          currentWakeFlowState: Value(completed.name),
          outcome: const Value('retryLimitReached'),
          completedAtMs: Value(now),
        ),
      );
      await _appendEvent(wakeSessionId, 'WAKE_RETRY_LIMIT_REACHED', now, {
        'failures': session.wakeCheckFailureCount,
      });
    });
  }

  Future<void> _finish(
    String executionId, {
    required domain.MissionExecutionStatus status,
    required WakeFlowState nextState,
    required String eventType,
    String? reason,
  }) {
    return _database.transaction(() async {
      final execution = await (_database.select(
        _database.missionExecutions,
      )..where((row) => row.id.equals(executionId))).getSingle();
      if (execution.status != domain.MissionExecutionStatus.active.name) {
        throw StateError('Mission execution is already resolved.');
      }
      final session = await _session(execution.wakeSessionId);
      final resolvedState = _reducer.transition(
        WakeFlowState.values.byName(session.currentWakeFlowState),
        nextState,
      );
      final now = _clock().millisecondsSinceEpoch;
      final completed = status == domain.MissionExecutionStatus.completed;
      await (_database.update(
        _database.missionExecutions,
      )..where((row) => row.id.equals(executionId))).write(
        MissionExecutionsCompanion(
          status: Value(status.name),
          completedAtMs: completed ? Value(now) : const Value.absent(),
          failedAtMs: completed ? const Value.absent() : Value(now),
          failureReason: Value(reason),
        ),
      );
      await _updateSession(
        execution.wakeSessionId,
        state: resolvedState,
        failureCount: completed ? null : session.missionFailureCount + 1,
      );
      await _appendEvent(execution.wakeSessionId, eventType, now, {
        'missionType': execution.missionType,
        'attempt': execution.attemptNumber,
        'reason': ?reason,
      });
      if (status == domain.MissionExecutionStatus.bypassed) {
        await (_database.update(
          _database.wakeSessions,
        )..where((row) => row.id.equals(execution.wakeSessionId))).write(
          WakeSessionsCompanion(
            currentWakeFlowState: const Value('completed'),
            outcome: const Value('bypassed'),
            completedAtMs: Value(now),
          ),
        );
      }
    });
  }

  Future<WakeSession> _session(String id) {
    return (_database.select(
      _database.wakeSessions,
    )..where((row) => row.id.equals(id))).getSingle();
  }

  Future<void> _updateSession(
    String id, {
    required WakeFlowState state,
    String? missionType,
    int? attemptCount,
    int? failureCount,
  }) {
    return (_database.update(
      _database.wakeSessions,
    )..where((row) => row.id.equals(id))).write(
      WakeSessionsCompanion(
        currentWakeFlowState: Value(state.name),
        missionType: missionType == null
            ? const Value.absent()
            : Value(missionType),
        missionAttemptCount: attemptCount == null
            ? const Value.absent()
            : Value(attemptCount),
        missionFailureCount: failureCount == null
            ? const Value.absent()
            : Value(failureCount),
      ),
    );
  }

  Future<void> _appendEvent(
    String sessionId,
    String eventType,
    int occurredAtMs,
    Map<String, Object> metadata,
  ) async {
    final prior = await (_database.select(
      _database.wakeEvents,
    )..where((row) => row.wakeSessionId.equals(sessionId))).get();
    await _database
        .into(_database.wakeEvents)
        .insert(
          WakeEventsCompanion.insert(
            id: _idFactory(),
            wakeSessionId: sessionId,
            sequenceNumber: prior.length,
            eventType: eventType,
            occurredAtMs: occurredAtMs,
            metadataJson: jsonEncode(metadata),
            source: 'flutter',
          ),
        );
  }
}
