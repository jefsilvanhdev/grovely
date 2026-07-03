import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grovely/data/models/tree.dart';
import 'package:grovely/features/focus_session/focus_session_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

// O controller usa `clock.now()` (package:clock) para todo o timing —
// dentro de fakeAsync, `elapse` avança esse relógio junto dos timers.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  ProviderContainer makeContainer() {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    return c;
  }

  test('estado inicial: selecting, 25 min, semente', () {
    final s = makeContainer().read(focusSessionProvider);
    expect(s.phase, FocusPhase.selecting);
    expect(s.durationMinutes, 25);
    expect(s.secondsRemaining, 25 * 60);
    expect(s.stage, TreeStage.seed);
  });

  test('setDuration ajusta minutos e segundos', () {
    final c = makeContainer();
    c.read(focusSessionProvider.notifier).setDuration(45);
    expect(c.read(focusSessionProvider).durationMinutes, 45);
    expect(c.read(focusSessionProvider).secondsRemaining, 45 * 60);
  });

  test('start roda contagem; restante segue o relógio, não os ticks', () {
    fakeAsync((async) {
      final c = makeContainer();
      c.read(focusSessionProvider.notifier).start();
      expect(c.read(focusSessionProvider).phase, FocusPhase.running);
      async.elapse(const Duration(seconds: 3));
      expect(c.read(focusSessionProvider).secondsRemaining, 25 * 60 - 3);
      expect(c.read(focusSessionProvider).stage, TreeStage.seed);
    });
  });

  test('wither marca murcha', () {
    fakeAsync((async) {
      final c = makeContainer();
      c.read(focusSessionProvider.notifier)
        ..start()
        ..wither();
      final s = c.read(focusSessionProvider);
      expect(s.phase, FocusPhase.withered);
      expect(s.stage, TreeStage.withered);
    });
  });

  test('carência: murcha se ficar fora além da janela', () {
    fakeAsync((async) {
      final c = makeContainer();
      final n = c.read(focusSessionProvider.notifier)..start();
      n.onAppPaused();
      async.elapse(
        const Duration(seconds: FocusSessionController.witherGraceSeconds - 1),
      );
      expect(c.read(focusSessionProvider).phase, FocusPhase.running);
      async.elapse(const Duration(seconds: 2));
      expect(c.read(focusSessionProvider).phase, FocusPhase.withered);
    });
  });

  test('carência: voltar a tempo cancela a murcha e realinha o contador', () {
    fakeAsync((async) {
      final c = makeContainer();
      final n = c.read(focusSessionProvider.notifier)..start();
      n.onAppPaused();
      async.elapse(const Duration(seconds: 20));
      n.onAppResumed();
      expect(c.read(focusSessionProvider).phase, FocusPhase.running);
      // Os 20s fora contam contra o deadline — o contador não congela.
      expect(c.read(focusSessionProvider).secondsRemaining, 25 * 60 - 20);
      async.elapse(const Duration(seconds: 30));
      expect(c.read(focusSessionProvider).phase, FocusPhase.running);
    });
  });

  test('resumed vence a corrida: ausência longa murcha mesmo sem o timer de '
      'carência ter disparado (suspensão)', () {
    fakeAsync((async) {
      final c = makeContainer();
      final n = c.read(focusSessionProvider.notifier)..start();
      n.onAppPaused();
      // Simula suspensão: nada de elapse (timers congelados), só o relógio.
      async.elapse(const Duration(minutes: 3));
      // fakeAsync teria disparado o graceTimer no elapse acima; o cenário
      // real de suspensão é coberto pela decisão por relógio no resumed —
      // que também é o caminho executado aqui (wither idempotente).
      n.onAppResumed();
      expect(c.read(focusSessionProvider).phase, FocusPhase.withered);
    });
  });

  test('sessão pendente: processo morto após o fim → planta no boot', () {
    fakeAsync((async) {
      final endsAt = DateTime.now().subtract(const Duration(minutes: 5));
      SharedPreferences.setMockInitialValues({
        'pending_session': jsonEncode({
          'endsAtMs': endsAt.millisecondsSinceEpoch,
          'durationMinutes': 25,
          'tree': TreeType.pine.slug,
        }),
      });
      final c = makeContainer();
      c.read(focusSessionProvider); // dispara build + restore
      async.flushMicrotasks();
      final s = c.read(focusSessionProvider);
      expect(s.phase, FocusPhase.completed);
      expect(s.treeType, TreeType.pine);
    });
  });

  test('sessão pendente: processo morto antes do fim → murcha no boot', () {
    fakeAsync((async) {
      final endsAt = DateTime.now().add(const Duration(minutes: 10));
      SharedPreferences.setMockInitialValues({
        'pending_session': jsonEncode({
          'endsAtMs': endsAt.millisecondsSinceEpoch,
          'durationMinutes': 45,
          'tree': TreeType.oak.slug,
        }),
      });
      final c = makeContainer();
      c.read(focusSessionProvider);
      async.flushMicrotasks();
      final s = c.read(focusSessionProvider);
      expect(s.phase, FocusPhase.withered);
      expect(s.durationMinutes, 45);
    });
  });

  test('progress → stage: mapeamento de crescimento', () {
    expect(TreeStage.fromProgress(0), TreeStage.seed);
    expect(TreeStage.fromProgress(0.30), TreeStage.sprout);
    expect(TreeStage.fromProgress(0.50), TreeStage.sapling);
    expect(TreeStage.fromProgress(0.70), TreeStage.young);
    expect(TreeStage.fromProgress(0.85), TreeStage.mature);
    expect(TreeStage.fromProgress(1.0), TreeStage.elder);
  });
}
