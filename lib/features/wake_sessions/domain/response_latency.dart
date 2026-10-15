int calculateResponseLatencyMs({
  required int triggeredAtMs,
  required int interactionAtMs,
}) {
  return (interactionAtMs - triggeredAtMs).clamp(0, 1 << 62).toInt();
}
