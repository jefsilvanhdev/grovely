import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/theme_mode_provider.dart';
import '../../data/providers/garden_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';

/// Perfil / Ajustes (§8): identidade, stats vitalícios, conta, assinatura,
/// notificações, tema, privacidade.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final stats = ref.watch(gardenStatsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Identidade
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: scheme.primaryContainer,
                  child: Text(
                    'G',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.profileGuest,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      StreakBadge(count: stats.currentStreak),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(l10n.profileSaveProgress),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats vitalícios
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: scheme.outline),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.profileLifetime,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      StatPill(
                        icon: Icons.park_outlined,
                        label: l10n.statTrees(stats.trees),
                      ),
                      StatPill(
                        icon: Icons.timer_outlined,
                        label: l10n.statHoursFocused(stats.hours),
                      ),
                      StatPill(
                        icon: Icons.emoji_events_outlined,
                        label: l10n.statLongest(stats.longestStreak),
                      ),
                      StatPill(
                        icon: Icons.spa_outlined,
                        label: l10n.statSpecies(stats.species),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Ajustes
            _Row(
              icon: Icons.workspace_premium_outlined,
              label: l10n.rowSubscription,
              value: l10n.profileFreePlan,
              onTap: () => context.go('/paywall'),
            ),
            _Row(
              icon: Icons.notifications_outlined,
              label: l10n.rowNotifications,
              onTap: () {},
            ),
            _Row(
              icon: Icons.palette_outlined,
              label: l10n.rowAppearance,
              value: _themeLabel(l10n, ref.watch(themeModeProvider)),
              onTap: () => _themeSheet(context, ref),
            ),
            _Row(
              icon: Icons.lock_outline,
              label: l10n.rowPrivacy,
              onTap: () {},
            ),
            _Row(
              icon: Icons.description_outlined,
              label: l10n.rowTerms,
              onTap: () {},
            ),
            _Row(icon: Icons.logout, label: l10n.rowSignOut, onTap: () {}),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '${l10n.appName} · v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _themeLabel(AppLocalizations l10n, ThemeMode m) => switch (m) {
    ThemeMode.system => l10n.themeSystem,
    ThemeMode.light => l10n.themeLight,
    ThemeMode.dark => l10n.themeDark,
  };

  void _themeSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) {
        final current = ref.read(themeModeProvider);
        Widget opt(ThemeMode m, String label) => ListTile(
          title: Text(label),
          trailing: current == m
              ? Icon(Icons.check, color: Theme.of(sheetCtx).colorScheme.primary)
              : null,
          onTap: () {
            ref.read(themeModeProvider.notifier).set(m);
            Navigator.pop(sheetCtx);
          },
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              opt(ThemeMode.system, l10n.themeSystem),
              opt(ThemeMode.light, l10n.themeLight),
              opt(ThemeMode.dark, l10n.themeDark),
            ],
          ),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
  });
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: scheme.onSurfaceVariant),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value!,
              style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 13),
            ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: scheme.outline),
        ],
      ),
      onTap: onTap,
    );
  }
}
