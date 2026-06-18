import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/completed_tree.dart';
import '../models/tree.dart';
import '../services/supabase_service.dart';

/// Persistência das sessões concluídas (jardim pessoal).
///
/// Offline-first: sempre grava local (shared_preferences) — a sessão solo
/// funciona sem rede (princípio §QA). Quando há sessão Supabase, também
/// sincroniza `focus_sessions` + `streaks` na nuvem (best-effort).
class SessionRepository {
  static const _key = 'garden_trees_v1';

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

  // ── Nuvem (Supabase) ─────────────────────────────────────────────────────
  bool get _cloudReady => SupabaseService.instance.currentUserId != null;

  /// Carrega o jardim: nuvem se autenticado, senão local.
  Future<List<CompletedTree>> load() async {
    final userId = SupabaseService.instance.currentUserId;
    if (userId == null) return loadLocal();
    try {
      final rows = await SupabaseService.instance.client
          .from('focus_sessions')
          .select()
          .eq('user_id', userId)
          .eq('completed', true)
          .order('ended_at', ascending: false);
      return (rows as List).map((r) {
        final m = r as Map<String, dynamic>;
        return CompletedTree(
          type: TreeType.fromSlug((m['tree_type'] as String?) ?? 'oak'),
          durationMinutes: (m['duration_minutes'] as int?) ?? 0,
          completedAt: DateTime.parse(
              (m['ended_at'] ?? m['started_at']) as String),
        );
      }).toList();
    } catch (_) {
      return loadLocal();
    }
  }

  /// Registra uma árvore concluída: local + (se autenticado) nuvem + streak.
  Future<void> add(CompletedTree tree) async {
    await addLocal(tree);
    if (!_cloudReady) return;
    final userId = SupabaseService.instance.currentUserId!;
    final client = SupabaseService.instance.client;
    try {
      await client.from('focus_sessions').insert({
        'user_id': userId,
        'duration_minutes': tree.durationMinutes,
        'completed': true,
        'tree_type': tree.type.slug,
        'started_at': tree.completedAt
            .subtract(Duration(minutes: tree.durationMinutes))
            .toIso8601String(),
        'ended_at': tree.completedAt.toIso8601String(),
      });
      await _bumpStreak(userId, tree.completedAt);
    } catch (_) {/* offline — fica só local, sincroniza depois */}
  }

  Future<void> _bumpStreak(String userId, DateTime when) async {
    final client = SupabaseService.instance.client;
    final today = DateTime(when.year, when.month, when.day);
    final existing = await client
        .from('streaks')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    var current = 1;
    var longest = 1;
    if (existing != null) {
      final cur = (existing['current_streak'] as int?) ?? 0;
      final lng = (existing['longest_streak'] as int?) ?? 0;
      final lastStr = existing['last_session_date'] as String?;
      if (lastStr != null) {
        final last = DateTime.parse(lastStr);
        final diff =
            today.difference(DateTime(last.year, last.month, last.day)).inDays;
        current = switch (diff) {
          0 => cur == 0 ? 1 : cur, // mesma data
          1 => cur + 1, // dia seguinte
          _ => 1, // quebrou
        };
      }
      longest = current > lng ? current : lng;
    }

    await client.from('streaks').upsert({
      'user_id': userId,
      'current_streak': current,
      'longest_streak': longest,
      'last_session_date': today.toIso8601String().split('T').first,
    }, onConflict: 'user_id');
  }
}
