import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/models/completed_tree.dart';
import '../../data/models/tree.dart';
import '../../data/providers/garden_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';
import '../focus_session/widgets/tree_view.dart';

/// Jardim pessoal — vitrine de árvores conquistadas (§3, polido).
class GardenScreen extends ConsumerWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final garden = ref.watch(gardenProvider);

    final hasTrees = (garden.value ?? const <CompletedTree>[]).isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gardenTitle),
        actions: [
          // Recap semanal compartilhável — só faz sentido com árvores no jardim.
          if (hasTrees)
            IconButton(
              icon: const Icon(Icons.ios_share),
              tooltip: l10n.recapTitle,
              onPressed: () => context.push('/recap'),
            ),
        ],
      ),
      body: SafeArea(
        child: garden.when(
          loading: () => const _GardenSkeleton(),
          error: (_, _) =>
              GrovelyError(onRetry: () => ref.invalidate(gardenProvider)),
          data: (trees) =>
              trees.isEmpty ? const _GardenEmpty() : _GardenGrid(trees: trees),
        ),
      ),
    );
  }
}

class _GardenGrid extends ConsumerWidget {
  const _GardenGrid({required this.trees});
  final List<CompletedTree> trees;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final stats = ref.watch(gardenStatsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        // Header card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: grovelyCard(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.gardenTreeCount(stats.trees),
                    style: theme.textTheme.headlineSmall,
                  ),
                  StreakBadge(count: stats.currentStreak),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
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
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          // Último slot é o convite pra plantar a próxima (mockup v6).
          itemCount: trees.length + 1,
          itemBuilder: (context, i) => i == trees.length
              ? const _PlantMoreTile().staggerIn(context, i)
              : _TreeTile(tree: trees[i]).staggerIn(context, i),
        ),
      ],
    );
  }
}

class _TreeTile extends StatelessWidget {
  const _TreeTile({required this.tree});
  final CompletedTree tree;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PressableScale(
      onTap: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => _TreeDetailSheet(tree: tree),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: TreeView(type: tree.type, stage: TreeStage.elder, size: 80),
        ),
      ),
    );
  }
}

/// Slot "+" no fim do grid — convite pra próxima árvore (mockup v6).
class _PlantMoreTile extends StatelessWidget {
  const _PlantMoreTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return PressableScale(
      onTap: () => context.go('/focus'),
      child: Semantics(
        button: true,
        label: l10n.plantAnother,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.outline, width: 1.5),
          ),
          child: Icon(
            Icons.add,
            size: 32,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _TreeDetailSheet extends StatelessWidget {
  const _TreeDetailSheet({required this.tree});
  final CompletedTree tree;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final date = DateFormat.yMMMd(l10n.localeName).format(tree.completedAt);
    final species = speciesName(l10n, tree.type);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TreeView(type: tree.type, stage: TreeStage.elder, size: 160),
          const SizedBox(height: 8),
          Text(
            species[0].toUpperCase() + species.substring(1),
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          Text(
            '$date · ${l10n.minutesShort(tree.durationMinutes)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _GardenEmpty extends StatelessWidget {
  const _GardenEmpty();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GrovelyEmpty(
      icon: Icons.park_outlined,
      title: l10n.gardenWaiting,
      body: l10n.gardenWaitingSub,
      action: FilledButton(
        onPressed: () => context.go('/focus'),
        child: Text(l10n.plantFirst),
      ),
    );
  }
}

class _GardenSkeleton extends StatelessWidget {
  const _GardenSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        const GrovelySkeletonBox(height: 96, radius: 20),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: List.generate(9, (_) => const GrovelySkeletonBox()),
        ),
      ],
    );
  }
}
