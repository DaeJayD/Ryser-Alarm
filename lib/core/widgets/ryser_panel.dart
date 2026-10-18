import 'package:flutter/material.dart';
import 'package:ryser/app/theme/ryser_colors.dart';

class RyserPanel extends StatelessWidget {
  const RyserPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.highlighted = false,
    this.accent,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool highlighted;
  final Color? accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        accent ?? (highlighted ? RyserColors.primaryDim : RyserColors.muted);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: highlighted
            ? [BoxShadow(color: color.withValues(alpha: .08), blurRadius: 18)]
            : null,
      ),
      child: Material(
        color: RyserColors.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: CustomPaint(
            foregroundPainter: _PanelFrame(color),
            child: Container(
              width: double.infinity,
              padding: padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: .045), Colors.transparent],
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelFrame extends CustomPainter {
  const _PanelFrame(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: .7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(18)),
      paint,
    );
    paint
      ..color = color
      ..strokeWidth = 1.2;
    const inset = 9.0, length = 7.0;
    for (final corner in [
      Offset(inset, inset),
      Offset(size.width - inset, inset),
      Offset(inset, size.height - inset),
      Offset(size.width - inset, size.height - inset),
    ]) {
      final dx = corner.dx < size.width / 2 ? length : -length;
      final dy = corner.dy < size.height / 2 ? length : -length;
      canvas.drawPath(
        Path()
          ..moveTo(corner.dx, corner.dy + dy)
          ..lineTo(corner.dx, corner.dy)
          ..lineTo(corner.dx + dx, corner.dy),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_PanelFrame oldDelegate) => oldDelegate.color != color;
}

class RyserBackdrop extends StatelessWidget {
  const RyserBackdrop({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: RyserColors.background,
    child: Stack(
      fit: StackFit.expand,
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(child: CustomPaint(painter: _Grid())),
          ),
        ),
        child,
      ],
    ),
  );
}

class _Grid extends CustomPainter {
  const _Grid();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = RyserColors.primary.withValues(alpha: .025)
      ..strokeWidth = .5;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_Grid oldDelegate) => false;
}

class RyserSectionTitle extends StatelessWidget {
  const RyserSectionTitle(this.title, {super.key, this.caption});
  final String title;
  final String? caption;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.6,
            color: RyserColors.primary,
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 6),
          Text(caption!, style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    ),
  );
}
