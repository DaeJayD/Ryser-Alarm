import 'package:ryser/features/alarms/domain/alarm.dart';

DateTime calculateNextOccurrence({
  required DateTime now,
  required int hour,
  required int minute,
  required AlarmRecurrenceType recurrenceType,
  required int repeatDaysMask,
}) {
  final localNow = now.toLocal();
  final today = DateTime(
    localNow.year,
    localNow.month,
    localNow.day,
    hour,
    minute,
  );

  switch (recurrenceType) {
    case AlarmRecurrenceType.oneTime:
    case AlarmRecurrenceType.daily:
      return today.isAfter(localNow)
          ? today
          : today.add(const Duration(days: 1));
    case AlarmRecurrenceType.selectedWeekdays:
      if (repeatDaysMask == 0) {
        throw ArgumentError.value(
          repeatDaysMask,
          'repeatDaysMask',
          'At least one weekday is required.',
        );
      }
      for (var daysAhead = 0; daysAhead < 7; daysAhead++) {
        final candidateDay = localNow.add(Duration(days: daysAhead));
        final weekdayBit = 1 << (candidateDay.weekday - 1);
        final isSelected = repeatDaysMask & weekdayBit != 0;
        if (!isSelected) continue;

        final candidate = DateTime(
          candidateDay.year,
          candidateDay.month,
          candidateDay.day,
          hour,
          minute,
        );
        if (candidate.isAfter(localNow)) return candidate;
      }
      return DateTime(
        localNow.year,
        localNow.month,
        localNow.day,
        hour,
        minute,
      ).add(const Duration(days: 7));
  }
}

String formatRecurrence(Alarm alarm) {
  switch (alarm.recurrenceType) {
    case AlarmRecurrenceType.oneTime:
      return 'One time';
    case AlarmRecurrenceType.daily:
      return 'Every day';
    case AlarmRecurrenceType.selectedWeekdays:
      const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return [
        for (var index = 0; index < labels.length; index++)
          if (alarm.repeatDaysMask & (1 << index) != 0) labels[index],
      ].join(' ');
  }
}
