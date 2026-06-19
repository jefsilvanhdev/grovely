import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers/circle_provider.dart';
import '../../data/services/supabase_service.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';

/// Liga semanal (§5) — circle-gated. MVP: ranking dos membros do círculo por
/// árvores na semana. Tiers/promote-relegate = pendência de mecânica (Jeff).
class LeagueScreen extends ConsumerWidget {
  const LeagueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final circle = ref.watch(myCircleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.leagueTitle)),
      body: SafeArea(
        child: circle.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _Solo(),
          data: (c) {
            if (c == null) return _Solo();
            final members = ref.watch(circleMembersProvider(c.id));
            final uid = SupabaseService.instance.currentUserId;
            return members.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => Center(child: Text(l10n.commonError)),
              data: (list) => ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: theme.colorScheme.secondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.leagueTitleWeek,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < list.length; i++)
                    _RankRow(
                      rank: i + 1,
                      name: list[i].userId == uid
                          ? l10n.leagueYou
                          : list[i].displayName,
                      score: list[i].weeklyTrees,
                      isYou: list[i].userId == uid,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.name,
    required this.score,
    required this.isYou,
  });
  final int rank;
  final String name;
  final int score;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isYou ? scheme.primaryContainer : scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.outline),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 26,
            child: Text(
              '$rank',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: scheme.surfaceContainerHighest,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            l10n.memberWeekly(score),
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _Solo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        const SymbolWatermark(size: 280),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 48,
                color: theme.colorScheme.secondary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.leagueSolo,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
