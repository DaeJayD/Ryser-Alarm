import 'package:ryser/features/adaptive_wake/domain/adaptive_thresholds.dart';

enum WakeFailureMode {
  none,
  noResponse,
  slowInitialResponse,
  excessiveSnooze,
  missionFailure,
  wakeCheckFailure,
  repeatedReactivation,
  emergencyBypass,
  manualTermination,
  soundEffectivenessDecline,
  unknown,
}

enum ResponseLatencyClassification { unavailable, fast, normal, slow, verySlow }

enum SnoozeClassification { none, low, moderate, high }

enum DataSufficiency { insufficient, limited, adequate }

class WakeSessionEvidence {
  const WakeSessionEvidence({
    required this.sessionId,
    required this.outcome,
    required this.responseLatencyMs,
    required this.snoozeCount,
    required this.missionFailureCount,
    required this.wakeCheckFailureCount,
    required this.reactivationCount,
    required this.emergencyBypass,
    required this.completed,
    this.soundDeclining = false,
    this.eventTypes = const [],
  });

  final String sessionId;
  final String outcome;
  final int? responseLatencyMs;
  final int snoozeCount;
  final int missionFailureCount;
  final int wakeCheckFailureCount;
  final int reactivationCount;
  final bool emergencyBypass;
  final bool completed;
  final bool soundDeclining;
  final List<String> eventTypes;

  bool get confirmedWake => outcome == 'wakeConfirmed';
}

class WakeSessionAnalysis {
  const WakeSessionAnalysis({
    required this.sessionId,
    required this.primaryFailureMode,
    required this.secondaryFailureModes,
    required this.response,
    required this.snoozes,
    required this.dataSufficiency,
    required this.validForAdaptation,
    required this.confirmedWake,
    required this.notes,
  });

  final String sessionId;
  final WakeFailureMode primaryFailureMode;
  final List<WakeFailureMode> secondaryFailureModes;
  final ResponseLatencyClassification response;
  final SnoozeClassification snoozes;
  final DataSufficiency dataSufficiency;
  final bool validForAdaptation;
  final bool confirmedWake;
  final List<String> notes;
}

class WakeSessionAnalyzer {
  const WakeSessionAnalyzer({this.thresholds = const AdaptiveThresholds()});

  final AdaptiveThresholds thresholds;

  WakeSessionAnalysis analyze(
    WakeSessionEvidence evidence, {
    required int comparableValidSessionCount,
  }) {
    final response = _response(evidence.responseLatencyMs);
    final snoozes = _snoozes(evidence.snoozeCount);
    final sufficiency = comparableValidSessionCount < thresholds.minimumBaseline
        ? DataSufficiency.insufficient
        : comparableValidSessionCount < thresholds.adequateBaseline
        ? DataSufficiency.limited
        : DataSufficiency.adequate;
    final failures = <WakeFailureMode>[];
    if (!evidence.completed) {
      failures.add(WakeFailureMode.unknown);
    } else {
      if (evidence.emergencyBypass || evidence.outcome == 'bypassed') {
        failures.add(WakeFailureMode.emergencyBypass);
      }
      if (evidence.outcome == 'manualTermination' ||
          evidence.eventTypes.contains('MANUAL_TERMINATION')) {
        failures.add(WakeFailureMode.manualTermination);
      }
      if (evidence.responseLatencyMs == null && failures.isEmpty) {
        failures.add(WakeFailureMode.noResponse);
      }
      if (evidence.wakeCheckFailureCount > 0) {
        failures.add(WakeFailureMode.wakeCheckFailure);
      }
      if (evidence.missionFailureCount > 0) {
        failures.add(WakeFailureMode.missionFailure);
      }
      if (evidence.reactivationCount > 1) {
        failures.add(WakeFailureMode.repeatedReactivation);
      }
      if (evidence.responseLatencyMs != null &&
          (response == ResponseLatencyClassification.slow ||
              response == ResponseLatencyClassification.verySlow)) {
        failures.add(WakeFailureMode.slowInitialResponse);
      }
      if (snoozes == SnoozeClassification.high) {
        failures.add(WakeFailureMode.excessiveSnooze);
      }
      if (evidence.soundDeclining) {
        failures.add(WakeFailureMode.soundEffectivenessDecline);
      }
    }
    final primary = failures.isEmpty ? WakeFailureMode.none : failures.first;
    return WakeSessionAnalysis(
      sessionId: evidence.sessionId,
      primaryFailureMode: primary,
      secondaryFailureModes: failures.skip(1).toList(growable: false),
      response: response,
      snoozes: snoozes,
      dataSufficiency: sufficiency,
      validForAdaptation:
          evidence.completed &&
          !evidence.emergencyBypass &&
          (evidence.responseLatencyMs == null ||
              evidence.responseLatencyMs! >= 0) &&
          !const {
            'active',
            'incomplete',
            'cancelled',
            'bypassed',
            'manualTermination',
          }.contains(evidence.outcome),
      confirmedWake: evidence.confirmedWake,
      notes: [
        if (!evidence.completed) 'Session is not terminal.',
        if (sufficiency == DataSufficiency.insufficient)
          'Baseline data is still insufficient.',
      ],
    );
  }

  ResponseLatencyClassification _response(int? milliseconds) {
    if (milliseconds == null) return ResponseLatencyClassification.unavailable;
    if (milliseconds < 0) return ResponseLatencyClassification.unavailable;
    if (milliseconds <= thresholds.fastMs) {
      return ResponseLatencyClassification.fast;
    }
    if (milliseconds <= thresholds.normalMs) {
      return ResponseLatencyClassification.normal;
    }
    if (milliseconds <= thresholds.slowMs) {
      return ResponseLatencyClassification.slow;
    }
    return ResponseLatencyClassification.verySlow;
  }

  SnoozeClassification _snoozes(int count) {
    if (count <= 0) return SnoozeClassification.none;
    if (count == 1) return SnoozeClassification.low;
    if (count == 2) return SnoozeClassification.moderate;
    return SnoozeClassification.high;
  }
}
