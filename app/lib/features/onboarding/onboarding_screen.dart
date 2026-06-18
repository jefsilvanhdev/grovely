import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/grovely_logo.dart';

/// Onboarding (Agente E): boas-vindas → permissão notif → opt-in social →
/// primeira sessão guiada → paywall rígido. Fase 0: tela única com avanço.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GrovelyLogo(height: 56),
              const SizedBox(height: 24),
              Text(
                l10n.onboardingWelcome,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => context.go('/focus'),
                child: Text(l10n.commonContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
