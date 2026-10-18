import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/app/theme/ryser_theme.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/alarm_health/presentation/alarm_health_screen.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/alarms/presentation/home_screen.dart';
import 'package:ryser/features/alarms/presentation/dashboard_providers.dart';
import 'package:ryser/features/alarms/presentation/alarm_editor_screen.dart';
import 'package:ryser/features/alarms/domain/alarm.dart' as domain;
import 'package:ryser/features/settings/data/app_defaults_repository.dart';
import 'package:ryser/features/settings/presentation/settings_screen.dart';

class _Api extends AlarmRuntimeApi {
  bool failHealth = false;
  @override
  Future<AlarmHealthDto> getAlarmHealth() async {
    if (failHealth) throw StateError('unavailable');
    return AlarmHealthDto(
      exactAlarmsReady: false,
      notificationsReady: true,
      fullScreenReady: true,
      batteryUnrestricted: true,
      alarmVolume: 5,
      alarmVolumeMax: 10,
    );
  }

  @override
  Future<bool> isSoundAvailable(String uri) async => true;
  @override
  Future<bool> canVibrate() async => true;
  @override
  Future<bool> isMissionAvailable(String type) async => true;
  @override
  Future<List<RingtoneDto>> getAlarmRingtones() async => [];
  @override
  Future<AlarmApplyResult> scheduleAlarm(AlarmScheduleDto alarm) async =>
      AlarmApplyResult(
        scheduled: false,
        message: 'Exact alarm access required.',
      );
}

class _FailDefaults extends AppDefaultsRepository {
  _FailDefaults(super.database);
  @override
  Future<AppDefaults> load() async => const AppDefaults();
  @override
  Future<void> save(AppDefaults defaults) async => throw StateError('disk');
}

void main() {
  testWidgets(
    'health failure has an actionable error rather than endless loading',
    (tester) async {
      final api = _Api()..failHealth = true;
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            alarmRuntimeGatewayProvider.overrideWithValue(
              AlarmRuntimeGateway(api: api),
            ),
          ],
          child: MaterialApp(
            theme: RyserTheme.dark,
            home: const AlarmHealthScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Alarm readiness could not be checked.'),
        findsOneWidget,
      );
      expect(find.text('TRY AGAIN'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    },
  );

  testWidgets('failed default save preserves input and unlocks save', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDefaultsProvider.overrideWith((ref) async => const AppDefaults()),
          appDefaultsRepositoryProvider.overrideWithValue(_FailDefaults(db)),
        ],
        child: MaterialApp(
          theme: RyserTheme.dark,
          home: const SettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '7');
    await tester.scrollUntilVisible(
      find.text('SAVE DEFAULTS'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('SAVE DEFAULTS'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Defaults could not be saved.'), findsOneWidget);
    expect(find.text('SAVE DEFAULTS'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '7',
    );
  });

  testWidgets('native schedule rejection does not enable the persisted alarm', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db
        .into(db.alarms)
        .insert(
          AlarmsCompanion.insert(
            id: 'test',
            localHour: 7,
            localMinute: 0,
            enabled: const Value(false),
            recurrenceType: 'daily',
            soundId: 'pulse-a',
            ringtoneUri: const Value('content://audio/1'),
            snoozeDurationMinutes: 5,
            createdAtMs: 1,
            updatedAtMs: 1,
          ),
        );
    final now = DateTime.now();
    final alarm = domain.Alarm(
      id: 'test',
      localHour: 7,
      localMinute: 0,
      enabled: false,
      recurrenceType: domain.AlarmRecurrenceType.daily,
      repeatDaysMask: 0,
      soundId: 'pulse-a',
      ringtoneUri: 'content://audio/1',
      ringtoneTitle: 'Pulse',
      adaptiveSoundRotation: true,
      increasingVolume: false,
      vibrationEnabled: true,
      snoozeEnabled: true,
      snoozeDurationMinutes: 5,
      definitionRevision: 1,
      createdAt: now,
      updatedAt: now,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          alarmRuntimeGatewayProvider.overrideWithValue(
            AlarmRuntimeGateway(api: _Api()),
          ),
          alarmsProvider.overrideWith((ref) => Stream.value([alarm])),
          dashboardMissionProvider.overrideWith(
            (ref, id) => Stream.value(null),
          ),
          dashboardProtocolProvider.overrideWith(
            (ref, id) => Stream.value(null),
          ),
          wakeSessionsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(theme: RyserTheme.dark, home: const HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byType(Switch),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 30));
    }
    expect(find.text('Exact alarm access required.'), findsOneWidget);
    expect((await db.select(db.alarms).getSingle()).enabled, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('editor keeps mission fields reachable at double text size', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    tester.view.physicalSize = const Size(360, 733);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          appDefaultsRepositoryProvider.overrideWithValue(_FailDefaults(db)),
          alarmRuntimeGatewayProvider.overrideWithValue(
            AlarmRuntimeGateway(api: _Api()),
          ),
          appDefaultsProvider.overrideWith((ref) async => const AppDefaults()),
        ],
        child: MaterialApp(
          theme: RyserTheme.dark,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: const AlarmEditorScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('WAKE ENFORCEMENT'),
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    final toggle = find.ancestor(
      of: find.text('WAKE ENFORCEMENT'),
      matching: find.byType(SwitchListTile),
    );
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('MISSION'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
