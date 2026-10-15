class WakeRetryPolicy {
  const WakeRetryPolicy({this.maximumFailures = 2});

  final int maximumFailures;

  bool shouldScheduleAnotherCheck(int failureCount) =>
      failureCount < maximumFailures;
}
