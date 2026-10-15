import 'package:drift/drift.dart';

class WakeSessions extends Table {
  TextColumn get id => text()();
  TextColumn get alarmId => text()();
  IntColumn get scheduledTimeMs => integer()();
  IntColumn get triggeredAtMs => integer()();
  TextColumn get initialSoundId => text()();
  RealColumn get initialVolume => real().nullable()();
  IntColumn get firstInteractionAtMs => integer().nullable()();
  IntColumn get responseLatencyMs => integer().nullable()();
  IntColumn get snoozeCount => integer().withDefault(const Constant(0))();
  IntColumn get soundChangeCount => integer().withDefault(const Constant(0))();
  IntColumn get escalationCount => integer().withDefault(const Constant(0))();
  IntColumn get dismissedAtMs => integer().nullable()();
  TextColumn get outcome => text()();
  BoolColumn get wakeEnforcementEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get currentWakeFlowState =>
      text().withDefault(const Constant('completed'))();
  TextColumn get missionType => text().nullable()();
  IntColumn get missionAttemptCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get missionFailureCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get wakeCheckAttemptCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get wakeCheckFailureCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get confirmedAwakeAtMs => integer().nullable()();
  IntColumn get createdAtMs => integer()();
  IntColumn get completedAtMs => integer().nullable()();
  TextColumn get protocolId => text().nullable()();
  IntColumn get protocolVersion => integer().nullable()();
  TextColumn get protocolSnapshotJson => text().nullable()();
  TextColumn get analysisStatus =>
      text().withDefault(const Constant('pending'))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
