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

  static const String supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const String supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY', defaultValue: '');

  static const String revenueCatAndroidKey =
      String.fromEnvironment('REVENUECAT_ANDROID_KEY', defaultValue: '');
  static const String revenueCatIosKey =
      String.fromEnvironment('REVENUECAT_IOS_KEY', defaultValue: '');

  static const String admobAppId =
      String.fromEnvironment('ADMOB_APP_ID', defaultValue: '');

  /// True quando as credenciais do Supabase foram fornecidas.
  static bool get hasSupabase =>
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;
}
