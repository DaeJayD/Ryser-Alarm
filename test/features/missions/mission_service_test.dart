import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/missions/data/mission_service.dart';

void main() {
  late AppDatabase database;

  setUp(() async {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    await database
        .into(database.alarms)
        .insert(
          AlarmsCompanion.insert(
            id: 'alarm-1',
            localHour: 7,
            localMinute: 0,
            recurrenceType: 'daily',
            soundId: 'pulse-a',
            snoozeDurationMinutes: 5,
            createdAtMs: 1000,
            updatedAtMs: 1000,
          ),
        );
    await database
        .into(database.wakeSessions)
        .insert(
          WakeSessionsCompanion.insert(
            id: 'session-1',
            alarmId: 'alarm-1',
            scheduledTimeMs: 2000,
            triggeredAtMs: 2000,
            initialSoundId: 'pulse-a',
            outcome: 'active',
            wakeEnforcementEnabled: const Value(true),
            currentWakeFlowState: const Value('missionPreparing'),
            createdAtMs: 2000,
          ),
        );
    await database
        .into(database.missions)
        .insert(
          MissionsCompanion.insert(
            id: 'mission-1',
            alarmId: 'alarm-1',
            missionType: 'qr',
            difficulty: 'normal',
            createdAtMs: 1000,
            updatedAtMs: 1000,
          ),
        );
  });

  tearDown(() => database.close());

  test('start and complete are persisted with ordered events', () async {
    final ids = ['execution-1', 'event-1', 'event-2'].iterator;
    final service = MissionService(
      database,
      clock: () => DateTime.fromMillisecondsSinceEpoch(3000),
      idFactory: () {
        ids.moveNext();
        return ids.current;
      },
    );

    final executionId = await service.start(
      wakeSessionId: 'session-1',
      missionId: 'mission-1',
    );
    await service.complete(executionId);

    final session = await database.select(database.wakeSessions).getSingle();
    final execution = await database
        .select(database.missionExecutions)
        .getSingle();
    final events = await (database.select(
      database.wakeEvents,
    )..orderBy([(row) => OrderingTerm.asc(row.sequenceNumber)])).get();

    expect(session.currentWakeFlowState, 'missionCompleted');
    expect(session.missionAttemptCount, 1);
    expect(session.missionFailureCount, 0);
    expect(execution.status, 'completed');
    expect(events.map((event) => event.eventType), [
      'MISSION_STARTED',
      'MISSION_COMPLETED',
    ]);
  });

  test('resolved execution cannot be completed twice', () async {
    var id = 0;
    final service = MissionService(
      database,
      clock: () => DateTime.fromMillisecondsSinceEpoch(3000),
      idFactory: () => 'id-${id++}',
    );
    final executionId = await service.start(
      wakeSessionId: 'session-1',
      missionId: 'mission-1',
    );
    await service.complete(executionId);

    await expectLater(service.complete(executionId), throwsStateError);
    expect(await database.select(database.wakeEvents).get(), hasLength(2));
  });

  test(
    'emergency bypass is recorded as bypassed rather than success',
    () async {
      var id = 0;
      final service = MissionService(
        database,
        clock: () => DateTime.fromMillisecondsSinceEpoch(3000),
        idFactory: () => 'bypass-${id++}',
      );
      final executionId = await service.start(
        wakeSessionId: 'session-1',
        missionId: 'mission-1',
      );

      await service.bypass(executionId, reason: 'emergency_hold');

      final session = await database.select(database.wakeSessions).getSingle();
      final execution = await database
          .select(database.missionExecutions)
          .getSingle();
      expect(session.currentWakeFlowState, 'completed');
      expect(session.outcome, 'bypassed');
      expect(execution.status, 'bypassed');
      expect(execution.failureReason, 'emergency_hold');
    },
  );

  test(
    'mission timeout remains a failure and never dismisses as success',
    () async {
      var id = 0;
      final service = MissionService(
        database,
        clock: () => DateTime.fromMillisecondsSinceEpoch(3000),
        idFactory: () => 'timeout-${id++}',
      );
      final executionId = await service.start(
        wakeSessionId: 'session-1',
        missionId: 'mission-1',
      );

      await service.timeOut(executionId);

      final session = await database.select(database.wakeSessions).getSingle();
      final execution = await database
          .select(database.missionExecutions)
          .getSingle();
      expect(session.currentWakeFlowState, 'missionFailed');
      expect(session.outcome, 'active');
      expect(session.missionFailureCount, 1);
      expect(execution.status, 'timedOut');
      expect(execution.failureReason, 'timeout');
    },
  );

  test('timed-out mission can be prepared and attempted again', () async {
    var id = 0;
    final service = MissionService(
      database,
      clock: () => DateTime.fromMillisecondsSinceEpoch(3000 + id * 100),
      idFactory: () => 'retry-mission-${id++}',
    );
    var executionId = await service.start(
      wakeSessionId: 'session-1',
      missionId: 'mission-1',
    );
    await service.timeOut(executionId);

    await service.prepare('session-1');
    executionId = await service.start(
      wakeSessionId: 'session-1',
      missionId: 'mission-1',
    );

    final session = await database.select(database.wakeSessions).getSingle();
    expect(session.currentWakeFlowState, 'missionActive');
    expect(session.missionAttemptCount, 2);
    final executions = await database.select(database.missionExecutions).get();
    expect(executions, hasLength(2));
    expect(executions.last.id, executionId);
  });

  test('two failed Wake Checks end after the final recovery mission', () async {
    var id = 0;
    final service = MissionService(
      database,
      clock: () => DateTime.fromMillisecondsSinceEpoch(4000),
      idFactory: () => 'retry-${id++}',
    );
    await (database.update(
      database.wakeSessions,
    )..where((row) => row.id.equals('session-1'))).write(
      const WakeSessionsCompanion(
        currentWakeFlowState: Value('missionCompleted'),
        wakeCheckFailureCount: Value(2),
      ),
    );

    await service.completeAfterWakeRetryLimit('session-1');

    final session = await database.select(database.wakeSessions).getSingle();
    expect(session.currentWakeFlowState, 'completed');
    expect(session.outcome, 'retryLimitReached');
    final event = await database.select(database.wakeEvents).getSingle();
    expect(event.eventType, 'WAKE_RETRY_LIMIT_REACHED');
  });
}
