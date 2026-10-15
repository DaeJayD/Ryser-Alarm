import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/core/platform/alarm_runtime_gateway.dart';
import 'package:ryser/database/app_database.dart';
import 'package:ryser/features/alarms/data/drift_alarm_repository.dart';
import 'package:ryser/features/alarms/domain/alarm.dart' as domain;
import 'package:ryser/features/alarms/domain/alarm_repository.dart';
import 'package:ryser/features/adaptive_wake/data/wake_protocol_repository.dart';
import 'package:ryser/features/adaptive_wake/data/adaptive_wake_coordinator.dart';
import 'package:ryser/features/missions/data/drift_mission_repository.dart';
import 'package:ryser/features/missions/data/mission_service.dart';
import 'package:ryser/features/missions/domain/mission_repository.dart';
import 'package:ryser/features/wake_sessions/data/runtime_event_reconciler.dart';
import 'package:ryser/features/wake_check/data/wake_check_service.dart';
import 'package:ryser/features/settings/data/app_defaults_repository.dart';
import 'package:ryser/features/sounds/data/sound_performance_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final alarmRuntimeGatewayProvider = Provider<AlarmRuntimeGateway>((ref) {
  return AlarmRuntimeGateway();
});

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return DriftAlarmRepository(ref.watch(appDatabaseProvider));
});

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return DriftMissionRepository(ref.watch(appDatabaseProvider));
});

final missionServiceProvider = Provider<MissionService>((ref) {
  return MissionService(ref.watch(appDatabaseProvider));
});

final wakeCheckServiceProvider = Provider<WakeCheckService>((ref) {
  return WakeCheckService(ref.watch(appDatabaseProvider));
});

final wakeProtocolRepositoryProvider = Provider<WakeProtocolRepository>((ref) {
  final runtime = ref.watch(alarmRuntimeGatewayProvider);
  return WakeProtocolRepository(
    ref.watch(appDatabaseProvider),
    soundAvailable: runtime.isSoundAvailable,
    vibrationAvailable: runtime.canVibrate,
    missionAvailable: runtime.isMissionAvailable,
  );
});

final adaptiveWakeCoordinatorProvider = Provider<AdaptiveWakeCoordinator>((
  ref,
) {
  return AdaptiveWakeCoordinator(
    ref.watch(appDatabaseProvider),
    ref.watch(wakeProtocolRepositoryProvider),
    ref.watch(alarmRuntimeGatewayProvider),
  );
});

final alarmsProvider = StreamProvider<List<domain.Alarm>>((ref) {
  return ref.watch(alarmRepositoryProvider).watchAll();
});

final runtimeEventReconcilerProvider = Provider<RuntimeEventReconciler>((ref) {
  return RuntimeEventReconciler(
    ref.watch(appDatabaseProvider),
    ref.watch(alarmRuntimeGatewayProvider),
  );
});

final wakeSessionsProvider = StreamProvider<List<WakeSession>>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return (database.select(
    database.wakeSessions,
  )..orderBy([(row) => OrderingTerm.desc(row.triggeredAtMs)])).watch();
});

final appDefaultsRepositoryProvider = Provider<AppDefaultsRepository>((ref) {
  return AppDefaultsRepository(ref.watch(appDatabaseProvider));
});

final appDefaultsProvider = FutureProvider<AppDefaults>((ref) {
  return ref.watch(appDefaultsRepositoryProvider).load();
});

final soundPerformanceRepositoryProvider = Provider<SoundPerformanceRepository>(
  (ref) => SoundPerformanceRepository(ref.watch(appDatabaseProvider)),
);

final soundPerformanceProvider = FutureProvider<List<SoundPerformance>>((ref) {
  return ref.watch(soundPerformanceRepositoryProvider).load();
});
