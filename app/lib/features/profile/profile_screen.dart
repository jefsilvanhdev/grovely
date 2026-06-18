import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/feature_scaffold.dart';

/// Perfil, streak e configurações — inclui gerenciar/cancelar assinatura.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureScaffold(
      title: l10n.profileTitle,
      message: l10n.profileTitle,
    );
  }
}
