import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/missions/domain/hold_duration.dart';

void main() {
  const hold = HoldDuration(Duration(seconds: 8));

  test('emergency hold cannot complete before eight seconds', () {
    expect(hold.progress(const Duration(seconds: 4)), 0.5);
    expect(hold.isComplete(const Duration(milliseconds: 7999)), isFalse);
    expect(hold.isComplete(const Duration(seconds: 8)), isTrue);
    expect(hold.progress(const Duration(seconds: 9)), 1);
  });
}
