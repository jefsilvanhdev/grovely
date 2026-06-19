import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Tema do Grovely.
///
/// Tipografia: Bricolage Grotesque (display/timer/títulos) + Hanken Grotesque
/// (UI/corpo) — Google Fonts, licença livre. Tokens em [AppColors];
/// fonte da verdade em `plantio-coletivo-design/brand/brand-book.html`.
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scheme = isDark
        ? const ColorScheme.dark(
            primary: AppColors.primaryDark,
            onPrimary: AppColors.onPrimaryDark,
            primaryContainer: AppColors.primaryContainerDark,
            onPrimaryContainer: AppColors.onPrimaryContainerDark,
            secondary: AppColors.accentDark,
            onSecondary: AppColors.onAccent,
            surface: AppColors.surfaceDark,
            onSurface: AppColors.onSurfaceDark,
            surfaceContainerHighest: AppColors.surfaceVariantDark,
            onSurfaceVariant: AppColors.onSurfaceVariantDark,
            outline: AppColors.outlineDark,
          )
        : const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: AppColors.onPrimary,
            primaryContainer: AppColors.primaryContainer,
            onPrimaryContainer: AppColors.onPrimaryContainer,
            secondary: AppColors.accent,
            onSecondary: AppColors.onAccent,
            surface: AppColors.surface,
            onSurface: AppColors.onSurface,
            surfaceContainerHighest: AppColors.surfaceVariant,
            onSurfaceVariant: AppColors.onSurfaceVariant,
            outline: AppColors.outline,
          );

    final base = ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.background,
    );

    final body = GoogleFonts.hankenGroteskTextTheme(base.textTheme);
    final display = GoogleFonts.bricolageGrotesqueTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: body.copyWith(
        displayLarge: display.displayLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        displayMedium: display.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        displaySmall: display.displaySmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: display.headlineLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: display.headlineMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: display.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.bricolageGrotesque(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
    );
  }
}

/// Tokens de motion (brand/tokens.json → motion). Orgânico, calmo, nunca brusco.
class GrovelyMotion {
  GrovelyMotion._();

  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 360);
  static const Duration grand = Duration(milliseconds: 600);

  static const Curve standard = Curves.easeOutCubic;
  static const Curve decelerate = Curves.decelerate;
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  // Springs (mass/stiffness/damping) — crescimento, chegada e toque.
  static const SpringDescription tree = SpringDescription(
    mass: 1,
    stiffness: 180,
    damping: 16,
  );
  static const SpringDescription settle = SpringDescription(
    mass: 1,
    stiffness: 120,
    damping: 14,
  );
  static const SpringDescription press = SpringDescription(
    mass: 1,
    stiffness: 500,
    damping: 28,
  );

  /// True quando o sistema pede menos movimento (acessibilidade).
  static bool reduced(BuildContext c) => MediaQuery.of(c).disableAnimations;

  /// Duração efetiva: zera sob reduce-motion.
  static Duration dur(BuildContext c, Duration d) =>
      reduced(c) ? Duration.zero : d;
}

/// Escala de espaçamento — encerra os números soltos.
class GrovelySpacing {
  GrovelySpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;
}

/// Sombras suaves verde-acinzentadas por nível (claro). No escuro: usar borda.
class GrovelyElevation {
  GrovelyElevation._();
  static const List<BoxShadow> level1 = [
    BoxShadow(color: Color(0x0F2E7D52), blurRadius: 3, offset: Offset(0, 1)),
  ];
  static const List<BoxShadow> level2 = [
    BoxShadow(color: Color(0x1A2E7D52), blurRadius: 12, offset: Offset(0, 4)),
  ];
  static const List<BoxShadow> level3 = [
    BoxShadow(color: Color(0x242E7D52), blurRadius: 24, offset: Offset(0, 8)),
  ];
}
