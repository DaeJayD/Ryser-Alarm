import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/wake_check/data/wake_check_service.dart';

void main() {
  test('scheduling persists the check and advances the same session', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    await database
        .into(database.wakeSessions)
        .insert(
          WakeSessionsCompanion.insert(
            id: 'session-1',
            alarmId: 'alarm-1',
            scheduledTimeMs: 1000,
            triggeredAtMs: 1000,
            initialSoundId: 'pulse-a',
            outcome: 'active',
            wakeEnforcementEnabled: const Value(true),
            currentWakeFlowState: const Value('missionCompleted'),
            createdAtMs: 1000,
          ),
        );
    final triggerAt = DateTime.fromMillisecondsSinceEpoch(301000);

    await WakeCheckService(database)
        .schedule(wakeSessionId: 'session-1', triggerAt: triggerAt);

    final session = await database.select(database.wakeSessions).getSingle();
    final check = await database.select(database.wakeChecks).getSingle();
    final event = await database.select(database.wakeEvents).getSingle();
    expect(session.currentWakeFlowState, 'wakeCheckPending');
    expect(session.wakeCheckAttemptCount, 1);
    expect(check.scheduledForMs, triggerAt.millisecondsSinceEpoch);
    expect(event.eventType, 'WAKE_CHECK_SCHEDULED');
  });
}
