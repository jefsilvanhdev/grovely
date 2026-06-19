import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/focus_session/focus_session_controller.dart';
import '../../l10n/app_localizations.dart';

/// Casca principal com bottom nav de 5 abas: Foco · Jardim · Círculo · Liga ·
/// Perfil. Cada aba é um branch do [StatefulShellRoute] (mantém estado).
///
/// Durante uma sessão de foco rodando, a nav some (modo imersivo) — evita
/// "sair" acidental e reforça "fique aqui".
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final running = ref.watch(
      focusSessionProvider.select((s) => s.phase == FocusPhase.running),
    );
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: running
          ? null
          : NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.timer_outlined),
                  selectedIcon: const Icon(Icons.timer),
                  label: l10n.navFocus,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.grass_outlined),
                  selectedIcon: const Icon(Icons.grass),
                  label: l10n.navGarden,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.groups_outlined),
                  selectedIcon: const Icon(Icons.groups),
                  label: l10n.navCircle,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.emoji_events_outlined),
                  selectedIcon: const Icon(Icons.emoji_events),
                  label: l10n.navLeague,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline),
                  selectedIcon: const Icon(Icons.person),
                  label: l10n.navProfile,
                ),
              ],
            ),
    );
  }
}
