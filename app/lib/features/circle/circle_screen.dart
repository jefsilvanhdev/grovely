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
          error: (_, _) =>
              GrovelyError(onRetry: () => ref.invalidate(myCircleProvider)),
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

Future<void> _createSheet(BuildContext context, WidgetRef ref) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CircleFormSheet.create(ref: ref),
    );

Future<void> _joinSheet(BuildContext context, WidgetRef ref) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CircleFormSheet.join(ref: ref),
    );

/// Sheet de criar/entrar num círculo: controller com dispose, botão trava
/// durante o await (sem double-tap = dois círculos) e erro de rede aparece
/// como offline, não como "código inválido" (QA C3/I5/M2).
class _CircleFormSheet extends StatefulWidget {
  const _CircleFormSheet.create({required this.ref}) : isJoin = false;
  const _CircleFormSheet.join({required this.ref}) : isJoin = true;

  final WidgetRef ref;
  final bool isJoin;

  @override
  State<_CircleFormSheet> createState() => _CircleFormSheetState();
}

class _CircleFormSheetState extends State<_CircleFormSheet> {
  final _ctrl = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context);
    final value = _ctrl.text.trim();
    if (value.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repo = widget.ref.read(circleRepositoryProvider);
      if (widget.isJoin) {
        await repo.joinByCode(value);
      } else {
        await repo.create(value);
      }
      widget.ref.invalidate(myCircleProvider);
      if (mounted) Navigator.pop(context);
    } on CircleException catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = switch (e.kind) {
          CircleError.full => l10n.circleFull,
          CircleError.offline => l10n.circleOffline,
          CircleError.notFound => l10n.circleInvalidCode,
          CircleError.unknown =>
            widget.isJoin ? l10n.circleInvalidCode : l10n.commonError,
        };
      });
    } on Object {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = l10n.commonError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
            widget.isJoin ? l10n.circleJoinTitle : l10n.circleCreate,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            autofocus: true,
            enabled: !_busy,
            textCapitalization: widget.isJoin
                ? TextCapitalization.characters
                : TextCapitalization.sentences,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: widget.isJoin
                  ? l10n.circleCodeLabel
                  : l10n.circleNameLabel,
              hintText: widget.isJoin ? null : l10n.circleNameHint,
              border: const OutlineInputBorder(),
              errorText: _error,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Text(
                      widget.isJoin ? l10n.circleJoinCta : l10n.circleCreateCta,
                    ),
            ),
          ),
        ],
      ),
    );
  }
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
            error: (_, _) => const GrovelyError(),
            data: (list) {
              final planted = list.fold<int>(0, (s, m) => s + m.weeklyTrees);
              final goal = (list.length * 5).clamp(5, 999);
              final goalReached = planted >= goal;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta coletiva — card do bosque com respiro mint (mockup v6)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: grovelyCard(context).copyWith(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.colorScheme.primaryContainer.withValues(
                            alpha: 0.45,
                          ),
                          theme.colorScheme.surface,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.circleGroveOverline.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                try {
                  await ref.read(circleRepositoryProvider).leave(circle.id);
                  ref.invalidate(myCircleProvider);
                  if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                } on Object {
                  if (!sheetCtx.mounted) return;
                  Navigator.pop(sheetCtx);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.commonError)));
                }
              },
              child: Text(l10n.circleLeave),
            ),
          ],
        ),
      ),
    );
  }
}
