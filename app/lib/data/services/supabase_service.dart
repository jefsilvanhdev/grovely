import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/env.dart';

/// Inicializa e expõe o cliente Supabase (auth, postgres, realtime, presence).
///
/// Fase 0: inicialização tolerante a falha — se as credenciais não foram
/// passadas via `--dart-define`, o app sobe mesmo assim (sessão de foco solo
/// funciona offline; a sincronização entra quando houver credenciais).
class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Chama uma vez no startup. Não lança — registra e segue.
  Future<void> init() async {
    if (_initialized || !Env.hasSupabase) return;
    await Supabase.initialize(
      url: Env.supabaseUrl,
      publishableKey: Env.supabasePublishableKey,
    );
    _initialized = true;
  }

  /// Cliente ativo. Só use após [init] ter sucesso ([isInitialized] true).
  SupabaseClient get client => Supabase.instance.client;
}
