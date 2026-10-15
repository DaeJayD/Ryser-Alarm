import 'package:drift/drift.dart';

class AlarmSounds extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get assetPath => text()();
  TextColumn get soundFamily => text()();
  IntColumn get intensityLevel => integer().check(
    const CustomExpression('intensity_level BETWEEN 1 AND 5'),
  )();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  IntColumn get lastUsedAtMs => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
