import 'package:ryser/features/wake_experiments/data/experiment_restoration_ledger.dart';
import 'package:ryser/features/wake_experiments/data/experiment_scheduling_service.dart';

/// Native requests are idempotent. Failed acknowledgements leave work retryable.
class ExperimentRestorationService {
  ExperimentRestorationService(this._ledger, this._scheduling);
  final ExperimentRestorationLedger _ledger;
  final ExperimentSchedulingService _scheduling;
  Future<int>? _inFlight;

  Future<int> retryPending() =>
      _inFlight ??= _retry().whenComplete(() => _inFlight = null);

  Future<int> _retry() async {
    var restored = 0;
    for (final request in await _ledger.pending()) {
      try {
        final result = await _scheduling.restoreStable(request.alarmId);
        if (result == StableRestorationResult.deferred ||
            result == StableRestorationResult.rejected) {
          continue;
        }
        if (await _ledger.acknowledge(
          request,
          scheduled: result == StableRestorationResult.scheduled,
          skipReason: result == StableRestorationResult.scheduled
              ? null
              : result.name,
        )) {
          restored++;
        }
      } catch (_) {
        // Keep the durable request. Other alarms and the current wake stay usable.
      }
    }
    return restored;
  }
}
