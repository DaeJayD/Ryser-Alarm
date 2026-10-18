import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/app/theme/ryser_theme.dart';
import 'package:ryser/app/app_version.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/core/widgets/ryser_panel.dart';
import 'package:ryser/database/app_database.dart' as db;
import 'package:ryser/features/alarms/domain/alarm.dart';
import 'package:ryser/features/alarms/presentation/alarm_dashboard.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/alarms/presentation/dashboard_providers.dart';

final clock = DateTime(2026, 10, 15, 23, 9, 34);
Alarm alarm(String id, int hour, int minute, {bool enabled = true}) => Alarm(
  id: id,
  localHour: hour,
  localMinute: minute,
  enabled: enabled,
  label: 'Morning routine',
  recurrenceType: AlarmRecurrenceType.daily,
  repeatDaysMask: 0,
  soundId: 'pulse-a',
  ringtoneUri: 'content://audio/1',
  ringtoneTitle: 'Morning pulse',
  adaptiveSoundRotation: true,
  increasingVolume: true,
  vibrationEnabled: true,
  snoozeEnabled: true,
  snoozeDurationMinutes: 3,
  definitionRevision: 1,
  createdAt: clock,
  updatedAt: clock,
);

AlarmHealthDto health({bool ready = true}) => AlarmHealthDto(
  exactAlarmsReady: ready,
  notificationsReady: ready,
  fullScreenReady: ready,
  batteryUnrestricted: ready,
  alarmVolume: ready ? 5 : 0,
  alarmVolumeMax: 10,
);

Future<void> capture(WidgetTester tester, GlobalKey key, String name) async {
  if (Platform.environment['RYSER_LAYOUT_CAPTURE'] != '1') return;
  // Image decoding runs outside the widget test's fake clock.
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      await precacheImage((element.widget as Image).image, element);
    }
  });
  await tester.pumpAndSettle();
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1.5);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File('artifacts/screenshots/$name.png');
    await file.parent.create(recursive: true);
    await file.writeAsBytes(data!.buffer.asUint8List());
    image.dispose();
  });
}

