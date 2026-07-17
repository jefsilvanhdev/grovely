import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../core/constants/env.dart';

/// Anúncios do Grovely — **só rewarded, só pra reviver árvore murcha**.
///
/// Nunca banner, nunca interstitial, nunca durante o foco: o produto vende
/// concentração; anúncio no meio da sessão trairia isso. O único anúncio é
/// opt-in, escolhido pelo usuário, na tela da árvore murcha.
///
/// Best-effort: se o SDK falhar, não houver preenchimento ou o unit id estiver
/// vazio, [showRewarded] devolve `true` — o usuário nunca fica preso sem poder
/// reviver por culpa de anúncio.
class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  bool _initialized = false;
  RewardedAd? _ad;
  bool _loading = false;

  /// Init do SDK. Best-effort, chamado no bootstrap.
  Future<void> init() async {
    if (_initialized) return;
    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      unawaited(_preload());
    } catch (_) {
      // sem ads — o revive segue direto
    }
  }

  bool get _enabled => _initialized && Env.admobRewardedUnitId.isNotEmpty;

  /// Carrega um rewarded pra ficar pronto antes de o usuário precisar.
  Future<void> _preload() async {
    if (!_enabled || _loading || _ad != null) return;
    _loading = true;
    try {
      await RewardedAd.load(
        adUnitId: Env.admobRewardedUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _ad = ad;
            _loading = false;
          },
          onAdFailedToLoad: (_) {
            _ad = null;
            _loading = false;
          },
        ),
      );
    } catch (_) {
      _loading = false;
    }
  }

  /// Mostra o rewarded e resolve `true` se o usuário ganhou a recompensa
  /// (assistiu). Se não houver anúncio disponível, resolve `true` também —
  /// falha de anúncio não pode punir quem quer reviver a árvore.
  Future<bool> showRewarded() async {
    if (!_enabled) return true;
    final ad = _ad;
    if (ad == null) {
      unawaited(_preload()); // tenta ter um pro próximo
      return true;
    }
    _ad = null; // consumido

    final completer = Completer<bool>();
    var earned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        unawaited(_preload());
        if (!completer.isCompleted) completer.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        unawaited(_preload());
        if (!completer.isCompleted) completer.complete(true); // não punir
      },
    );

    try {
      await ad.show(onUserEarnedReward: (_, _) => earned = true);
    } catch (_) {
      if (!completer.isCompleted) completer.complete(true);
    }
    return completer.future;
  }
}
