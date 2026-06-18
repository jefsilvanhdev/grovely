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
      scaffoldBackgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.background,
    );

    final body = GoogleFonts.hankenGroteskTextTheme(base.textTheme);
    final display = GoogleFonts.bricolageGrotesqueTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: body.copyWith(
        displayLarge: display.displayLarge?.copyWith(fontWeight: FontWeight.w700),
        displayMedium: display.displayMedium?.copyWith(fontWeight: FontWeight.w700),
        displaySmall: display.displaySmall?.copyWith(fontWeight: FontWeight.w700),
        headlineLarge: display.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
        headlineMedium: display.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        headlineSmall: display.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
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
