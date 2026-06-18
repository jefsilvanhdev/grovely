import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/feature_scaffold.dart';

/// Liga semanal — tiers e ranking entre membros (Agente C).
class LeagueScreen extends StatelessWidget {
  const LeagueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureScaffold(title: l10n.leagueTitle, message: l10n.leagueTitle);
  }
}
