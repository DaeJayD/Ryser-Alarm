import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/alarms/data/drift_alarm_repository.dart';
import 'package:ryser/features/alarms/domain/alarm.dart' as domain;
import 'package:ryser/features/settings/data/app_defaults_repository.dart';
import 'package:ryser/features/sounds/data/sound_performance_repository.dart';

void main() {
  late AppDatabase database;
  late DriftAlarmRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftAlarmRepository(database);
  });

  tearDown(() => database.close());

  test('schema creation seeds stable bundled sounds', () async {
    final sounds = await database.select(database.alarmSounds).get();

    expect(
      sounds.map((sound) => sound.id),
      containsAll(['pulse-a', 'melodic-a', 'urgent-a']),
    );
  });

  test(
    'alarm repository creates, updates, and deletes without duplicates',
    () async {
      final createdAt = DateTime.utc(2026, 9, 16, 7);
      final alarm = domain.Alarm(
        id: 'alarm-1',
        localHour: 7,
        localMinute: 30,
        label: 'Work',
        enabled: false,
        recurrenceType: domain.AlarmRecurrenceType.selectedWeekdays,
        repeatDaysMask: 0x1F,
        soundId: 'pulse-a',
        ringtoneUri: 'content://settings/system/alarm_alert',
        ringtoneTitle: 'Default alarm',
        adaptiveSoundRotation: false,
        increasingVolume: false,
        vibrationEnabled: true,
        snoozeEnabled: true,
        snoozeDurationMinutes: 5,
        definitionRevision: 1,
        createdAt: createdAt,
        updatedAt: createdAt,
      );

      await repository.save(alarm);
      await repository.save(
        domain.Alarm(
          id: alarm.id,
          localHour: 8,
          localMinute: alarm.localMinute,
          label: alarm.label,
          enabled: alarm.enabled,
          recurrenceType: alarm.recurrenceType,
          repeatDaysMask: alarm.repeatDaysMask,
          soundId: alarm.soundId,
          ringtoneUri: alarm.ringtoneUri,
          ringtoneTitle: alarm.ringtoneTitle,
          adaptiveSoundRotation: alarm.adaptiveSoundRotation,
          increasingVolume: alarm.increasingVolume,
          vibrationEnabled: alarm.vibrationEnabled,
          snoozeEnabled: alarm.snoozeEnabled,
          snoozeDurationMinutes: alarm.snoozeDurationMinutes,
          definitionRevision: 2,
          createdAt: alarm.createdAt,
          updatedAt: createdAt.add(const Duration(minutes: 1)),
        ),
      );

      final stored = await repository.findById(alarm.id);
      final rows = await database.select(database.alarms).get();
      expect(rows, hasLength(1));
      expect(stored?.localHour, 8);
      expect(stored?.definitionRevision, 2);

      await repository.delete(alarm.id);
      expect(await repository.findById(alarm.id), isNull);
    },
  );

  test('database rejects invalid civil time', () async {
    final invalid = AlarmsCompanion.insert(
      id: 'invalid',
      localHour: 24,
      localMinute: 0,
      recurrenceType: 'oneTime',
      soundId: 'pulse-a',
      snoozeDurationMinutes: 5,
      createdAtMs: 0,
      updatedAtMs: 0,
    );

    await expectLater(
      database.into(database.alarms).insert(invalid),
      throwsA(anything),
    );
  });

  test('V2 alarm defaults persist and reload', () async {
    final defaults = AppDefaultsRepository(database);
    await defaults.save(
      const AppDefaults(
        snoozeDurationMinutes: 1,
        vibrationEnabled: false,
        adaptiveSoundRotation: true,
      ),
    );

    final stored = await defaults.load();
    expect(stored.snoozeDurationMinutes, 1);
    expect(stored.vibrationEnabled, isFalse);
    expect(stored.adaptiveSoundRotation, isTrue);
  });

  test('V2 sound performance derives statistics from raw sessions', () async {
    await database
        .into(database.wakeSessions)
        .insert(
          WakeSessionsCompanion.insert(
            id: 'session-1',
            alarmId: 'alarm-1',
            scheduledTimeMs: 1000,
            triggeredAtMs: 1000,
            initialSoundId: 'content://alarm/pulse',
            responseLatencyMs: const Value(10000),
            snoozeCount: const Value(1),
            outcome: 'dismissed',
            createdAtMs: 1000,
            completedAtMs: const Value(11000),
          ),
        );
    await database
        .into(database.wakeSessions)
        .insert(
          WakeSessionsCompanion.insert(
            id: 'session-2',
            alarmId: 'alarm-1',
            scheduledTimeMs: 2000,
            triggeredAtMs: 2000,
            initialSoundId: 'content://alarm/pulse',
            responseLatencyMs: const Value(20000),
            snoozeCount: const Value(2),
            outcome: 'dismissed',
            createdAtMs: 2000,
            completedAtMs: const Value(22000),
          ),
        );

    final rows = await SoundPerformanceRepository(database).load();
    expect(rows, hasLength(1));
    expect(rows.single.timesUsed, 2);
    expect(rows.single.snoozeCount, 3);
    expect(rows.single.averageResponseLatencyMs, 15000);
  });

  test(
    'wake enforcement records preserve one session across attempts',
    () async {
      const alarmId = 'alarm-enforced';
      const sessionId = 'session-enforced';
      const missionId = 'mission-qr';

      await database
          .into(database.alarms)
          .insert(
            AlarmsCompanion.insert(
              id: alarmId,
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
              id: sessionId,
              alarmId: alarmId,
              scheduledTimeMs: 2000,
              triggeredAtMs: 2000,
              initialSoundId: 'pulse-a',
              outcome: 'active',
              wakeEnforcementEnabled: const Value(true),
              currentWakeFlowState: const Value('missionActive'),
              missionType: const Value('qr'),
              missionAttemptCount: const Value(1),
              createdAtMs: 2000,
            ),
          );
      await database
          .into(database.missions)
          .insert(
            MissionsCompanion.insert(
              id: missionId,
              alarmId: alarmId,
              missionType: 'qr',
              difficulty: 'normal',
              configurationJson: const Value('{"locationLabel":"Bathroom"}'),
              createdAtMs: 1000,
              updatedAtMs: 1000,
            ),
          );
      await database
          .into(database.missionExecutions)
          .insert(
            MissionExecutionsCompanion.insert(
              id: 'execution-1',
              wakeSessionId: sessionId,
              missionId: missionId,
              missionType: 'qr',
              status: 'completed',
              attemptNumber: 1,
              startedAtMs: 2100,
              completedAtMs: const Value(2200),
            ),
          );
      await database
          .into(database.wakeChecks)
          .insert(
            WakeChecksCompanion.insert(
              id: 'wake-check-1',
              wakeSessionId: sessionId,
              attemptNumber: 1,
              scheduledForMs: 302000,
              status: 'pending',
              createdAtMs: 2200,
            ),
          );

      final session = await database.select(database.wakeSessions).getSingle();
      final executions = await database
          .select(database.missionExecutions)
          .get();
      final checks = await database.select(database.wakeChecks).get();

      expect(session.id, sessionId);
      expect(session.currentWakeFlowState, 'missionActive');
      expect(executions.single.wakeSessionId, sessionId);
      expect(checks.single.wakeSessionId, sessionId);
    },
  );
}
