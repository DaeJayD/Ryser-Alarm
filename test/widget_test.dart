import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/app/app.dart';
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

    expect(find.text('RYSER // ADAPTIVE ALARM'), findsOneWidget);
    expect(find.text('> ALARM REGISTRY EMPTY'), findsOneWidget);
    expect(find.text('INITIALIZE NEW ALARM'), findsOneWidget);

    await tester.tap(find.text('INITIALIZE NEW ALARM'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('ADD ALARM'), findsOneWidget);
    expect(find.text('TIME'), findsOneWidget);
    expect(find.text('One time'), findsOneWidget);
  });
}
