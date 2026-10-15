import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/missions/data/mission_service.dart';
import 'package:ryser/features/wake_check/data/wake_check_service.dart';
import 'package:ryser/features/wake_sessions/data/runtime_event_reconciler.dart';

class _EventApi extends AlarmRuntimeApi {
  _EventApi(this.events);
  final List<RuntimeEventDto> events;

  @override
  Future<List<RuntimeEventDto>> getRuntimeEvents() async => events;

  @override
  Future<void> acknowledgeRuntimeEvents(List<String> eventIds) async {}
}

RuntimeEventDto _event(String id, String type, int time) => RuntimeEventDto(
  id: id,
  sessionId: 'session-1',
  alarmId: 'alarm-1',
  eventType: type,
  occurredAtMs: time,
  scheduledAtMs: 1000,
  ringtoneUri: 'alarm://one',
  metadataJson: '{}',
  protocolId: '',
  protocolVersion: 0,
  protocolSnapshotJson: '{}',
);

Future<AppDatabase> _seed(String missionType) async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
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
          createdAtMs: 1,
          updatedAtMs: 1,
        ),
      );
  await database
      .into(database.wakeSessions)
      .insert(
        WakeSessionsCompanion.insert(
          id: 'session-1',
          alarmId: 'alarm-1',
          scheduledTimeMs: 1000,
          triggeredAtMs: 1000,
          initialSoundId: 'alarm://one',
          outcome: 'active',
          wakeEnforcementEnabled: const Value(true),
          currentWakeFlowState: const Value('alarmActive'),
          createdAtMs: 1000,
        ),
      );
  await database
      .into(database.missions)
      .insert(
        MissionsCompanion.insert(
          id: 'mission-1',
          alarmId: 'alarm-1',
          missionType: missionType,
          difficulty: 'normal',
          configurationJson: Value(
            missionType == 'qr'
                ? '{"payloadHash":"abc","wakeCheckDelayMinutes":5}'
                : '{"requiredSteps":20,"wakeCheckDelayMinutes":5}',
          ),
          createdAtMs: 1,
          updatedAtMs: 1,
        ),
      );
  return database;
}

void main() {
  for (final missionType in ['qr', 'movement']) {
    test(
      '$missionType mission reaches delayed Wake Check confirmation',
      () async {
        final database = await _seed(missionType);
        addTearDown(database.close);
        var nextId = 0;
        final missions = MissionService(
          database,
          clock: () => DateTime.fromMillisecondsSinceEpoch(2000),
          idFactory: () => 'generated-${nextId++}',
        );

        await missions.prepare('session-1');
        final execution = await missions.start(
          wakeSessionId: 'session-1',
          missionId: 'mission-1',
        );
        await missions.complete(execution);
        await WakeCheckService(database).schedule(
          wakeSessionId: 'session-1',
          triggerAt: DateTime.fromMillisecondsSinceEpoch(302000),
        );
        await RuntimeEventReconciler(
          database,
          AlarmRuntimeGateway(
            api: _EventApi([
              _event('native-trigger', 'WAKE_CHECK_TRIGGERED', 302000),
              _event('native-touch', 'WAKE_CHECK_INTERACTION', 302100),
              _event('native-pass', 'WAKE_CHECK_PASSED', 304100),
            ]),
          ),
        ).reconcile();

        final session = await database
            .select(database.wakeSessions)
            .getSingle();
        expect(session.currentWakeFlowState, 'completed');
        expect(session.outcome, 'wakeConfirmed');
        expect(session.missionType, missionType);
        expect(session.missionAttemptCount, 1);
        expect(session.wakeCheckAttemptCount, 1);
        expect(session.confirmedAwakeAtMs, 304100);
      },
    );
  }

  test(
    'failed delayed check reuses one session and requires mission attempt two',
    () async {
      final database = await _seed('qr');
      addTearDown(database.close);
      var nextId = 0;
      final missions = MissionService(
        database,
        clock: () => DateTime.fromMillisecondsSinceEpoch(2000 + nextId * 100),
        idFactory: () => 'generated-${nextId++}',
      );

      await missions.prepare('session-1');
      var execution = await missions.start(
        wakeSessionId: 'session-1',
        missionId: 'mission-1',
      );
      await missions.complete(execution);
      await WakeCheckService(database).schedule(
        wakeSessionId: 'session-1',
        triggerAt: DateTime.fromMillisecondsSinceEpoch(302000),
      );
      await RuntimeEventReconciler(
        database,
        AlarmRuntimeGateway(
          api: _EventApi([
            _event('check-1-trigger', 'WAKE_CHECK_TRIGGERED', 302000),
            _event('check-1-missed', 'WAKE_CHECK_MISSED', 362000),
            _event('reactivation-1', 'ALARM_REACTIVATED', 362001),
          ]),
        ),
      ).reconcile();

      await missions.prepare('session-1');
      execution = await missions.start(
        wakeSessionId: 'session-1',
        missionId: 'mission-1',
      );
      await missions.complete(execution);
      await WakeCheckService(database).schedule(
        wakeSessionId: 'session-1',
        triggerAt: DateTime.fromMillisecondsSinceEpoch(662000),
      );
      await RuntimeEventReconciler(
        database,
        AlarmRuntimeGateway(
          api: _EventApi([
            _event('check-2-trigger', 'WAKE_CHECK_TRIGGERED', 662000),
            _event('check-2-pass', 'WAKE_CHECK_PASSED', 664000),
          ]),
        ),
      ).reconcile();

      final sessions = await database.select(database.wakeSessions).get();
      expect(sessions, hasLength(1));
      expect(sessions.single.id, 'session-1');
      expect(sessions.single.missionAttemptCount, 2);
      expect(sessions.single.wakeCheckAttemptCount, 2);
      expect(sessions.single.wakeCheckFailureCount, 1);
      expect(sessions.single.escalationCount, 1);
      expect(sessions.single.outcome, 'wakeConfirmed');
    },
  );
}