void main() {
  setUpAll(() async {
    final iconFont = Platform.environment['RYSER_ICON_FONT'];
    if (iconFont != null) {
      await (FontLoader('MaterialIcons')
            ..addFont(File(iconFont).readAsBytes().then(ByteData.sublistView)))
          .load();
    }
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
  });

  test(
    'next alarm sorts by actual enabled occurrence, not insertion order',
    () {
      final items = [
        alarm('disabled', 23, 10, enabled: false),
        alarm('later', 8, 0),
        alarm('next', 3, 28),
      ];
      expect(orderDashboardAlarms(items, clock).map((a) => a.id), [
        'next',
        'later',
        'disabled',
      ]);
      expect(items.first.id, 'disabled');
    },
  );

  test('displayed version matches the package build identity', () {
    expect(
      File('pubspec.yaml').readAsStringSync(),
      contains('version: ${RyserBuild.version}+${RyserBuild.number}'),
    );
  });

  test('weekday alarms beyond tomorrow retain their real calendar offset', () {
    expect(dashboardDayOffset(DateTime(2026, 10, 15, 23, 30), clock), 0);
    expect(dashboardDayOffset(DateTime(2026, 10, 16, 7), clock), 1);
    expect(dashboardDayOffset(DateTime(2026, 10, 19, 7), clock), 4);
  });

  testWidgets('second ticks update the clock without rebuilding alarm cards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 1500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final ticking = ValueNotifier(clock);
    addTearDown(ticking.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardHealthProvider.overrideWith((ref) async => health()),
          dashboardMissionProvider.overrideWith(
            (ref, id) => Stream.value(null),
          ),
          dashboardProtocolProvider.overrideWith(
            (ref, id) => Stream.value(null),
          ),
          wakeSessionsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: RyserTheme.dark,
          home: Scaffold(
            body: AlarmDashboard(
              now: clock,
              clock: ticking,
              alarms: [alarm('next', 3, 28)],
              onAdd: () {},
              onEdit: (_) {},
              onToggle: (_, _) {},
              onHistory: () {},
              onHealth: () {},
              onSettings: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final before = tester.widget(find.text('Morning routine'));
    ticking.value = clock.add(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('35'), findsOneWidget);
    expect(
      identical(before, tester.widget(find.text('Morning routine'))),
      isTrue,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  for (final scenario in [
    (name: 'reference', size: const Size(430, 1500), scale: 1.0),
    (name: 'small', size: const Size(320, 568), scale: 1.0),
    (name: 'large-text', size: const Size(360, 733), scale: 2.0),
    (name: 'landscape', size: const Size(780, 360), scale: 1.0),
  ]) {
    testWidgets(
      'dashboard fits ${scenario.name} without quick actions or invented sleep data',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = scenario.size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final key = GlobalKey();
        var added = false, edited = false, historyOpened = false;
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              dashboardHealthProvider.overrideWith((ref) async => health()),
              dashboardMissionProvider.overrideWith(
                (ref, id) => Stream.value(null),
              ),
              dashboardProtocolProvider.overrideWith(
                (ref, id) => Stream.value(null),
              ),
              wakeSessionsProvider.overrideWith((ref) => Stream.value([])),
            ],
            child: RepaintBoundary(
              key: key,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: RyserTheme.dark,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(scenario.scale)),
                  child: RyserBackdrop(child: child!),
                ),
                home: Scaffold(
                  body: SafeArea(
                    child: AlarmDashboard(
                      now: clock,
                      alarms: [alarm('next', 3, 28)],
                      onAdd: () => added = true,
                      onEdit: (_) => edited = true,
                      onToggle: (_, _) {},
                      onHistory: () => historyOpened = true,
                      onHealth: () {},
                      onSettings: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('ACCESS READY'), findsOneWidget);
        expect(find.text('QUICK ACTIONS'), findsNothing);
        expect(find.textContaining('Total Sleep'), findsNothing);
        expect(tester.takeException(), isNull);
        if (scenario.name == 'reference') {
          await capture(tester, key, 'v3-dashboard-reference');
        }
        await tester.scrollUntilVisible(
          find.text('HISTORY'),
          200,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('HISTORY'));
        expect(historyOpened, isTrue);
        await tester.scrollUntilVisible(
          find.text('Wake-up verification'),
          250,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Wake-up verification'));
        expect(edited, isTrue);
        await tester.scrollUntilVisible(
          find.text('INITIALIZE NEW ALARM'),
          250,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('INITIALIZE NEW ALARM'));
        expect(added, isTrue);
        expect(find.text('No completed sessions yet'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }

  testWidgets('denied access is not presented as system ready', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardHealthProvider.overrideWith(
            (ref) async => health(ready: false),
          ),
          wakeSessionsProvider.overrideWith((ref) => Stream.value([])),
        ],
        child: MaterialApp(
          theme: RyserTheme.dark,
          home: Scaffold(
            body: AlarmDashboard(
              now: clock,
              alarms: const [],
              onAdd: () {},
              onEdit: (_) {},
              onToggle: (_, _) {},
              onHistory: () {},
              onHealth: () {},
              onSettings: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('CHECK HEALTH'), findsOneWidget);
    expect(find.text('ACCESS READY'), findsNothing);
    expect(find.text('Your first wake starts here'), findsOneWidget);
  });

  testWidgets('overview counts eligible history and shows measured latency', (
    tester,
  ) async {
    final database = db.AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    for (final entry in [
      ('confirmed', 'wakeConfirmed', 10000),
      ('failed', 'noResponse', 30000),
      ('bypass', 'bypassed', 0),
    ]) {
      await database
          .into(database.wakeSessions)
          .insert(
            db.WakeSessionsCompanion.insert(
              id: entry.$1,
              alarmId: 'a',
              scheduledTimeMs: clock.millisecondsSinceEpoch - 100000,
              triggeredAtMs: clock.millisecondsSinceEpoch - 100000,
              initialSoundId: 'sound',
              outcome: entry.$2,
              responseLatencyMs: Value(entry.$3),
              completedAtMs: Value(clock.millisecondsSinceEpoch - 1000),
              createdAtMs: clock.millisecondsSinceEpoch - 100000,
            ),
          );
    }
    final rows = await database.select(database.wakeSessions).get();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardHealthProvider.overrideWith((ref) async => health()),
          wakeSessionsProvider.overrideWith((ref) => Stream.value(rows)),
        ],
        child: MaterialApp(
          theme: RyserTheme.dark,
          home: Scaffold(
            body: AlarmDashboard(
              now: clock,
              alarms: const [],
              onAdd: () {},
              onEdit: (_) {},
              onToggle: (_, _) {},
              onHistory: () {},
              onHealth: () {},
              onSettings: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('WAKE OVERVIEW'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('20s'), findsOneWidget);
    expect(find.text('50%'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
