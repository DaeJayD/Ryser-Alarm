import 'package:drift/drift.dart';
import 'package:ryser/database/tables/alarms.dart';

@TableIndex(name: 'missions_alarm_id', columns: {#alarmId})
class Missions extends Table {
  TextColumn get id => text()();
  TextColumn get alarmId =>
      text().references(Alarms, #id, onDelete: KeyAction.cascade)();
  TextColumn get missionType => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  TextColumn get difficulty => text()();
  TextColumn get configurationJson =>
      text().withDefault(const Constant('{}'))();
  IntColumn get createdAtMs => integer()();
  IntColumn get updatedAtMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
