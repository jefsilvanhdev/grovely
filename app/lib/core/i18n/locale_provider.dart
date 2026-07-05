import 'dart:async';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Idioma escolhido pelo usuário. `null` = segue o sistema (default).
/// Persiste em shared_preferences. Trocar aqui reconstrói o MaterialApp com o
/// novo `locale`, sem reiniciar o app.
class LocaleNotifier extends Notifier<Locale?> {
  static const _pref = 'app_locale';

  /// Idiomas oferecidos na troca manual (subconjunto de supportedLocales).
  static const supported = <Locale>[Locale('en'), Locale('pt'), Locale('es')];

  @override
  Locale? build() {
    unawaited(
      SharedPreferences.getInstance().then((p) {
        final code = p.getString(_pref);
        if (code != null && code.isNotEmpty) state = Locale(code);
      }),
    );
    return null;
  }

  /// `null` volta a seguir o sistema.
  Future<void> set(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_pref);
    } else {
      await prefs.setString(_pref, locale.languageCode);
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  LocaleNotifier.new,
);
