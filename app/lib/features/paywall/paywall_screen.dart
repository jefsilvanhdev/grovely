import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/feature_scaffold.dart';

/// Paywall rígido — RevenueCat, trial 21 dias, anchoring anual (Agente D).
class PaywallScreen extends StatelessWidget {
  const PaywallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureScaffold(
      title: l10n.paywallTitle,
      message: l10n.paywallTitle,
    );
  }
}
