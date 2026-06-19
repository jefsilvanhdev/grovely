import 'dart:math';

import '../models/circle.dart';
import '../services/supabase_service.dart';

/// Erros de negócio do círculo (mapeados das exceptions do Postgres).
enum CircleError { notFound, full, offline, unknown }

class CircleException implements Exception {
  CircleException(this.kind);
  final CircleError kind;
}

/// CRUD de círculos via Supabase. Join e stats de membros usam funções RPC
/// (migration 0003) por causa do RLS. Requer auth (anônimo serve).
class CircleRepository {
  String? get _uid => SupabaseService.instance.currentUserId;
  bool get _ready => _uid != null && SupabaseService.instance.isInitialized;

  String _genCode() {
    const chars = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
    final r = Random();
    return List.generate(6, (_) => chars[r.nextInt(chars.length)]).join();
  }

  /// Círculo atual do usuário (MVP: um por usuário). Null se nenhum.
  Future<Circle?> myCircle() async {
    if (!_ready) return null;
    final rows = await SupabaseService.instance.client
        .from('circle_members')
        .select('circles(*)')
        .eq('user_id', _uid!);
    if (rows.isEmpty) return null;
    final c = rows.first['circles'] as Map<String, dynamic>?;
    return c == null ? null : Circle.fromJson(c);
  }

  Future<Circle> create(String name) async {
    final client = SupabaseService.instance.client;
    final row = await client
        .from('circles')
        .insert({'name': name, 'invite_code': _genCode(), 'created_by': _uid})
        .select()
        .single();
    await client.from('circle_members').insert({
      'circle_id': row['id'],
      'user_id': _uid,
    });
    return Circle.fromJson(row);
  }

  Future<Circle> joinByCode(String code) async {
    try {
      final id =
          await SupabaseService.instance.client.rpc(
                'join_circle_by_code',
                params: {'p_code': code},
              )
              as String;
      final row = await SupabaseService.instance.client
          .from('circles')
          .select()
          .eq('id', id)
          .single();
      return Circle.fromJson(row);
    } on Object catch (e) {
      final msg = e.toString();
      if (msg.contains('circle_not_found')) {
        throw CircleException(CircleError.notFound);
      }
      if (msg.contains('circle_full')) {
        throw CircleException(CircleError.full);
      }
      throw CircleException(CircleError.unknown);
    }
  }

  Future<List<MemberStat>> members(String circleId) async {
    final rows =
        await SupabaseService.instance.client.rpc(
              'circle_member_stats',
              params: {'p_circle_id': circleId},
            )
            as List;
    return rows
        .map((r) => MemberStat.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  Future<void> leave(String circleId) async {
    await SupabaseService.instance.client
        .from('circle_members')
        .delete()
        .eq('circle_id', circleId)
        .eq('user_id', _uid!);
  }
}
