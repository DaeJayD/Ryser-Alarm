import 'dart:math';

/// Detects walking-like acceleration peaks when the device step counter is
/// delayed or unavailable.
class StepMotionDetector {
  StepMotionDetector({
    this.peakThreshold = 0.85,
    this.resetThreshold = 0.35,
    this.minimumStepInterval = const Duration(milliseconds: 260),
  });

  final double peakThreshold;
  final double resetThreshold;
  final Duration minimumStepInterval;

  double? _smoothedMagnitude;
  DateTime? _lastStepAt;
  bool _armed = true;

  bool addReading({
    required double x,
    required double y,
    required double z,
    required DateTime recordedAt,
  }) {
    final magnitude = sqrt(x * x + y * y + z * z);
    final previous = _smoothedMagnitude;
    if (previous == null) {
      _smoothedMagnitude = magnitude;
      return false;
    }

    // Follow gravity and orientation changes slowly, leaving the short walking
    // impulse in `dynamicAcceleration`.
    final smoothed = previous * 0.9 + magnitude * 0.1;
    _smoothedMagnitude = smoothed;
    final dynamicAcceleration = magnitude - smoothed;

    if (dynamicAcceleration <= resetThreshold) {
      _armed = true;
      return false;
    }

    final enoughTimePassed =
        _lastStepAt == null ||
        recordedAt.difference(_lastStepAt!) >= minimumStepInterval;
    if (_armed && dynamicAcceleration >= peakThreshold && enoughTimePassed) {
      _armed = false;
      _lastStepAt = recordedAt;
      return true;
    }
    return false;
  }
}
