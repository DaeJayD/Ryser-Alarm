import 'package:flutter/material.dart';
import 'package:ryser/app/theme/ryser_colors.dart';

/// Presentation only; mission screens retain their existing hold timing/handlers.
class EmergencyHoldSurface extends StatelessWidget {
  const EmergencyHoldSurface({super.key, required this.progress});
  final double progress;
  @override
  Widget build(BuildContext context) {
    final value = progress.clamp(0.0, 1.0);
    return Semantics(
      label: 'Emergency stop',
      hint: 'Hold continuously for eight seconds. Releasing early cancels.',
      child: Container(
        width: 280,
        height: 64,
        decoration: BoxDecoration(
          border: Border.all(
            color: RyserColors.critical.withValues(alpha: .65),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 64,
                  color: RyserColors.critical.withValues(alpha: .28),
                  backgroundColor: RyserColors.surfaceRaised,
                ),
              ),
              IgnorePointer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    value > 0
                        ? 'KEEP HOLDING · ${((1 - value) * 8).ceil()}s'
                        : 'HOLD TO STOP',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: RyserColors.critical,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      letterSpacing: .8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
