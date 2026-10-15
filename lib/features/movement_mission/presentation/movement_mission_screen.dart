import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/features/movement_mission/domain/movement_progress.dart';
import 'package:ryser/features/movement_mission/domain/step_motion_detector.dart';
import 'package:ryser/features/missions/domain/hold_duration.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MovementMissionScreen extends StatefulWidget {
  const MovementMissionScreen({super.key, required this.requiredSteps});
  final int requiredSteps;
  @override
  State<MovementMissionScreen> createState() => _MovementMissionScreenState();
}

class _MovementMissionScreenState extends State<MovementMissionScreen> {
  StreamSubscription<StepCount>? _stepSub;
  StreamSubscription<AccelerometerEvent>? _motionSub;
  StreamSubscription<Position>? _locationSub;
  Timer? _timeout;
  Timer? _bypassTimer;
  Timer? _sensorWatchdog;
  int _steps = 0;
  late final MovementProgress _movement = MovementProgress(
    requiredSteps: widget.requiredSteps,
  );
  final StepMotionDetector _motionDetector = StepMotionDetector();
  static const _emergencyHold = HoldDuration(Duration(seconds: 8));
  Position? _lastPosition;
  String _source = 'STARTING SENSORS';
  String? _error;
  double _bypassProgress = 0;
  bool _finished = false;
  bool _receivedStepReading = false;
  bool _receivedMotionReading = false;
  bool _receivedLocationReading = false;

  @override
  void initState() {
    super.initState();
    _start();
    _timeout = Timer(const Duration(minutes: 2), () => _finish('timedOut'));
  }

  Future<void> _start() async {
    _motionSub =
        accelerometerEventStream(samplingPeriod: SensorInterval.gameInterval)
            .listen((event) {
              _receivedMotionReading = true;
              if (_motionDetector.addReading(
                x: event.x,
                y: event.y,
                z: event.z,
                recordedAt: DateTime.now(),
              )) {
                _setProgress(_movement.addMotionStep(), 'WALKING MOTION');
              }
            }, onError: (_) {});
    final activity = await Permission.activityRecognition.request();
    if (activity.isGranted) {
      _stepSub = Pedometer.stepCountStream.listen((event) {
        _receivedStepReading = true;
        _setProgress(
          _movement.addStepCounterReading(event.steps),
          'STEP SENSOR',
        );
      }, onError: (_) => _startLocationFallback());
    }
    await _startLocationFallback();
    _sensorWatchdog = Timer(const Duration(seconds: 10), () {
      if (mounted &&
          !_receivedStepReading &&
          !_receivedMotionReading &&
          !_receivedLocationReading) {
        setState(() {
          _error = 'NO MOVEMENT DATA — CHECK LOCATION AND ACTIVITY ACCESS';
        });
      }
    });
  }

  Future<void> _startLocationFallback() async {
    if (_locationSub != null) return;
    final permission = await Permission.locationWhenInUse.request();
    if (!permission.isGranted) {
      if (_stepSub == null && mounted) {
        setState(() => _error = 'ALLOW ACTIVITY OR LOCATION ACCESS');
      }
      return;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (_stepSub == null && mounted) {
        setState(() => _error = 'TURN ON LOCATION');
      }
      return;
    }
    _locationSub =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 1,
          ),
        ).listen(
          _onPosition,
          onError: (_) {
            if (_stepSub == null && mounted) {
              setState(() => _error = 'MOVEMENT SENSOR UNAVAILABLE');
            }
          },
        );
  }

  void _onPosition(Position current) {
    if (current.accuracy > 30) return;
    _receivedLocationReading = true;
    final previous = _lastPosition;
    _lastPosition = current;
    if (previous == null) return;
    final metres = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      current.latitude,
      current.longitude,
    );
    if (metres < 0.4 || metres > 20) return;
    _setProgress(
      _movement.addLocationDistance(metres, accuracyMetres: current.accuracy),
      'LOCATION',
    );
  }

  void _setProgress(int value, String source) {
    if (!mounted || _finished || value <= _steps) return;
    setState(() {
      _steps = value.clamp(0, widget.requiredSteps);
      _source = source;
      _error = null;
    });
    if (value >= widget.requiredSteps) _finish('completed');
  }

  void _finish(String result) {
    if (_finished || !mounted) return;
    _finished = true;
    _timeout?.cancel();
    _bypassTimer?.cancel();
    _sensorWatchdog?.cancel();
    Navigator.of(context).pop(result);
  }

  void _startBypass() {
    if (_finished) return;
    final started = DateTime.now();
    _bypassTimer?.cancel();
    _bypassTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || _finished) return timer.cancel();
      final elapsed = DateTime.now().difference(started).inMilliseconds;
      final duration = Duration(milliseconds: elapsed);
      setState(() => _bypassProgress = _emergencyHold.progress(duration));
      if (_emergencyHold.isComplete(duration)) _finish('bypassed');
    });
  }

  void _cancelBypass() {
    if (_finished) return;
    _bypassTimer?.cancel();
    if (mounted) setState(() => _bypassProgress = 0);
  }

  @override
  void dispose() {
    _timeout?.cancel();
    _bypassTimer?.cancel();
    _sensorWatchdog?.cancel();
    _stepSub?.cancel();
    _motionSub?.cancel();
    _locationSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Scaffold(
      appBar: AppBar(title: const Text('WALK')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 48).clamp(
                  0,
                  double.infinity,
                ),
                minWidth: constraints.maxWidth - 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$_steps / ${widget.requiredSteps}',
                    style: const TextStyle(
                      color: RyserColors.primary,
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('STEPS', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 16),
                  Text(
                    _error ?? 'TRACKING: $_source',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _error == null
                          ? RyserColors.textSecondary
                          : RyserColors.critical,
                    ),
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
                        value: _bypassProgress,
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
    ),
  );
}
