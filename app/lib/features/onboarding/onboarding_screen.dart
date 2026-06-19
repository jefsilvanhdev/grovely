import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/models/tree.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_components.dart';
import '../../shared/widgets/grovely_logo.dart';
import '../focus_session/widgets/tree_view.dart';

/// Onboarding (§1): welcome → notificações → opt-in social → sessão guiada →
/// paywall. Conta é opcional (anônimo); upgrade depois.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _step = 0;
  static const _steps = 5; // welcome, notif, social, guided, (paywall route)

  void _next() {
    if (_step >= 3) {
      context.go('/paywall'); // passo 5 = paywall
    } else {
      setState(() => _step++);
    }
  }

  void _back() => setState(() => _step = (_step - 1).clamp(0, _steps));

  @override
  Widget build(BuildContext context) {
    final canSkip = _step == 1 || _step == 2;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // chrome: back + dots + skip
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    child: _step > 0
                        ? IconButton(
                            onPressed: _back,
                            icon: const Icon(Icons.arrow_back))
                        : null,
                  ),
                  Expanded(child: _Dots(active: _step, total: _steps)),
                  SizedBox(
                    width: 56,
                    child: canSkip
                        ? TextButton(
                            onPressed: _next,
                            child: Text(AppLocalizations.of(context).commonSkip))
                        : null,
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: switch (_step) {
                  0 => _Welcome(key: const ValueKey(0), onNext: _next),
                  1 => _Notif(key: const ValueKey(1), onNext: _next),
                  2 => _Social(key: const ValueKey(2), onNext: _next),
                  _ => _Guided(key: const ValueKey(3), onDone: _next),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.active, required this.total});
  final int active;
  final int total;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < total; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == active ? 20 : 7,
            height: 7,
            decoration: BoxDecoration(
              color: i == active ? scheme.primary : scheme.outline,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}

class _Welcome extends StatelessWidget {
  const _Welcome({super.key, required this.onNext});
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        const SymbolWatermark(size: 320),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            children: [
              const Spacer(),
              const GrovelyLogo(height: 64),
              const SizedBox(height: 20),
              Text(l10n.onboardingWelcome,
                  textAlign: TextAlign.center, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 10),
              Text(l10n.onbWelcomeSub,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(onPressed: onNext, child: Text(l10n.onbGetStarted)),
              ),
              const SizedBox(height: 4),
              TextButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(l10n.onbHaveAccount)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Notif extends StatelessWidget {
  const _Notif({super.key, required this.onNext});
  final VoidCallback onNext;
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget bullet(String t) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [
            Icon(Icons.check_circle, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(t, style: theme.textTheme.bodyMedium)),
          ]),
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        children: [
          const Spacer(),
          Icon(Icons.notifications_active_outlined,
              size: 56, color: theme.colorScheme.secondary),
          const SizedBox(height: 16),
          Text(l10n.onbNotifTitle,
              textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          bullet(l10n.onbNotifBullet1),
          bullet(l10n.onbNotifBullet2),
          bullet(l10n.onbNotifBullet3),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            // TODO(Agente E): disparar prompt OS de notificação aqui.
            child: FilledButton(onPressed: onNext, child: Text(l10n.onbNotifCta)),
          ),
          const SizedBox(height: 4),
          TextButton(onPressed: onNext, child: Text(l10n.onbNotNow)),
        ],
      ),
    );
  }
}

class _Social extends StatefulWidget {
  const _Social({super.key, required this.onNext});
  final VoidCallback onNext;
  @override
  State<_Social> createState() => _SocialState();
}

class _SocialState extends State<_Social> {
  bool solo = true; // default solo (honesto: não pré-opta no social)

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    Widget choice(String title, String desc, bool isSolo, {bool recommended = false}) {
      final sel = solo == isSolo;
      return GestureDetector(
        onTap: () => setState(() => solo = isSolo),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: sel ? theme.colorScheme.primaryContainer : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: sel ? theme.colorScheme.primary : theme.colorScheme.outline,
                width: sel ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(title, style: theme.textTheme.titleMedium),
                if (recommended) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(l10n.onbRecommended,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSecondary)),
                  ),
                ],
              ]),
              const SizedBox(height: 4),
              Text(desc,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          Text(l10n.onbSocialTitle,
              textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(l10n.onbSocialSub,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          const Spacer(),
          choice(l10n.onbSoloTitle, l10n.onbSoloDesc, true),
          choice(l10n.onbCircleTitle, l10n.onbCircleDesc, false, recommended: true),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.lock_outline, size: 13, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Flexible(
                child: Text(l10n.onbPrivacy,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
          ]),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
                onPressed: widget.onNext, child: Text(l10n.commonContinue)),
          ),
        ],
      ),
    );
  }
}

/// Sessão guiada de 5 min — perdoa background (tutorial), auto-avança ao fim.
class _Guided extends StatefulWidget {
  const _Guided({super.key, required this.onDone});
  final VoidCallback onDone;
  @override
  State<_Guided> createState() => _GuidedState();
}

class _GuidedState extends State<_Guided> {
  static const total = 30; // 30s — recompensa rápida no onboarding
  Timer? _timer;
  int _remaining = total;
  bool _started = false;
  bool _done = false;

  double get _progress => (total - _remaining) / total;
  TreeStage get _stage =>
      _done ? TreeStage.mature : TreeStage.fromProgress(_progress);

  void _begin() {
    setState(() => _started = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 1) {
        _timer?.cancel();
        setState(() => _done = true);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final mm = (_remaining ~/ 60).toString().padLeft(2, '0');
    final ss = (_remaining % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          Text(_done ? l10n.onbGuidedDone : l10n.onbGuidedCoach,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium),
          Expanded(
            child: Center(
              child: TimerRing(
                progress: _done ? 1 : _progress,
                size: 240,
                child: TreeView(type: TreeType.oak, stage: _stage, size: 150),
              ),
            ),
          ),
          if (_started && !_done)
            Text('$mm:$ss',
                style: theme.textTheme.displaySmall),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: _done
                  ? widget.onDone
                  : (_started ? null : _begin),
              child: Text(_done ? l10n.commonContinue : l10n.onbBegin),
            ),
          ),
        ],
      ),
    );
  }
}
