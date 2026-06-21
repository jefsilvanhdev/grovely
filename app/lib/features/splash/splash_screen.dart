import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/grovely_logo.dart';

/// Splash animada da marca — emenda na splash nativa (mesmo verde #2E7D52),
/// o símbolo "nasce" num disco claro (sol/bosque) e o wordmark sobe.
/// Depois encaminha pro app. Honra reduce-motion (sem movimento, espera curta).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Fundo idêntico ao da splash nativa (pubspec: flutter_native_splash.color).
  static const _brandGreen = Color(0xFF2E7D52);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Agenda a transição pós-primeiro frame para ter acesso ao MediaQuery
    // (reduce-motion encurta a espera, sem deixar a tela travada).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final reduced = GrovelyMotion.reduced(context);
      _timer = Timer(
        reduced ? const Duration(milliseconds: 600) : const Duration(milliseconds: 1700),
        () {
          if (mounted) context.go('/onboarding');
        },
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduced = GrovelyMotion.reduced(context);

    Widget disc = Container(
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        color: Color(0xFFF6F4EC), // creme da marca — contraste pro símbolo
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const GrovelyLogo(symbolOnly: true, height: 84),
    );

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
      disc = disc
          .animate()
          .scale(
            begin: const Offset(0.7, 0.7),
            end: const Offset(1, 1),
            duration: GrovelyMotion.grand,
            curve: GrovelyMotion.decelerate,
          )
          .fadeIn(duration: GrovelyMotion.slow);
      wordmark = wordmark
          .animate()
          .fadeIn(delay: 320.ms, duration: GrovelyMotion.slow)
          .moveY(begin: 12, end: 0, delay: 320.ms, duration: GrovelyMotion.slow);
    }

    return Scaffold(
      backgroundColor: _brandGreen,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [disc, const SizedBox(height: 28), wordmark],
        ),
      ),
    );
  }
}
