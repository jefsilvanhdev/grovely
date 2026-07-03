import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/completed_tree.dart';
import '../models/tree.dart';
import '../services/supabase_service.dart';

/// Persistência das sessões concluídas (jardim pessoal).
///
/// Offline-first: sempre grava local (shared_preferences) — a sessão solo
/// funciona sem rede (princípio §QA). Quando há sessão Supabase, também
/// sincroniza `focus_sessions` + `streaks` na nuvem.
///
/// Árvores que não subiram (offline, falha) entram numa fila de pendências:
/// o próximo `load()` autenticado tenta reenviar e, enquanto isso, elas são
/// MESCLADAS ao resultado da nuvem — antes, sumiam do jardim ao reconectar
/// (QA I3: "o app apagou meu progresso").
class SessionRepository {
  static const _key = 'garden_trees_v1';
  static const _pendingKey = 'garden_trees_pending_v1';

  // ── Local ──────────────────────────────────────────────────────────────
  Future<List<CompletedTree>> loadLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(CompletedTree.fromJson).toList();
  }

  Future<void> addLocal(CompletedTree tree) async {
    final prefs = await SharedPreferences.getInstance();
    final next = [tree, ...await loadLocal()];
    await prefs.setString(
      _key,
      jsonEncode(next.map((t) => t.toJson()).toList()),
    );
  }

  // ── Fila de pendências (não sincronizadas) ───────────────────────────────
  Future<List<CompletedTree>> _loadPending() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_pendingKey);
    if (raw == null || raw.isEmpty) return [];
    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    return list.map(CompletedTree.fromJson).toList();
  }

  Future<void> _savePending(List<CompletedTree> trees) async {
    final prefs = await SharedPreferences.getInstance();
    if (trees.isEmpty) {
      await prefs.remove(_pendingKey);
    } else {
      await prefs.setString(
        _pendingKey,
        jsonEncode(trees.map((t) => t.toJson()).toList()),
      );
    }
  }

  Future<void> _addPending(CompletedTree tree) async =>
      _savePending([tree, ...await _loadPending()]);

  /// Reenvia pendências (uma a uma; as que falharem seguem na fila).
  Future<void> _flushPending() async {
    if (!_cloudReady) return;
    final pending = await _loadPending();
    if (pending.isEmpty) return;
    final remaining = <CompletedTree>[];
    for (final t in pending) {
      try {
        await _insertCloud(t);
      } catch (_) {
        remaining.add(t);
      }
    }
    await _savePending(remaining);
  }

  // ── Nuvem (Supabase) ─────────────────────────────────────────────────────
  bool get _cloudReady => SupabaseService.instance.currentUserId != null;

  Future<void> _insertCloud(CompletedTree tree) async {
    final userId = SupabaseService.instance.currentUserId!;
    await SupabaseService.instance.client.from('focus_sessions').insert({
      'user_id': userId,
      'duration_minutes': tree.durationMinutes,
      'completed': true,
      'tree_type': tree.type.slug,
      'started_at': tree.completedAt
          .subtract(Duration(minutes: tree.durationMinutes))
          .toIso8601String(),
      'ended_at': tree.completedAt.toIso8601String(),
    });
    // streaks são atualizados pelo trigger no servidor (migration 0002) —
    // atômico, sem race do cliente.
  }

  /// Carrega o jardim: nuvem (+ pendências mescladas) se autenticado, senão
  /// local. Antes de buscar, tenta subir a fila de pendências.
  Future<List<CompletedTree>> load() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return loadLocal();
    try {
      await _flushPending();
      final rows = await SupabaseService.instance.client
          .from('focus_sessions')
          .select()
          .eq('user_id', userId)
          .eq('completed', true)
          .order('ended_at', ascending: false);
      final cloud = (rows as List).map((r) {
        final m = r as Map<String, dynamic>;
        return CompletedTree(
          type: TreeType.fromSlug((m['tree_type'] as String?) ?? 'oak'),
          durationMinutes: (m['duration_minutes'] as int?) ?? 0,
          completedAt: DateTime.parse(
            (m['ended_at'] ?? m['started_at']) as String,
          ),
        );
      }).toList();

      // Pendências que ainda não subiram continuam visíveis no jardim.
      final pending = await _loadPending();
      if (pending.isEmpty) return cloud;
      String key(CompletedTree t) =>
          '${t.type.slug}·${t.durationMinutes}·'
          '${t.completedAt.millisecondsSinceEpoch ~/ 1000}';
      final seen = cloud.map(key).toSet();
      final merged = [...cloud, ...pending.where((t) => seen.add(key(t)))]
        ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
      return merged;
    } catch (_) {
      return loadLocal();
    }
  }

  /// Registra uma árvore concluída: local + (se autenticado) nuvem + streak.
  /// Falhou a subida (ou sem auth) → entra na fila de pendências.
  Future<void> add(CompletedTree tree) async {
    await addLocal(tree);
    if (!_cloudReady) {
      await _addPending(tree);
      return;
    }
    try {
      await _insertCloud(tree);
    } catch (_) {
      await _addPending(tree);
    }
  }
}
