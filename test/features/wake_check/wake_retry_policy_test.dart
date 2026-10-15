import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/wake_check/domain/wake_retry_policy.dart';

void main() {
  const policy = WakeRetryPolicy();

  test('allows checks until two failures and then enforces the limit', () {
    expect(policy.shouldScheduleAnotherCheck(0), isTrue);
    expect(policy.shouldScheduleAnotherCheck(1), isTrue);
    expect(policy.shouldScheduleAnotherCheck(2), isFalse);
    expect(policy.shouldScheduleAnotherCheck(3), isFalse);
  });
}
