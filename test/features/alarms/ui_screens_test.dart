import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/app/theme/ryser_theme.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/core/widgets/ryser_panel.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/alarm_health/presentation/alarm_health_screen.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/alarms/presentation/alarm_editor_screen.dart';
import 'package:ryser/features/settings/data/app_defaults_repository.dart';
import 'package:ryser/features/settings/presentation/settings_screen.dart';
import 'package:ryser/features/wake_sessions/presentation/wake_history_screen.dart';

import 'dashboard_test.dart' show capture;

class _ScreenApi extends AlarmRuntimeApi {
  @override
  Future<AlarmHealthDto> getAlarmHealth() async => AlarmHealthDto(
    exactAlarmsReady: true,
    notificationsReady: true,
    fullScreenReady: true,
    batteryUnrestricted: true,
    alarmVolume: 7,
    alarmVolumeMax: 10,
  );
  @override
  Future<List<RingtoneDto>> getAlarmRingtones() async => [];
}

void main() {
  setUpAll(() async {
    if (Platform.environment['RYSER_LAYOUT_CAPTURE'] == '1' &&
        Platform.isWindows) {
      for (final font in [
        ('Roboto', 'segoeui.ttf'),
        ('monospace', 'consola.ttf'),
      ]) {
        await (FontLoader(font.$1)..addFont(
              File('${Platform.environment['WINDIR']}\\Fonts\\${font.$2}')
                  .readAsBytes()
                  .then(ByteData.sublistView),
            ))
            .load();
      }
    }
    final icons = Platform.environment['RYSER_ICON_FONT'];
    if (icons != null) {
      await (FontLoader(
        'MaterialIcons',
      )..addFont(File(icons).readAsBytes().then(ByteData.sublistView))).load();
    }
  });
  for (final page in ['settings', 'history', 'health', 'editor']) {
    testWidgets('$page uses readable shared surfaces and remains scrollable', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(430, 960);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(db.close);
      await db
          .into(db.wakeSessions)
          .insert(
            WakeSessionsCompanion.insert(
              id: 'sample',
              alarmId: 'a',
              scheduledTimeMs: 1792020600000,
              triggeredAtMs: 1792020600000,
              initialSoundId: 'pulse-a',
              outcome: 'wakeConfirmed',
              responseLatencyMs: const Value(12000),
              completedAtMs: const Value(1792021000000),
              createdAtMs: 1792020600000,
            ),
          );
      final sessions = await db.select(db.wakeSessions).get();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            const MethodChannel('ryser/wake_enforcement'),
            (_) async => <String, Object?>{
              'cameraAvailable': true,
              'cameraPermission': true,
              'stepSensorAvailable': true,
              'activityPermission': true,
            },
          );
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
              const MethodChannel('ryser/wake_enforcement'),
              null,
            ),
      );
      final key = GlobalKey();
      final screen = switch (page) {
        'settings' => const SettingsScreen(),
        'history' => const WakeHistoryScreen(),
        'health' => const AlarmHealthScreen(),
        _ => const AlarmEditorScreen(),
      };
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            alarmRuntimeGatewayProvider.overrideWithValue(
              AlarmRuntimeGateway(api: _ScreenApi()),
            ),
            appDefaultsProvider.overrideWith(
              (ref) async => const AppDefaults(),
            ),
            wakeSessionsProvider.overrideWith((ref) => Stream.value(sessions)),
          ],
          child: RepaintBoundary(
            key: key,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: RyserTheme.dark,
              builder: (_, child) => RyserBackdrop(child: child!),
              home: screen,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Scrollable), findsWidgets);
      expect(tester.takeException(), isNull);
      await capture(tester, key, 'v3-$page');
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 1));
    });
  }
}
