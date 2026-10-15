import 'dart:convert';

import 'package:crypto/crypto.dart';

String normalizeQrPayload(String value) =>
    value.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

String hashQrPayload(String value) =>
    sha256.convert(utf8.encode(normalizeQrPayload(value))).toString();

bool qrPayloadMatches({
  required String scanned,
  required String expectedHash,
}) => hashQrPayload(scanned) == expectedHash;

enum QrMissionDecision { ignore, reject, complete }

QrMissionDecision evaluateQrMissionScan({
  required String? scanned,
  required String expectedHash,
}) {
  if (scanned == null || normalizeQrPayload(scanned).isEmpty) {
    return QrMissionDecision.ignore;
  }
  return qrPayloadMatches(scanned: scanned, expectedHash: expectedHash)
      ? QrMissionDecision.complete
      : QrMissionDecision.reject;
}
