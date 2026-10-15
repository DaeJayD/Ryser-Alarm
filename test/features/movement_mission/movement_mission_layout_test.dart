import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ryser/app/theme/ryser_theme.dart';
import 'package:ryser/features/movement_mission/presentation/movement_mission_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    if (Platform.environment['RYSER_LAYOUT_CAPTURE'] == '1' &&
        Platform.isWindows) {
      final font = File(
        '${Platform.environment['WINDIR']}\\Fonts\\consola.ttf',
      );
      final loader = FontLoader('monospace')
        ..addFont(font.readAsBytes().then(ByteData.sublistView));
      await loader.load();
    }
  });

  setUp(() {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final name in [
      'dev.fluttercommunity.plus/sensors/method',
      'dev.fluttercommunity.plus/sensors/accelerometer',
      'step_count',
    ]) {
      messenger.setMockMethodCallHandler(
        MethodChannel(name),
        (_) async => null,
      );
    }
    messenger.setMockMethodCallHandler(
      const MethodChannel('flutter.baseflow.com/permissions/methods'),
      (call) async => <int, int>{
        for (final permission in (call.arguments as List).cast<int>())
          permission: permission == Permission.activityRecognition.value
              ? 1
              : 0,
      },
    );
  });

  for (final scenario in [
    (name: 'phone', size: const Size(384, 784), scale: 1.0),
    (name: 'small phone', size: const Size(320, 568), scale: 1.0),
    (name: 'large text', size: const Size(360, 733), scale: 2.0),
    (name: 'landscape', size: const Size(784, 384), scale: 1.0),
  ]) {
    testWidgets('walking retry is centered and reachable on ${scenario.name}', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = scenario.size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: MaterialApp(
            theme: RyserTheme.dark,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scenario.scale)),
              child: child!,
            ),
            home: const MovementMissionScreen(requiredSteps: 10),
          ),
        ),
      );
      await tester.pump();

      final screenCenter = scenario.size.width / 2;
      for (final finder in [
        find.text('0 / 10'),
        find.text('STEPS'),
        find.text('TRACKING: STARTING SENSORS'),
        find.text('EMERGENCY STOP — HOLD 8 SECONDS'),
        find.byType(LinearProgressIndicator),
      ]) {
        expect(tester.getCenter(finder).dx, closeTo(screenCenter, 0.5));
        final rect = tester.getRect(finder);
        expect(rect.left, greaterThanOrEqualTo(24));
        expect(rect.right, lessThanOrEqualTo(scenario.size.width - 24));
      }
      final emergency = find.byType(LinearProgressIndicator);
      await tester.ensureVisible(emergency);
      await tester.pump();
      expect(emergency.hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);

      if (scenario.name == 'phone' &&
          Platform.environment['RYSER_LAYOUT_CAPTURE'] == '1') {
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 1.875);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final output = File(
            'artifacts/screenshots/walking-alignment-fixed.png',
          );
          await output.parent.create(recursive: true);
          await output.writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}
