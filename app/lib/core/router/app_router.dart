import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../features/auth/auth_screen.dart';
import '../../features/circle/circle_screen.dart';
import '../../features/focus_session/focus_session_screen.dart';
import '../../features/garden/garden_screen.dart';
import '../../features/league/league_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/paywall/paywall_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/recap/recap_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../shared/widgets/main_shell.dart';

/// Esqueleto de navegação (Fase 0).
///
/// Fora da casca: onboarding, auth, paywall, recap (telas full-screen).
/// Dentro da casca ([StatefulShellRoute]): as 5 abas do app.
/// O redirect inicial (onboarding vs. app) será ligado ao estado de auth/
/// onboarding-concluído nas fases seguintes.
final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
    GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
    GoRoute(path: '/paywall', builder: (_, _) => const PaywallScreen()),
    GoRoute(path: '/recap', builder: (_, _) => const RecapScreen()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/focus',
              builder: (_, _) => const FocusSessionScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/garden', builder: (_, _) => const GardenScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/circle', builder: (_, _) => const CircleScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/league', builder: (_, _) => const LeagueScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        // Localizado (QA M4 — era PT fixo).
        '${AppLocalizations.of(context).commonError}\n${state.uri}',
        textAlign: TextAlign.center,
      ),
    ),
  ),
);
