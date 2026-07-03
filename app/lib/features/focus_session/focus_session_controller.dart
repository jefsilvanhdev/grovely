import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
///
/// Tempo por relógio de parede: a sessão tem um `_endsAt` fixado no start e o
/// tick apenas recalcula o restante — ticks atrasados/perdidos (Doze, jank)
/// não esticam a sessão. A decisão murcha-ou-segue no retorno do background é
/// determinística (compara `now - _pausedAt` com a carência), sem depender da
/// ordem timer-vencido × resumed. A sessão em andamento é persistida: se o SO
/// matar o processo, o boot seguinte planta (se o tempo fechou) ou murcha.
class FocusSessionController extends Notifier<FocusState> {
  Timer? _timer;
  Timer? _graceTimer;
  DateTime? _endsAt;
  DateTime? _pausedAt;

  static const durationOptions = [15, 25, 45, 60];

  /// Carência p/ pausas transitórias (ligação, notificação, troca rápida de
  /// app). Só murcha se o app ficar em background além disso. Com o wakelock
  /// segurando a tela acesa, `paused` só acontece por saída real do usuário —
  /// 45s perdoa uma ligação atendida e recusada, sem abrir espaço pra "dar uma
  /// olhadinha no Instagram". (Forest usa carências nessa ordem de grandeza.)
  static const witherGraceSeconds = 45;

  static const _prefPending = 'pending_session';

  /// Wakelock best-effort: sem plugin (testes) ou falha de plataforma não
  /// pode derrubar a máquina de estados.
  void _wakelock(bool on) {
    unawaited(
      (on ? WakelockPlus.enable() : WakelockPlus.disable()).catchError((_) {}),
    );
  }

  @override
  FocusState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _graceTimer?.cancel();
      _wakelock(false);
    });
    // Sessão interrompida por morte do processo? Resolve fora do build
    // (prefs é async): planta, murcha ou retoma.
    unawaited(_resolvePendingSession());
    return _initialState();
  }

  FocusState _initialState() => FocusState(
    phase: FocusPhase.selecting,
    durationMinutes: 25,
    secondsRemaining: 25 * 60,
    treeType: _randomTree(),
  );

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
    _beginRunning(
      endsAt: clock.now().add(Duration(seconds: state.totalSeconds)),
    );
    unawaited(_savePendingSession());
  }

  void _beginRunning({required DateTime endsAt}) {
    _endsAt = endsAt;
    _pausedAt = null;
    state = state.copyWith(
      phase: FocusPhase.running,
      secondsRemaining: _remainingNow(),
    );
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    // Mantém a tela acesa durante a sessão: sem isso o screen-timeout dispara
    // `paused` e mataria a árvore de quem largou o celular na mesa — exatamente
    // o comportamento que o produto pede.
    _wakelock(true);
  }

  int _remainingNow() {
    final ends = _endsAt;
    if (ends == null) return state.secondsRemaining;
    final diff = ends.difference(clock.now()).inSeconds;
    return diff < 0 ? 0 : diff;
  }

  void _tick() {
    final remaining = _remainingNow();
    if (remaining <= 0) {
      _complete();
    } else {
      state = state.copyWith(secondsRemaining: remaining);
    }
  }

  Future<void> _complete({DateTime? completedAt}) async {
    _timer?.cancel();
    _graceTimer?.cancel();
    _wakelock(false);
    unawaited(_clearPendingSession());
    state = state.copyWith(phase: FocusPhase.completed, secondsRemaining: 0);
    await ref
        .read(gardenProvider.notifier)
        .plant(
          CompletedTree(
            type: state.treeType,
            durationMinutes: state.durationMinutes,
            completedAt: completedAt ?? clock.now(),
          ),
        );
  }

  /// Ficou fora do app além da carência → árvore murcha.
  void wither() {
    if (state.phase != FocusPhase.running) return;
    _timer?.cancel();
    _graceTimer?.cancel();
    _wakelock(false);
    unawaited(_clearPendingSession());
    state = state.copyWith(phase: FocusPhase.withered);
  }

  /// App foi pro background durante a sessão → marca o instante e arma a
  /// carência (para o caso de o processo seguir vivo).
  void onAppPaused() {
    if (state.phase != FocusPhase.running) return;
    _pausedAt = clock.now();
    _graceTimer?.cancel();
    _graceTimer = Timer(const Duration(seconds: witherGraceSeconds), wither);
  }

  /// Voltou ao app: decide por relógio de parede — imune à ordem de execução
  /// entre o timer de carência e o resumed depois de uma suspensão (Doze/iOS).
  void onAppResumed() {
    _graceTimer?.cancel();
    if (state.phase != FocusPhase.running) return;
    final pausedAt = _pausedAt;
    _pausedAt = null;
    if (pausedAt == null) return;

    final away = clock.now().difference(pausedAt).inSeconds;
    if (away > witherGraceSeconds) {
      // Ausência real além da carência — mesmo que o SO tenha segurado o
      // _graceTimer suspenso o tempo todo.
      wither();
    } else {
      // Voltou a tempo: realinha o contador ao relógio (ticks suspensos não
      // esticam a sessão) e completa já se o tempo fechou fora da tela.
      if (_remainingNow() <= 0) {
        _complete();
      } else {
        state = state.copyWith(secondsRemaining: _remainingNow());
      }
    }
  }

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
    _endsAt = null;
    _pausedAt = null;
    _wakelock(false);
    unawaited(_clearPendingSession());
    state = _initialState();
  }

  // ── Sessão pendente (sobrevive à morte do processo) ────────────────────────

  Future<void> _savePendingSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _prefPending,
      jsonEncode({
        'endsAtMs': _endsAt!.millisecondsSinceEpoch,
        'durationMinutes': state.durationMinutes,
        'tree': state.treeType.slug,
      }),
    );
  }

  Future<void> _clearPendingSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefPending);
  }

  /// Processo morreu no meio de uma sessão? Se o tempo fechou enquanto o app
  /// estava morto, a árvore é plantada (com o horário real do fim); se não
  /// fechou, murcha — o usuário claramente não estava aqui. Fecha o cheese
  /// "mata o app pra não murchar".
  Future<void> _resolvePendingSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefPending);
    if (raw == null) return;
    await prefs.remove(_prefPending);

    Map<String, dynamic> data;
    try {
      data = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }
    final endsAt = DateTime.fromMillisecondsSinceEpoch(
      (data['endsAtMs'] as num).toInt(),
    );
    final minutes = (data['durationMinutes'] as num).toInt();
    final tree = TreeType.values.firstWhere(
      (t) => t.slug == data['tree'],
      orElse: () => TreeType.oak,
    );

    // O boot pode ter re-entrado aqui com uma sessão nova já rodando — não
    // atropela (só restaura a partir do estado inicial de seleção).
    if (state.phase != FocusPhase.selecting) return;

    state = state.copyWith(durationMinutes: minutes, treeType: tree);
    if (clock.now().isBefore(endsAt)) {
      state = state.copyWith(phase: FocusPhase.withered);
    } else {
      await _complete(completedAt: endsAt);
    }
  }
}

final focusSessionProvider =
    NotifierProvider<FocusSessionController, FocusState>(
      FocusSessionController.new,
    );
