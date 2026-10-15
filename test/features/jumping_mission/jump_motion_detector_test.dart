import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/jumping_mission/domain/jump_motion_detector.dart';

void main() {
  test('counts a light airborne and landing sequence', () {
    final detector = JumpMotionDetector();
    final start = DateTime(2026);

    expect(_reading(detector, start, 9.8), isFalse);
    expect(
      _reading(detector, start.add(const Duration(milliseconds: 100)), 7.5),
      isFalse,
    );
    expect(
      _reading(detector, start.add(const Duration(milliseconds: 350)), 12.5),
      isTrue,
    );
  });

  test('does not count a landing spike without an airborne phase', () {
    final detector = JumpMotionDetector();
    expect(_reading(detector, DateTime(2026), 13), isFalse);
  });

  test('rejects a stale airborne phase', () {
    final detector = JumpMotionDetector();
    final start = DateTime(2026);
    _reading(detector, start, 7.5);
    expect(
      _reading(detector, start.add(const Duration(seconds: 2)), 13),
      isFalse,
    );
  });
}

bool _reading(JumpMotionDetector detector, DateTime at, double z) =>
    detector.addReading(x: 0, y: 0, z: z, recordedAt: at);
