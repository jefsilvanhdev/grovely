import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_mode_provider.dart';
import 'data/services/supabase_service.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Edge-to-edge + retrato apenas (mesmo padrão do "O Meu Salmo").
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Sobe a UI imediatamente: a splash animada aparece sem esperar rede. Os
  // inits (Supabase/Firebase) rodam em background — são best-effort e ninguém
  // no boot (splash → onboarding) depende deles; quando o usuário chega nas
  // telas autenticadas já terminaram. Sem isso, a splash nativa travava ~8-10s.
  unawaited(_bootstrapServices());

  runApp(const ProviderScope(child: PlantioApp()));
}

/// Inits tolerantes a falha, fora do caminho crítico do primeiro frame.
Future<void> _bootstrapServices() async {
  try {
    await SupabaseService.instance.init();
    await SupabaseService.instance.ensureSignedIn();
  } catch (_) {}

  try {
    await Firebase.initializeApp();
  } catch (_) {}
}

class PlantioApp extends ConsumerWidget {
  const PlantioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
