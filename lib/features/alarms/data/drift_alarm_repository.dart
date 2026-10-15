import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart' as db;
import 'package:ryser/features/alarms/domain/alarm.dart';
import 'package:ryser/features/alarms/domain/alarm_repository.dart';

class DriftAlarmRepository implements AlarmRepository {
  DriftAlarmRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<List<Alarm>> watchAll() {
    final query = _database.select(_database.alarms)
      ..orderBy([
        (row) => OrderingTerm.asc(row.localHour),
        (row) => OrderingTerm.asc(row.localMinute),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Alarm?> findById(String id) async {
    final row = await (_database.select(
      _database.alarms,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<void> save(Alarm alarm) {
    return _database
        .into(_database.alarms)
        .insertOnConflictUpdate(
          db.AlarmsCompanion.insert(
            id: alarm.id,
            localHour: alarm.localHour,
            localMinute: alarm.localMinute,
            label: Value(alarm.label),
            enabled: Value(alarm.enabled),
            recurrenceType: alarm.recurrenceType.name,
            repeatDaysMask: Value(alarm.repeatDaysMask),
            soundId: alarm.soundId,
            ringtoneUri: Value(alarm.ringtoneUri),
            ringtoneTitle: Value(alarm.ringtoneTitle),
            adaptiveSoundRotation: Value(alarm.adaptiveSoundRotation),
            increasingVolume: Value(alarm.increasingVolume),
            vibrationEnabled: Value(alarm.vibrationEnabled),
            snoozeEnabled: Value(alarm.snoozeEnabled),
            snoozeDurationMinutes: alarm.snoozeDurationMinutes,
            definitionRevision: Value(alarm.definitionRevision),
            createdAtMs: alarm.createdAt.millisecondsSinceEpoch,
            updatedAtMs: alarm.updatedAt.millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<void> delete(String id) {
    return (_database.delete(
      _database.alarms,
    )..where((row) => row.id.equals(id))).go();
  }

  Alarm _toDomain(db.Alarm row) {
    return Alarm(
      id: row.id,
      localHour: row.localHour,
      localMinute: row.localMinute,
      label: row.label,
      enabled: row.enabled,
      recurrenceType: AlarmRecurrenceType.values.byName(row.recurrenceType),
      repeatDaysMask: row.repeatDaysMask,
      soundId: row.soundId,
      ringtoneUri: row.ringtoneUri,
      ringtoneTitle: row.ringtoneTitle,
      adaptiveSoundRotation: row.adaptiveSoundRotation,
      increasingVolume: row.increasingVolume,
      vibrationEnabled: row.vibrationEnabled,
      snoozeEnabled: row.snoozeEnabled,
      snoozeDurationMinutes: row.snoozeDurationMinutes,
      definitionRevision: row.definitionRevision,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAtMs),
    );
  }
}
