import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/qr_mission/domain/qr_payload.dart';

void main() {
  test('normalization is deterministic across surrounding whitespace', () {
    expect(
      hashQrPayload('  bathroom-code\r\n'),
      hashQrPayload('bathroom-code'),
    );
  });

  test('matching accepts the registered payload only', () {
    final expected = hashQrPayload('bathroom-code');
    expect(
      qrPayloadMatches(scanned: 'bathroom-code', expectedHash: expected),
      isTrue,
    );
    expect(
      qrPayloadMatches(scanned: 'kitchen-code', expectedHash: expected),
      isFalse,
    );
  });

  test('QR mission completes only for the registered target', () {
    final expected = hashQrPayload('bathroom-code');
    expect(
      evaluateQrMissionScan(scanned: null, expectedHash: expected),
      QrMissionDecision.ignore,
    );
    expect(
      evaluateQrMissionScan(scanned: 'kitchen-code', expectedHash: expected),
      QrMissionDecision.reject,
    );
    expect(
      evaluateQrMissionScan(scanned: ' bathroom-code ', expectedHash: expected),
      QrMissionDecision.complete,
    );
  });
}
