import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'focus_session_controller.dart';
import 'widgets/tree_view.dart';

/// Core loop — timer de foco + árvore que cresce (Agente B).
///
/// Detecta saída do app (lifecycle): se sair durante a sessão, a árvore murcha.
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
    // Background → inicia carência; volta a tempo → cancela. Murcha só se ficar
    // fora além da janela (perdoa ligação/notificação/troca rápida).
    final controller = ref.read(focusSessionProvider.notifier);
    if (state == AppLifecycleState.paused) {
      controller.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      controller.onAppResumed();
    }
  }

  String _fmt(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(focusSessionProvider);
    final controller = ref.read(focusSessionProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.focusTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: switch (state.phase) {
            FocusPhase.selecting => _Selecting(
              state: state,
              controller: controller,
            ),
            FocusPhase.running => _Running(state: state, fmt: _fmt),
            FocusPhase.completed => _Result(
              state: state,
              title: l10n.focusCompletedTitle,
              body: l10n.focusCompletedBody(state.durationMinutes),
              onReset: controller.reset,
              resetLabel: l10n.focusNewSession,
            ),
            FocusPhase.withered => _Result(
              state: state,
              title: l10n.focusWitheredTitle,
              body: l10n.focusWitheredBody,
              onReset: controller.reset,
              resetLabel: l10n.focusNewSession,
            ),
          },
        ),
      ),
    );
  }
}

class _Selecting extends StatelessWidget {
  const _Selecting({required this.state, required this.controller});
  final FocusState state;
  final FocusSessionController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        Text(
          l10n.focusSubtitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Center(
            child: TreeView(
              type: state.treeType,
              stage: state.stage,
              size: 200,
            ),
          ),
        ),
        Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            for (final min in FocusSessionController.durationOptions)
              ChoiceChip(
                label: Text(l10n.minutesShort(min)),
                selected: state.durationMinutes == min,
                onSelected: (_) => controller.setDuration(min),
              ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: controller.start,
            child: Text(l10n.focusStart),
          ),
        ),
      ],
    );
  }
}

class _Running extends ConsumerWidget {
  const _Running({required this.state, required this.fmt});
  final FocusState state;
  final String Function(int) fmt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: TreeView(
              type: state.treeType,
              stage: state.stage,
              size: 260,
            ),
          ),
        ),
        Text(
          fmt(state.secondsRemaining),
          style: theme.textTheme.displayLarge?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.focusKeepGrowing,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => ref.read(focusSessionProvider.notifier).wither(),
          child: Text(l10n.focusGiveUp),
        ),
      ],
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({
    required this.state,
    required this.title,
    required this.body,
    required this.onReset,
    required this.resetLabel,
  });
  final FocusState state;
  final String title;
  final String body;
  final VoidCallback onReset;
  final String resetLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: Center(
            child: TreeView(
              type: state.treeType,
              stage: state.stage,
              size: 240,
            ),
          ),
        ),
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          body,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton(onPressed: onReset, child: Text(resetLabel)),
        ),
      ],
    );
  }
}
