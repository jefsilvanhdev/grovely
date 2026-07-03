import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Marca do Grovely v6 (bosque orgânico + sol) que **cresce** — replica a
/// linguagem de motion do design system (`gv-grow`: escala da base + fade;
/// `gv-sway`: balanço leve). O chão surge primeiro, cada árvore brota da base
/// em sequência (baixa → média → alta), o sol surge por último e o bosque
/// balança de leve depois de assentar.
///
/// Geometria 1:1 com o símbolo v6 (viewBox 0 0 100 100, `grovely-symbol-v6`).
/// Cores = variante da splash nativa (foreground no verde #2E7D52): árvore
/// central quase-branca, laterais mint, chão verde-escuro, sol âmbar.
/// Honra reduce-motion: pinta o estado final, sem movimento.
class GrovelyMark extends StatefulWidget {
  const GrovelyMark({
    super.key,
    this.size = 180,
    this.animate = true,
    this.onSettled,
  });

  final double size;

  /// Quando false, pinta o estado final estático (ex.: ícone fora de splash).
  final bool animate;

  /// Chamado quando o bosque termina de crescer (ou de imediato no modo
  /// estático). A splash usa isso para navegar sem cortar a animação — o
  /// relógio de parede mente no cold start (primeiro frame fica coberto
  /// pela splash nativa).
  final VoidCallback? onSettled;

  @override
  State<GrovelyMark> createState() => _GrovelyMarkState();
}

class _GrovelyMarkState extends State<GrovelyMark>
    with TickerProviderStateMixin {
  late final AnimationController _grow;
  late final AnimationController _sway;

  late final Animation<double> _ground;
  late final Animation<double> _left; // árvore baixa (esquerda)
  late final Animation<double> _right; // árvore média (direita)
  late final Animation<double> _center; // árvore alta (centro)
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
      duration: const Duration(milliseconds: 1300),
    );
    _sway = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    // Chão assenta primeiro (sem overshoot), árvores brotam por cima dele.
    _ground = CurvedAnimation(
      parent: _grow,
      curve: const Interval(0.0, 0.22, curve: Curves.easeOut),
    );
    _left = _stage(0.10, 0.50);
    _right = _stage(0.26, 0.68);
    _center = _stage(0.42, 0.92);
    // Sol surge suave (sem overshoot) no fim.
    _sun = CurvedAnimation(
      parent: _grow,
      curve: const Interval(0.70, 1.0, curve: Curves.easeOut),
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onSettled?.call();
      });
    }
  }

  void _onGrowDone(AnimationStatus s) {
    if (s == AnimationStatus.completed && mounted) {
      _sway.repeat(reverse: true);
      widget.onSettled?.call();
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
              ground: _ground.value.clamp(0.0, 1.0),
              left: _left.value.clamp(0.0, 1.2),
              right: _right.value.clamp(0.0, 1.2),
              center: _center.value.clamp(0.0, 1.2),
              sun: _sun.value.clamp(0.0, 1.0),
              sway: sway,
            ),
          );
        },
      ),
    );
  }
}

/// Uma árvore orgânica v6: copa em gota (quadráticas) + tronco, coordenadas no
/// espaço 0..100 do símbolo. Copa e tronco compartilham a mesma cor (variante
/// da splash — silhuetas chapadas, como no foreground nativo).
class _Tree {
  const _Tree({
    required this.canopy,
    required this.trunk,
    required this.base,
    required this.color,
  });

  final Path canopy;
  final RRect trunk;
  final Offset base; // pé do tronco: âncora do crescimento
  final Color color;
}

Path _teardrop(List<double> qs) {
  // qs = [x0,y0, cx1,cy1,x1,y1, cx2,cy2,x2,y2, ...] — moveTo + quadráticas.
  final p = Path()..moveTo(qs[0], qs[1]);
  for (var i = 2; i + 3 < qs.length; i += 4) {
    p.quadraticBezierTo(qs[i], qs[i + 1], qs[i + 2], qs[i + 3]);
  }
  return p..close();
}

// Cores da variante splash (amostradas do foreground nativo v6).
const _mint = Color(0xFF9FD3B4);
const _nearWhite = Color(0xFFF3F6F1);
const _groundGreen = Color(0xFF17402A);
const _amber = Color(0xFFE0A458);

