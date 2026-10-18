import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';

final dashboardHealthProvider = FutureProvider<AlarmHealthDto>(
  (ref) => ref.watch(alarmRuntimeGatewayProvider).getAlarmHealth(),
);

final dashboardMissionProvider = StreamProvider.family<Mission?, String>((
  ref,
  id,
) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(
    db.missions,
  )..where((m) => m.alarmId.equals(id))).watchSingleOrNull();
});

final dashboardProtocolProvider = StreamProvider.family<WakeProtocol?, String>((
  ref,
  id,
) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.wakeProtocols)
        ..where((p) => p.alarmId.equals(id) & p.status.equals('active'))
        ..orderBy([(p) => OrderingTerm.desc(p.version)])
        ..limit(1))
      .watchSingleOrNull();
});
