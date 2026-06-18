import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/tree.dart';

/// Renderiza a árvore no estágio atual, com transição suave ao crescer.
class TreeView extends StatelessWidget {
  const TreeView({
    super.key,
    required this.type,
    required this.stage,
    this.size = 220,
  });

  final TreeType type;
  final TreeStage stage;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1).animate(animation),
            child: child,
          ),
        ),
        child: SvgPicture.asset(
          treeAsset(type, stage),
          key: ValueKey('${type.slug}-${stage.slug}'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
