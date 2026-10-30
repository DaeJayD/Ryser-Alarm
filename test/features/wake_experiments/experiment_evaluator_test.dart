import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ryser/features/wake_experiments/domain/experiment_evaluator.dart';
import 'package:ryser/features/wake_experiments/domain/wake_experiment.dart';

ExperimentTrialEvidence trial(
  int i, {
  bool candidate = false,
  SessionValidity validity = SessionValidity.valid,
  String outcome = 'wakeConfirmed',
  int? latency = 20000,
  int snoozes = 0,
  int checkFailures = 0,
  int missionFailures = 0,
  int reactivations = 0,
  bool enforcement = false,
  bool completed = true,
  String? wakeId,
}) => ExperimentTrialEvidence(
  assignmentId: '${candidate ? 'b' : 'a'}-$i',
  wakeSessionId: wakeId ?? '${candidate ? 'b' : 'a'}-wake-$i',
  variant: candidate ? ExperimentVariant.candidate : ExperimentVariant.control,
  validity: validity,
  scheduledTimeMs: i * 1000,
  outcome: outcome,
  completed: completed,
  responseLatencyMs: latency,
  snoozeCount: snoozes,
  wakeCheckFailureCount: checkFailures,
  missionFailureCount: missionFailures,
  reactivationCount: reactivations,
  wakeEnforcementEnabled: enforcement,
  configuredIntensity: 2,
);

List<ExperimentTrialEvidence> balanced(
  int count, {
  int latencyA = 20000,
  int latencyB = 20000,
}) => [
  for (var i = 0; i < count; i++) ...[
    trial(i, latency: latencyA),
    trial(i, candidate: true, latency: latencyB),
  ],
];

