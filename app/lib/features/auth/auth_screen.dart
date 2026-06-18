import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/feature_scaffold.dart';

/// Login/cadastro via Supabase Auth. Estrutura criada na Fase 0; fluxo real
/// entra junto com a camada social (Agente C) e o onboarding (Agente E).
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FeatureScaffold(title: l10n.appName, message: l10n.appName);
  }
}
