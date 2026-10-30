# V4B.1: read-only wake comparison

Status: comparison foundation implemented; lifecycle integration, result audit,
automatic safety-stop execution, promotion and visible controls remain pending.
Experiments still default OFF. This is not a new release or device acceptance.

## What it does

`ExperimentEvaluator` compares the usual alarm choice with one new choice using
completed, provenance-checked wakes. `ExperimentComparisonService` reads saved
assignments, wakes, events, tasks and follow-up checks in one database transaction.
It never changes a schedule, marks a test finished, activates a protocol, writes
an audit event, or trains a model. No schema or platform-bridge change is needed.

The service checks the original alarm/occurrence, context, protocol identity,
complete executable snapshot, assignment-before-trigger, completion timestamp,
event ordering and unfinished tasks/checks. Invalid/partial samples still count
toward the attempt budget but cannot improve either choice's results. Failed but
fully observed wakes remain evidence. Cancelled/invalidated tests cannot choose
a winner. Repeated reads produce the same result from the same evidence.

## Policy version 1

These thresholds are deterministic product heuristics, not statistical tests:

- At least 3 complete valid wakes per choice; 3–4 is limited coverage and 5+
  is adequate under the default sample policy. Saved custom sample policies are
  honored. Coverage labels do not establish causality or statistical confidence.
- Compare successful-wake rate first, missed follow-up checks second, first
  response time third, then snoozes. Worse mission failures, reactivations,
  bypasses or success/check reliability block a latency-only advantage.
- A meaningful success/check-rate difference is at least 20 percentage points.
  A meaningful response improvement needs both at least 5 seconds and 20% of
  the other choice's median. A snooze improvement needs at least 0.5 per wake.
- A clear advantage can be reported at the minimum with limited coverage;
  otherwise continue toward the preferred/maximum count. At the attempt cap,
  report no clear winner, or request review if evidence remains incomplete.
- Use the smaller of the saved maximum and 10 attempts per choice. Partial or
  invalid attempts cannot lead to endless sampling. Any unfinished reservation
  prevents a comparative winner until its outcome is settled or reviewed.

Recommendations are intentionally separate from results. One candidate bypass,
two consecutive valid candidate no-response wakes, or at least two missed/failed
follow-up checks in one candidate wake recommends stopping the candidate. The
same serious failure in the usual choice recommends pausing the entire test.
An invalid or unfinished record does not clear an observed no-response streak;
only a subsequent usable responding wake does.
These safety stops do not label either choice a sampled winner. The current
service only reports the recommendation; it does not execute it.

## Honest metrics

Report attempted, valid, excluded and partial counts; successful-wake rate;
mean/median first response and its sample count; mean snoozes and snoozed-wake
rate; check/task failure, reactivation and bypass rates; configured intensity;
and time to confirmed awake only when recorded. No response is not zero latency.
Empty denominators are unavailable, not zero success. Missing response times
prevent a response-based winner. Raw task/check/event failures cannot be hidden
by a stale summary count. A snooze or reactivation is not another trial.

Observed maximum volume is not fabricated from configured volume. Lower-burden
tie-breaking and detailed observed escalation metrics remain later work. No
weighted reward or optional personalization is active.

## Verification and remaining work

Tests cover threshold boundaries, missing metrics, small/unequal samples, ties,
sample caps, valid failures, safety-stop priority, duplicate identities, negative
counters, old/unknown outcomes, snapshot mismatch, event ordering, pending checks,
and replay without database mutation. See [Testing](TESTING.md) for commands.

Local verification, 30 October 2026: all 186 Flutter tests passed, including
36 new evaluator/database tests; `dart analyze lib test` reports no issues and
`git diff --check` passes. The no-response/missing-evidence regression was first
observed failing, then passed after preserving the failure streak across missing
records. No new APK was built and no native instrumentation assertion ran.

Native validation remains separate: the 30 October 2026 isolated API 36.1 retry
booted but repeated the SurfaceFlinger `GoldfishMapper::readFromHost` assertion
and lost Android's package service before instrumentation could start. Disabling
the GL DMA/Vulkan paths did not resolve it. The owned emulator was stopped; no
application-test assertion ran and no phone was changed.

Next: transactional result/lifecycle audit, actual enforcement of safety-stop
recommendations with stable native rearming, then opt-in controls and the
remaining non-ML flow. Keep representative-device, audible locked-screen,
reboot/recovery and control/candidate execution acceptance open.
