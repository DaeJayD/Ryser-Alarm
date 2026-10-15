/// Versioned product heuristics, not medical or calibrated acoustic thresholds.
class AdaptiveThresholds {
  const AdaptiveThresholds({
    this.fastMs = 15000,
    this.normalMs = 30000,
    this.slowMs = 60000,
    this.minimumBaseline = 3,
    this.adequateBaseline = 7,
    this.declineBaselineUses = 4,
    this.declineRecentUses = 3,
    this.declineRatio = 1.3,
    this.declineDifferenceMs = 8000,
  });

  static const version = 1;
  final int fastMs;
  final int normalMs;
  final int slowMs;
  final int minimumBaseline;
  final int adequateBaseline;
  final int declineBaselineUses;
  final int declineRecentUses;
  final double declineRatio;
  final int declineDifferenceMs;

  /// Group budgets: last three 60%, four preceding 30%, older baseline 10%.
  /// Missing groups are renormalized by the engine.
  static const recentWeight = 0.6;
  static const moderateWeight = 0.3;
  static const historicalWeight = 0.1;
}
