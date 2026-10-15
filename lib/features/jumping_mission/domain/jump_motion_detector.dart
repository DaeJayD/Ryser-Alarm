import 'dart:math';

/// Detects a jump as a short low-gravity phase followed by a landing.
///
/// Requiring both phases lets light jumps register without treating ordinary
/// walking or a single phone movement as a jump.
class JumpMotionDetector {
  JumpMotionDetector({
    this.airborneThreshold = 8.5,
    this.landingThreshold = 12.0,
    this.maximumAirborneDuration = const Duration(milliseconds: 1100),
    this.minimumJumpInterval = const Duration(milliseconds: 450),
  });

  final double airborneThreshold;
  final double landingThreshold;
  final Duration maximumAirborneDuration;
  final Duration minimumJumpInterval;

  DateTime? _airborneAt;
  DateTime? _lastJumpAt;

  bool addReading({
    required double x,
    required double y,
    required double z,
    required DateTime recordedAt,
  }) {
    final magnitude = sqrt(x * x + y * y + z * z);

    if (magnitude <= airborneThreshold) {
      _airborneAt ??= recordedAt;
      return false;
    }

    final airborneAt = _airborneAt;
    if (airborneAt == null) return false;

    final airborneDuration = recordedAt.difference(airborneAt);
    if (airborneDuration > maximumAirborneDuration) {
      _airborneAt = null;
      return false;
    }

    final enoughTimePassed =
        _lastJumpAt == null ||
        recordedAt.difference(_lastJumpAt!) >= minimumJumpInterval;
    if (magnitude >= landingThreshold && enoughTimePassed) {
      _airborneAt = null;
      _lastJumpAt = recordedAt;
      return true;
    }
    return false;
  }
}
