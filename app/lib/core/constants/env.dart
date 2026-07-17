/// Segredos por app via `--dart-define` (NUNCA commitados).
///
/// Exemplo de execução:
/// ```
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xxx.supabase.co \
///   --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_... \
///   --dart-define=REVENUECAT_ANDROID_KEY=goog_... \
///   --dart-define=ADMOB_APP_ID=ca-app-pub-...
/// ```
/// Em CI/release, prefira `--dart-define-from-file=env.json` (gitignored).
class Env {
  Env._();

  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );
  static const String supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: '',
  );

  // RevenueCat: fora do MVP (lançamento é grátis, sem premium). As chaves
  // ficam aqui para quando o Plus voltar.
  static const String revenueCatAndroidKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_KEY',
    defaultValue: '',
  );
  static const String revenueCatIosKey = String.fromEnvironment(
    'REVENUECAT_IOS_KEY',
    defaultValue: '',
  );

  /// Unidade do anúncio rewarded (reviver árvore murcha). Vazio = sem anúncio
  /// (revive direto). O App ID do AdMob vive no manifest, não aqui — ver
  /// `android/app/build.gradle.kts` (manifestPlaceholder + guard de release).
  ///
  /// ID de TESTE oficial do Google como default: em dev sempre mostra anúncio
  /// de teste; em release o env.json traz o real.
  static const String admobRewardedUnitId = String.fromEnvironment(
    'ADMOB_REWARDED_UNIT_ID',
    defaultValue: 'ca-app-pub-3940256099942544/5224354917',
  );

  /// True quando as credenciais do Supabase foram fornecidas.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
}
