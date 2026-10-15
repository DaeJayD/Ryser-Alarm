class MovementProgress {
  MovementProgress({required this.requiredSteps});

  final int requiredSteps;
  int? _stepBaseline;
  int _sensorSteps = 0;
  int _motionSteps = 0;
  double _distanceMetres = 0;

  int get countedSteps => [
    _sensorSteps,
    _motionSteps,
    gpsSteps,
  ].reduce((strongest, value) => value > strongest ? value : strongest);
  int get gpsSteps => (_distanceMetres / metresPerStep).floor();
  bool get completed => countedSteps >= requiredSteps;

  static const double metresPerStep = 0.75;

  int addStepCounterReading(int cumulativeSteps) {
    _stepBaseline ??= cumulativeSteps;
    final delta = cumulativeSteps - _stepBaseline!;
    if (delta > _sensorSteps) _sensorSteps = delta;
    return countedSteps;
  }

  int addMotionStep() {
    _motionSteps++;
    return countedSteps;
  }

  int addLocationDistance(double metres, {required double accuracyMetres}) {
    // Ignore inaccurate readings, stationary GPS drift, and impossible jumps.
    if (accuracyMetres <= 30 && metres >= 0.4 && metres <= 20) {
      _distanceMetres += metres;
    }
    return countedSteps;
  }
}
