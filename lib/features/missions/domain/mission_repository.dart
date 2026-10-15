import 'package:ryser/features/missions/domain/mission.dart';

abstract interface class MissionRepository {
  Stream<Mission?> watchForAlarm(String alarmId);

  Future<Mission?> findByAlarmId(String alarmId);

  Future<void> save(Mission mission);

  Future<void> deleteForAlarm(String alarmId);
}
