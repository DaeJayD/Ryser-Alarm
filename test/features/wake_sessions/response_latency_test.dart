import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/wake_sessions/domain/response_latency.dart';

void main() {
  test('response latency preserves raw millisecond precision', () {
    expect(
      calculateResponseLatencyMs(
        triggeredAtMs: 1_000_000,
        interactionAtMs: 1_019_735,
      ),
      19_735,
    );
  });

  test('response latency never becomes negative', () {
    expect(
      calculateResponseLatencyMs(triggeredAtMs: 2_000, interactionAtMs: 1_999),
      0,
    );
  });
}
