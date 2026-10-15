import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ryser/app/theme/ryser_colors.dart';
import 'package:ryser/features/qr_mission/domain/qr_payload.dart';
import 'package:ryser/features/missions/domain/hold_duration.dart';

class QrRegistration {
  const QrRegistration({
    required this.payloadHash,
    required this.locationLabel,
  });

  final String payloadHash;
  final String locationLabel;
}

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen.registration({super.key})
    : expectedHash = null,
      locationLabel = null,
      timeout = null;

  const QrScannerScreen.mission({
    super.key,
    required this.expectedHash,
    required this.locationLabel,
    this.timeout = const Duration(minutes: 2),
  });

  final String? expectedHash;
  final String? locationLabel;
  final Duration? timeout;

  bool get isRegistration => expectedHash == null;

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  static const _emergencyHold = HoldDuration(Duration(seconds: 8));
  final MobileScannerController _controller = MobileScannerController();
  Timer? _timeout;
  Timer? _bypassTimer;
  bool _handling = false;
  String? _message;
  double _bypassProgress = 0;

  @override
  void initState() {
    super.initState();
    final timeout = widget.timeout;
    if (timeout != null) {
      _timeout = Timer(timeout, () {
        if (mounted) Navigator.of(context).pop('timedOut');
      });
    }
  }

  @override
  void dispose() {
    _timeout?.cancel();
    _bypassTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handling) return;
    final value = capture.barcodes.firstOrNull?.rawValue;
    if (value == null || normalizeQrPayload(value).isEmpty) return;
    _handling = true;
    if (widget.isRegistration) {
      await _controller.stop();
      if (!mounted) return;
      final label = await _requestLabel();
      if (!mounted) return;
      if (label == null) {
        _handling = false;
        await _controller.start();
        return;
      }
      Navigator.of(context).pop(
        QrRegistration(payloadHash: hashQrPayload(value), locationLabel: label),
      );
      return;
    }
    final decision = evaluateQrMissionScan(
      scanned: value,
      expectedHash: widget.expectedHash!,
    );
    if (decision == QrMissionDecision.complete) {
      Navigator.of(context).pop('completed');
    } else if (decision == QrMissionDecision.reject) {
      setState(
        () => _message =
            'WRONG CODE — FIND ${widget.locationLabel?.toUpperCase()}',
      );
      _handling = false;
    }
  }

  Future<String?> _requestLabel() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('WAKE LOCATION'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 40,
          decoration: const InputDecoration(hintText: 'Bathroom mirror'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () {
              final label = controller.text.trim();
              if (label.isNotEmpty) Navigator.pop(context, label);
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  void _startBypass() {
    if (widget.isRegistration) return;
    _bypassTimer?.cancel();
    final started = DateTime.now();
    _bypassTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return timer.cancel();
      final elapsed = DateTime.now().difference(started);
      setState(() => _bypassProgress = _emergencyHold.progress(elapsed));
      if (_emergencyHold.isComplete(elapsed)) {
        timer.cancel();
        Navigator.of(context).pop('bypassed');
      }
    });
  }

  void _cancelBypass() {
    _bypassTimer?.cancel();
    if (mounted) setState(() => _bypassProgress = 0);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.isRegistration,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isRegistration ? 'REGISTER CODE' : 'SCAN TO WAKE'),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              errorBuilder: (context, error) => ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      _cameraErrorMessage(error),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: RyserColors.critical),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.black87,
                    child: Text(
                      widget.isRegistration
                          ? 'SCAN THE CODE AT YOUR WAKE LOCATION'
                          : 'FIND: ${widget.locationLabel?.toUpperCase()}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: RyserColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (_message != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: Colors.black87,
                      child: Text(
                        _message!,
                        style: const TextStyle(color: RyserColors.critical),
                      ),
                    ),
                  if (!widget.isRegistration)
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: GestureDetector(
                        onLongPressStart: (_) => _startBypass(),
                        onLongPressEnd: (_) => _cancelBypass(),
                        child: LinearProgressIndicator(
                          value: _bypassProgress,
                          minHeight: 56,
                          color: RyserColors.critical,
                          backgroundColor: RyserColors.surface,
                          semanticsLabel:
                              'Hold for eight seconds for emergency stop',
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _cameraErrorMessage(MobileScannerException error) {
    final code = error.errorCode.name.toLowerCase();
    if (code.contains('permission')) {
      return 'CAMERA ACCESS DENIED\n\nAllow camera access or use the emergency stop.';
    }
    if (code.contains('unsupported')) {
      return 'CAMERA NOT SUPPORTED\n\nUse the emergency stop.';
    }
    return 'CAMERA COULD NOT START\n\nTry again or use the emergency stop.';
  }
}
