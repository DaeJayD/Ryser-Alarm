import 'package:ryser/database/app_database.dart';

class ExperimentExecutionSettings {
  const ExperimentExecutionSettings({
    this.enabled = false,
    this.critical = false,
  });
  final bool enabled;
  final bool critical;
}

/// Durable per-alarm controls; no experiments are enabled by migration/default.
class ExperimentExecutionSettingsRepository {
  ExperimentExecutionSettingsRepository(this._database);
  final AppDatabase _database;

  Future<ExperimentExecutionSettings> load(String alarmId) async {
    final rows =
        await (_database.select(_database.appSettings)..where(
              (r) => r.key.isIn([_enabledKey(alarmId), _criticalKey(alarmId)]),
            ))
            .get();
    final values = {for (final r in rows) r.key: r};
    final enabled = values[_enabledKey(alarmId)];
    final critical = values[_criticalKey(alarmId)];
    return ExperimentExecutionSettings(
      enabled: enabled?.valueType == 'bool' && enabled?.value == 'true',
      // Corrupt critical-mode values fail closed rather than allowing a test.
      critical:
          critical != null &&
          (critical.valueType != 'bool' || critical.value != 'false'),
    );
  }

  Future<void> save(String alarmId, ExperimentExecutionSettings settings) =>
      _database.batch(
        (batch) => batch.insertAllOnConflictUpdate(_database.appSettings, [
          AppSettingsCompanion.insert(
            key: _enabledKey(alarmId),
            valueType: 'bool',
            value: settings.enabled.toString(),
            updatedAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
          AppSettingsCompanion.insert(
            key: _criticalKey(alarmId),
            valueType: 'bool',
            value: settings.critical.toString(),
            updatedAtMs: DateTime.now().millisecondsSinceEpoch,
          ),
        ]),
      );

  static String _enabledKey(String alarmId) =>
      'wake_experiments.enabled.$alarmId';
  static String _criticalKey(String alarmId) =>
      'wake_experiments.critical.$alarmId';
}

/// Initial exact-time context; versioned broader buckets arrive in phase 4D.
String scheduledExperimentContext(String alarmId, DateTime scheduled) {
  final time = scheduled.toLocal();
  return 'occurrence-v1:$alarmId:${time.weekday <= 5 ? 'weekday' : 'weekend'}:'
      '${time.hour}:${time.minute}:${time.timeZoneOffset.inMinutes}';
}
