import 'package:ryser/database/app_database.dart';

class AppDefaults {
  const AppDefaults({
    this.snoozeDurationMinutes = 5,
    this.vibrationEnabled = true,
    this.adaptiveSoundRotation = true,
  });

  final int snoozeDurationMinutes;
  final bool vibrationEnabled;
  final bool adaptiveSoundRotation;
}

class AppDefaultsRepository {
  AppDefaultsRepository(this._database);

  final AppDatabase _database;

  Future<AppDefaults> load() async {
    final rows = await _database.select(_database.appSettings).get();
    final values = {for (final row in rows) row.key: row.value};
    final snooze = int.tryParse(values[snoozeKey] ?? '') ?? 5;
    return AppDefaults(
      snoozeDurationMinutes: snooze.clamp(1, 60),
      vibrationEnabled: values[vibrationKey] != 'false',
      adaptiveSoundRotation: values[rotationKey] != 'false',
    );
  }

  Future<void> save(AppDefaults defaults) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _database.batch((batch) {
      batch.insertAllOnConflictUpdate(_database.appSettings, [
        AppSettingsCompanion.insert(
          key: snoozeKey,
          valueType: 'int',
          value: defaults.snoozeDurationMinutes.toString(),
          updatedAtMs: now,
        ),
        AppSettingsCompanion.insert(
          key: vibrationKey,
          valueType: 'bool',
          value: defaults.vibrationEnabled.toString(),
          updatedAtMs: now,
        ),
        AppSettingsCompanion.insert(
          key: rotationKey,
          valueType: 'bool',
          value: defaults.adaptiveSoundRotation.toString(),
          updatedAtMs: now,
        ),
      ]);
    });
  }

  static const snoozeKey = 'default_snooze_minutes';
  static const vibrationKey = 'default_vibration_enabled';
  static const rotationKey = 'default_adaptive_sound_rotation';
}
