import 'package:drift/drift.dart';
import 'package:ryser/database/tables/wake_protocols.dart';
import 'package:ryser/database/tables/wake_sessions.dart';

@TableIndex(
  name: 'protocol_evaluations_session',
  columns: {#wakeSessionId},
  unique: true,
)
class ProtocolEvaluations extends Table {
  TextColumn get id => text()();
  TextColumn get protocolId => text().references(WakeProtocols, #id)();
  TextColumn get wakeSessionId => text().references(WakeSessions, #id)();
  TextColumn get result => text()();
  TextColumn get primaryFailureMode => text()();
  TextColumn get analysisJson => text()();
  TextColumn get selectedRuleId => text().nullable()();
  TextColumn get ruleTraceJson => text().withDefault(const Constant('{}'))();
  TextColumn get changesJson => text().withDefault(const Constant('[]'))();
  IntColumn get performanceScore => integer().nullable()();
  IntColumn get scoreVersion => integer().nullable()();
  TextColumn get evaluationNotes => text().withDefault(const Constant(''))();
  IntColumn get createdAtMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
