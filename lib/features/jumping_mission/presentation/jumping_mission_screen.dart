import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/features/jumping_mission/domain/jump_motion_detector.dart';
import 'package:sensors_plus/sensors_plus.dart';

class JumpingMissionScreen extends StatefulWidget {
  const JumpingMissionScreen({super.key, required this.requiredJumps});
  final int requiredJumps;
  @override
  State<JumpingMissionScreen> createState() => _JumpingMissionScreenState();
}

class _JumpingMissionScreenState extends State<JumpingMissionScreen> {
  StreamSubscription<AccelerometerEvent>? _sub;
  Timer? _timeout;
  Timer? _bypass;
  int _jumps = 0;
  final JumpMotionDetector _detector = JumpMotionDetector();
  double _progress = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _sub = accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
        .listen((event) {
          final now = DateTime.now();
          if (_detector.addReading(
            x: event.x,
            y: event.y,
            z: event.z,
            recordedAt: now,
          )) {
            setState(() => _jumps++);
            if (_jumps >= widget.requiredJumps) _finish('completed');
          }
        });
    _timeout = Timer(const Duration(minutes: 2), () => _finish('timedOut'));
  }

  void _finish(String result) {
    if (_finished || !mounted) return;
    _finished = true;
    Navigator.pop(context, result);
  }

  void _startBypass() {
    final started = DateTime.now();
    _bypass?.cancel();
    _bypass = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || _finished) return timer.cancel();
      final elapsed = DateTime.now().difference(started).inMilliseconds;
      setState(() => _progress = (elapsed / 8000).clamp(0, 1));
      if (elapsed >= 8000) _finish('bypassed');
    });
  }

  void _cancelBypass() {
    _bypass?.cancel();
    if (mounted && !_finished) setState(() => _progress = 0);
  }

  @override
  void dispose() {
    _sub?.cancel();
    _timeout?.cancel();
    _bypass?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Scaffold(
      appBar: AppBar(title: const Text('JUMP')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  '$_jumps / ${widget.requiredJumps}',
                  style: const TextStyle(
                    color: RyserColors.primary,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('JUMPS', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 20),
                const Text(
                  'Keep the phone secured while jumping.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: RyserColors.textSecondary),
                ),
                const SizedBox(height: 48),
                const Text(
                  'EMERGENCY STOP — HOLD 8 SECONDS',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPressStart: (_) => _startBypass(),
                  onLongPressEnd: (_) => _cancelBypass(),
                  onLongPressCancel: _cancelBypass,
                  child: SizedBox(
                    width: 280,
                    height: 56,
                    child: LinearProgressIndicator(
                      value: _progress,
                      minHeight: 56,
                      color: RyserColors.critical,
                      backgroundColor: RyserColors.surface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
