import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_theme.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/alarms/presentation/home_screen.dart';
import 'package:ryser/features/missions/domain/mission.dart';
import 'package:ryser/features/movement_mission/presentation/movement_mission_screen.dart';
import 'package:ryser/features/jumping_mission/presentation/jumping_mission_screen.dart';
import 'package:ryser/features/qr_mission/presentation/qr_scanner_screen.dart';
import 'package:ryser/features/wake_enforcement/data/wake_mission_bridge.dart';
import 'package:ryser/features/wake_check/domain/wake_retry_policy.dart';
import 'package:ryser/features/wake_check/domain/wake_check_protocol.dart';
import 'package:ryser/features/wake_check/domain/wake_check_configuration.dart';

class RyserApp extends ConsumerStatefulWidget {
  const RyserApp({super.key});

  @override
  ConsumerState<RyserApp> createState() => _RyserAppState();
}

class _RyserAppState extends ConsumerState<RyserApp>
    with WidgetsBindingObserver {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _wakeBridge = WakeMissionBridge();
  bool _handlingMission = false;
  bool _reconciling = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _reconcile());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _reconcile();
  }

  Future<void> _reconcile() async {
    if (_reconciling) return;
    _reconciling = true;
    try {
      try {
        await ref.read(runtimeEventReconcilerProvider).reconcile();
      } catch (_) {
        // Continue to the wake mission even if an outbox item is malformed.
      }
      try {
        await ref.read(adaptiveWakeCoordinatorProvider).processPending();
      } catch (_) {
        // Adaptation is optional; a failed evaluation must not block dismissal.
      }
      try {
        final handled = await _handlePendingMission();
        if (!handled) await _restorePersistedMission();
      } catch (_) {
        // The UI remains usable if mission restoration encounters corrupt data.
      }
    } finally {
      _reconciling = false;
    }
  }

  Future<bool> _handlePendingMission() async {
    if (_handlingMission) return true;
    final pending = await _wakeBridge.takePending();
    if (pending == null) return false;
    _handlingMission = true;
    try {
      final repository = ref.read(missionRepositoryProvider);
      final mission = await repository.findByAlarmId(pending.alarmId);
      if (mission == null || !mission.enabled) {
        await _wakeBridge.completeDismiss(pending);
        return true;
      }
      final configuration = await _configurationForSession(
        pending.sessionId,
        mission,
      );
      final service = ref.read(missionServiceProvider);
      await service.prepare(pending.sessionId);
      final executionId = await service.start(
        wakeSessionId: pending.sessionId,
        missionId: mission.id,
      );
      await _presentMission(pending, mission, configuration, executionId);
      return true;
    } finally {
      _handlingMission = false;
    }
  }

  Future<void> _restorePersistedMission() async {
    if (_handlingMission) return;
    final database = ref.read(appDatabaseProvider);
    final session =
        await (database.select(database.wakeSessions)
              ..where((row) => row.currentWakeFlowState.equals('missionActive'))
              ..orderBy([(row) => OrderingTerm.desc(row.triggeredAtMs)])
              ..limit(1))
            .getSingleOrNull();
    if (session == null) return;
    final execution =
        await (database.select(database.missionExecutions)
              ..where(
                (row) =>
                    row.wakeSessionId.equals(session.id) &
                    row.status.equals('active'),
              )
              ..limit(1))
            .getSingleOrNull();
    final mission = await ref
        .read(missionRepositoryProvider)
        .findByAlarmId(session.alarmId);
    if (execution == null || mission == null || !mission.enabled) return;
    _handlingMission = true;
    try {
      await _presentMission(
        PendingWakeMission(
          alarmId: session.alarmId,
          sessionId: session.id,
          scheduledAtMs: session.scheduledTimeMs,
          ringtoneUri: session.initialSoundId,
        ),
        mission,
        await _configurationForSession(session.id, mission),
        execution.id,
      );
    } finally {
      _handlingMission = false;
    }
  }

  Future<Map<String, dynamic>> _configurationForSession(
    String sessionId,
    Mission mission,
  ) async {
    final fallback =
        jsonDecode(mission.configurationJson) as Map<String, dynamic>;
    final database = ref.read(appDatabaseProvider);
    final session = await (database.select(
      database.wakeSessions,
    )..where((row) => row.id.equals(sessionId))).getSingleOrNull();
    final snapshot = session?.protocolSnapshotJson;
    if (snapshot == null) return fallback;
    try {
      final protocol = jsonDecode(snapshot) as Map<String, dynamic>;
      if (protocol['missionType'] != mission.type.name ||
          protocol['missionRequired'] != true) {
        return fallback;
      }
      final configuration = protocol['missionConfiguration'];
      if (configuration is Map<String, dynamic>) return configuration;
    } on FormatException {
      // Historical sessions may not contain a full V3 protocol snapshot.
    } on TypeError {
      // Retain the persisted mission configuration for an invalid snapshot.
    }
    return fallback;
  }

  Future<void> _presentMission(
    PendingWakeMission pending,
    Mission mission,
    Map<String, dynamic> configuration,
    String executionId,
  ) async {
    final service = ref.read(missionServiceProvider);
    final navigator = _navigatorKey.currentState;
    if (navigator == null) return;
    final result = await navigator.push<String>(
      MaterialPageRoute(
        builder: (_) => mission.type == MissionType.qr
            ? QrScannerScreen.mission(
                expectedHash: configuration['payloadHash']! as String,
                locationLabel: configuration['locationLabel']! as String,
              )
            : mission.type == MissionType.jumping
            ? JumpingMissionScreen(
                requiredJumps: configuration['requiredJumps']! as int,
              )
            : MovementMissionScreen(
                requiredSteps: configuration['requiredSteps']! as int,
              ),
      ),
    );
    if (result == 'completed') {
      await service.complete(executionId);
      final database = ref.read(appDatabaseProvider);
      final session = await (database.select(
        database.wakeSessions,
      )..where((row) => row.id.equals(pending.sessionId))).getSingle();
      final checkProtocol = WakeCheckProtocol.fromSnapshot(
        session.protocolSnapshotJson,
      );
      final retryPolicy = WakeRetryPolicy(
        maximumFailures: checkProtocol.maximumFailures,
      );
      if (!checkProtocol.required ||
          !retryPolicy.shouldScheduleAnotherCheck(
            session.wakeCheckFailureCount,
          )) {
        await service.completeAfterWakeRetryLimit(pending.sessionId);
        await _wakeBridge.completeDismiss(pending);
        return;
      }
      var delayMinutes = WakeCheckConfiguration.delayMinutesFrom(configuration);
      final snapshot = session.protocolSnapshotJson;
      if (snapshot != null) {
        try {
          final protocol = jsonDecode(snapshot) as Map<String, dynamic>;
          final delay = protocol['wakeCheckDelayMinutes'];
          if (protocol['wakeCheckRequired'] == true &&
              delay is int &&
              WakeCheckConfiguration.allowedDelayMinutes.contains(delay)) {
            delayMinutes = delay;
          }
        } on FormatException {
          // Older sessions continue with their saved mission configuration.
        } on TypeError {
          // Reject invalid protocol data without blocking dismissal.
        }
      }
      final wakeCheckAt = DateTime.now().add(Duration(minutes: delayMinutes));
      await ref
          .read(wakeCheckServiceProvider)
          .schedule(wakeSessionId: pending.sessionId, triggerAt: wakeCheckAt);
      await _wakeBridge.scheduleWakeCheck(
        pending,
        triggerAt: wakeCheckAt,
        protocolId: session.protocolId ?? '',
        protocolVersion: session.protocolVersion ?? 0,
        protocolSnapshotJson: session.protocolSnapshotJson ?? '{}',
      );
      await _wakeBridge.completeDismiss(pending);
    } else if (result == 'bypassed') {
      // Stop native audio first. Evidence persistence must never delay an
      // emergency stop or leave the foreground playback service running.
      await _wakeBridge.completeDismiss(pending);
      await service.bypass(executionId, reason: 'emergency_hold');
    } else {
      await service.timeOut(executionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Ryser',
      debugShowCheckedModeBanner: false,
      theme: RyserTheme.dark,
      home: const HomeScreen(),
    );
  }
}
