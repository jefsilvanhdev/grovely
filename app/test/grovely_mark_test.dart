import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grovely/shared/widgets/grovely_mark.dart';

/// Marca dentro de um MediaQuery com reduce-motion ligado/desligado.
Widget _host({required bool reduceMotion, bool animate = true}) => MediaQuery(
  data: MediaQueryData(disableAnimations: reduceMotion),
  child: Directionality(
    textDirection: TextDirection.ltr,
    child: GrovelyMark(animate: animate),
  ),
);

void main() {
  group('GrovelyMark', () {
    testWidgets('reduce-motion: assenta sem timer infinito (sway off)', (
      tester,
    ) async {
      await tester.pumpWidget(_host(reduceMotion: true));
      // pumpAndSettle só retorna se NÃO há animação perpétua. Com reduce-motion,
      // a marca pinta o estado final e o sway nunca arranca.
      await tester.pumpAndSettle();
      expect(find.byType(GrovelyMark), findsOneWidget);
    });

    testWidgets('animate=false: estático mesmo sem reduce-motion', (
      tester,
    ) async {
      await tester.pumpWidget(_host(reduceMotion: false, animate: false));
      await tester.pumpAndSettle();
      expect(find.byType(GrovelyMark), findsOneWidget);
    });

    testWidgets('animado: cresce, sway arranca e dispose limpa (sem leak)', (
      tester,
    ) async {
      await tester.pumpWidget(_host(reduceMotion: false));
      // Deixa o crescimento terminar (1200ms) — o sway passa a repetir.
      await tester.pump(const Duration(milliseconds: 1300));
      // Desmonta: dispose deve cancelar o sway e os controllers. Se vazasse,
      // o teardown do teste acusaria ticker pendente.
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox.shrink(),
        ),
      );
      await tester.pump();
      expect(find.byType(GrovelyMark), findsNothing);
    });
  });
}
