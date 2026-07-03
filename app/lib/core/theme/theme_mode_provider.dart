import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controla o [ThemeMode] do app. Padrão: segue o sistema.
/// Escolha persiste em shared_preferences (QA M10 — antes evaporava no boot).
class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _pref = 'theme_mode';

  @override
  ThemeMode build() {
    // Restore assíncrono: primeiro frame segue o sistema, prefs resolve em ms.
    unawaited(
      SharedPreferences.getInstance().then((p) {
        final saved = p.getString(_pref);
        final mode = ThemeMode.values.asNameMap()[saved];
        if (mode != null && mode != state) state = mode;
      }),
    );
    return ThemeMode.system;
  }

  void set(ThemeMode mode) {
    state = mode;
    unawaited(
      SharedPreferences.getInstance().then(
        (p) => p.setString(_pref, mode.name),
      ),
    );
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
