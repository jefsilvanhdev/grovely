import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/completed_tree.dart';
import '../repositories/session_repository.dart';

final sessionRepositoryProvider =
    Provider<SessionRepository>((ref) => SessionRepository());

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
        GardenNotifier.new);
