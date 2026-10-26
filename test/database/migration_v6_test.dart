import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/database/app_database.dart';

import 'migration_generated/schema.dart';

void main() {
  final verifier = SchemaVerifier(GeneratedHelper());

  test(
    'v5 protocols, evaluation, settings and session provenance survive v6',
    () async {
      final old = await verifier.schemaAt(5);
      final raw = old.rawDatabase;
      raw.execute('''
      INSERT INTO alarms (id,local_hour,local_minute,recurrence_type,sound_id,
        snooze_duration_minutes,created_at_ms,updated_at_ms)
      VALUES ('alarm',7,0,'daily','pulse-a',5,100,100)
    ''');
      final protocol = <String, Object?>{
        'id': 'protocol',
        'alarm_id': 'alarm',
        'version': 4,
        'source': 'userDefined',
        'status': 'active',
        'initial_sound_id': 'pulse-a',
        'initial_sound_family': 'PULSE',
        'ringtone_uri': 'content://retained',
        'initial_volume_percent': 50,
        'max_volume_percent': 90,
        'volume_escalation_enabled': 1,
        'volume_escalation_step_percent': 10,
        'volume_escalation_interval_seconds': 5,
        'vibration_enabled': 1,
        'vibration_pattern': 'standard',
        'vibration_escalation_enabled': 0,
        'mission_required': 0,
        'mission_type': null,
        'mission_difficulty': null,
        'mission_configuration_json': '{}',
        'wake_check_required': 0,
        'wake_check_delay_minutes': 5,
        'wake_check_hold_milliseconds': 2000,
        'max_wake_check_failures': 2,
        'reactivation_sound_policy': 'keep',
        'intensity_level': 2,
        'reason_code': 'manualUserOverride',
        'technical_explanation': 'Preserve original explanation',
        'user_explanation': 'Keep my settings',
        'created_at_ms': 100,
        'effective_from_ms': 100,
      };
      raw.execute(
        'INSERT INTO wake_protocols (${protocol.keys.join(',')}) '
        'VALUES (${List.filled(protocol.length, '?').join(',')})',
        protocol.values.toList(),
      );
      raw.execute('''
      INSERT INTO wake_sessions (id,alarm_id,scheduled_time_ms,triggered_at_ms,
        initial_sound_id,outcome,created_at_ms,completed_at_ms,protocol_id,
        protocol_version,protocol_snapshot_json,analysis_status)
      VALUES ('session','alarm',200,201,'pulse-a','wakeConfirmed',201,900,
        'protocol',4,'{"id":"protocol","version":4}','completed')
    ''');
      raw.execute('''
      INSERT INTO protocol_evaluations (id,protocol_id,wake_session_id,result,
        primary_failure_mode,analysis_json,created_at_ms)
      VALUES ('evaluation','protocol','session','noChange','none','{}',950)
    ''');
      raw.execute('''
      INSERT INTO alarm_adaptation_settings (alarm_id,enabled,adapt_sound,
        adapt_volume,user_max_volume_percent,updated_at_ms)
      VALUES ('alarm',1,0,1,90,100)
    ''');
      const tables = [
        'alarms',
        'wake_protocols',
        'wake_sessions',
        'protocol_evaluations',
        'alarm_adaptation_settings',
      ];
      final expected = {
        for (final table in tables)
          table: raw
              .select('SELECT * FROM $table')
              .map((row) => Map<String, Object?>.from(row))
              .toList(),
      };
      final database = AppDatabase.forTesting(old.newConnection());
      try {
        await verifier.migrateAndValidate(database, 6);
        for (final table in tables) {
          final actual = await database
              .customSelect('SELECT * FROM $table')
              .get();
          expect(
            actual.map((row) => row.data).toList(),
            expected[table],
            reason: table,
          );
        }
        expect(await database.select(database.wakeExperiments).get(), isEmpty);
        expect(
          await database.select(database.experimentSessions).get(),
          isEmpty,
        );
        expect(
          await database.select(database.experimentAuditEvents).get(),
          isEmpty,
        );
        final guards = await database
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type='trigger' AND name LIKE 'experiment_%'",
            )
            .get();
        expect(guards, hasLength(6));
      } finally {
        await database.close();
      }
    },
  );
}
