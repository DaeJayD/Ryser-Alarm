import 'package:drift/drift.dart';
import 'package:ryser/database/tables/missions.dart';
import 'package:ryser/database/tables/wake_sessions.dart';

@TableIndex(
  name: 'mission_executions_session_attempt',
  columns: {#wakeSessionId, #attemptNumber},
  unique: true,
)
class MissionExecutions extends Table {
  TextColumn get id => text()();
  TextColumn get wakeSessionId => text().references(WakeSessions, #id)();
  TextColumn get missionId => text().references(Missions, #id)();
  TextColumn get missionType => text()();
  TextColumn get status => text()();
  IntColumn get attemptNumber =>
      integer().check(const CustomExpression('attempt_number > 0'))();
  IntColumn get startedAtMs => integer()();
  IntColumn get completedAtMs => integer().nullable()();
  IntColumn get failedAtMs => integer().nullable()();
  TextColumn get failureReason => text().nullable()();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
