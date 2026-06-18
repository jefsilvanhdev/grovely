import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/feature_scaffold.dart';

/// Jardim pessoal — grid de árvores conquistadas (Agente B).
class GardenScreen extends StatelessWidget {
  const GardenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureScaffold(title: l10n.gardenTitle, message: l10n.gardenEmpty);
  }
}
