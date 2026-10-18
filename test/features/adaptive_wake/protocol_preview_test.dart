import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/app/theme/ryser_theme.dart';
import 'package:ryser/features/adaptive_wake/presentation/wake_protocol_preview.dart';

import 'adaptive_test_fixtures.dart';

void main() {
  setUpAll(() async {
    if (Platform.environment['RYSER_LAYOUT_CAPTURE'] == '1' &&
        Platform.isWindows) {
      final loader = FontLoader('monospace')
        ..addFont(
          File('${Platform.environment['WINDIR']}\\Fonts\\consola.ttf')
              .readAsBytes()
              .then(ByteData.sublistView),
        );
      await loader.load();
    }
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'protocol execution summary fits narrow phone at text scale $scale',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(320, 700);
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
                    .copyWith(textScaler: TextScaler.linear(scale)),
                child: child!,
              ),
              home: Scaffold(
                appBar: AppBar(title: const Text('WAKE PROTOCOL')),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: WakeProtocolPreview(
                    protocol:
                        protocol(
                          missionRequired: true,
                          missionConfiguration: '{"requiredSteps":20}',
                        ).copyWith(
                          wakeCheckHoldMilliseconds: 3500,
                          maxWakeCheckFailures: 3,
                        ),
                    policy: adaptivePolicy,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text('To stop the alarm: Walk 20 steps. Stays as you set it.'),
          findsOneWidget,
        );
        expect(find.textContaining('Volume starts at 50%'), findsOneWidget);
        final check = find.textContaining(
          'After dismissal, Ryser checks again in 10 minutes.',
        );
        expect(check, findsOneWidget);
        await tester.ensureVisible(check);
        // Large text may make this paragraph taller than the viewport;
        // scrolling must remain available without a layout overflow.
        expect(tester.takeException(), isNull);
        if (scale == 1 && Platform.environment['RYSER_LAYOUT_CAPTURE'] == '1') {
          final boundary =
              boundaryKey.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await boundary.toImage(pixelRatio: 2);
            final bytes = await image.toByteData(
              format: ui.ImageByteFormat.png,
            );
            final output = File(
              'artifacts/screenshots/protocol-preview-release.png',
            );
            await output.parent.create(recursive: true);
            await output.writeAsBytes(bytes!.buffer.asUint8List());
            image.dispose();
          });
        }
      },
    );
  }
}
