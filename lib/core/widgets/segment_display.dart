import 'package:flutter/material.dart';
import 'package:ryser/app/theme/ryser_colors.dart';

/// A scalable clock face without a downloaded font or raster asset.
class SegmentDisplay extends StatelessWidget {
  const SegmentDisplay(
    this.value, {
    super.key,
    required this.semanticLabel,
    this.height = 100,
  });
  final String value;
  final String semanticLabel;
  final double height;
  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    image: true,
    excludeSemantics: true,
    child: SizedBox(
      height: height,
      child: AspectRatio(
        aspectRatio: value
            .split('')
            .fold<double>(
              0,
              (width, char) => width + (char == ':' ? .28 : .66),
            ),
        child: RepaintBoundary(child: CustomPaint(painter: _Segments(value))),
      ),
    ),
  );
}

class _Segments extends CustomPainter {
  const _Segments(this.value);
  final String value;
  static const digits = [
    'abcdef',
    'bc',
    'abged',
    'abgcd',
    'fgbc',
    'afgcd',
    'afgecd',
    'abc',
    'abcdefg',
    'abfgcd',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final units = value
        .split('')
        .fold<double>(0, (w, c) => w + (c == ':' ? .28 : .66));
    final scale = size.width / units;
    canvas.save();
    canvas.scale(scale, size.height);
    double offset = 0;
    final paint = Paint()..color = RyserColors.primary;
    for (final char in value.split('')) {
      canvas.save();
      canvas.translate(offset, 0);
      if (char == ':') {
        for (final y in [.34, .69]) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(.08, y - .05, .09, .10),
              const Radius.circular(.04),
            ),
            paint,
          );
        }
        offset += .28;
      } else {
        final number = int.tryParse(char);
        if (number != null) {
          for (final segment in ['a', 'b', 'c', 'd', 'e', 'f', 'g']) {
            final active = digits[number].contains(segment);
            paint.color = active
                ? RyserColors.primary
                : RyserColors.primary.withValues(alpha: .035);
            final path = _path(segment);
            canvas.drawPath(path, paint);
          }
        }
        offset += .66;
      }
      canvas.restore();
    }
    canvas.restore();
  }

  Path _path(String segment) {
    const t = .10, left = .035, right = .565;
    if ('agd'.contains(segment)) {
      final y = segment == 'a'
          ? .015
          : segment == 'g'
          ? .45
          : .885;
      return Path()
        ..moveTo(left, y + t / 2)
        ..lineTo(left + t / 2, y)
        ..lineTo(right - t / 2, y)
        ..lineTo(right, y + t / 2)
        ..lineTo(right - t / 2, y + t)
        ..lineTo(left + t / 2, y + t)
        ..close();
    }
    final x = (segment == 'f' || segment == 'e') ? .015 : .49;
    final y = (segment == 'f' || segment == 'b') ? .075 : .51;
    return Path()
      ..moveTo(x, y + .04)
      ..lineTo(x + .05, y)
      ..lineTo(x + t, y + .04)
      ..lineTo(x + t, y + .35)
      ..lineTo(x + .05, y + .40)
      ..lineTo(x, y + .35)
      ..close();
  }

  @override
  bool shouldRepaint(_Segments oldDelegate) => oldDelegate.value != value;
}