void main() {
  const evaluator = ExperimentEvaluator();
  test('empty metrics stay unavailable, never fabricated zero success', () {
    final r = evaluator.evaluate(evidence: []);
    expect(r.outcome, ExperimentOutcome.insufficientData);
    expect(r.control.successRate, isNull);
    expect(r.candidate.medianResponseMs, isNull);
    expect(r.control.toJson()['meanConfiguredIntensity'], isNull);
    expect(r.recommendation, ExperimentRecommendation.collectMore);
  });

  test('minimum is required on both sides even for a large improvement', () {
    final r = evaluator.evaluate(evidence: balanced(2, latencyB: 5000));
    expect(r.outcome, ExperimentOutcome.insufficientData);
    expect(r.confidence, ExperimentConfidence.insufficient);
  });

  test('three wakes give limited coverage, five give adequate coverage', () {
    for (final count in [3, 5]) {
      final r = evaluator.evaluate(evidence: balanced(count, latencyB: 10000));
      expect(r.outcome, ExperimentOutcome.candidateBetter);
      expect(r.recommendation, ExperimentRecommendation.conclude);
      expect(
        r.confidence,
        count == 3
            ? ExperimentConfidence.limited
            : ExperimentConfidence.adequate,
      );
      expect(r.policyVersion, 1);
    }
  });

  test('latency needs both five seconds and twenty percent improvement', () {
    expect(
      evaluator
          .evaluate(evidence: balanced(3, latencyA: 25000, latencyB: 20000))
          .outcome,
      ExperimentOutcome.candidateBetter,
    );
    for (final pair in [(24999, 20000), (100000, 85000)]) {
      expect(
        evaluator
            .evaluate(
              evidence: balanced(3, latencyA: pair.$1, latencyB: pair.$2),
            )
            .outcome,
        ExperimentOutcome.noClearWinner,
      );
    }
  });

  test('usual choice can win; reversing order cannot change the result', () {
    final rows = balanced(5, latencyA: 10000, latencyB: 30000);
    final forward = evaluator.evaluate(evidence: rows);
    expect(forward.outcome, ExperimentOutcome.controlBetter);
    expect(
      jsonEncode(evaluator.evaluate(evidence: rows.reversed).toJson()),
      jsonEncode(forward.toJson()),
    );
  });

  test(
    'ties keep collecting until the attempt cap, without equivalence claims',
    () {
      final partial = evaluator.evaluate(evidence: balanced(5));
      expect(partial.outcome, ExperimentOutcome.noClearWinner);
      expect(partial.recommendation, ExperimentRecommendation.collectMore);
      final finalResult = evaluator.evaluate(evidence: balanced(10));
      expect(finalResult.recommendation, ExperimentRecommendation.conclude);
      expect(finalResult.outcome, ExperimentOutcome.noClearWinner);
      expect(finalResult.reason, contains('does not prove'));
    },
  );

  test('invalid and partial attempts count toward the budget, not success', () {
    final r = evaluator.evaluate(
      evidence: [
        for (var i = 0; i < 10; i++)
          trial(
            i,
            validity: i.isEven
                ? SessionValidity.invalid
                : SessionValidity.partial,
          ),
      ],
    );
    expect(r.control.attempts, 10);
    expect(r.control.validSessions, 0);
    expect(r.control.excludedSessions, 5);
    expect(r.control.partialSessions, 5);
    expect(r.outcome, ExperimentOutcome.insufficientData);
    expect(r.recommendation, ExperimentRecommendation.reviewRequired);
  });

  test(
    'unfinished assignment prevents a winner even with enough other wakes',
    () {
      final r = evaluator.evaluate(
        evidence: [
          ...balanced(3, latencyB: 5000),
          trial(4, validity: SessionValidity.partial, completed: false),
        ],
      );
      expect(r.recommendation, ExperimentRecommendation.collectMore);
      expect(r.outcome, ExperimentOutcome.insufficientData);
    },
  );

  test('a fully observed failure stays in the success denominator', () {
    final r = evaluator.evaluate(
      evidence: [
        trial(0, outcome: 'noResponse', latency: null),
        trial(1),
      ],
    );
    expect(r.control.validSessions, 2);
    expect(r.control.successRate, .5);
    expect(r.control.responseSamples, 1);
    expect(r.control.meanResponseMs, 20000);
  });

  test('missing latency cannot manufacture a faster response winner', () {
    final r = evaluator.evaluate(
      evidence: [
        for (var i = 0; i < 3; i++) ...[
          trial(i, latency: 60000),
          trial(i, candidate: true, latency: i == 0 ? null : 1000),
        ],
      ],
    );
    expect(r.candidate.successRate, 1);
    expect(r.candidate.responseSamples, 2);
    expect(r.outcome, ExperimentOutcome.noClearWinner);
  });

  test('success beats latency and a failure remains adverse evidence', () {
    final r = evaluator.evaluate(
      evidence: [
        for (var i = 0; i < 3; i++) ...[
          trial(i, latency: 60000),
          trial(
            i,
            candidate: true,
            latency: 1000,
            outcome: i == 0 ? 'noResponse' : 'wakeConfirmed',
          ),
        ],
      ],
    );
    expect(r.outcome, ExperimentOutcome.controlBetter);
    expect(r.candidate.validSessions, 3);
  });

  test(
    'faster latency cannot offset worse check, mission, or reactivation rate',
    () {
      for (final field in ['check', 'mission', 'reactivation']) {
        final r = evaluator.evaluate(
          evidence: [
            for (var i = 0; i < 3; i++) ...[
              trial(i, latency: 60000),
              trial(
                i,
                candidate: true,
                latency: 5000,
                checkFailures: field == 'check' && i == 0 ? 1 : 0,
                missionFailures: field == 'mission' && i == 0 ? 1 : 0,
                reactivations: field == 'reactivation' && i == 0 ? 1 : 0,
              ),
            ],
          ],
        );
        expect(
          r.outcome,
          isNot(ExperimentOutcome.candidateBetter),
          reason: field,
        );
      }
    },
  );

  test('response priority precedes snoozes when reliability is equal', () {
    final r = evaluator.evaluate(
      evidence: [
        for (var i = 0; i < 3; i++) ...[
          trial(i, latency: 40000),
          trial(i, candidate: true, latency: 10000, snoozes: 1),
        ],
      ],
    );
    expect(r.outcome, ExperimentOutcome.candidateBetter);
  });

  test('snoozes break a latency tie at the configured boundary', () {
    final r = evaluator.evaluate(
      evidence: [
        for (var i = 0; i < 4; i++) ...[
          trial(i, snoozes: i.isEven ? 1 : 0),
          trial(i, candidate: true),
        ],
      ],
    );
    expect(r.outcome, ExperimentOutcome.candidateBetter);
    expect(r.control.meanSnoozes, .5);
    expect(r.control.snoozedSessionRate, .5);
  });

  test(
    'candidate bypass or severe check failure stops before minimum samples',
    () {
      for (final row in [
        trial(0, candidate: true, outcome: 'bypassed'),
        trial(0, candidate: true, checkFailures: 2),
      ]) {
        final r = evaluator.evaluate(evidence: [row]);
        expect(r.recommendation, ExperimentRecommendation.stopCandidate);
        expect(r.outcome, ExperimentOutcome.insufficientData);
        expect(r.candidate.validSessions, 1);
      }
    },
  );

  test(
    'repeated no response means two consecutive wakes of the same variant',
    () {
      final r = evaluator.evaluate(
        evidence: [
          trial(0, candidate: true, outcome: 'noResponse', latency: null),
          trial(1),
          trial(2, candidate: true, outcome: 'noResponse', latency: null),
        ],
      );
      expect(r.recommendation, ExperimentRecommendation.stopCandidate);
      expect(r.candidate.successRate, 0);
      expect(r.candidate.responseSamples, 0);
    },
  );

  test('missing evidence cannot erase two observed no-response wakes', () {
    for (final validity in [SessionValidity.partial, SessionValidity.invalid]) {
      final r = evaluator.evaluate(
        evidence: [
          trial(0, candidate: true, outcome: 'noResponse', latency: null),
          trial(1, candidate: true, validity: validity, completed: false),
          trial(2, candidate: true, outcome: 'noResponse', latency: null),
        ],
      );
      expect(r.recommendation, ExperimentRecommendation.stopCandidate);
    }
  });

  test('a successful wake resets the no-response streak', () {
    final r = evaluator.evaluate(
      evidence: [
        trial(0, candidate: true, outcome: 'noResponse'),
        trial(1, candidate: true),
        trial(2, candidate: true, outcome: 'noResponse'),
      ],
    );
    expect(r.recommendation, ExperimentRecommendation.collectMore);
  });

  test(
    'serious control failure pauses the whole test, not a candidate promotion',
    () {
      final r = evaluator.evaluate(
        evidence: [
          trial(0, outcome: 'bypassed'),
          trial(0, candidate: true, outcome: 'bypassed'),
        ],
      );
      expect(r.recommendation, ExperimentRecommendation.pauseAll);
      expect(r.outcome, ExperimentOutcome.insufficientData);
    },
  );

  test(
    'duplicate assignments or wakes require review rather than extra samples',
    () {
      for (final rows in [
        [trial(0), trial(0)],
        [trial(0, wakeId: 'same'), trial(1, candidate: true, wakeId: 'same')],
      ]) {
        final r = evaluator.evaluate(evidence: rows);
        expect(r.outcome, ExperimentOutcome.invalidated);
        expect(r.recommendation, ExperimentRecommendation.reviewRequired);
      }
    },
  );

  test(
    'unknown, negative, unfinished, or enforced dismissal evidence is excluded',
    () {
      final rows = [
        trial(0, outcome: 'legacy'),
        trial(1, latency: -1),
        trial(2, completed: false),
        trial(3, outcome: 'dismissed', enforcement: true),
        trial(4, snoozes: -1),
      ];
      final r = evaluator.evaluate(evidence: rows);
      expect(r.control.validSessions, 0);
      expect(r.control.excludedSessions, 5);
      expect(r.control.successRate, isNull);
    },
  );

  test('ordinary dismissal counts without pretending a follow-up passed', () {
    final r = evaluator.evaluate(evidence: [trial(0, outcome: 'dismissed')]);
    expect(r.control.successfulWakes, 1);
    expect(r.control.confirmedAwakeSamples, 0);
    expect(r.control.medianConfirmedAwakeMs, isNull);
  });

  test('even response medians use both central observations', () {
    final r = evaluator.evaluate(
      evidence: [trial(0, latency: 5000), trial(1, latency: 20000)],
    );
    expect(r.control.medianResponseMs, 12500);
    expect(r.control.meanResponseMs, 12500);
  });

  test('invalid sample policy is rejected', () {
    for (final policy in [(2, 5, 10), (5, 3, 10), (3, 5, 4), (3, 5, 101)]) {
      expect(
        () => evaluator.evaluate(
          evidence: [],
          minimumSessions: policy.$1,
          preferredSessions: policy.$2,
          maximumSessions: policy.$3,
        ),
        throwsArgumentError,
      );
    }
  });
}
