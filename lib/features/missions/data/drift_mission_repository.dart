import 'package:drift/drift.dart';
import 'package:ryser/database/app_database.dart' as db;
import 'package:ryser/features/missions/domain/mission.dart';
import 'package:ryser/features/missions/domain/mission_repository.dart';

class DriftMissionRepository implements MissionRepository {
  DriftMissionRepository(this._database);

  final db.AppDatabase _database;

  @override
  Stream<Mission?> watchForAlarm(String alarmId) {
    final query = _database.select(_database.missions)
      ..where((row) => row.alarmId.equals(alarmId));
    return query.watchSingleOrNull().map(_toDomainNullable);
  }

  @override
  Future<Mission?> findByAlarmId(String alarmId) async {
    final row =
        await (_database.select(_database.missions)
              ..where((candidate) => candidate.alarmId.equals(alarmId)))
            .getSingleOrNull();
    return _toDomainNullable(row);
  }

  @override
  Future<void> save(Mission mission) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.missions,
      )..where((row) => row.alarmId.equals(mission.alarmId))).go();
      await _database
          .into(_database.missions)
          .insert(
            db.MissionsCompanion.insert(
              id: mission.id,
              alarmId: mission.alarmId,
              missionType: mission.type.name,
              enabled: Value(mission.enabled),
              difficulty: mission.difficulty.name,
              configurationJson: Value(mission.configurationJson),
              createdAtMs: mission.createdAt.millisecondsSinceEpoch,
              updatedAtMs: mission.updatedAt.millisecondsSinceEpoch,
            ),
          );
    });
  }

  @override
  Future<void> deleteForAlarm(String alarmId) {
    return (_database.delete(
      _database.missions,
    )..where((row) => row.alarmId.equals(alarmId))).go();
  }

  Mission? _toDomainNullable(db.Mission? row) {
    if (row == null) return null;
    return Mission(
      id: row.id,
      alarmId: row.alarmId,
      type: MissionType.values.byName(row.missionType),
      enabled: row.enabled,
      difficulty: MissionDifficulty.values.byName(row.difficulty),
      configurationJson: row.configurationJson,
      createdAt: DateTime.fromMillisecondsSinceEpoch(row.createdAtMs),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.updatedAtMs),
    );
  }
}
