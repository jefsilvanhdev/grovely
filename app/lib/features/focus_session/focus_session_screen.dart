import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/tree.dart';
import '../../data/providers/garden_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';
import '../../shared/widgets/leaf_confetti.dart';
import 'focus_session_controller.dart';
import 'widgets/tree_view.dart';

/// Core loop — timer de foco + árvore que cresce (Agente B, polido §2).
class FocusSessionScreen extends ConsumerStatefulWidget {
  const FocusSessionScreen({super.key});

  @override
  ConsumerState<FocusSessionScreen> createState() => _FocusSessionScreenState();
}

class _FocusSessionScreenState extends ConsumerState<FocusSessionScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = ref.read(focusSessionProvider.notifier);
    if (state == AppLifecycleState.paused) {
      controller.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      controller.onAppResumed();
    }
  }

  String _fmt(int s) =>
      '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    // Sessão terminou com a sheet "desistir?" aberta → fecha a sheet; sem
    // isso ela sobrevive sobre a tela de conclusão (QA M8).
    ref.listen(focusSessionProvider.select((s) => s.phase), (prev, next) {
      if (prev == FocusPhase.running && next != FocusPhase.running) {
        Navigator.of(
          context,
        ).popUntil((route) => route is! ModalBottomSheetRoute);
      }
    });

    final state = ref.watch(focusSessionProvider);
    final running = state.phase == FocusPhase.running;
    // Sessão rodando é sempre imersiva/escura (mockup v6 "focus session — dark"),
    // independente do tema: a tela vira um ambiente de foco.
    return Scaffold(
      backgroundColor: running ? _Running.bgTop : null,
      body: SafeArea(
        child: switch (state.phase) {
          FocusPhase.selecting => _Selecting(fmt: _fmt),
          FocusPhase.running => _Running(state: state, fmt: _fmt),
          FocusPhase.completed => _Completed(state: state),
          FocusPhase.withered => _Withered(state: state),
        },
      ),
    );
  }
}

