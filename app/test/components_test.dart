import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grovely/data/providers/entitlement_provider.dart';
import 'package:grovely/data/services/presence_service.dart';
import 'package:grovely/shared/widgets/grovely_components.dart';

void main() {
  group('Entitlement', () {
    test('free não é pagante', () {
      expect(Entitlement.free.status, PlanStatus.free);
      expect(Entitlement.free.isPaying, false);
    });

    test('trial e plus são pagantes', () {
      expect(const Entitlement(PlanStatus.trial).isPaying, true);
      expect(const Entitlement(PlanStatus.plus).isPaying, true);
    });
  });

  group('CirclePresence', () {
    test('vazio: 0 online, 0 focando', () {
      const p = CirclePresence();
      expect(p.online, 0);
      expect(p.focusingCount, 0);
    });

    test('focusingCount = tamanho do set', () {
      const p = CirclePresence(online: 5, focusing: {'a', 'b'});
      expect(p.focusingCount, 2);
    });

    test('copyWith preserva o não passado', () {
      const p = CirclePresence(online: 3, focusing: {'a'});
      final q = p.copyWith(online: 7);
      expect(q.online, 7);
      expect(q.focusing, {'a'});
    });
  });

  group('avatarColor', () {
    testWidgets('determinístico: mesmo userId → mesma cor', (tester) async {
      late (Color, Color) c1, c2, cOther;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              c1 = avatarColor(context, 'user-123');
              c2 = avatarColor(context, 'user-123');
              cOther = avatarColor(context, 'user-999');
              return const SizedBox();
            },
          ),
        ),
      );
      expect(c1, c2); // estável para a mesma pessoa
      // Pessoas diferentes normalmente diferem (não garantido, mas provável);
      // o essencial é a estabilidade acima. cOther só exercita o caminho.
      expect(cOther.$1, isA<Color>());
    });
  });

  group('MemberAvatar', () {
    testWidgets('sem foto: mostra a inicial em maiúscula', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MemberAvatar(userId: 'u1', displayName: 'nicole'),
          ),
        ),
      );
      expect(find.text('N'), findsOneWidget);
    });

    testWidgets('nome vazio: mostra "?"', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: MemberAvatar(userId: 'u1', displayName: '')),
        ),
      );
      expect(find.text('?'), findsOneWidget);
    });
  });
}
