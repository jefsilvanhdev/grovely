import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/i18n/locale_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_mode_provider.dart';
import '../../data/providers/display_name_provider.dart';
import '../../data/providers/entitlement_provider.dart';
import '../../data/providers/garden_provider.dart';
import '../../data/providers/profile_photo_provider.dart';
import '../../data/services/notification_service.dart';
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
    final plan = ref.watch(entitlementProvider);
    final name = ref.watch(displayNameProvider) ?? l10n.profileGuest;
    final photo = ref.watch(profilePhotoProvider);
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accent;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            // Identidade — nome local editável ("Guest" pagante era P0 do
            // review populado); anel accent no avatar celebra o Plus.
            // Tocar no avatar troca a foto (photo picker do sistema).
            Row(
              children: [
                PressableScale(
                  semanticLabel: l10n.profileChangePhoto,
                  onTap: () => _photoSheet(context, ref),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: plan.status == PlanStatus.plus
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: accent, width: 2),
                          )
                        : null,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: scheme.primaryContainer,
                          backgroundImage: photo != null
                              ? FileImage(File(photo))
                              : null,
                          child: photo == null
                              ? Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : 'G',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: scheme.onPrimaryContainer,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: scheme.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.photo_camera_outlined,
                              size: 12,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: theme.textTheme.titleLarge),
                      const SizedBox(height: 6),
                      StreakBadge(count: stats.currentStreak),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.profileEditName,
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () => _editNameSheet(context, ref),
                ),
                // "Salvar progresso" volta quando o auth real existir —
                // hoje /auth é placeholder sem saída (QA I7).
              ],
            ),
            const SizedBox(height: 20),

            // Stats vitalícios
            Container(
              padding: const EdgeInsets.all(18),
              decoration: grovelyCard(context),
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
                      // Mesma regra do jardim: recorde só quando difere do
                      // streak atual (review populado P2-2).
                      if (stats.longestStreak > stats.currentStreak)
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

            // Plano — card de status para trial/plus; row de upsell no free.
            // Assinante NUNCA navega pro paywall de venda (review populado P0).
            if (plan.isPaying) ...[
              _PlanCard(plan: plan),
              const SizedBox(height: 20),
            ] else
              _Row(
                icon: Icons.workspace_premium_outlined,
                label: l10n.planFreeUpsell,
                value: l10n.profileFreePlan,
                onTap: () => context.go('/paywall'),
              ),
            _Row(
              icon: Icons.notifications_outlined,
              label: l10n.rowNotifications,
              onTap: () => _notifSheet(context),
            ),
            _Row(
              icon: Icons.palette_outlined,
              label: l10n.rowAppearance,
              value: _themeLabel(l10n, ref.watch(themeModeProvider)),
              onTap: () => _themeSheet(context, ref),
            ),
            _Row(
              icon: Icons.language_outlined,
              label: l10n.rowLanguage,
              value: _localeLabel(l10n, ref.watch(localeProvider)),
              onTap: () => _localeSheet(context, ref),
            ),
            // Privacidade/Termos entram quando as URLs existirem (gate do
            // Play Console — Jeff); Sair, quando houver auth real. Rows mortas
            // no beta minam a confiança (QA I7).
            const SizedBox(height: 12),
            Center(
              child: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snap) => Text(
                  snap.hasData
                      ? '${l10n.appName} · v${snap.data!.version}'
                      : l10n.appName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Foto: com foto atual → escolher trocar/remover; sem foto → picker direto.
  Future<void> _photoSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(profilePhotoProvider.notifier);
    if (ref.read(profilePhotoProvider) == null) {
      await notifier.pickFromGallery();
      return;
    }
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(l10n.profileChangePhoto),
              onTap: () async {
                Navigator.pop(sheetCtx);
                await notifier.pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(l10n.profileRemovePhoto),
              onTap: () {
                Navigator.pop(sheetCtx);
                notifier.remove();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editNameSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetCtx) => _NameSheet(
        l10n: l10n,
        initial: ref.read(displayNameProvider) ?? '',
        onSave: (v) => ref.read(displayNameProvider.notifier).set(v),
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

  // Endônimos (nome do idioma nele mesmo) — reconhecíveis em qualquer locale,
  // não se traduzem. `null` = segue o sistema.
  String _localeLabel(AppLocalizations l10n, Locale? locale) =>
      switch (locale?.languageCode) {
        'en' => 'English',
        'pt' => 'Português',
        'es' => 'Español',
        _ => l10n.languageSystem,
      };

  void _localeSheet(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) {
        final current = ref.read(localeProvider)?.languageCode;
        Widget opt(String? code, String label) => ListTile(
          title: Text(label),
          trailing: current == code
              ? Icon(Icons.check, color: Theme.of(sheetCtx).colorScheme.primary)
              : null,
          onTap: () {
            ref
                .read(localeProvider.notifier)
                .set(code == null ? null : Locale(code));
            Navigator.pop(sheetCtx);
          },
        );
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              opt(null, l10n.languageSystem),
              opt('en', 'English'),
              opt('pt', 'Português'),
              opt('es', 'Español'),
            ],
          ),
        );
      },
    );
  }

  void _notifSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final notif = NotificationService.instance;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) {
        bool? enabled; // null = carregando
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            if (enabled == null) {
              notif.isStreakReminderEnabled().then((v) {
                if (ctx.mounted) setSheet(() => enabled = v);
              });
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
              child: SwitchListTile(
                value: enabled ?? false,
                title: Text(
                  (enabled ?? false)
                      ? l10n.notifReminderOn
                      : l10n.notifReminderOff,
                ),
                subtitle: Text(l10n.notifReminderSheetBody),
                secondary: const Icon(Icons.notifications_active_outlined),
                onChanged: enabled == null
                    ? null
                    : (want) async {
                        if (want) {
                          final granted = await notif.requestPermission();
                          if (!granted) {
                            if (ctx.mounted) {
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.notifPermissionDenied),
                                ),
                              );
                            }
                            return;
                          }
                          await notif.enableStreakReminder(
                            title: l10n.notifStreakTitle,
                            body: l10n.notifStreakBody,
                            channelName: l10n.notifChannelName,
                            channelDescription: l10n.notifChannelDesc,
                          );
                        } else {
                          await notif.disableStreakReminder();
                        }
                        if (ctx.mounted) setSheet(() => enabled = want);
                      },
              ),
            );
          },
        );
      },
    );
  }
}

