import 'package:drift/drift.dart';
import 'package:ryser/database/tables/wake_sessions.dart';

@TableIndex(
  name: 'wake_checks_session_attempt',
  columns: {#wakeSessionId, #attemptNumber},
  unique: true,
)
class WakeChecks extends Table {
  TextColumn get id => text()();
  TextColumn get wakeSessionId => text().references(WakeSessions, #id)();
  IntColumn get attemptNumber =>
      integer().check(const CustomExpression('attempt_number > 0'))();
  IntColumn get scheduledForMs => integer()();
  IntColumn get triggeredAtMs => integer().nullable()();
  IntColumn get firstInteractionAtMs => integer().nullable()();
  IntColumn get completedAtMs => integer().nullable()();
  TextColumn get status => text()();
  IntColumn get createdAtMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
