import 'package:drift/drift.dart';

// Snapshots deliberately have no cascading parent FK: deleted alarms/protocols
// must not erase the experiment's historical evidence.
@DataClassName('WakeExperimentRow')
@TableIndex.sql(
  "CREATE UNIQUE INDEX wake_experiments_one_open ON wake_experiments (alarm_id) WHERE status IN ('ready', 'running', 'paused')",
)
class WakeExperiments extends Table {
  TextColumn get id => text()();
  TextColumn get alarmId => text()();
  TextColumn get name => text()();
  TextColumn get hypothesis => text()();
  TextColumn get status => text().check(
    const CustomExpression(
      "status IN ('draft','ready','running','paused','completed','cancelled','invalidated')",
    ),
  )();
  TextColumn get dimension => text()();
  TextColumn get controlProtocolId => text()();
  IntColumn get controlProtocolVersion => integer()();
  TextColumn get controlSnapshotJson => text()();
  TextColumn get candidateProtocolId => text()();
  IntColumn get candidateProtocolVersion => integer()();
  TextColumn get candidateSnapshotJson => text()();
  TextColumn get contextKey => text()();
  IntColumn get minimumSessionsPerVariant => integer()();
  IntColumn get preferredSessionsPerVariant => integer()();
  IntColumn get maximumSessionsPerVariant => integer()();
  TextColumn get result =>
      text().withDefault(const Constant('insufficientData'))();
  TextColumn get confidence =>
      text().withDefault(const Constant('insufficient'))();
  TextColumn get winnerProtocolId => text().nullable()();
  TextColumn get invalidReason => text().nullable()();
  IntColumn get startedAtMs => integer().nullable()();
  IntColumn get completedAtMs => integer().nullable()();
  IntColumn get createdAtMs => integer()();
  IntColumn get updatedAtMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (control_protocol_id <> candidate_protocol_id AND control_protocol_version > 0 AND candidate_protocol_version > 0 AND control_protocol_version <> candidate_protocol_version)',
    'CHECK (minimum_sessions_per_variant >= 3 AND preferred_sessions_per_variant >= minimum_sessions_per_variant AND maximum_sessions_per_variant >= preferred_sessions_per_variant AND maximum_sessions_per_variant <= 100)',
  ];
}

@DataClassName('ExperimentSessionRow')
@TableIndex(
  name: 'experiment_sessions_occurrence',
  columns: {#alarmId, #scheduledTimeMs},
  unique: true,
)
@TableIndex(
  name: 'experiment_sessions_wake',
  columns: {#wakeSessionId},
  unique: true,
)
@TableIndex(
  name: 'experiment_sessions_assignment',
  columns: {#experimentId, #assignmentIndex},
  unique: true,
)
class ExperimentSessions extends Table {
  TextColumn get id => text()();
  TextColumn get experimentId => text().references(WakeExperiments, #id)();
  TextColumn get alarmId => text()();
  IntColumn get scheduledTimeMs => integer()();
  IntColumn get assignmentIndex =>
      integer().check(const CustomExpression('assignment_index >= 0'))();
  TextColumn get variant => text().check(
    const CustomExpression("variant IN ('control','candidate')"),
  )();
  TextColumn get protocolId => text()();
  IntColumn get protocolVersion => integer()();
  TextColumn get contextKey => text()();
  IntColumn get assignedAtMs => integer()();
  TextColumn get wakeSessionId => text().nullable()();
  IntColumn get completedAtMs => integer().nullable()();
  TextColumn get validity => text()
      .withDefault(const Constant('partial'))
      .check(
        const CustomExpression("validity IN ('valid','partial','invalid')"),
      )();
  TextColumn get invalidReason => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
  @override
  List<String> get customConstraints => [
    'CHECK (assigned_at_ms <= scheduled_time_ms)',
    "CHECK (validity <> 'valid' OR (wake_session_id IS NOT NULL AND completed_at_ms IS NOT NULL))",
    "CHECK (validity <> 'invalid' OR (invalid_reason IS NOT NULL AND length(trim(invalid_reason)) > 0))",
  ];
}

@DataClassName('ExperimentAuditEventRow')
@TableIndex(
  name: 'experiment_audit_order',
  columns: {#experimentId, #sequence},
  unique: true,
)
class ExperimentAuditEvents extends Table {
  TextColumn get id => text()();
  TextColumn get experimentId => text().references(WakeExperiments, #id)();
  IntColumn get sequence => integer()();
  TextColumn get eventType => text()();
  IntColumn get occurredAtMs => integer()();
  TextColumn get detailsJson => text()();
  IntColumn get policyVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
