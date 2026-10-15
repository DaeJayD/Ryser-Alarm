import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/movement_mission/domain/step_motion_detector.dart';

void main() {
  test('counts separated walking peaks and ignores steady gravity', () {
    final detector = StepMotionDetector();
    final start = DateTime(2026);

    expect(_reading(detector, start, 9.8), isFalse);
    expect(
      _reading(detector, start.add(const Duration(milliseconds: 100)), 9.8),
      isFalse,
    );
    expect(
      _reading(detector, start.add(const Duration(milliseconds: 200)), 11.2),
      isTrue,
    );
    expect(
      _reading(detector, start.add(const Duration(milliseconds: 300)), 9.8),
      isFalse,
    );
    expect(
      _reading(detector, start.add(const Duration(milliseconds: 500)), 11.2),
      isTrue,
    );
  });

  test('rejects multiple peaks inside the minimum step interval', () {
    final detector = StepMotionDetector();
    final start = DateTime(2026);

    _reading(detector, start, 9.8);
    expect(
      _reading(detector, start.add(const Duration(milliseconds: 100)), 11.2),
      isTrue,
    );
    _reading(detector, start.add(const Duration(milliseconds: 150)), 9.8);
    expect(
      _reading(detector, start.add(const Duration(milliseconds: 220)), 11.2),
      isFalse,
    );
  });
}

bool _reading(StepMotionDetector detector, DateTime at, double z) =>
    detector.addReading(x: 0, y: 0, z: z, recordedAt: at);
