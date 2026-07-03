import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/grovely_mark.dart';

/// Splash animada da marca — emenda na splash nativa (mesmo verde #2E7D52 e a
/// mesma arte v6: bosque orgânico + sol). O bosque cresce, o wordmark
/// "Grovely" sobe, e a navegação segue quando a animação assenta. Honra
/// reduce-motion (sem movimento, espera curta).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Fundo idêntico ao da splash nativa (pubspec: flutter_native_splash.color).
  static const _brandGreen = Color(0xFF2E7D52);

  Timer? _timer;

  // A marca só monta (e anima) depois que a splash nativa sai de cena —
  // main() faz FlutterNativeSplash.preserve(); aqui a gente remove no
  // primeiro frame. Sem isso a animação corre por baixo da nativa.
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    // Rede de segurança: se a animação nunca "assentar" (edge case), segue em
    // frente mesmo assim. A navegação normal vem do onSettled da marca.
    _timer = Timer(const Duration(seconds: 8), _leave);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      if (mounted) setState(() => _revealed = true);
    });
  }

  void _leave() {
    if (mounted) context.go('/onboarding');
  }

  void _onSettled() {
    final reduced = GrovelyMotion.reduced(context);
    _timer?.cancel();
    // Segura o bosque completo na tela um instante antes de seguir.
    _timer = Timer(
      reduced
          ? const Duration(milliseconds: 600)
          : const Duration(milliseconds: 1100),
      _leave,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = GrovelyMotion.reduced(context);

    // Mesma arte da splash NATIVA (bosque v6 + sol), mas viva: o bosque
    // CRESCE (gv-grow do design system) — cada pinheiro brota da base, o sol
    // surge e o bosque balança de leve. Emenda sem "pulo" com o native.
    final Widget symbol = _revealed
        ? GrovelyMark(size: 200, animate: !reduced, onSettled: _onSettled)
        : const SizedBox(width: 200, height: 200);

    Widget wordmark = Text(
      'Grovely',
      style: GoogleFonts.bricolageGrotesque(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
    );

    if (!reduced) {
      // Wordmark sobe depois que o bosque já cresceu (gv-grow no símbolo).
      wordmark = wordmark
          .animate()
          .fadeIn(delay: 900.ms, duration: GrovelyMotion.slow)
          .moveY(
            begin: 12,
            end: 0,
            delay: 900.ms,
            duration: GrovelyMotion.slow,
          );
    }

    return Scaffold(
      backgroundColor: _brandGreen,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [symbol, const SizedBox(height: 12), wordmark],
        ),
      ),
    );
  }
}
