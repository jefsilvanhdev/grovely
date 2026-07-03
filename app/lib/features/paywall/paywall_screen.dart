import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_mark.dart';

/// Paywall rígido e honesto (§7). RevenueCat/billing reais = Agente D.
/// Preços ainda placeholder (pendência do Jeff) — nunca mostra preço falso.
class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool annual = true;

  void _enterApp() {
    // Fim do funil de boas-vindas: cold starts seguintes pulam onboarding e
    // paywall (a splash lê esta flag). Fire-and-forget: prefs local não pode
    // segurar a navegação.
    unawaited(
      SharedPreferences.getInstance().then(
        (p) => p.setBool('onboarding_done', true),
      ),
    );
    context.go('/focus');
  }

  @override
  Widget build(BuildContext context) {
    // Paywall imersivo escuro (mockup v6 "premium paywall — dark"), com a
    // marca no topo — momento de brand, independente do tema do sistema.
    return Theme(
      data: AppTheme.dark(),
      child: Builder(builder: _buildDark),
    );
  }

  Widget _buildDark(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final rows = <(String, bool)>[
      (l10n.pwRowSoloFocus, true),
      (l10n.pwRowGarden, true),
      (l10n.pwRowOneCircle, true),
      (l10n.pwRowCustom, false),
      (l10n.pwRowSpecies, false),
      (l10n.pwRowStats, false),
      (l10n.pwRowMultiCircle, false),
      (l10n.pwRowRecap, false),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0F1A15),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              children: [
                const Center(child: GrovelyMark(size: 96, animate: false)),
                const SizedBox(height: 12),
                Text(
                  l10n.pwTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.pwSub,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Free vs Premium
                _CompareHeader(free: l10n.pwFree, premium: l10n.pwPremium),
                const SizedBox(height: 6),
                for (final (label, freeHas) in rows)
                  _CompareRow(label: label, free: freeHas),
                const SizedBox(height: 24),

                // Plan toggle (anchoring)
                _PlanToggle(
                  annual: annual,
                  annualLabel: l10n.pwAnnual,
                  monthlyLabel: l10n.pwMonthly,
                  saveLabel: l10n.pwSave,
                  onChanged: (v) => setState(() => annual = v),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: _enterApp,
                    child: Text(l10n.pwTrialCta),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  // Preço só volta aqui quando o RevenueCat trouxer o real —
                  // "preço a definir" na cara do usuário minava a confiança
                  // (usability P1, persona cética).
                  l10n.pwTrialSub,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                Center(
                  child: TextButton(
                    onPressed: _enterApp,
                    child: Text(l10n.pwContinueFree),
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      l10n.pwRestore,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CompareHeader extends StatelessWidget {
  const _CompareHeader({required this.free, required this.premium});
  final String free;
  final String premium;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        const Expanded(flex: 3, child: SizedBox()),
        Expanded(
          flex: 2,
          child: Text(
            free,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            premium,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: scheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class _CompareRow extends StatelessWidget {
  const _CompareRow({required this.label, required this.free});
  final String label;
  final bool free;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget mark(bool on) => Icon(
      on ? Icons.check_circle : Icons.remove,
      size: 18,
      color: on ? scheme.primary : scheme.outline,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          Expanded(flex: 2, child: Center(child: mark(free))),
          Expanded(flex: 2, child: Center(child: mark(true))),
        ],
      ),
    );
  }
}

class _PlanToggle extends StatelessWidget {
  const _PlanToggle({
    required this.annual,
    required this.annualLabel,
    required this.monthlyLabel,
    required this.saveLabel,
    required this.onChanged,
  });
  final bool annual;
  final String annualLabel;
  final String monthlyLabel;
  final String saveLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget seg(String label, bool isAnnual) {
      final sel = annual == isAnnual;
      return Expanded(
        // TalkBack: toggle anual/mensal precisa anunciar e ativar (QA I6).
        child: Semantics(
          button: true,
          selected: sel,
          label: label,
          child: GestureDetector(
            onTap: () => onChanged(isAnnual),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: sel ? scheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: sel ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
                  if (isAnnual) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: sel ? scheme.onPrimary : scheme.secondary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        saveLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: sel ? scheme.primary : scheme.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(children: [seg(annualLabel, true), seg(monthlyLabel, false)]),
    );
  }
}
