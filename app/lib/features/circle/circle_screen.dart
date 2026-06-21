import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/circle.dart';
import '../../data/models/tree.dart';
import '../../data/providers/circle_provider.dart';
import '../../data/repositories/circle_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';
import '../focus_session/widgets/tree_view.dart';

/// Círculo (§4): vazio → criar/entrar; em círculo → detalhe (jardim coletivo,
/// membros, meta). Presence ao vivo = follow-up (precisa realtime + 2 devices).
class CircleScreen extends ConsumerWidget {
  const CircleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final circle = ref.watch(myCircleProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.circleTitle)),
      body: SafeArea(
        child: circle.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.commonError),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => ref.invalidate(myCircleProvider),
                  child: Text(l10n.commonRetry),
                ),
              ],
            ),
          ),
          data: (c) => c == null ? _Empty() : _Detail(circle: c),
        ),
      ),
    );
  }
}

class _Empty extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return GrovelyEmpty(
      icon: Icons.groups_outlined,
      title: l10n.circleEmptyTitle,
      body: l10n.circleEmptySub,
      action: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: () => _createSheet(context, ref),
              child: Text(l10n.circleCreate),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.tonal(
              onPressed: () => _joinSheet(context, ref),
              child: Text(l10n.circleJoin),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 13,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  l10n.circlePrivacy,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _createSheet(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final ctrl = TextEditingController();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetCtx) => Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        4,
        24,
        MediaQuery.of(sheetCtx).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.circleCreate,
            style: Theme.of(sheetCtx).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: ctrl,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.circleNameLabel,
              hintText: l10n.circleNameHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () async {
                final name = ctrl.text.trim();
                if (name.isEmpty) return;
                await ref.read(circleRepositoryProvider).create(name);
                ref.invalidate(myCircleProvider);
                if (sheetCtx.mounted) Navigator.pop(sheetCtx);
              },
              child: Text(l10n.circleCreateCta),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<void> _joinSheet(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final ctrl = TextEditingController();
  String? error;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetCtx) => StatefulBuilder(
      builder: (sheetCtx, setSheet) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          4,
          24,
          MediaQuery.of(sheetCtx).viewInsets.bottom + 28,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.circleJoinTitle,
              style: Theme.of(sheetCtx).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: ctrl,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: l10n.circleCodeLabel,
                border: const OutlineInputBorder(),
                errorText: error,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () async {
                  final code = ctrl.text.trim();
                  if (code.isEmpty) return;
                  try {
                    await ref.read(circleRepositoryProvider).joinByCode(code);
                    ref.invalidate(myCircleProvider);
                    if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                  } on CircleException catch (e) {
                    setSheet(
                      () => error = e.kind == CircleError.full
                          ? l10n.circleFull
                          : l10n.circleInvalidCode,
                    );
                  }
                },
                child: Text(l10n.circleJoinCta),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _Detail extends ConsumerWidget {
  const _Detail({required this.circle});
  final Circle circle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final members = ref.watch(circleMembersProvider(circle.id));

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(circleMembersProvider(circle.id)),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(circle.name, style: theme.textTheme.headlineSmall),
              ),
              IconButton(
                tooltip: l10n.circleInvite,
                onPressed: () => SharePlus.instance.share(
                  ShareParams(
                    text: '${circle.name} · Grovely: ${circle.inviteCode}',
                  ),
                ),
                icon: const Icon(Icons.ios_share),
              ),
              PopupMenuButton<String>(
                onSelected: (_) => _confirmLeave(context, ref),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'leave', child: Text(l10n.circleLeave)),
                ],
              ),
            ],
          ),
          Text(
            '${l10n.circleCodeLabel}: ${circle.inviteCode}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          members.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, _) => Text(l10n.commonError),
            data: (list) {
              final planted = list.fold<int>(0, (s, m) => s + m.weeklyTrees);
              final goal = (list.length * 5).clamp(5, 999);
              final goalReached = planted >= goal;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta coletiva
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: grovelyCard(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goalReached
                              ? l10n.circleGoalReached(planted)
                              : l10n.circleGoal(planted, goal),
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        // Jardim coletivo: cada árvore plantada na semana enche
                        // o bosque; vagas restantes ficam como brotos esmaecidos.
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            for (var i = 0; i < goal.clamp(0, 36); i++)
                              SizedBox(
                                width: 22,
                                height: 28,
                                child: i < planted
                                    ? TreeView(
                                        type: TreeType
                                            .values[i % TreeType.values.length],
                                        stage: TreeStage.young,
                                        size: 22,
                                      )
                                    : Icon(
                                        Icons.eco_outlined,
                                        size: 16,
                                        color: theme.colorScheme.outline,
                                      ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.circleMembers, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final (i, m) in list.indexed)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          m.displayName.isNotEmpty
                              ? m.displayName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      title: Text(m.displayName),
                      trailing: Text(
                        l10n.memberWeekly(m.weeklyTrees),
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ).staggerIn(context, i),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLeave(BuildContext context, WidgetRef ref) async {
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
              l10n.circleLeaveConfirm,
              style: Theme.of(sheetCtx).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.circleLeaveBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(sheetCtx).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: () => Navigator.pop(sheetCtx),
                child: Text(l10n.circleStay),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                await ref.read(circleRepositoryProvider).leave(circle.id);
                ref.invalidate(myCircleProvider);
                if (sheetCtx.mounted) Navigator.pop(sheetCtx);
              },
              child: Text(l10n.circleLeave),
            ),
          ],
        ),
      ),
    );
  }
}
