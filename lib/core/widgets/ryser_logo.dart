import 'package:flutter/material.dart';

/// The supplied Ryser artwork, kept whole rather than redrawn or cropped.
class RyserLogo extends StatelessWidget {
  const RyserLogo({super.key, this.size = 112});

  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/branding/ryser-logo.png',
    width: size,
    height: size,
    fit: BoxFit.contain,
    filterQuality: FilterQuality.medium,
    cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).ceil(),
    semanticLabel: 'Ryser',
  );
}
