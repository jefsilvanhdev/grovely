import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Logo do Grovely a partir do SVG da marca (brand/logo).
class GrovelyLogo extends StatelessWidget {
  const GrovelyLogo({super.key, this.height = 40, this.symbolOnly = false});

  final double height;
  final bool symbolOnly;

  @override
  Widget build(BuildContext context) {
    final asset = symbolOnly
        ? 'assets/brand/logo/grovely-symbol.svg'
        : 'assets/brand/logo/grovely-wordmark.svg';
    return SvgPicture.asset(asset, height: height, semanticsLabel: 'Grovely');
  }
}
