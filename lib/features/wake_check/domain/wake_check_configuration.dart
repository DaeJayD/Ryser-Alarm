class WakeCheckConfiguration {
  const WakeCheckConfiguration._();

  static const allowedDelayMinutes = <int>[5, 7, 10];
  static const defaultDelayMinutes = 5;

  static int delayMinutesFrom(Map<String, dynamic> configuration) {
    final value = configuration['wakeCheckDelayMinutes'];
    return value is int && allowedDelayMinutes.contains(value)
        ? value
        : defaultDelayMinutes;
  }
}
