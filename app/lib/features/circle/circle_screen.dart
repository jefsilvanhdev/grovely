import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/circle.dart';
import '../../data/providers/circle_provider.dart';
import '../../data/repositories/circle_repository.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';

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
          error: (_, _) => _Empty(),
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
    return Stack(
      alignment: Alignment.center,
      children: [
        const SymbolWatermark(size: 300),
        Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.circleEmptyTitle,
                  textAlign: TextAlign.center, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(l10n.circleEmptySub,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 28),
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.lock_outline, size: 13, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Flexible(
                    child: Text(l10n.circlePrivacy,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
              ]),
            ],
          ),
        ),
      ],
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
          24, 4, 24, MediaQuery.of(sheetCtx).viewInsets.bottom + 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.circleCreate, style: Theme.of(sheetCtx).textTheme.titleLarge),
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
            24, 4, 24, MediaQuery.of(sheetCtx).viewInsets.bottom + 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.circleJoinTitle, style: Theme.of(sheetCtx).textTheme.titleLarge),
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
                    setSheet(() => error = e.kind == CircleError.full
                        ? l10n.circleFull
                        : l10n.circleInvalidCode);
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
                  child: Text(circle.name, style: theme.textTheme.headlineSmall)),
              IconButton(
                tooltip: l10n.circleInvite,
                onPressed: () => SharePlus.instance.share(
                    ShareParams(text: '${circle.name} · Grovely: ${circle.inviteCode}')),
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
          Text('${l10n.circleCodeLabel}: ${circle.inviteCode}',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 16),
          members.when(
            loading: () => const Center(
                child: Padding(
                    padding: EdgeInsets.all(24),
                    child: CircularProgressIndicator())),
            error: (_, _) => Text(l10n.commonError),
            data: (list) {
              final planted = list.fold<int>(0, (s, m) => s + m.weeklyTrees);
              final goal = (list.length * 5).clamp(5, 999);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta coletiva
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.circleGoal(planted, goal),
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: goal == 0 ? 0 : (planted / goal).clamp(0, 1),
                            minHeight: 10,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.circleMembers, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  for (final m in list)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          m.displayName.isNotEmpty
                              ? m.displayName[0].toUpperCase()
                              : '?',
                          style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                        ),
                      ),
                      title: Text(m.displayName),
                      trailing: Text(l10n.memberWeekly(m.weeklyTrees),
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                    ),
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
            Text(l10n.circleLeaveConfirm,
                style: Theme.of(sheetCtx).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(l10n.circleLeaveBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(sheetCtx).colorScheme.onSurfaceVariant)),
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
