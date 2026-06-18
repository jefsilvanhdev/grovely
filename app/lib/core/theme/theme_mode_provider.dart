import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controla o [ThemeMode] do app. Padrão: segue o sistema.
///
/// Persistência (shared_preferences) entra quando o Agente A/perfil definir
/// o seletor de tema; por ora vive só em memória.
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);
