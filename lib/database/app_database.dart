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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
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
    },
  );

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
