enum AlarmRecurrenceType { oneTime, daily, selectedWeekdays }

class Alarm {
  const Alarm({
    required this.id,
    required this.localHour,
    required this.localMinute,
    required this.enabled,
    required this.recurrenceType,
    required this.repeatDaysMask,
    required this.soundId,
    required this.ringtoneUri,
    required this.ringtoneTitle,
    required this.adaptiveSoundRotation,
    required this.increasingVolume,
    required this.vibrationEnabled,
    required this.snoozeEnabled,
    required this.snoozeDurationMinutes,
    required this.definitionRevision,
    required this.createdAt,
    required this.updatedAt,
    this.label,
  });

  final String id;
  final int localHour;
  final int localMinute;
  final String? label;
  final bool enabled;
  final AlarmRecurrenceType recurrenceType;
  final int repeatDaysMask;
  final String soundId;
  final String? ringtoneUri;
  final String? ringtoneTitle;
  final bool adaptiveSoundRotation;
  final bool increasingVolume;
  final bool vibrationEnabled;
  final bool snoozeEnabled;
  final int snoozeDurationMinutes;
  final int definitionRevision;
  final DateTime createdAt;
  final DateTime updatedAt;
}
