import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/movement_mission/domain/movement_progress.dart';

void main() {
  test('only steps after the mission baseline count', () {
    final progress = MovementProgress(requiredSteps: 10);
    expect(progress.addStepCounterReading(1200), 0);
    expect(progress.addStepCounterReading(1204), 4);
    expect(progress.addStepCounterReading(1210), 10);
    expect(progress.completed, isTrue);
  });

  test('GPS fallback counts realistic walking and rejects drift and jumps', () {
    final progress = MovementProgress(requiredSteps: 4);
    expect(progress.addLocationDistance(0.2, accuracyMetres: 5), 0);
    expect(progress.addLocationDistance(50, accuracyMetres: 5), 0);
    expect(progress.addLocationDistance(3, accuracyMetres: 80), 0);
    expect(progress.addLocationDistance(1.5, accuracyMetres: 5), 2);
    expect(progress.addLocationDistance(1.5, accuracyMetres: 5), 4);
    expect(progress.completed, isTrue);
  });

  test(
    'uses the stronger of sensor and location evidence without double counting',
    () {
      final progress = MovementProgress(requiredSteps: 10);
      progress.addStepCounterReading(100);
      expect(progress.addStepCounterReading(105), 5);
      expect(progress.addLocationDistance(1.5, accuracyMetres: 5), 5);
    },
  );

  test('motion fallback advances while preserving the strongest source', () {
    final progress = MovementProgress(requiredSteps: 10);
    progress.addStepCounterReading(100);
    expect(progress.addStepCounterReading(102), 2);
    expect(progress.addMotionStep(), 2);
    expect(progress.addMotionStep(), 2);
    expect(progress.addMotionStep(), 3);
  });
}
