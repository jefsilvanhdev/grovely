import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/feature_scaffold.dart';

/// Core loop — timer de foco + árvore animada (Agente B).
class FocusSessionScreen extends StatelessWidget {
  const FocusSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureScaffold(title: l10n.focusTitle, message: l10n.focusSubtitle);
  }
}
