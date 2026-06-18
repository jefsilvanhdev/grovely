import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/completed_tree.dart';

/// Persistência das sessões concluídas (jardim pessoal).
///
/// Fase B: local (shared_preferences) — funciona offline, princípio §QA
/// "sessão solo funciona offline". A sincronização com Supabase
/// (`focus_sessions`, tabelas prontas) entra na camada social (Agente C).
class SessionRepository {
  static const _key = 'garden_trees_v1';

  Future<List<CompletedTree>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(CompletedTree.fromJson).toList();
  }

  Future<void> add(CompletedTree tree) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await load();
    final next = [tree, ...current];
    await prefs.setString(
      _key,
      jsonEncode(next.map((t) => t.toJson()).toList()),
    );
  }
}