/// Sheet de edição do nome local (controller com dispose).
class _NameSheet extends StatefulWidget {
  const _NameSheet({
    required this.l10n,
    required this.initial,
    required this.onSave,
  });
  final AppLocalizations l10n;
  final String initial;
  final ValueChanged<String> onSave;

  @override
  State<_NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<_NameSheet> {
  late final _ctrl = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final v = _ctrl.text.trim();
    if (v.isNotEmpty) widget.onSave(v);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        4,
        24,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.l10n.profileEditName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            maxLength: 24,
            onSubmitted: (_) => _save(),
            decoration: InputDecoration(
              labelText: widget.l10n.profileNameLabel,
              hintText: widget.l10n.profileNameHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _save,
              child: Text(widget.l10n.commonSave),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card de status do plano (trial/plus) — gradiente mint do bosque + pills de
/// benefícios + gestão nativa da assinatura. Spec: APP_REVIEW_V6_POPULATED §1.
class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});
  final Entitlement plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accent;
    final healthy = isDark ? AppColors.treeHealthyDark : AppColors.treeHealthy;
    final isPlus = plan.status == PlanStatus.plus;
    final df = DateFormat.MMMd(l10n.localeName);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: grovelyCard(context).copyWith(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.primaryContainer.withValues(alpha: 0.45),
            scheme.surface,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.planPlusOverline,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              // Badge de status: dot + label (verde = ativo, âmbar = teste).
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: (isPlus ? healthy : accent).withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isPlus ? healthy : accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isPlus ? l10n.planActiveBadge : l10n.planTrialBadge,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (isPlus)
            Text(
              [
                if (plan.memberSince != null)
                  l10n.planMemberSince(df.format(plan.memberSince!)),
                if (plan.renewsAt != null)
                  l10n.planRenews(df.format(plan.renewsAt!)),
              ].join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          else
            Text(
              l10n.planTrialDaysLeft(plan.trialDaysLeft ?? 0),
              style: theme.textTheme.titleMedium,
            ),
          const SizedBox(height: 14),
          // Benefícios como lista alinhada em 2 colunas (check mint, sem
          // fundo) — os pills liam como chips desalinhados (feedback Jeff).
          _BenefitGrid(
            items: [
              l10n.planBenefitCircles,
              l10n.planBenefitSpecies,
              l10n.planBenefitThemes,
              l10n.planBenefitStats,
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              // Gestão/cancelamento é do sistema (Play) — nunca o /paywall.
              onPressed: () async {
                final ok = await launchUrl(
                  Uri.parse(
                    'https://play.google.com/store/account/subscriptions?package=com.grovely.app',
                  ),
                  mode: LaunchMode.externalApplication,
                );
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.commonError)));
                }
              },
              child: Text(l10n.planManage),
            ),
          ),
        ],
      ),
    );
  }
}

/// Benefícios do plano em 2 colunas: check mint + texto, sem chip — alinhado
/// e escaneável.
class _BenefitGrid extends StatelessWidget {
  const _BenefitGrid({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget item(String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_rounded, size: 16, color: theme.colorScheme.primary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
    return Column(
      children: [
        for (var i = 0; i < items.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: i + 2 < items.length ? 8 : 0),
            child: Row(
              children: [
                Expanded(child: item(items[i])),
                const SizedBox(width: 8),
                Expanded(
                  child: i + 1 < items.length
                      ? item(items[i + 1])
                      : const SizedBox(),
                ),
              ],
            ),
          ),
      ],
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
