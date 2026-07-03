import 'package:flutter_test/flutter_test.dart';
import 'package:grovely/data/models/completed_tree.dart';
import 'package:grovely/data/models/tree.dart';
import 'package:grovely/data/providers/garden_provider.dart';

CompletedTree _tree({
  TreeType type = TreeType.oak,
  int minutes = 25,
  required DateTime at,
}) => CompletedTree(type: type, durationMinutes: minutes, completedAt: at);

void main() {
  // Meio-dia de hoje: somar horas nos testes nunca cruza a meia-noite
  // (com DateTime.now() cru, rodar o teste depois das 22h virava outro dia).
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day, 12);
  DateTime daysAgo(int d) => today.subtract(Duration(days: d));

  group('computeGardenStats', () {
    test('jardim vazio → GardenStats.empty', () {
      final s = computeGardenStats(const []);
      expect(s.trees, 0);
      expect(s.currentStreak, 0);
      expect(s.longestStreak, 0);
      expect(s.totalMinutes, 0);
      expect(s.species, 0);
    });

    test('totais: árvores, minutos, horas e espécies distintas', () {
      final trees = [
        _tree(type: TreeType.oak, minutes: 60, at: today),
        _tree(type: TreeType.pine, minutes: 45, at: today),
        _tree(type: TreeType.oak, minutes: 15, at: today), // mesma espécie
      ];
      final s = computeGardenStats(trees);
      expect(s.trees, 3);
      expect(s.totalMinutes, 120);
      expect(s.hours, 2);
      expect(s.species, 2); // oak + pine
    });

    test('streak atual conta dias consecutivos terminando hoje', () {
      final trees = [
        _tree(at: today),
        _tree(at: daysAgo(1)),
        _tree(at: daysAgo(2)),
      ];
      final s = computeGardenStats(trees);
      expect(s.currentStreak, 3);
      expect(s.longestStreak, 3);
    });

    test('streak atual vale quando termina ontem (hoje ainda sem sessão)', () {
      final trees = [_tree(at: daysAgo(1)), _tree(at: daysAgo(2))];
      final s = computeGardenStats(trees);
      expect(s.currentStreak, 2);
    });

    test('lacuna zera o streak atual mas preserva o maior', () {
      final trees = [
        _tree(at: today), // streak atual = 1
        // lacuna em daysAgo(1)
        _tree(at: daysAgo(2)),
        _tree(at: daysAgo(3)),
        _tree(at: daysAgo(4)), // corrida de 3 dias
      ];
      final s = computeGardenStats(trees);
      expect(s.currentStreak, 1);
      expect(s.longestStreak, 3);
    });

    test('várias sessões no mesmo dia contam como 1 dia de streak', () {
      final trees = [
        _tree(at: today),
        _tree(at: today.add(const Duration(hours: 1))),
        _tree(at: today.add(const Duration(hours: 2))),
      ];
      final s = computeGardenStats(trees);
      expect(s.trees, 3);
      expect(s.currentStreak, 1);
      expect(s.longestStreak, 1);
    });

    test('streak atual = 0 quando a sessão mais recente é antiga', () {
      final trees = [_tree(at: daysAgo(5)), _tree(at: daysAgo(6))];
      final s = computeGardenStats(trees);
      expect(s.currentStreak, 0);
      expect(s.longestStreak, 2);
    });
  });
}
