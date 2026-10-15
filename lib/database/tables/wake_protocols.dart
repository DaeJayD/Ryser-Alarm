import 'package:drift/drift.dart';
import 'package:ryser/database/tables/alarms.dart';

@TableIndex(
  name: 'wake_protocols_alarm_version',
  columns: {#alarmId, #version},
  unique: true,
)
@TableIndex(name: 'wake_protocols_alarm_status', columns: {#alarmId, #status})
class WakeProtocols extends Table {
  TextColumn get id => text()();
  TextColumn get alarmId =>
      text().references(Alarms, #id, onDelete: KeyAction.cascade)();
  IntColumn get version =>
      integer().check(const CustomExpression('version > 0'))();
  TextColumn get source => text()();
  TextColumn get status => text()();
  TextColumn get initialSoundId => text()();
  TextColumn get initialSoundFamily => text().nullable()();
  TextColumn get ringtoneUri => text()();
  IntColumn get initialVolumePercent => integer().check(
    const CustomExpression('initial_volume_percent BETWEEN 0 AND 100'),
  )();
  IntColumn get maxVolumePercent => integer().check(
    const CustomExpression('max_volume_percent BETWEEN 0 AND 100'),
  )();
  BoolColumn get volumeEscalationEnabled => boolean()();
  IntColumn get volumeEscalationStepPercent => integer()();
  IntColumn get volumeEscalationIntervalSeconds => integer()();
  BoolColumn get vibrationEnabled => boolean()();
  TextColumn get vibrationPattern => text()();
  BoolColumn get vibrationEscalationEnabled => boolean()();
  BoolColumn get missionRequired => boolean()();
  TextColumn get missionType => text().nullable()();
  TextColumn get missionDifficulty => text().nullable()();
  TextColumn get missionConfigurationJson =>
      text().withDefault(const Constant('{}'))();
  BoolColumn get wakeCheckRequired => boolean()();
  IntColumn get wakeCheckDelayMinutes => integer()();
  IntColumn get wakeCheckHoldMilliseconds => integer()();
  IntColumn get maxWakeCheckFailures => integer()();
  TextColumn get reactivationSoundPolicy => text()();
  IntColumn get intensityLevel => integer().check(
    const CustomExpression('intensity_level BETWEEN 1 AND 5'),
  )();
  TextColumn get reasonCode => text()();
  TextColumn get technicalExplanation => text()();
  TextColumn get userExplanation => text()();
  TextColumn get basedOnSessionId => text().nullable()();
  TextColumn get supersedesProtocolId => text().nullable()();
  TextColumn get settingsSnapshotJson =>
      text().withDefault(const Constant('{}'))();
  IntColumn get createdAtMs => integer()();
  IntColumn get effectiveFromMs => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
