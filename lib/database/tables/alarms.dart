import 'package:drift/drift.dart';

class Alarms extends Table {
  TextColumn get id => text()();
  IntColumn get localHour =>
      integer().check(const CustomExpression('local_hour BETWEEN 0 AND 23'))();
  IntColumn get localMinute => integer().check(
    const CustomExpression('local_minute BETWEEN 0 AND 59'),
  )();
  TextColumn get label => text().nullable()();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  TextColumn get recurrenceType => text()();
  IntColumn get repeatDaysMask => integer().withDefault(const Constant(0))();
  TextColumn get soundId => text()();
  TextColumn get ringtoneUri => text().nullable()();
  TextColumn get ringtoneTitle => text().nullable()();
  BoolColumn get adaptiveSoundRotation =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get increasingVolume =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get vibrationEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get snoozeEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get snoozeDurationMinutes => integer().check(
    const CustomExpression('snooze_duration_minutes BETWEEN 1 AND 60'),
  )();
  IntColumn get definitionRevision =>
      integer().withDefault(const Constant(1))();
  IntColumn get createdAtMs => integer()();
  IntColumn get updatedAtMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
