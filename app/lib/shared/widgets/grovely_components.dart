import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/tree.dart';
import '../../l10n/app_localizations.dart';

/// Estado vazio unificado: ícone + título + corpo + ação opcional, centrado.
/// Padrão único para garden/circle/league/recap (corrige alinhamentos soltos).
class GrovelyEmpty extends StatelessWidget {
  const GrovelyEmpty({
    super.key,
    required this.icon,
    required this.title,
    this.body,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(GrovelySpacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: theme.colorScheme.primary),
            const SizedBox(height: GrovelySpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            if (body != null) ...[
              const SizedBox(height: GrovelySpacing.sm),
              Text(
                body!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: GrovelySpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

/// Estado de erro unificado: mensagem + (opcional) botão "tentar de novo".
/// Padrão único para garden/circle/league (corrige erros ad-hoc soltos).
class GrovelyError extends StatelessWidget {
  const GrovelyError({super.key, this.onRetry, this.message});

  /// Callback de retry; se nulo, o botão some (ex.: erro dentro de um card).
  final VoidCallback? onRetry;

  /// Mensagem custom; default = `l10n.commonError`.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GrovelySpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? l10n.commonError,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: GrovelySpacing.md),
              OutlinedButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bloco de carregamento com shimmer (DS §skeleton). Primitivo reutilizável
/// para montar telas de loading consistentes (garden/circle/league).
class GrovelySkeletonBox extends StatelessWidget {
  const GrovelySkeletonBox({super.key, this.height, this.radius = 14});

  /// Altura fixa; se nula, ocupa o espaço do pai (ex.: célula de grid).
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final box = Container(
      height: height,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    // Reduce-motion: bloco estático, sem shimmer perpétuo (QA M9).
    if (GrovelyMotion.reduced(context)) return box;
    return box
        .animate(onPlay: (ctrl) => ctrl.repeat())
        .shimmer(duration: 1200.ms, color: scheme.surface);
  }
}

/// Decoração padrão de card de superfície: sombra suave no claro, borda no
/// escuro (DS §elevation). Usar em todo card, em vez de Container+border ad-hoc.
BoxDecoration grovelyCard(BuildContext context, {double radius = 20}) {
  final scheme = Theme.of(context).colorScheme;
  final dark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: scheme.surface,
    borderRadius: BorderRadius.circular(radius),
    border: dark ? Border.all(color: scheme.outline) : null,
    boxShadow: dark ? null : GrovelyElevation.level2,
  );
}

/// Feedback de toque: leve scale-down + haptic. Honra reduce-motion.
/// [semanticLabel] expõe o toque como botão pro leitor de tela — sem ele,
/// GestureDetector puro é invisível pro TalkBack (QA I6).
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
  });
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final reduced = GrovelyMotion.reduced(context);
    final child = GestureDetector(
      onTapDown: (_) {
        setState(() => _down = true);
        HapticFeedback.selectionClick();
      },
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: (_down && !reduced) ? 0.97 : 1,
        duration: GrovelyMotion.fast,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
    if (widget.semanticLabel == null) return child;
    return Semantics(
      button: widget.onTap != null,
      label: widget.semanticLabel,
      child: child,
    );
  }
}

/// Entrada encadeada (stagger) para itens de lista — honra reduce-motion.
/// Delay tem teto: com acervo grande (24+ tiles) a onda escalava com a lista
/// e rodava ~1s+ a cada visita (review populado P1-1).
extension GrovelyStagger on Widget {
  Widget staggerIn(BuildContext context, int index) {
    if (GrovelyMotion.reduced(context)) return this;
    return animate(delay: (index.clamp(0, 10) * 45).ms)
        .fadeIn(duration: 280.ms)
        .slideY(
          begin: 0.12,
          end: 0,
          curve: Curves.easeOutCubic,
          duration: 320.ms,
        );
  }
}

/// Cor determinística de avatar por pessoa — a mesma pessoa tem a mesma cor
/// em toda tela. Sem isso, 8 membros viram 8 bolinhas idênticas (review
/// populado P1-4). Retorna (fundo, texto).
(Color, Color) avatarColor(BuildContext context, String userId) {
  final scheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final accent = isDark ? AppColors.accentDark : AppColors.accent;
  final healthy = isDark ? AppColors.treeHealthyDark : AppColors.treeHealthy;
  final pairs = <(Color, Color)>[
    (scheme.primaryContainer, scheme.onPrimaryContainer),
    (accent.withValues(alpha: 0.28), scheme.onSurface),
    (healthy.withValues(alpha: 0.24), scheme.onSurface),
    (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
    (scheme.primary.withValues(alpha: 0.18), scheme.onSurface),
    (
      const Color(0xFFF4C6D0).withValues(alpha: isDark ? 0.3 : 0.6),
      scheme.onSurface,
    ),
  ];
  return pairs[userId.hashCode.abs() % pairs.length];
}

/// Nome localizado da espécie (preview de foco, detalhe da árvore).
String speciesName(AppLocalizations l10n, TreeType type) => switch (type) {
  TreeType.oak => l10n.speciesOak,
  TreeType.pine => l10n.speciesPine,
  TreeType.roundBush => l10n.speciesRoundBush,
  TreeType.willow => l10n.speciesWillow,
  TreeType.birch => l10n.speciesBirch,
  TreeType.cherryBlossom => l10n.speciesCherryBlossom,
};

/// Pill de sequência — chama o motivo do sol (chama/flame) em accent.
class StreakBadge extends StatelessWidget {
  const StreakBadge({super.key, required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.accentDark : AppColors.accent;
    final label = count > 0 ? l10n.streakDays(count) : l10n.streakStart;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.22 : 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, size: 16, color: accent),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pill de estatística — glifo + valor já formatado.
class StatPill extends StatelessWidget {
  const StatPill({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Seletor de duração — pill segmentado (substitui os ChoiceChips).
class DurationDial extends StatelessWidget {
  const DurationDial({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<int> options;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          for (final min in options)
            Expanded(
              // TalkBack: sem isto o dial é invisível pro leitor de tela e o
              // usuário nem descobre que existe escolha de duração (QA I6).
              child: Semantics(
                button: true,
                selected: selected == min,
                label: AppLocalizations.of(context).minutesShort(min),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelected(min);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected == min
                          ? scheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$min',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: selected == min
                            ? scheme.onPrimary
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Anel de progresso ao redor da árvore.
class TimerRing extends StatelessWidget {
  const TimerRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 260,
  });

  final double progress;
  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Sweep contínuo: interpola o progresso entre os ticks de 1s (não salta).
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: progress.clamp(0, 1)),
        duration: GrovelyMotion.dur(context, const Duration(seconds: 1)),
        curve: Curves.linear,
        builder: (context, value, _) => CustomPaint(
          painter: _RingPainter(
            progress: value,
            track: scheme.outline,
            arc: scheme.primary,
          ),
          child: Center(
            child: SizedBox(
              width: size * 0.78,
              height: size * 0.78,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.track,
    required this.arc,
  });
  final double progress;
  final Color track;
  final Color arc;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 4;
    const stroke = 7.0;
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = track;
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = arc;
    canvas.drawCircle(center, radius, trackPaint);
    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweep,
      false,
      arcPaint,
    );
    // Ponta viva: dot + glow na cabeça do arco.
    if (progress > 0) {
      final a = -math.pi / 2 + sweep;
      final head = center + Offset(math.cos(a), math.sin(a)) * radius;
      canvas.drawCircle(
        head,
        stroke * 1.6,
        Paint()..color = arc.withValues(alpha: 0.25),
      );
      canvas.drawCircle(head, stroke * 0.8, Paint()..color = arc);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.progress != progress || old.track != track || old.arc != arc;
}

/// Marca d'água do símbolo Grovely atrás de momentos-herói (faint).
class SymbolWatermark extends StatelessWidget {
  const SymbolWatermark({super.key, this.size = 280, this.opacity = 0.06});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: SvgPicture.asset(
          'assets/brand/logo/grovely-symbol.svg',
          width: size,
          height: size,
        ),
      ),
    );
  }
}
