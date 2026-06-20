import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/tree.dart';

/// Renderiza a árvore no estágio atual, com transição suave ao crescer.
///
/// [scale] permite ligar o tamanho ao progresso da sessão (a árvore cresce
/// enquanto você foca). Honra reduce-motion.
class TreeView extends StatelessWidget {
  const TreeView({
    super.key,
    required this.type,
    required this.stage,
    this.size = 220,
    this.scale = 1.0,
    this.heroTag,
  });

  final TreeType type;
  final TreeStage stage;
  final double size;
  final double scale;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final reduced = GrovelyMotion.reduced(context);
    // width/height explícitos: AnimatedSwitcher usa um Stack com constraints
    // loose, então sem dimensão o SVG colapsaria pro tamanho intrínseco
    // (viewBox ~100x120) e ficaria minúsculo. Fixar em [size] garante que
    // ele preencha de fato a área pedida.
    Widget tree = SvgPicture.asset(
      treeAsset(type, stage),
      key: ValueKey('${type.slug}-${stage.slug}'),
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
    if (heroTag != null) tree = Hero(tag: heroTag!, child: tree);

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedScale(
        scale: scale,
        duration: GrovelyMotion.dur(context, GrovelyMotion.base),
        curve: GrovelyMotion.standard,
        child: AnimatedSwitcher(
          duration: GrovelyMotion.dur(context, GrovelyMotion.grand),
          switchInCurve: Curves.easeOutBack,
          transitionBuilder: (child, animation) => reduced
              ? FadeTransition(opacity: animation, child: child)
              : FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.85,
                      end: 1,
                    ).animate(animation),
                    child: child,
                  ),
                ),
          child: tree,
        ),
      ),
    );
  }
}
