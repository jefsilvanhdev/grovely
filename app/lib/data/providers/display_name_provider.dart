import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/supabase_service.dart';

/// Nome local do usuário (o mesmo que o círculo vê via `profiles`).
/// Sem auth real ainda, o dono também merece ver o próprio nome — "Guest"
/// pagante era dissonância (design review populado, P0-2). Null = sem nome
/// (UI mostra o fallback localizado).
class DisplayNameNotifier extends Notifier<String?> {
  static const _pref = 'display_name';

  @override
  String? build() {
    unawaited(
      SharedPreferences.getInstance().then((p) {
        final saved = p.getString(_pref);
        if (saved != null && saved.isNotEmpty && saved != state) state = saved;
      }),
    );
    return null;
  }

  Future<void> set(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    state = trimmed;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pref, trimmed);
    // Sobe pro profiles (é o display_name que o círculo consome) — best-effort.
    try {
      final uid = SupabaseService.instance.currentUserId;
      if (uid != null) {
        await SupabaseService.instance.client.from('profiles').upsert({
          'id': uid,
          'display_name': trimmed,
        }, onConflict: 'id');
      }
    } catch (_) {}
  }
}

final displayNameProvider = NotifierProvider<DisplayNameNotifier, String?>(
  DisplayNameNotifier.new,
);
