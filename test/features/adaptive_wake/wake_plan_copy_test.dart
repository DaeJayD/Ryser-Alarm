import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/app/theme/ryser_theme.dart';
import 'package:ryser/features/adaptive_wake/domain/protocol_diff.dart';
import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';
import 'package:ryser/features/adaptive_wake/presentation/adaptive_explanation_screen.dart';
import 'package:ryser/features/adaptive_wake/presentation/wake_plan_copy.dart';

import 'adaptive_test_fixtures.dart';

void main() {
  test('every audited setting and reason has a readable label', () {
    for (final key in protocolDisplayValues(protocol()).keys) {
      expect(planFieldLabels[key], isNotNull, reason: key);
      expect(planFieldLabels[key], isNot(key));
    }
    for (final reason in AdaptiveReasonCode.values) {
      expect(planReason(reason), isNot(contains(reason.name)));
    }
    expect(soundLabel('PULSE'), 'Pulsing sound');
    expect(planFieldValue('wakeCheckHoldMilliseconds', 3500), '3.5 seconds');
    expect(
      planFieldValue('vibrationPattern', 'doublePulse'),
      'Two short pulses',
    );
    expect(
      missionLabel(
        protocol(missionRequired: true, missionConfiguration: 'bad'),
      ),
      'Complete your walking task',
    );
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('existing plans show plain explanations at text scale $scale', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 733);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final previous = protocol().copyWith(
        status: WakeProtocolStatus.superseded,
      );
      final current = previous.copyWith(
        id: 'new',
        version: 4,
        status: WakeProtocolStatus.active,
        supersedesProtocolId: previous.id,
        initialVolumePercent: 70,
        reasonCode: AdaptiveReasonCode.manualUserOverride,
        userExplanation: 'Unchanged: soundFamily, initialVolumePercent',
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            wakePlanHistoryProvider('alarm-1')
                .overrideWith((ref) async => [current, previous]),
          ],
          child: MaterialApp(
            theme: RyserTheme.dark,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            ),
            home: const AdaptiveExplanationScreen(alarmId: 'alarm-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Current plan · Update 4'), findsOneWidget);
      expect(find.text('Starting volume: 50% → 70%'), findsOneWidget);
      expect(find.textContaining('manualUserOverride'), findsNothing);
      expect(find.textContaining('soundFamily'), findsNothing);
      expect(find.textContaining('PROTOCOL V4'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
