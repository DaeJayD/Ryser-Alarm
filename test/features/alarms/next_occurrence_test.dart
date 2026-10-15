import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/alarms/domain/alarm.dart';
import 'package:ryser/features/alarms/domain/next_occurrence.dart';

void main() {
  group('calculateNextOccurrence', () {
    test('uses today when a one-time alarm is still ahead', () {
      final now = DateTime(2026, 9, 16, 6, 30);

      final next = calculateNextOccurrence(
        now: now,
        hour: 7,
        minute: 0,
        recurrenceType: AlarmRecurrenceType.oneTime,
        repeatDaysMask: 0,
      );

      expect(next, DateTime(2026, 9, 16, 7));
    });

    test('moves a passed one-time alarm to the next calendar day', () {
      final now = DateTime(2026, 9, 16, 7, 1);

      final next = calculateNextOccurrence(
        now: now,
        hour: 7,
        minute: 0,
        recurrenceType: AlarmRecurrenceType.oneTime,
        repeatDaysMask: 0,
      );

      expect(next, DateTime(2026, 9, 17, 7));
    });

    test('finds the next selected weekday', () {
      final wednesday = DateTime(2026, 9, 16, 8);
      const fridayBit = 1 << (DateTime.friday - 1);

      final next = calculateNextOccurrence(
        now: wednesday,
        hour: 7,
        minute: 0,
        recurrenceType: AlarmRecurrenceType.selectedWeekdays,
        repeatDaysMask: fridayBit,
      );

      expect(next, DateTime(2026, 9, 18, 7));
    });

    test('rejects selected-weekday recurrence with no selected day', () {
      expect(
        () => calculateNextOccurrence(
          now: DateTime(2026, 9, 16),
          hour: 7,
          minute: 0,
          recurrenceType: AlarmRecurrenceType.selectedWeekdays,
          repeatDaysMask: 0,
        ),
        throwsArgumentError,
      );
    });
  });
}
