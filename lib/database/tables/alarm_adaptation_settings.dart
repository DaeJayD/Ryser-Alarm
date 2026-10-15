import 'package:drift/drift.dart';
import 'package:ryser/database/tables/alarms.dart';

class AlarmAdaptationSettings extends Table {
  TextColumn get alarmId =>
      text().references(Alarms, #id, onDelete: KeyAction.cascade)();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  BoolColumn get adaptSound => boolean().withDefault(const Constant(true))();
  BoolColumn get adaptVolume => boolean().withDefault(const Constant(true))();
  BoolColumn get adaptVibration =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get adaptWakeCheck =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get adaptMission => boolean().withDefault(const Constant(false))();
  IntColumn get userMaxVolumePercent => integer()
      .check(
        const CustomExpression('user_max_volume_percent BETWEEN 30 AND 100'),
      )
      .withDefault(const Constant(100))();
  IntColumn get updatedAtMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {alarmId};
}
