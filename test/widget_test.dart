import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/app/app.dart';
import 'package:ryser/app/app_version.dart';
import 'package:ryser/features/alarms/domain/alarm.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';

void main() {
  testWidgets('renders the Ryser empty alarm state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          alarmsProvider.overrideWith((ref) => Stream<List<Alarm>>.value([])),
        ],
        child: const RyserApp(),
      ),
    );
    await tester.pump();

    expect(
      find.text('v${RyserBuild.version}  /  ADAPTIVE ALARM SYSTEM'),
      findsOneWidget,
    );
    expect(find.text('Your first wake starts here'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('INITIALIZE NEW ALARM'),
      250,
      scrollable: find.byType(Scrollable).first,
    );

    await tester.tap(find.text('INITIALIZE NEW ALARM'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('ADD ALARM'), findsOneWidget);
    expect(find.text('TIME'), findsOneWidget);
    expect(find.text('One time'), findsOneWidget);
  });
}
