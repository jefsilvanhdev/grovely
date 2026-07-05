import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/circle.dart';
import '../../data/providers/circle_provider.dart';
import '../../data/providers/profile_photo_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';

/// Liga semanal (§5) — circle-gated. Fase A do review populado: competição de
/// verdade com os dados atuais — countdown, pódio top-3, card "Você" com
/// delta acionável. Fase B (liga entre círculos, divisões) = backend novo.
/// A cooperação (bosque/meta/contribuição) mora na aba Círculo.
class LeagueScreen extends ConsumerWidget {
  const LeagueScreen({super.key});

  /// Tempo até a virada da liga (segunda 00:00 local), como "2d 5h" / "5h".
  String _endsIn() {
    final now = clock.now();
    final daysToMonday = (DateTime.monday - now.weekday + 7) % 7;
    final nextMonday = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(days: daysToMonday == 0 ? 7 : daysToMonday));
    final left = nextMonday.difference(now);
    if (left.inDays > 0) return '${left.inDays}d ${left.inHours % 24}h';
    if (left.inHours > 0) return '${left.inHours}h';
    return '${left.inMinutes}min';
  }

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
            final uid = ref.watch(currentUserIdProvider);
            final youPhoto = ref.watch(profilePhotoProvider);
            return members.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, _) => const GrovelyError(),
              data: (raw) {
                final list = [...raw]
                  ..sort((a, b) => b.weeklyTrees.compareTo(a.weeklyTrees));
                final youIndex = list.indexWhere((m) => m.userId == uid);
                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.leagueTitleWeek,
                            style: theme.textTheme.titleMedium,
                          ),
                        ),
                        // Urgência: nada dizia que a liga zera na segunda.
                        Icon(
                          Icons.hourglass_bottom,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.leagueEndsIn(_endsIn()),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (list.isNotEmpty)
                      _Podium(
                        top: list.take(3).toList(),
                        youId: uid,
                        youPhoto: youPhoto,
                      ),
                    if (youIndex >= 0) ...[
                      const SizedBox(height: 16),
                      _YouCard(list: list, youIndex: youIndex),
                    ],
                    const SizedBox(height: 16),
                    for (var i = 3; i < list.length; i++)
                      _RankRow(
                        rank: i + 1,
                        member: list[i],
                        isYou: list[i].userId == uid,
                        youPhoto: list[i].userId == uid ? youPhoto : null,
                      ).staggerIn(context, i - 3),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

/// Pódio top-3: 2º · 1º · 3º, alturas 64/80/56 — hero da competição.
class _Podium extends StatelessWidget {
  const _Podium({required this.top, this.youId, this.youPhoto});
  final List<MemberStat> top;
  final String? youId;
  final String? youPhoto;

  @override
  Widget build(BuildContext context) {
    MemberStat? at(int i) => i < top.length ? top[i] : null;
    String? photoFor(MemberStat? m) =>
        m != null && m.userId == youId ? youPhoto : null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _PodiumSpot(
            member: at(1),
            rank: 2,
            height: 64,
            photoPath: photoFor(at(1)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodiumSpot(
            member: at(0),
            rank: 1,
            height: 84,
            photoPath: photoFor(at(0)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _PodiumSpot(
            member: at(2),
            rank: 3,
            height: 56,
            photoPath: photoFor(at(2)),
          ),
        ),
      ],
    );
  }
}

class _PodiumSpot extends StatelessWidget {
  const _PodiumSpot({
    required this.member,
    required this.rank,
    required this.height,
    this.photoPath,
  });
  final MemberStat? member;
  final int rank;
  final double height;
  final String? photoPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = member;
    if (m == null) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MemberAvatar(
          userId: m.userId,
          displayName: m.displayName,
          photoPath: photoPath,
          radius: rank == 1 ? 26 : 20,
        ),
        const SizedBox(height: 6),
        Text(
          m.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          '${m.weeklyTrees}',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(
              alpha: rank == 1 ? 0.9 : 0.5,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          alignment: Alignment.center,
          child: _RankMedal(rank: rank),
        ),
      ],
    );
  }
}

/// Card "Você": posição + score + delta acionável (o que falta pra subir, ou
/// quem está colando) — transforma leitura passiva em meta.
class _YouCard extends StatelessWidget {
  const _YouCard({required this.list, required this.youIndex});
  final List<MemberStat> list;
  final int youIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final you = list[youIndex];
    final rankLabel = '${youIndex + 1}º';

    String? delta;
    if (youIndex > 0) {
      final above = list[youIndex - 1];
      final gap = above.weeklyTrees - you.weeklyTrees + 1;
      delta = l10n.leagueDeltaBehind(gap, above.displayName);
    } else if (list.length > 1) {
      final below = list[1];
      final gap = you.weeklyTrees - below.weeklyTrees;
      // gap 0 = empate: "0 árvores atrás" soa estranho, esconde (QA P2-2).
      if (gap > 0) delta = l10n.leagueDeltaAhead(below.displayName, gap);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.leagueYou.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.leagueYourPlace(rankLabel, you.weeklyTrees),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: 2),
            Text(
              delta,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({
    required this.rank,
    required this.member,
    required this.isYou,
    this.youPhoto,
  });
  final int rank;
  final MemberStat member;
  final bool isYou;
  final String? youPhoto;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final name = isYou ? l10n.leagueYou : member.displayName;
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
          _RankMedal(rank: rank),
          const SizedBox(width: 8),
          MemberAvatar(
            userId: member.userId,
            displayName: name,
            photoPath: youPhoto,
            radius: 16,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            // Unidade explícita: "10 this week" não dizia 10 de quê (P2-3).
            l10n.leagueScore(member.weeklyTrees),
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _RankMedal extends StatelessWidget {
  const _RankMedal({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    const medals = {
      1: Color(0xFFE0A458), // ouro (sol da marca)
      2: Color(0xFFB8C0C8), // prata
      3: Color(0xFFCB8E5A), // bronze
    };
    final medal = medals[rank];
    if (medal == null) {
      return SizedBox(
        width: 26,
        child: Text(
          '$rank',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      );
    }
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: medal, shape: BoxShape.circle),
      child: Text(
        '$rank',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Solo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GrovelyEmpty(
      icon: Icons.emoji_events_outlined,
      title: l10n.leagueSolo,
    );
  }
}
