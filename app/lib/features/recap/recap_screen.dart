import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/feature_scaffold.dart';

/// Recap semanal visual e compartilhável (card p/ Stories/Reels) — Agente E.
class RecapScreen extends StatelessWidget {
  const RecapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureScaffold(title: l10n.appName, message: l10n.appName);
  }
}
