import 'dart:convert';

/// Immutable execution settings for the session, with V2-compatible defaults.
class WakeCheckProtocol {
  const WakeCheckProtocol({
    this.required = true,
    this.holdMilliseconds = 2000,
    this.maximumFailures = 2,
    this.delayMinutes = 5,
  });

  final bool required;
  final int holdMilliseconds;
  final int maximumFailures;
  final int delayMinutes;

  factory WakeCheckProtocol.fromSnapshot(String? snapshot) {
    try {
      final p = jsonDecode(snapshot ?? '{}') as Map<String, dynamic>;
      int bounded(String key, int fallback, int min, int max) {
        final value = p[key];
        return value is int && value >= min && value <= max ? value : fallback;
      }

      return WakeCheckProtocol(
        required: p['wakeCheckRequired'] != false,
        holdMilliseconds: bounded(
          'wakeCheckHoldMilliseconds',
          2000,
          1500,
          4000,
        ),
        maximumFailures: bounded('maxWakeCheckFailures', 2, 1, 3),
        delayMinutes: bounded('wakeCheckDelayMinutes', 5, 5, 10),
      );
    } on FormatException {
      return const WakeCheckProtocol();
    } on TypeError {
      return const WakeCheckProtocol();
    }
  }
}
