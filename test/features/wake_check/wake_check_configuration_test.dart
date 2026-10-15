import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/wake_check/domain/wake_check_configuration.dart';

void main() {
  test('accepts only supported delayed Wake Check values', () {
    for (final value in WakeCheckConfiguration.allowedDelayMinutes) {
      expect(
        WakeCheckConfiguration.delayMinutesFrom({
          'wakeCheckDelayMinutes': value,
        }),
        value,
      );
    }
    expect(WakeCheckConfiguration.delayMinutesFrom(const {}), 5);
    expect(
      WakeCheckConfiguration.delayMinutesFrom(const {
        'wakeCheckDelayMinutes': 0,
      }),
      5,
    );
  });
}
