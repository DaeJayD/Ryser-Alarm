import 'package:ryser/features/adaptive_wake/domain/wake_protocol.dart';

class AdaptiveChange {
  const AdaptiveChange({
    required this.dimension,
    required this.oldValue,
    required this.newValue,
    required this.evidence,
    this.major = true,
    this.soundUri,
    this.soundFamily,
    this.field,
    this.priority = 100,
    this.reasonCode,
  });

  final AdaptiveDimension dimension;
  final Object? oldValue;
  final Object? newValue;
  final String evidence;
  final bool major;
  final String? soundUri;
  final String? soundFamily;
  final String? field;
  final int priority;
  final AdaptiveReasonCode? reasonCode;
}

class AdaptiveDecision {
  const AdaptiveDecision({
    required this.selectedRuleId,
    required this.reasonCode,
    required this.changes,
    required this.technicalExplanation,
    required this.userExplanation,
    required this.rulesEvaluated,
    required this.rulesMatched,
    required this.shouldApplyAutomatically,
    this.severity = 'ordinary',
    this.rejectedRules = const {},
  });

  final String? selectedRuleId;
  final AdaptiveReasonCode reasonCode;
  final List<AdaptiveChange> changes;
  final String technicalExplanation;
  final String userExplanation;
  final List<String> rulesEvaluated;
  final List<String> rulesMatched;
  final bool shouldApplyAutomatically;
  final String severity;
  final Map<String, String> rejectedRules;

  bool get hasChange => changes.isNotEmpty;
}
