import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/completed_tree.dart';
import '../repositories/session_repository.dart';

final sessionRepositoryProvider = Provider<SessionRepository>(
  (ref) => SessionRepository(),
);

/// Jardim pessoal — lista de árvores conquistadas, carregada do repositório.
class GardenNotifier extends AsyncNotifier<List<CompletedTree>> {
  @override
  Future<List<CompletedTree>> build() =>
      ref.read(sessionRepositoryProvider).load();

  /// Registra uma nova árvore (sessão concluída) e atualiza o jardim.
  Future<void> plant(CompletedTree tree) async {
    await ref.read(sessionRepositoryProvider).add(tree);
    state = AsyncData([tree, ...(state.value ?? const <CompletedTree>[])]);
  }
}

final gardenProvider =
    AsyncNotifierProvider<GardenNotifier, List<CompletedTree>>(
      GardenNotifier.new,
    );

/// Estatísticas derivadas do jardim (streak, totais, espécies).
class GardenStats {
  const GardenStats({
    required this.trees,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalMinutes,
    required this.species,
  });

  final int trees;
  final int currentStreak;
  final int longestStreak;
  final int totalMinutes;
  final int species;

  int get hours => totalMinutes ~/ 60;

  static const empty = GardenStats(
      trees: 0, currentStreak: 0, longestStreak: 0, totalMinutes: 0, species: 0);
}

GardenStats computeGardenStats(List<CompletedTree> trees) {
  if (trees.isEmpty) return GardenStats.empty;
  final totalMinutes = trees.fold<int>(0, (s, t) => s + t.durationMinutes);
  final species = trees.map((t) => t.type).toSet().length;
  final days = trees
      .map((t) => DateTime(t.completedAt.year, t.completedAt.month, t.completedAt.day))
      .toSet()
      .toList()
    ..sort();

  // streak atual: conta dias consecutivos terminando hoje (ou ontem).
  final today = DateTime.now();
  final t0 = DateTime(today.year, today.month, today.day);
  final daySet = days.toSet();
  var current = 0;
  if (daySet.contains(t0) || daySet.contains(t0.subtract(const Duration(days: 1)))) {
    var cursor = daySet.contains(t0) ? t0 : t0.subtract(const Duration(days: 1));
    while (daySet.contains(cursor)) {
      current++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
  }

  // maior streak: maior corrida de dias consecutivos.
  var longest = 1;
  var run = 1;
  for (var i = 1; i < days.length; i++) {
    if (days[i].difference(days[i - 1]).inDays == 1) {
      run++;
      longest = run > longest ? run : longest;
    } else {
      run = 1;
    }
  }

  return GardenStats(
    trees: trees.length,
    currentStreak: current,
    longestStreak: longest,
    totalMinutes: totalMinutes,
    species: species,
  );
}

final gardenStatsProvider = Provider<GardenStats>((ref) {
  final trees = ref.watch(gardenProvider).value ?? const <CompletedTree>[];
  return computeGardenStats(trees);
});
