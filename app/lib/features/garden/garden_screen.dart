import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/tree.dart';
import '../../data/providers/garden_provider.dart';
import '../../l10n/app_localizations.dart';
import '../focus_session/widgets/tree_view.dart';

/// Jardim pessoal — grid de árvores conquistadas (Agente B).
class GardenScreen extends ConsumerWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final garden = ref.watch(gardenProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.gardenTitle)),
      body: SafeArea(
        child: garden.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonError)),
          data: (trees) {
            if (trees.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    l10n.gardenEmpty,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: Text(
                    l10n.gardenTreeCount(trees.length),
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: trees.length,
                    itemBuilder: (_, i) => DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: TreeView(
                          type: trees[i].type,
                          stage: TreeStage.elder,
                          size: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
