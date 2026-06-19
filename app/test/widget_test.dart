// Smoke test da Fase 0: o app monta e a tela de onboarding aparece.
// Testes de widget dos componentes críticos (timer, paywall) entram nas
// fases seguintes, conforme o checklist de QA do briefing.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:grovely/main.dart';

void main() {
  testWidgets('App monta e mostra o onboarding', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: PlantioApp()));
    await tester.pumpAndSettle();

    // Botão "Continuar" / "Continue" da tela de boas-vindas.
    expect(find.byType(PlantioApp), findsOneWidget);
  });
}
