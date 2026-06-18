import 'package:flutter/material.dart';

/// Tokens de cor do Grovely — gerados pelo design (brand/tokens.json).
///
/// Fonte da verdade: `plantio-coletivo-design/brand/brand-book.html`.
class AppColors {
  AppColors._();

  // ── Claro ──────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF2E7D52);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFC8E6CF);
  static const Color onPrimaryContainer = Color(0xFF14361F);
  static const Color accent = Color(0xFFE0A458);
  static const Color onAccent = Color(0xFF2A1C08);
  static const Color background = Color(0xFFF3F6F1);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE7EEE7);
  static const Color onSurface = Color(0xFF18241D);
  static const Color onSurfaceVariant = Color(0xFF4A5A50);
  static const Color outline = Color(0xFFC2D0C5);
  static const Color treeHealthy = Color(0xFF43A86B);
  static const Color treeWithered = Color(0xFFA89274);

  // ── Escuro ─────────────────────────────────────────────────────────────
  static const Color primaryDark = Color(0xFF6FD79B);
  static const Color onPrimaryDark = Color(0xFF07120C);
  static const Color primaryContainerDark = Color(0xFF1E5238);
  static const Color onPrimaryContainerDark = Color(0xFFC8E6CF);
  static const Color accentDark = Color(0xFFF0B978);
  static const Color backgroundDark = Color(0xFF0F1A15);
  static const Color surfaceDark = Color(0xFF16221C);
  static const Color surfaceVariantDark = Color(0xFF213029);
  static const Color onSurfaceDark = Color(0xFFE7F0E9);
  static const Color onSurfaceVariantDark = Color(0xFFA7B8AD);
  static const Color outlineDark = Color(0xFF3A4D42);
  static const Color treeHealthyDark = Color(0xFF5FD394);
  static const Color treeWitheredDark = Color(0xFFB9A488);

  static const Color seed = primary;
}

/// Border-radius tokens (brand/tokens.json).
class AppRadius {
  AppRadius._();
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double pill = 999;
}
