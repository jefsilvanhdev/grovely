import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

/// Estado de presença de um círculo: quantos estão online e quem está focando
/// agora. Best-effort — se o realtime cair, degrada pra vazio, nunca quebra a UI.
class CirclePresence {
  const CirclePresence({this.online = 0, this.focusing = const {}});

  /// Total de membros com o app aberto no círculo.
  final int online;

  /// user_ids que estão numa sessão de foco agora.
  final Set<String> focusing;

  int get focusingCount => focusing.length;

  CirclePresence copyWith({int? online, Set<String>? focusing}) =>
      CirclePresence(
        online: online ?? this.online,
        focusing: focusing ?? this.focusing,
      );
}

/// Canal de presença por círculo (Supabase Realtime). Cada membro publica
/// `{user_id, focusing}`; o serviço agrega o estado e emite num stream.
class CirclePresenceChannel {
  CirclePresenceChannel({required this.circleId, required this.userId});

  final String circleId;
  final String userId;

  RealtimeChannel? _channel;
  bool _focusing = false;
  final _controller = StreamController<CirclePresence>.broadcast();

  Stream<CirclePresence> get stream => _controller.stream;

  /// Entra no canal e publica presença inicial. Não lança.
  Future<void> join() async {
    if (!SupabaseService.instance.isInitialized) return;
    try {
      final client = SupabaseService.instance.client;
      final ch = client.channel(
        'circle:$circleId',
        opts: const RealtimeChannelConfig(self: true),
      );
      _channel = ch;
      ch.onPresenceSync((_) => _emit());
      ch.onPresenceJoin((_) => _emit());
      ch.onPresenceLeave((_) => _emit());
      ch.subscribe((status, _) async {
        if (status == RealtimeSubscribeStatus.subscribed) {
          await _track();
        }
      });
    } catch (_) {
      // realtime indisponível — segue sem presença
    }
  }

  /// Marca/desmarca que este usuário está focando agora.
  Future<void> setFocusing(bool value) async {
    if (_focusing == value) return;
    _focusing = value;
    await _track();
  }

  Future<void> _track() async {
    try {
      await _channel?.track({'user_id': userId, 'focusing': _focusing});
    } catch (_) {}
  }

  void _emit() {
    final ch = _channel;
    if (ch == null || _controller.isClosed) return;
    try {
      final states = ch.presenceState();
      final focusing = <String>{};
      var online = 0;
      for (final s in states) {
        for (final p in s.presences) {
          online++;
          final payload = p.payload;
          final uid = payload['user_id'] as String?;
          if (uid != null && payload['focusing'] == true) focusing.add(uid);
        }
      }
      _controller.add(CirclePresence(online: online, focusing: focusing));
    } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await _channel?.unsubscribe();
    } catch (_) {}
    _channel = null;
    if (!_controller.isClosed) await _controller.close();
  }
}
