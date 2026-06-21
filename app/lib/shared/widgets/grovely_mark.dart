import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Marca do Grovely (3 pinheiros + sol) que **cresce** — replica a linguagem de
/// motion do design system (`gv-grow`: escala da base + fade; `gv-sway`: balanço
/// leve). Cada pinheiro brota da base em sequência (baixo → alto), o sol surge
/// por último, e o bosque balança de leve depois de assentar.
///
/// Geometria 1:1 com o símbolo da marca (viewBox 0 0 100 100, `gv-mark`).
/// Honra reduce-motion: pinta o estado final, sem movimento.
class GrovelyMark extends StatefulWidget {
  const GrovelyMark({
    super.key,
    this.size = 180,
    this.treeColor = Colors.white,
    this.sunColor = const Color(0xFFE0A458),
    this.animate = true,
  });

  final double size;
  final Color treeColor;
  final Color sunColor;

  /// Quando false, pinta o estado final estático (ex.: ícone fora de splash).
  final bool animate;

  @override
  State<GrovelyMark> createState() => _GrovelyMarkState();
}

class _GrovelyMarkState extends State<GrovelyMark>
    with TickerProviderStateMixin {
  late final AnimationController _grow;
  late final AnimationController _sway;

  // Crescimento por pinheiro (baixo → médio → alto = clímax no central).
  late final Animation<double> _left; // pinheiro baixo (esquerda)
  late final Animation<double> _right; // pinheiro médio (direita)
  late final Animation<double> _center; // pinheiro alto (centro)
  late final Animation<double> _sun;

  Animation<double> _stage(double begin, double end) => CurvedAnimation(
    parent: _grow,
    curve: Interval(begin, end, curve: Curves.easeOutBack),
  );

  @override
  void initState() {
    super.initState();
    _grow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _sway = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _left = _stage(0.00, 0.45);
    _right = _stage(0.18, 0.66);
    _center = _stage(0.36, 0.90);
    // Sol surge suave (sem overshoot) no fim.
    _sun = CurvedAnimation(
      parent: _grow,
      curve: const Interval(0.66, 1.0, curve: Curves.easeOut),
    );
  }

  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // MediaQuery (reduce-motion) só é acessível a partir daqui, não em initState.
    if (_started) return;
    _started = true;
    if (widget.animate && !GrovelyMotion.reduced(context)) {
      _grow.forward();
      // Balanço entra só depois do bosque assentar (gv-sway, baixa amplitude).
      _grow.addStatusListener(_onGrowDone);
    } else {
      _grow.value = 1; // estado final estático
    }
  }

  void _onGrowDone(AnimationStatus s) {
    if (s == AnimationStatus.completed && mounted) {
      _sway.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _grow.removeStatusListener(_onGrowDone);
    _grow.dispose();
    _sway.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_grow, _sway]),
        builder: (context, _) {
          // Balanço: ±1.2° suave em torno da base do bosque.
          final sway = widget.animate
              ? (math.sin(_sway.value * math.pi * 2) * 1.2) * math.pi / 180
              : 0.0;
          return CustomPaint(
            painter: _MarkPainter(
              left: _left.value.clamp(0.0, 1.2),
              right: _right.value.clamp(0.0, 1.2),
              center: _center.value.clamp(0.0, 1.2),
              sun: _sun.value.clamp(0.0, 1.0),
              sway: sway,
              treeColor: widget.treeColor,
              sunColor: widget.sunColor,
            ),
          );
        },
      ),
    );
  }
}

/// Um pinheiro: tronco (base do scale) + tiers (triângulos), coordenadas no
/// espaço 0..100 do símbolo.
class _Pine {
  const _Pine(this.trunk, this.tiers, this.base);
  final RRect trunk;
  final List<List<Offset>> tiers; // cada tier = [ápice, base-esq, base-dir]
  final Offset base; // ponto de ancoragem do crescimento (base do tronco)
}

final _pineLeft = _Pine(
  RRect.fromLTRBR(25, 62, 29, 80, const Radius.circular(2)),
  const [
    [Offset(27, 47), Offset(16, 64), Offset(38, 64)],
    [Offset(27, 39), Offset(19, 53), Offset(35, 53)],
  ],
  const Offset(27, 80),
);

final _pineCenter = _Pine(
  RRect.fromLTRBR(47.75, 62, 52.25, 80, const Radius.circular(2.25)),
  const [
    [Offset(50, 45), Offset(35, 65), Offset(65, 65)],
    [Offset(50, 36), Offset(39, 52), Offset(61, 52)],
    [Offset(50, 28), Offset(42, 42), Offset(58, 42)],
  ],
  const Offset(50, 80),
);

final _pineRight = _Pine(
  RRect.fromLTRBR(69.75, 62, 74.75, 80, const Radius.circular(2.5)),
  const [
    [Offset(72, 41), Offset(55, 65), Offset(89, 65)],
    [Offset(72, 31), Offset(60, 50), Offset(84, 50)],
    [Offset(72, 22), Offset(63, 38), Offset(81, 38)],
  ],
  const Offset(72.25, 80),
);

class _MarkPainter extends CustomPainter {
  _MarkPainter({
    required this.left,
    required this.right,
    required this.center,
    required this.sun,
    required this.sway,
    required this.treeColor,
    required this.sunColor,
  });

  final double left;
  final double right;
  final double center;
  final double sun;
  final double sway;
  final Color treeColor;
  final Color sunColor;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100.0;
    canvas.save();
    canvas.scale(s);

    // Balanço do bosque inteiro em torno do chão (y≈80).
    if (sway != 0) {
      canvas.translate(50, 80);
      canvas.rotate(sway);
      canvas.translate(-50, -80);
    }

    _paintPine(canvas, _pineLeft, left);
    _paintPine(canvas, _pineRight, right);
    _paintPine(canvas, _pineCenter, center);

    // Sol: surge escalando da própria posição + fade.
    if (sun > 0) {
      final sunPaint = Paint()..color = sunColor.withValues(alpha: sun);
      const c = Offset(87, 16);
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.scale(0.6 + 0.4 * sun);
      canvas.translate(-c.dx, -c.dy);
      canvas.drawCircle(c, 5.5, sunPaint);
      canvas.restore();
    }

    canvas.restore();
  }

  void _paintPine(Canvas canvas, _Pine pine, double grow) {
    if (grow <= 0) return;
    final paint = Paint()
      ..color = treeColor.withValues(alpha: grow.clamp(0, 1));
    canvas.save();
    // Cresce da base: escala em torno do pé do tronco.
    canvas.translate(pine.base.dx, pine.base.dy);
    canvas.scale(grow);
    canvas.translate(-pine.base.dx, -pine.base.dy);

    canvas.drawRRect(pine.trunk, paint);
    for (final t in pine.tiers) {
      final path = Path()
        ..moveTo(t[0].dx, t[0].dy)
        ..lineTo(t[1].dx, t[1].dy)
        ..lineTo(t[2].dx, t[2].dy)
        ..close();
      canvas.drawPath(path, paint);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.left != left ||
      old.right != right ||
      old.center != center ||
      old.sun != sun ||
      old.sway != sway ||
      old.treeColor != treeColor ||
      old.sunColor != sunColor;
}
