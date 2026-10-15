import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/app/theme/ryser_spacing.dart';
import 'package:ryser/core/platform/generated/alarm_runtime_api.g.dart';
import 'package:ryser/features/alarms/presentation/alarm_providers.dart';
import 'package:ryser/features/wake_enforcement/data/wake_mission_bridge.dart';
import 'package:permission_handler/permission_handler.dart';

class AlarmHealthScreen extends ConsumerStatefulWidget {
  const AlarmHealthScreen({super.key});

  @override
  ConsumerState<AlarmHealthScreen> createState() => _AlarmHealthScreenState();
}

class _AlarmHealthScreenState extends ConsumerState<AlarmHealthScreen>
    with WidgetsBindingObserver {
  late Future<_HealthSnapshot> _health;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) setState(_refresh);
  }

  void _refresh() {
    _health = _loadHealth();
  }

  Future<_HealthSnapshot> _loadHealth() async {
    final native = await ref.read(alarmRuntimeGatewayProvider).getAlarmHealth();
    final mission = await WakeMissionBridge().getMissionHealth();
    final database = ref.read(appDatabaseProvider);
    final configured = await database.select(database.missions).get();
    final alarms = await database.select(database.alarms).get();
    final protocols = await database.select(database.wakeProtocols).get();
    final policy = await database
        .select(database.alarmAdaptationSettings)
        .get();
    final repository = ref.read(wakeProtocolRepositoryProvider);
    final readyAlarmIds = <String>{};
    for (final row in protocols.where((p) => p.status == 'active')) {
      try {
        final protocol = await repository.findById(row.id);
        if (protocol != null && await repository.isValid(protocol)) {
          readyAlarmIds.add(row.alarmId);
        }
      } catch (_) { /* Show an actionable warning for unreadable protocols. */ }
    }
    final missing = alarms
        .where((item) => item.enabled && !readyAlarmIds.contains(item.id))
        .length;
    final adaptive = policy.where((item) => item.enabled).length;
    final qrReady = configured
        .where((item) => item.enabled && item.missionType == 'qr')
        .every((item) {
          final json =
              jsonDecode(item.configurationJson) as Map<String, dynamic>;
          return (json['payloadHash'] as String?)?.isNotEmpty == true &&
              (json['locationLabel'] as String?)?.isNotEmpty == true;
        });
    return _HealthSnapshot(native, mission, qrReady, missing, adaptive);
  }

  @override
  Widget build(BuildContext context) {
    final runtime = ref.read(alarmRuntimeGatewayProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALARM HEALTH'),
        actions: [
          IconButton(
            onPressed: () => setState(_refresh),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<_HealthSnapshot>(
        future: _health,
        builder: (context, snapshot) {
          final snapshotHealth = snapshot.data;
          if (snapshotHealth == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final health = snapshotHealth.native;
          final mission = snapshotHealth.mission;
          return ListView(
            padding: const EdgeInsets.all(RyserSpacing.md),
            children: [
              const Text(
                '> SYSTEM READINESS',
                style: TextStyle(
                  color: RyserColors.primary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: RyserSpacing.md),
              _HealthRow(
                'EXACT ALARMS',
                health.exactAlarmsReady,
                runtime.openExactAlarmSettings,
              ),
              _HealthRow(
                'NOTIFICATIONS',
                health.notificationsReady,
                runtime.openNotificationSettings,
              ),
              _HealthRow(
                'FULL-SCREEN ALARM',
                health.fullScreenReady,
                runtime.openFullScreenSettings,
              ),
              _HealthRow(
                'BATTERY ACCESS',
                health.batteryUnrestricted,
                runtime.openBatterySettings,
              ),
              _HealthRow(
                'ALARM VOLUME  ${health.alarmVolume}/${health.alarmVolumeMax}',
                health.alarmVolume > 0,
                runtime.openAlarmVolumeSettings,
              ),
              const SizedBox(height: RyserSpacing.md),
              const Text(
                '> MISSION READINESS',
                style: TextStyle(
                  color: RyserColors.primary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: RyserSpacing.sm),
              _HealthRow(
                'CAMERA HARDWARE',
                mission.cameraAvailable,
                openAppSettings,
              ),
              _HealthRow(
                'CAMERA ACCESS',
                mission.cameraPermission,
                openAppSettings,
              ),
              _HealthRow(
                'QR REGISTRATION',
                snapshotHealth.qrConfigured,
                openAppSettings,
              ),
              _HealthRow(
                'STEP SENSOR',
                mission.stepSensorAvailable,
                openAppSettings,
              ),
              _HealthRow(
                'ACTIVITY ACCESS',
                mission.activityPermission,
                openAppSettings,
              ),
              const SizedBox(height: RyserSpacing.md),
              const Text(
                '> ADAPTIVE WAKE',
                style: TextStyle(
                  color: RyserColors.primary,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: RyserSpacing.sm),
              _HealthRow(
                'ENABLED ALARMS WITHOUT A SOUND PROTOCOL: ${snapshotHealth.missingProtocols}',
                snapshotHealth.missingProtocols == 0,
                null,
              ),
              Text(
                'Adaptive Wake enabled on ${snapshotHealth.adaptiveAlarms} alarms. '
                'A protocol warning does not mean the native alarm is disabled; '
                'check its sound and resave the alarm.',
                style: const TextStyle(color: RyserColors.textSecondary),
              ),
              if (!health.batteryUnrestricted) ...[
                const SizedBox(height: RyserSpacing.lg),
                const Text(
                  'Battery restrictions may prevent Ryser from waking you reliably.',
                  style: TextStyle(color: RyserColors.critical, height: 1.5),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _HealthSnapshot {
  const _HealthSnapshot(
    this.native,
    this.mission,
    this.qrConfigured,
    this.missingProtocols,
    this.adaptiveAlarms,
  );

  final AlarmHealthDto native;
  final MissionHealth mission;
  final bool qrConfigured;
  final int missingProtocols;
  final int adaptiveAlarms;
}

class _HealthRow extends StatelessWidget {
  const _HealthRow(this.label, this.ready, this.onTap);

  final String label;
  final bool ready;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: RyserSpacing.sm),
        padding: const EdgeInsets.all(RyserSpacing.md),
        decoration: BoxDecoration(
          color: RyserColors.surface,
          border: Border.all(
            color: ready ? RyserColors.primaryDim : RyserColors.critical,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(letterSpacing: 1)),
            ),
            Text(
              ready ? 'READY' : 'ATTENTION',
              style: TextStyle(
                color: ready ? RyserColors.primary : RyserColors.critical,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
