import 'package:ryser/features/alarms/domain/alarm.dart';

abstract interface class AlarmRepository {
  Stream<List<Alarm>> watchAll();
  Future<Alarm?> findById(String id);
  Future<void> save(Alarm alarm);
  Future<void> delete(String id);
}