// ── Selecting ────────────────────────────────────────────────────────────────
class _Selecting extends ConsumerWidget {
  const _Selecting({required this.fmt});
  final String Function(int) fmt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(focusSessionProvider);
    final controller = ref.read(focusSessionProvider.notifier);
    final stats = ref.watch(gardenStatsProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.surface,
            theme.colorScheme.surfaceContainerHighest,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: StreakBadge(count: stats.currentStreak),
            ),
            Expanded(
              // Pré-visualização grande: árvore madura preenche a área (detalhe).
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: LayoutBuilder(
                  builder: (context, c) {
                    // SVG aspect = 100/120 (mais alto que largo) → limita pela
                    // largura disponível para garantir tamanho máximo real.
                    final side =
                        (c.maxWidth < c.maxHeight ? c.maxWidth : c.maxHeight) *
                        0.95;
                    return Center(
                      child: TreeView(
                        type: state.treeType,
                        stage: TreeStage.mature,
                        size: side,
                      ),
                    );
                  },
                ),
              ),
            ),
            Text(
              l10n.focusPreview(
                speciesName(l10n, state.treeType),
                state.durationMinutes,
              ),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            // Regra do jogo ANTES da primeira perda — descobrir o wither
            // perdendo uma árvore era a pior fricção do teste de usabilidade.
            Text(
              l10n.focusRule,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 14),
            DurationDial(
              options: FocusSessionController.durationOptions,
              selected: state.durationMinutes,
              onSelected: controller.setDuration,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  controller.start();
                },
                child: Text(l10n.focusPlant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

// ── Running (imersivo) ───────────────────────────────────────────────────────
class _Running extends ConsumerWidget {
  const _Running({required this.state, required this.fmt});
  final FocusState state;
  final String Function(int) fmt;

  Future<void> _confirmGiveUp(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.focusGiveUpConfirmTitle,
              textAlign: TextAlign.center,
              style: Theme.of(sheetCtx).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => Navigator.pop(sheetCtx),
                child: Text(l10n.focusKeepFocusing),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(sheetCtx);
                ref.read(focusSessionProvider.notifier).wither();
              },
              child: Text(l10n.focusGiveUp),
            ),
          ],
        ),
      ),
    );
  }

  // Ambiente imersivo (mockup v6): sempre escuro durante a sessão.
  static const bgTop = Color(0xFF0F1A15);
  static const _bgWarm = Color(0xFF23301F); // fim de sessão: verde amanhecendo

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    // Fundo esquenta levemente conforme se aproxima do fim (alvorada → dia).
    final warm = Color.lerp(bgTop, _bgWarm, state.progress)!;
    const mint = Color(0xFF6FD79B);
    const dim = Color(0xFFA7B8AD);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [bgTop, warm],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          children: [
            // Cabeçalho da sessão: modo à esquerda, espécie · duração à direita.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.focusDeepWork.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: mint,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                  ),
                ),
                Text(
                  l10n.focusSessionMeta(
                    _capitalize(speciesName(l10n, state.treeType)),
                    state.durationMinutes,
                  ),
                  style: theme.textTheme.labelMedium?.copyWith(color: dim),
                ),
              ],
            ),
            Expanded(
              child: Center(
                // Anel mint sobre trilha escura — força os tokens dark aqui
                // dentro para o TimerRing e a árvore lerem o ambiente imersivo.
                child: Theme(
                  data: AppTheme.dark(),
                  child: TimerRing(
                    progress: state.progress,
                    size: 320,
                    child: TreeView(
                      type: state.treeType,
                      stage: state.stage,
                      size: 240,
                      scale: 0.9 + 0.1 * state.progress,
                    ),
                  ),
                ),
              ),
            ),
            // liveRegion: TalkBack anuncia o tempo restante quando ele muda de
            // minuto (anunciar todo segundo seria spam) — QA I6.
            Semantics(
              liveRegion: state.secondsRemaining % 60 == 0,
              label: fmt(state.secondsRemaining),
              excludeSemantics: true,
              child: Text(
                fmt(state.secondsRemaining),
                style: theme.textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.focusKeepGrowing,
              style: theme.textTheme.bodyMedium?.copyWith(color: dim),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: dim,
                  side: const BorderSide(color: Color(0xFF3A4D42)),
                ),
                onPressed: () => _confirmGiveUp(context, ref),
                child: Text(l10n.focusGiveUp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Completed ────────────────────────────────────────────────────────────────
class _Completed extends ConsumerStatefulWidget {
  const _Completed({required this.state});
  final FocusState state;

  @override
  ConsumerState<_Completed> createState() => _CompletedState();
}

class _CompletedState extends ConsumerState<_Completed> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = ref.read(focusSessionProvider.notifier);
    final stats = ref.watch(gardenStatsProvider);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SymbolWatermark(size: 300),
                    TreeView(
                      type: state.treeType,
                      stage: state.stage,
                      size: 220,
                    ),
                  ],
                ),
              ),
              Text(
                l10n.focusCompletedTitle,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  StatPill(
                    icon: Icons.timer_outlined,
                    label: l10n.statMinFocused(state.durationMinutes),
                  ),
                  StatPill(
                    icon: Icons.local_fire_department,
                    label: l10n.streakDays(stats.currentStreak),
                  ),
                  StatPill(
                    icon: Icons.park_outlined,
                    label: l10n.statTrees(stats.trees),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.addedToGarden,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: controller.reset,
                  child: Text(l10n.plantAnother),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.tonal(
                  onPressed: () => context.go('/garden'),
                  child: Text(l10n.viewGarden),
                ),
              ),
            ],
          ),
        ),
        const Positioned.fill(child: LeafConfetti()),
      ],
    );
  }
}

// ── Withered + Revive ────────────────────────────────────────────────────────
class _Withered extends ConsumerStatefulWidget {
  const _Withered({required this.state});
  final FocusState state;

  @override
  ConsumerState<_Withered> createState() => _WitheredState();
}

class _WitheredState extends ConsumerState<_Withered> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.lightImpact();
  }

  Future<void> _reviveSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetCtx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.reviveSheetBody,
              textAlign: TextAlign.center,
              style: Theme.of(sheetCtx).textTheme.titleMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(sheetCtx);
                  // TODO(Agente D): rewarded ad real antes de reviver.
                  ref.read(focusSessionProvider.notifier).revive();
                },
                child: Text(l10n.watchAndRevive),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(sheetCtx),
              child: Text(l10n.noThanks),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = ref.read(focusSessionProvider.notifier);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: TreeView(
                type: state.treeType,
                stage: state.stage,
                size: 200,
              ),
            ),
          ),
          Text(l10n.focusWitheredTitle, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(
            l10n.witheredBodyKind,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.tonal(
              onPressed: () => _reviveSheet(context),
              child: Text(l10n.reviveWithVideo),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: controller.reset, child: Text(l10n.startFresh)),
        ],
      ),
    );
  }
}
