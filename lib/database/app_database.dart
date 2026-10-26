import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:ryser/database/tables/alarm_sounds.dart';
import 'package:ryser/database/tables/alarm_adaptation_settings.dart';
import 'package:ryser/database/tables/alarms.dart';
import 'package:ryser/database/tables/app_settings.dart';
import 'package:ryser/database/tables/mission_executions.dart';
import 'package:ryser/database/tables/missions.dart';
import 'package:ryser/database/tables/protocol_evaluations.dart';
import 'package:ryser/database/tables/wake_checks.dart';
import 'package:ryser/database/tables/wake_events.dart';
import 'package:ryser/database/tables/wake_sessions.dart';
import 'package:ryser/database/tables/wake_protocols.dart';
import 'package:ryser/database/tables/wake_experiments.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Alarms,
    AlarmSounds,
    WakeSessions,
    WakeEvents,
    AppSettings,
    Missions,
    MissionExecutions,
    WakeChecks,
    WakeProtocols,
    ProtocolEvaluations,
    AlarmAdaptationSettings,
    WakeExperiments,
    ExperimentSessions,
    ExperimentAuditEvents,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _createExperimentGuards();
      await _seedBundledSounds();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(alarms, alarms.ringtoneUri);
        await migrator.addColumn(alarms, alarms.ringtoneTitle);
      }
      if (from < 3) {
        await migrator.addColumn(
          wakeSessions,
          wakeSessions.wakeEnforcementEnabled,
        );
        await migrator.addColumn(
          wakeSessions,
          wakeSessions.currentWakeFlowState,
        );
        await migrator.addColumn(wakeSessions, wakeSessions.missionType);
        await migrator.addColumn(
          wakeSessions,
          wakeSessions.missionAttemptCount,
        );
        await migrator.addColumn(
          wakeSessions,
          wakeSessions.missionFailureCount,
        );
        await migrator.addColumn(
          wakeSessions,
          wakeSessions.wakeCheckAttemptCount,
        );
        await migrator.addColumn(
          wakeSessions,
          wakeSessions.wakeCheckFailureCount,
        );
        await migrator.addColumn(wakeSessions, wakeSessions.confirmedAwakeAtMs);
        await migrator.createTable(missions);
        await migrator.createTable(missionExecutions);
        await migrator.createTable(wakeChecks);
        await customStatement(
          'CREATE INDEX missions_alarm_id ON missions (alarm_id)',
        );
        await customStatement(
          'CREATE UNIQUE INDEX mission_executions_session_attempt '
          'ON mission_executions (wake_session_id, attempt_number)',
        );
        await customStatement(
          'CREATE UNIQUE INDEX wake_checks_session_attempt '
          'ON wake_checks (wake_session_id, attempt_number)',
        );
      }
      if (from < 4) {
        await migrator.addColumn(alarms, alarms.increasingVolume);
      }
      if (from < 5) {
        await migrator.createTable(wakeProtocols);
        await migrator.createTable(protocolEvaluations);
        await migrator.createTable(alarmAdaptationSettings);
        await customStatement(
          'CREATE UNIQUE INDEX wake_protocols_alarm_version '
          'ON wake_protocols (alarm_id, version)',
        );
        await customStatement(
          'CREATE INDEX wake_protocols_alarm_status '
          'ON wake_protocols (alarm_id, status)',
        );
        await customStatement(
          'CREATE UNIQUE INDEX protocol_evaluations_session '
          'ON protocol_evaluations (wake_session_id)',
        );
        await migrator.addColumn(wakeSessions, wakeSessions.protocolId);
        await migrator.addColumn(wakeSessions, wakeSessions.protocolVersion);
        await migrator.addColumn(
          wakeSessions,
          wakeSessions.protocolSnapshotJson,
        );
        await migrator.addColumn(wakeSessions, wakeSessions.analysisStatus);
        await customStatement(
          "UPDATE alarm_sounds SET asset_path = 'android.resource://com.ryser.ryser/raw/pulse_a' WHERE id = 'pulse-a'",
        );
        await customStatement(
          "UPDATE alarm_sounds SET asset_path = 'android.resource://com.ryser.ryser/raw/melodic_a' WHERE id = 'melodic-a'",
        );
        await customStatement(
          "UPDATE alarm_sounds SET asset_path = 'android.resource://com.ryser.ryser/raw/urgent_a' WHERE id = 'urgent-a'",
        );
      }
      if (from < 6) {
        await migrator.createTable(wakeExperiments);
        await migrator.createTable(experimentSessions);
        await migrator.createTable(experimentAuditEvents);
        for (final index in allSchemaEntities.whereType<Index>()) {
          if (index.entityName.startsWith('wake_experiments_') ||
              index.entityName.startsWith('experiment_')) {
            await migrator.createIndex(index);
          }
        }
        await _createExperimentGuards();
      }
    },
  );

  Future<void> _createExperimentGuards() async {
    await customStatement('''
      CREATE TRIGGER experiment_variants_immutable BEFORE UPDATE OF
        alarm_id, name, hypothesis, dimension, control_protocol_id,
        control_protocol_version, control_snapshot_json, candidate_protocol_id,
        candidate_protocol_version, candidate_snapshot_json, context_key,
        minimum_sessions_per_variant, preferred_sessions_per_variant,
        maximum_sessions_per_variant, created_at_ms ON wake_experiments
      BEGIN SELECT RAISE(ABORT, 'experiment variants are immutable'); END
    ''');
    await customStatement('''
      CREATE TRIGGER experiment_assignment_immutable BEFORE UPDATE OF
        experiment_id, alarm_id, scheduled_time_ms, assignment_index, variant,
        protocol_id, protocol_version, context_key, assigned_at_ms ON experiment_sessions
      BEGIN SELECT RAISE(ABORT, 'experiment assignment is immutable'); END
    ''');
    await customStatement('''
      CREATE TRIGGER experiment_session_link_immutable BEFORE UPDATE OF
        wake_session_id ON experiment_sessions
      WHEN OLD.wake_session_id IS NOT NULL AND NEW.wake_session_id IS NOT OLD.wake_session_id
      BEGIN SELECT RAISE(ABORT, 'experiment session link is immutable'); END
    ''');
    await customStatement('''
      CREATE TRIGGER experiment_evidence_immutable BEFORE UPDATE OF
        completed_at_ms, validity, invalid_reason ON experiment_sessions
      WHEN OLD.completed_at_ms IS NOT NULL
      BEGIN SELECT RAISE(ABORT, 'completed experiment evidence is immutable'); END
    ''');
    for (final operation in ['UPDATE', 'DELETE']) {
      await customStatement('''
        CREATE TRIGGER experiment_audit_no_${operation.toLowerCase()}
        BEFORE $operation ON experiment_audit_events
        BEGIN SELECT RAISE(ABORT, 'experiment audit is append only'); END
      ''');
    }
  }

  Future<void> _seedBundledSounds() async {
    await batch((batch) {
      batch.insertAll(alarmSounds, [
        AlarmSoundsCompanion.insert(
          id: 'pulse-a',
          name: 'Pulse A',
          assetPath: 'android.resource://com.ryser.ryser/raw/pulse_a',
          soundFamily: 'PULSE',
          intensityLevel: 3,
        ),
        AlarmSoundsCompanion.insert(
          id: 'melodic-a',
          name: 'Melodic A',
          assetPath: 'android.resource://com.ryser.ryser/raw/melodic_a',
          soundFamily: 'MELODIC',
          intensityLevel: 2,
        ),
        AlarmSoundsCompanion.insert(
          id: 'urgent-a',
          name: 'Urgent A',
          assetPath: 'android.resource://com.ryser.ryser/raw/urgent_a',
          soundFamily: 'URGENT',
          intensityLevel: 5,
        ),
      ], mode: InsertMode.insertOrIgnore);
    });
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'ryser');
}
