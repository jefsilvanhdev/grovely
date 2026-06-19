import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Explosão de folhas (momento de colher: completed, meta do círculo, recap).
/// One-shot ao montar. Honra reduce-motion (não renderiza nada).
class LeafConfetti extends StatefulWidget {
  const LeafConfetti({super.key, this.count = 16});
  final int count;

  @override
  State<LeafConfetti> createState() => _LeafConfettiState();
}

class _LeafConfettiState extends State<LeafConfetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final List<_Leaf> _leaves;

  @override
  void initState() {
    super.initState();
    final r = Random();
    const colors = [AppColors.primary, AppColors.treeHealthy, AppColors.accent];
    _leaves = List.generate(widget.count, (_) {
      final angle =
          -pi / 2 + (r.nextDouble() - 0.5) * pi; // pra cima, espalhando
      return _Leaf(
        angle: angle,
        distance: 80 + r.nextDouble() * 140,
        rotation: (r.nextDouble() - 0.5) * 6,
        size: 8 + r.nextDouble() * 8,
        color: colors[r.nextInt(colors.length)],
        delay: r.nextDouble() * 0.2,
      );
    });
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (GrovelyMotion.reduced(context)) return const SizedBox.shrink();
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, _) => CustomPaint(
          painter: _ConfettiPainter(_leaves, _c.value),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _Leaf {
  _Leaf({
    required this.angle,
    required this.distance,
    required this.rotation,
    required this.size,
    required this.color,
    required this.delay,
  });
  final double angle, distance, rotation, size, delay;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.leaves, this.t);
  final List<_Leaf> leaves;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.42);
    for (final l in leaves) {
      final p = ((t - l.delay) / (1 - l.delay)).clamp(0.0, 1.0);
      if (p <= 0) continue;
      final eased = Curves.easeOut.transform(p);
      final gravity = p * p * 60; // cai no fim
      final pos =
          center +
          Offset(cos(l.angle), sin(l.angle)) * l.distance * eased +
          Offset(0, gravity);
      final opacity = (1 - p).clamp(0.0, 1.0);
      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(l.rotation * eased);
      final paint = Paint()..color = l.color.withValues(alpha: opacity);
      // folha = teardrop simples
      final path = Path()
        ..moveTo(0, -l.size)
        ..quadraticBezierTo(l.size * 0.7, -l.size * 0.2, 0, l.size)
        ..quadraticBezierTo(-l.size * 0.7, -l.size * 0.2, 0, -l.size)
        ..close();
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t;
}
