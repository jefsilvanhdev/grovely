import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/models/completed_tree.dart';
import '../../data/models/tree.dart';
import '../../data/providers/garden_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';
import '../focus_session/widgets/tree_view.dart';

/// Recap semanal compartilhável (§6) — card 9:16-friendly + share.
class RecapScreen extends ConsumerStatefulWidget {
  const RecapScreen({super.key});

  @override
  ConsumerState<RecapScreen> createState() => _RecapScreenState();
}

class _RecapScreenState extends ConsumerState<RecapScreen> {
  final _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) return;
      final file = await File(
              '${Directory.systemTemp.path}/grovely-recap-${DateTime.now().millisecondsSinceEpoch}.png')
          .writeAsBytes(bytes.buffer.asUint8List());
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)]),
      );
    } catch (_) {
      // silencioso — share cancelado/falhou; card segue na tela.
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final trees = ref.watch(gardenProvider).value ?? const <CompletedTree>[];

    final now = DateTime.now();
    final weekStart = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final weekly =
        trees.where((t) => !t.completedAt.isBefore(weekStart)).toList();
    final minutes = weekly.fold<int>(0, (s, t) => s + t.durationMinutes);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.recapTitle)),
      body: SafeArea(
        child: weekly.isEmpty
            ? _Empty()
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  RepaintBoundary(
                    key: _cardKey,
                    child: _RecapCard(
                      count: weekly.length,
                      minutes: minutes,
                      streak: ref.watch(gardenStatsProvider).currentStreak,
                      species: weekly.map((t) => t.type).toSet().toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: _sharing ? null : _share,
                      icon: _sharing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.ios_share),
                      label: Text(l10n.recapShare),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _RecapCard extends StatelessWidget {
  const _RecapCard({
    required this.count,
    required this.minutes,
    required this.streak,
    required this.species,
  });
  final int count;
  final int minutes;
  final int streak;
  final List<TreeType> species;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AspectRatio(
      aspectRatio: 9 / 16,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF34855A), Color(0xFF1C4A33)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Grovely',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800)),
            const Spacer(),
            Text('$count',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 96,
                    height: 1,
                    fontWeight: FontWeight.w800)),
            Text(l10n.recapHeroLabel(count),
                style: const TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 8),
            Text(l10n.recapSub(minutes ~/ 60, minutes % 60),
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85), fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              children: [
                for (final t in species.take(6))
                  SizedBox(
                      width: 44,
                      height: 56,
                      child: TreeView(type: t, stage: TreeStage.elder, size: 44)),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.local_fire_department,
                    color: Color(0xFFF0B978), size: 18),
                const SizedBox(width: 6),
                Text(l10n.streakDays(streak),
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const Spacer(),
                Text(l10n.recapFooter,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        const SymbolWatermark(size: 300),
        Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.recapEmpty,
                  textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(l10n.recapEmptySub,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.go('/focus'),
                child: Text(l10n.plantFirst),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