final _treeLeft = _Tree(
  canopy: _teardrop(const [
    27, 36, //
    31.5, 43.5, 34.8, 53,
    38, 62.5, 39.5, 70.5,
    33.5, 74.8, 27, 74.8,
    20.5, 74.8, 14.5, 70.5,
    16, 62.5, 19.2, 53,
    22.5, 43.5, 27, 36,
  ]),
  trunk: RRect.fromLTRBR(25.5, 73.5, 28.5, 83, const Radius.circular(1.5)),
  base: const Offset(27, 83),
  color: _mint,
);

final _treeRight = _Tree(
  canopy: _teardrop(const [
    73, 29, //
    78, 38, 81.8, 48.5,
    85.5, 59, 87.2, 68.5,
    80.5, 73.3, 73, 73.3,
    65.5, 73.3, 58.8, 68.5,
    60.5, 59, 64.2, 48.5,
    68, 38, 73, 29,
  ]),
  trunk: RRect.fromLTRBR(71.3, 72, 74.7, 82.5, const Radius.circular(1.7)),
  base: const Offset(73, 82.5),
  color: _mint,
);

final _treeCenter = _Tree(
  canopy: _teardrop(const [
    50, 13, //
    56, 23, 60.5, 36,
    65, 49, 67, 62.5,
    58.8, 68, 50, 68,
    41.2, 68, 33, 62.5,
    35, 49, 39.5, 36,
    44, 23, 50, 13,
  ]),
  trunk: RRect.fromLTRBR(47.8, 66.5, 52.2, 80, const Radius.circular(2.2)),
  base: const Offset(50, 80),
  color: _nearWhite,
);

// Chão: monte suave sob o bosque (path do símbolo v6).
final _groundPath = _teardrop(const [
  13, 86.5, //
  50, 79.5, 87, 86.5,
  87, 90.5, 50, 90.5,
  13, 90.5, 13, 86.5,
]);

class _MarkPainter extends CustomPainter {
  _MarkPainter({
    required this.ground,
    required this.left,
    required this.right,
    required this.center,
    required this.sun,
    required this.sway,
  });

  final double ground;
  final double left;
  final double right;
  final double center;
  final double sun;
  final double sway;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100.0;
    canvas.save();
    canvas.scale(s);

    // Chão: espalha do centro (scale-x da própria linha) + fade.
    if (ground > 0) {
      final paint = Paint()..color = _groundGreen.withValues(alpha: ground);
      canvas.save();
      canvas.translate(50, 88.5);
      canvas.scale(0.5 + 0.5 * ground, 1);
      canvas.translate(-50, -88.5);
      canvas.drawPath(_groundPath, paint);
      canvas.restore();
    }

    // Balanço do bosque inteiro em torno do chão (y≈84).
    if (sway != 0) {
      canvas.translate(50, 84);
      canvas.rotate(sway);
      canvas.translate(-50, -84);
    }

    _paintTree(canvas, _treeLeft, left);
    _paintTree(canvas, _treeRight, right);
    _paintTree(canvas, _treeCenter, center);

    // Sol: surge escalando da própria posição + fade.
    if (sun > 0) {
      final sunPaint = Paint()..color = _amber.withValues(alpha: sun);
      const c = Offset(83, 15);
      canvas.save();
      canvas.translate(c.dx, c.dy);
      canvas.scale(0.6 + 0.4 * sun);
      canvas.translate(-c.dx, -c.dy);
      canvas.drawCircle(c, 7, sunPaint);
      canvas.restore();
    }

    canvas.restore();
  }

  void _paintTree(Canvas canvas, _Tree tree, double grow) {
    if (grow <= 0) return;
    final paint = Paint()..color = tree.color.withValues(alpha: grow.clamp(0, 1));
    canvas.save();
    // Cresce da base: escala em torno do pé do tronco.
    canvas.translate(tree.base.dx, tree.base.dy);
    canvas.scale(grow);
    canvas.translate(-tree.base.dx, -tree.base.dy);

    canvas.drawRRect(tree.trunk, paint);
    canvas.drawPath(tree.canopy, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.ground != ground ||
      old.left != left ||
      old.right != right ||
      old.center != center ||
      old.sun != sun ||
      old.sway != sway;
}
