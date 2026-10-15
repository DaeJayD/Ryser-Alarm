class HoldDuration {
  const HoldDuration(this.required);

  final Duration required;

  double progress(Duration elapsed) =>
      (elapsed.inMilliseconds / required.inMilliseconds).clamp(0, 1);

  bool isComplete(Duration elapsed) => elapsed >= required;
}
