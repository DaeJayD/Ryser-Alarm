import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/database/app_database.dart' hide WakeProtocol;
import 'package:ryser/features/adaptive_wake/data/adaptive_wake_coordinator.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

import 'adaptive_test_fixtures.dart';

void main() {
  test(
    'a completed session is evaluated once and advances one protocol',
    () async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      try {
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
        final protocols = WakeProtocolRepository(database);
        await protocols.insertAndActivate(protocol());
        await protocols.savePolicy('alarm-1', adaptivePolicy);
        for (var index = 0; index < 3; index++) {
          await database
              .into(database.wakeSessions)
              .insert(
                WakeSessionsCompanion.insert(
                  id: 'session-$index',
                  alarmId: 'alarm-1',
                  scheduledTimeMs: 1000 + index * 1000,
                  triggeredAtMs: 1000 + index * 1000,
                  initialSoundId: 'sound-1',
                  responseLatencyMs: const Value(50000),
                  outcome: 'wakeConfirmed',
                  protocolId: const Value('protocol-1'),
                  protocolVersion: const Value(1),
                  createdAtMs: 1000 + index * 1000,
                  completedAtMs: Value(1500 + index * 1000),
                ),
              );
        }
        final coordinator = AdaptiveWakeCoordinator(
          database,
          protocols,
          _AvailableGateway(),
        );
        expect(await coordinator.processPending(), 3);
        expect(await coordinator.processPending(), 0);
        final versions = await protocols.historyForAlarm('alarm-1');
        expect(versions, hasLength(2));
        expect(versions.first.version, 2);
        expect(versions.first.initialSoundId, 'melodic-a');
        expect(versions.first.initialSoundFamily, 'MELODIC');
        expect(
          versions.first.ringtoneUri,
          'android.resource://com.ryser.ryser/raw/melodic_a',
        );
        expect(versions.first.initialVolumePercent, 50);
        expect(
          await database.select(database.protocolEvaluations).get(),
          hasLength(3),
        );
      } finally {
        await database.close();
      }
    },
  );

  test('rejected replacement schedule preserves the active protocol', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    try {
      await database
          .into(database.alarms)
          .insert(
            AlarmsCompanion.insert(
              id: 'alarm-1',
              localHour: 7,
              localMinute: 0,
              enabled: const Value(true),
              recurrenceType: 'daily',
              soundId: 'pulse-a',
              snoozeDurationMinutes: 5,
              createdAtMs: 1000,
              updatedAtMs: 1000,
            ),
          );
      final protocols = WakeProtocolRepository(database);
      await protocols.insertAndActivate(protocol());
      await protocols.savePolicy('alarm-1', adaptivePolicy);
      for (var index = 0; index < 3; index++) {
        await database
            .into(database.wakeSessions)
            .insert(
              WakeSessionsCompanion.insert(
                id: 'rejected-$index',
                alarmId: 'alarm-1',
                scheduledTimeMs: 1000 + index * 1000,
                triggeredAtMs: 1000 + index * 1000,
                initialSoundId: 'sound-1',
                responseLatencyMs: const Value(50000),
                outcome: 'wakeConfirmed',
                protocolId: const Value('protocol-1'),
                protocolVersion: const Value(1),
                createdAtMs: 1000 + index * 1000,
                completedAtMs: Value(1500 + index * 1000),
              ),
            );
      }
      final coordinator = AdaptiveWakeCoordinator(
        database,
        protocols,
        _RejectingGateway(),
      );
      expect(await coordinator.processPending(), 3);
      expect((await protocols.activeForAlarm('alarm-1'))?.id, 'protocol-1');
      expect(await protocols.historyForAlarm('alarm-1'), hasLength(1));
      final rejected =
          (await database.select(database.protocolEvaluations).get()).where(
            (item) => item.selectedRuleId == 'slow_response_repeated',
          );
      expect(rejected, isNotEmpty);
      expect(rejected.every((item) => item.result == 'kept'), isTrue);
      expect(
        rejected.every(
          (item) => item.evaluationNotes.contains('Android rejected'),
        ),
        isTrue,
      );
    } finally {
      await database.close();
    }
  });
}

class _AvailableGateway extends AlarmRuntimeGateway {
  @override
  Future<bool> isSoundAvailable(String uri) async => true;
  @override
  Future<bool> canVibrate() async => true;
  @override
  Future<bool> isMissionAvailable(String type) async => true;
}

class _RejectingGateway extends _AvailableGateway {
  @override
  Future<AlarmApplyResult> schedule({
    required String alarmId,
    required DateTime triggerAt,
    required String label,
    required String ringtoneUri,
    required bool vibrationEnabled,
    required bool snoozeEnabled,
    required int snoozeDurationMinutes,
    required bool adaptiveSoundRotation,
    required bool increasingVolume,
    required int localHour,
    required int localMinute,
    required String recurrenceType,
    required int repeatDaysMask,
    WakeProtocol? protocol,
  }) async => AlarmApplyResult(scheduled: false, message: 'Permission denied');
}
