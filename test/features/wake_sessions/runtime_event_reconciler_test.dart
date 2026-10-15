import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/wake_sessions/data/runtime_event_reconciler.dart';

class _FakeRuntimeApi extends AlarmRuntimeApi {
  _FakeRuntimeApi(this.events);
  final List<RuntimeEventDto> events;
  List<String> acknowledged = [];

  @override
  Future<List<RuntimeEventDto>> getRuntimeEvents() async => events;

  @override
  Future<void> acknowledgeRuntimeEvents(List<String> eventIds) async {
    acknowledged = eventIds;
  }
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

Future<AppDatabase> _databaseInWakeCheck() async {
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  await database
      .into(database.wakeSessions)
      .insert(
        WakeSessionsCompanion.insert(
          id: 'session-1',
          alarmId: 'alarm-1',
          scheduledTimeMs: 1000,
          triggeredAtMs: 1001,
          initialSoundId: 'alarm://one',
          outcome: 'active',
          wakeEnforcementEnabled: const Value(true),
          currentWakeFlowState: const Value('wakeCheckPending'),
          wakeCheckAttemptCount: const Value(1),
          createdAtMs: 1001,
        ),
      );
  await database
      .into(database.wakeChecks)
      .insert(
        WakeChecksCompanion.insert(
          id: 'check-1',
          wakeSessionId: 'session-1',
          attemptNumber: 1,
          scheduledForMs: 2000,
          status: 'pending',
          createdAtMs: 1100,
        ),
      );
  return database;
}

void main() {
  test(
    'delayed Wake Check trigger and hold confirmation complete the session',
    () async {
      final database = await _databaseInWakeCheck();
      addTearDown(database.close);
      final api = _FakeRuntimeApi([
        _event('triggered', 'WAKE_CHECK_TRIGGERED', 2000),
        _event('interaction', 'WAKE_CHECK_INTERACTION', 2100),
        _event('passed', 'WAKE_CHECK_PASSED', 4100),
      ]);

      await RuntimeEventReconciler(
        database,
        AlarmRuntimeGateway(api: api),
      ).reconcile();

      final session = await database.select(database.wakeSessions).getSingle();
      final check = await database.select(database.wakeChecks).getSingle();
      expect(session.currentWakeFlowState, 'completed');
      expect(session.outcome, 'wakeConfirmed');
      expect(session.confirmedAwakeAtMs, 4100);
      expect(check.status, 'passed');
      expect(check.triggeredAtMs, 2000);
      expect(check.firstInteractionAtMs, 2100);
      expect(api.acknowledged, ['triggered', 'interaction', 'passed']);
    },
  );

  test('missed Wake Check reactivates the same session exactly once', () async {
    final database = await _databaseInWakeCheck();
    addTearDown(database.close);
    final events = [
      _event('triggered', 'WAKE_CHECK_TRIGGERED', 2000),
      _event('missed', 'WAKE_CHECK_MISSED', 62000),
      _event('reactivated', 'ALARM_REACTIVATED', 62001),
    ];
    final api = _FakeRuntimeApi(events);
    final reconciler = RuntimeEventReconciler(
      database,
      AlarmRuntimeGateway(api: api),
    );

    await reconciler.reconcile();
    await reconciler.reconcile();

    final sessions = await database.select(database.wakeSessions).get();
    final check = await database.select(database.wakeChecks).getSingle();
    expect(sessions, hasLength(1));
    expect(sessions.single.id, 'session-1');
    expect(sessions.single.currentWakeFlowState, 'alarmActive');
    expect(sessions.single.wakeCheckFailureCount, 1);
    expect(sessions.single.escalationCount, 1);
    expect(check.status, 'missed');
    final storedEvents = await database.select(database.wakeEvents).get();
    expect(storedEvents.where((event) => event.id == 'missed'), hasLength(1));
  });
}
