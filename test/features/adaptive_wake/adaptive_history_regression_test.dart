import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart' hide WakeProtocol;
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/features/adaptive_wake/data/adaptive_wake_coordinator.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

import 'adaptive_test_fixtures.dart';

Future<AppDatabase> databaseWithAlarm() async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db
      .into(db.alarms)
      .insert(
        AlarmsCompanion.insert(
          id: 'alarm-1',
          localHour: 7,
          localMinute: 0,
          recurrenceType: 'daily',
          soundId: 'pulse-a',
          ringtoneUri: const Value('content://sound/1'),
          snoozeDurationMinutes: 5,
          createdAtMs: 1,
          updatedAtMs: 1,
        ),
      );
  return db;
}

Future<void> addSession(
  AppDatabase db,
  String id,
  String protocolId,
  int time, {
  int? latency = 10000,
  int checks = 0,
  int missions = 0,
  String status = 'pending',
}) async {
  await db
      .into(db.wakeSessions)
      .insert(
        WakeSessionsCompanion.insert(
          id: id,
          alarmId: 'alarm-1',
          scheduledTimeMs: time,
          triggeredAtMs: time,
          initialSoundId: 'content://sound/1',
          responseLatencyMs: Value(latency),
          wakeCheckFailureCount: Value(checks),
          missionFailureCount: Value(missions),
          outcome: 'wakeConfirmed',
          protocolId: Value(protocolId),
          protocolVersion: const Value(1),
          createdAtMs: time,
          completedAtMs: Value(time + 100),
          analysisStatus: Value(status),
        ),
      );
}

class _ReadyGateway extends AlarmRuntimeGateway {
  @override
  Future<bool> isSoundAvailable(String uri) async => true;
  @override
  Future<bool> canVibrate() async => true;
  @override
  Future<bool> isMissionAvailable(String type) async => true;
}

void main() {
  test(
    'mixed backlog retains each session analysis and excludes later evidence',
    () async {
      final db = await databaseWithAlarm();
      addTearDown(db.close);
      final repo = WakeProtocolRepository(db);
      await repo.insertAndActivate(protocol());
      await addSession(db, 'fast', 'protocol-1', 1000);
      await addSession(db, 'slow', 'protocol-1', 2000, latency: 50000);
      await addSession(db, 'check', 'protocol-1', 3000, checks: 2);
      final coordinator = AdaptiveWakeCoordinator(db, repo, _ReadyGateway());
      expect(await coordinator.processPending(), 3);
      final rows = await db.select(db.protocolEvaluations).get();
      final byId = {for (final row in rows) row.wakeSessionId: row};
      expect(byId['fast']!.primaryFailureMode, 'none');
      expect(byId['slow']!.primaryFailureMode, 'slowInitialResponse');
      expect(byId['check']!.primaryFailureMode, 'wakeCheckFailure');
      expect(
        (jsonDecode(byId['fast']!.analysisJson) as Map)['comparisonSessionIds'],
        ['fast'],
      );
      expect(
        (jsonDecode(byId['slow']!.analysisJson) as Map)['comparisonSessionIds'],
        ['slow', 'fast'],
      );
      expect(await coordinator.processPending(), 0);
    },
  );

  test('invalid activation preserves active version; lost resource resolves last valid', () async {
    final db = await databaseWithAlarm();
    addTearDown(db.close);
    var missing = false;
    final repo = WakeProtocolRepository(
      db,
      soundAvailable: (uri) async => !(missing && uri == 'content://sound/2'),
    );
    await repo.insertAndActivate(protocol());
    await expectLater(
      repo.insertAndActivate(
        protocol().copyWith(id: 'bad', version: 2, initialVolumePercent: 101),
      ),
      throwsStateError,
    );
    expect((await repo.activeForAlarm('alarm-1'))!.id, 'protocol-1');
    await repo.insertAndActivate(
      protocol().copyWith(
        id: 'protocol-2',
        version: 2,
        ringtoneUri: 'content://sound/2',
        supersedesProtocolId: 'protocol-1',
      ),
    );
    missing = true;
    expect((await repo.resolveForAlarm('alarm-1'))!.id, 'protocol-1');
    expect((await repo.createUserDefinedVersion('alarm-1')).version, 3);
  });

  test('repeated targeted regression creates a recovery version and marks reverted', () async {
    final db = await databaseWithAlarm();
    addTearDown(db.close);
    final repo = WakeProtocolRepository(db);
    await repo.savePolicy('alarm-1', adaptivePolicy);
    await repo.insertAndActivate(protocol());
    await addSession(db, 'old1', 'protocol-1', 1000, status: 'completed');
    await addSession(db, 'old2', 'protocol-1', 2000, status: 'completed');
    await repo.insertAndActivate(
      protocol().copyWith(
        id: 'protocol-2',
        version: 2,
        source: WakeProtocolSource.adaptiveEngine,
        initialVolumePercent: 60,
        supersedesProtocolId: 'protocol-1',
        basedOnSessionId: 'old2',
        reasonCode: AdaptiveReasonCode.slowResponseRepeated,
      ),
    );
    await addSession(
      db,
      'new1',
      'protocol-2',
      3000,
      latency: 50000,
      status: 'completed',
    );
    await addSession(db, 'new2', 'protocol-2', 4000, latency: 55000);
    await AdaptiveWakeCoordinator(db, repo, _ReadyGateway()).processPending();
    final active = (await repo.activeForAlarm('alarm-1'))!;
    expect(active.source, WakeProtocolSource.recovery);
    expect(active.initialVolumePercent, 50);
    expect(active.reasonCode, AdaptiveReasonCode.performanceWorsened);
    expect(
      (await repo.findById('protocol-2'))!.status,
      WakeProtocolStatus.reverted,
    );
  });
}
