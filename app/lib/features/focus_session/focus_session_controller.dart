import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/completed_tree.dart';
import '../../data/models/tree.dart';
import '../../data/providers/garden_provider.dart';

enum FocusPhase { selecting, running, completed, withered }

class FocusState {
  const FocusState({
    required this.phase,
    required this.durationMinutes,
    required this.secondsRemaining,
    required this.treeType,
  });

  final FocusPhase phase;
  final int durationMinutes;
  final int secondsRemaining;
  final TreeType treeType;

  int get totalSeconds => durationMinutes * 60;

  /// Progresso 0..1 da sessão (base do crescimento da árvore).
  double get progress {
    if (phase == FocusPhase.completed) return 1;
    if (totalSeconds == 0) return 0;
    return ((totalSeconds - secondsRemaining) / totalSeconds).clamp(0, 1);
  }

  TreeStage get stage => phase == FocusPhase.withered
      ? TreeStage.withered
      : TreeStage.fromProgress(progress);

  FocusState copyWith({
    FocusPhase? phase,
    int? durationMinutes,
    int? secondsRemaining,
    TreeType? treeType,
  }) => FocusState(
    phase: phase ?? this.phase,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    secondsRemaining: secondsRemaining ?? this.secondsRemaining,
    treeType: treeType ?? this.treeType,
  );
}

/// Máquina de estados do core loop: selecionar → focar → concluir/murchar.
class FocusSessionController extends Notifier<FocusState> {
  Timer? _timer;
  Timer? _graceTimer;

  static const durationOptions = [15, 25, 45, 60];

  /// Carência p/ pausas transitórias (ligação, notificação, troca rápida de
  /// app). Só murcha se o app ficar em background além disso. Tunável —
  /// decisão de produto.
  static const witherGraceSeconds = 5;

  @override
  FocusState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _graceTimer?.cancel();
    });
    return FocusState(
      phase: FocusPhase.selecting,
      durationMinutes: 25,
      secondsRemaining: 25 * 60,
      treeType: _randomTree(),
    );
  }

  TreeType _randomTree() =>
      TreeType.values[Random().nextInt(TreeType.values.length)];

  void setDuration(int minutes) {
    if (state.phase != FocusPhase.selecting) return;
    state = state.copyWith(
      durationMinutes: minutes,
      secondsRemaining: minutes * 60,
    );
  }

  void start() {
    if (state.phase != FocusPhase.selecting) return;
    state = state.copyWith(
      phase: FocusPhase.running,
      secondsRemaining: state.totalSeconds,
    );
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final remaining = state.secondsRemaining - 1;
    if (remaining <= 0) {
      _complete();
    } else {
      state = state.copyWith(secondsRemaining: remaining);
    }
  }

  Future<void> _complete() async {
    _timer?.cancel();
    _graceTimer?.cancel();
    state = state.copyWith(phase: FocusPhase.completed, secondsRemaining: 0);
    await ref
        .read(gardenProvider.notifier)
        .plant(
          CompletedTree(
            type: state.treeType,
            durationMinutes: state.durationMinutes,
            completedAt: DateTime.now(),
          ),
        );
  }

  /// Ficou fora do app além da carência → árvore murcha.
  void wither() {
    if (state.phase != FocusPhase.running) return;
    _timer?.cancel();
    _graceTimer?.cancel();
    state = state.copyWith(phase: FocusPhase.withered);
  }

  /// App foi pro background durante a sessão → inicia carência; só murcha se
  /// não voltar a tempo (perdoa interrupções involuntárias).
  void onAppPaused() {
    if (state.phase != FocusPhase.running) return;
    _graceTimer?.cancel();
    _graceTimer = Timer(const Duration(seconds: witherGraceSeconds), wither);
  }

  /// Voltou ao app dentro da carência → cancela a murcha.
  void onAppResumed() => _graceTimer?.cancel();

  /// Revive a árvore murcha (após rewarded ad — wiring real do anúncio é do
  /// Agente D). Planta a sessão como concluída. Permitido só a partir de murcha.
  Future<void> revive() async {
    if (state.phase != FocusPhase.withered) return;
    await _complete();
  }

  /// Volta para a seleção (nova árvore aleatória).
  void reset() {
    _timer?.cancel();
    _graceTimer?.cancel();
    state = build();
  }
}

final focusSessionProvider =
    NotifierProvider<FocusSessionController, FocusState>(
      FocusSessionController.new,
    );
