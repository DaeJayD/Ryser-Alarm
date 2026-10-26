import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';

import 'migration_generated/schema.dart';

void main() {
  final verifier = SchemaVerifier(GeneratedHelper());

  for (final oldVersion in [1, 3, 4, 5]) {
    test('migrates schema v$oldVersion to latest', () async {
      final connection = await verifier.startAt(oldVersion);
      final database = AppDatabase.forTesting(connection);
      try {
        await verifier.migrateAndValidate(database, database.schemaVersion);
      } finally {
        await database.close();
      }
    });
  }

  test('v4 alarm, mission and wake evidence survive latest upgrade', () async {
    final old = await verifier.schemaAt(4);
    final raw = old.rawDatabase;
    raw.execute('''
      INSERT INTO alarms (id, local_hour, local_minute, label, enabled,
        recurrence_type, repeat_days_mask, sound_id, ringtone_uri,
        ringtone_title, adaptive_sound_rotation, increasing_volume,
        vibration_enabled, snooze_enabled, snooze_duration_minutes,
        definition_revision, created_at_ms, updated_at_ms)
      VALUES ('legacy-alarm', 7, 15, 'Keep me', 1, 'oneTime', 0, 'pulse-a',
        'content://alarm', 'Legacy sound', 0, 1, 1, 1, 3, 1, 100, 100)
    ''');
    raw.execute('''
      INSERT INTO missions (id, alarm_id, mission_type, difficulty,
        configuration_json, enabled, created_at_ms, updated_at_ms)
      VALUES ('legacy-mission', 'legacy-alarm', 'movement', 'normal',
        '{"requiredSteps":20}', 1, 100, 100)
    ''');
    raw.execute('''
      INSERT INTO wake_sessions (id, alarm_id, scheduled_time_ms,
        triggered_at_ms, initial_sound_id, snooze_count, sound_change_count,
        escalation_count, outcome, created_at_ms, completed_at_ms)
      VALUES ('legacy-session', 'legacy-alarm', 200, 201,
        'content://alarm', 2, 1, 0, 'wakeConfirmed', 201, 300)
    ''');
    raw.execute(
      "INSERT INTO wake_events VALUES ('legacy-event', 'legacy-session', 0, 'ALARM_TRIGGERED', 201, '{}', 'native')",
    );
    raw.execute(
      "INSERT INTO mission_executions (id,wake_session_id,mission_id,mission_type,status,attempt_number,started_at_ms,metadata_json) VALUES ('legacy-execution','legacy-session','legacy-mission','movement','completed',1,210,'{}')",
    );
    raw.execute(
      "INSERT INTO wake_checks (id,wake_session_id,attempt_number,scheduled_for_ms,status,created_at_ms) VALUES ('legacy-check','legacy-session',1,250,'passed',220)",
    );
    raw.execute(
      "INSERT INTO app_settings VALUES ('legacy-setting','bool','true',100)",
    );
    raw.execute(
      "INSERT INTO alarm_sounds (id,name,asset_path,sound_family,intensity_level,enabled) VALUES ('legacy-sound','Retain audio','content://retained','CUSTOM',2,1)",
    );
    final database = AppDatabase.forTesting(old.newConnection());
    try {
      await verifier.migrateAndValidate(database, database.schemaVersion);
      final alarm = await (database.select(
        database.alarms,
      )..where((row) => row.id.equals('legacy-alarm'))).getSingle();
      final mission = await database.select(database.missions).getSingle();
      final session = await database.select(database.wakeSessions).getSingle();
      expect(alarm.label, 'Keep me');
      expect(alarm.increasingVolume, isTrue);
      expect(mission.configurationJson, '{"requiredSteps":20}');
      expect(session.snoozeCount, 2);
      expect(session.initialSoundId, 'content://alarm');
      expect(session.protocolId, isNull);
      expect(
        (await database.select(database.wakeEvents).getSingle()).id,
        'legacy-event',
      );
      expect(
        (await database.select(database.missionExecutions).getSingle()).status,
        'completed',
      );
      expect(
        (await database.select(database.wakeChecks).getSingle()).status,
        'passed',
      );
      expect(
        (await database.select(database.appSettings).getSingle()).value,
        'true',
      );
      expect(
        (await (database.select(
          database.alarmSounds,
        )..where((s) => s.id.equals('legacy-sound'))).getSingle()).assetPath,
        'content://retained',
      );
    } finally {
      await database.close();
    }
  });
}
