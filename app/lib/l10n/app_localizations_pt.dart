// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Grovely';

  @override
  String get navFocus => 'Foco';

  @override
  String get navGarden => 'Jardim';

  @override
  String get navCircle => 'Círculo';

  @override
  String get navLeague => 'Liga';

  @override
  String get navProfile => 'Perfil';

  @override
  String get focusTitle => 'Sessão de foco';

  @override
  String get focusSubtitle => 'Plante uma árvore mantendo o foco.';

  @override
  String get gardenTitle => 'Seu jardim';

  @override
  String get gardenEmpty =>
      'Nenhuma árvore ainda. Conclua uma sessão de foco para plantar a primeira.';

  @override
  String get circleTitle => 'Círculos';

  @override
  String get circleEmpty =>
      'Entre em um círculo para cultivar um jardim em grupo.';

  @override
  String get leagueTitle => 'Liga semanal';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get onboardingWelcome => 'Cresça no foco, em conjunto.';

  @override
  String get paywallTitle => 'Seja Premium';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonRetry => 'Tentar de novo';

  @override
  String get commonLoading => 'Carregando…';

  @override
  String get commonError => 'Algo deu errado.';

  @override
  String get focusStart => 'Começar foco';

  @override
  String get focusGiveUp => 'Desistir';

  @override
  String get focusKeepGrowing =>
      'Fique no app para sua árvore continuar crescendo.';

  @override
  String get focusCompletedTitle => 'Árvore plantada!';

  @override
  String focusCompletedBody(int minutes) {
    return 'Você focou por $minutes minutos.';
  }

  @override
  String get focusWitheredTitle => 'Sua árvore murchou';

  @override
  String get focusWitheredBody =>
      'Você saiu antes do fim da sessão. Tente de novo.';

  @override
  String get focusNewSession => 'Nova sessão';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String gardenTreeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count árvores',
      one: '1 árvore',
      zero: 'Nenhuma árvore ainda',
    );
    return '$_temp0';
  }

  @override
  String get streakStart => 'Comece uma sequência';

  @override
  String streakDays(int count) {
    return 'sequência de $count dias';
  }

  @override
  String focusLiveNow(int count) {
    return '$count focando agora';
  }

  @override
  String focusPreview(String species, int minutes) {
    return 'Um(a) $species jovem em $minutes min.';
  }

  @override
  String get focusPlant => 'Plantar e focar';

  @override
  String get focusGiveUpConfirmTitle => 'Sair agora? Sua árvore vai murchar.';

  @override
  String get focusKeepFocusing => 'Continuar focando';

  @override
  String statMinFocused(int minutes) {
    return '$minutes min de foco';
  }

  @override
  String statTrees(int count) {
    return '$count árvores';
  }

  @override
  String statHoursFocused(int hours) {
    return '${hours}h de foco';
  }

  @override
  String statLongest(int count) {
    return 'Recorde: $count dias';
  }

  @override
  String statSpecies(int count) {
    return '$count/6 espécies';
  }

  @override
  String get addedToGarden => 'Adicionada ao seu jardim';

  @override
  String get plantAnother => 'Plantar outra';

  @override
  String get viewGarden => 'Ver jardim';

  @override
  String get reviveWithVideo => 'Reviver com um vídeo curto';

  @override
  String get startFresh => 'Começar de novo';

  @override
  String get reviveSheetBody =>
      'Assista a um vídeo de 30s para reviver esta árvore.';

  @override
  String get watchAndRevive => 'Assistir e reviver';

  @override
  String get noThanks => 'Não, obrigado(a)';

  @override
  String get reviveUnavailable =>
      'Não deu pra carregar o vídeo — sua árvore segue aqui pra replantar.';

  @override
  String get witheredBodyKind =>
      'Você saiu antes do fim — acontece. Quer trazê-la de volta?';

  @override
  String get plantFirst => 'Plantar minha primeira árvore';

  @override
  String get gardenWaiting => 'Seu jardim está esperando.';

  @override
  String get gardenWaitingSub =>
      'Conclua uma sessão de foco para plantar sua primeira árvore.';

  @override
  String get speciesOak => 'carvalho';

  @override
  String get speciesPine => 'pinheiro';

  @override
  String get speciesRoundBush => 'arbusto';

  @override
  String get speciesWillow => 'salgueiro';

  @override
  String get speciesBirch => 'bétula';

  @override
  String get speciesCherryBlossom => 'cerejeira';

  @override
  String get commonSkip => 'Pular';

  @override
  String get onbWelcomeSub =>
      'Plante uma árvore a cada sessão de foco. Veja seu bosque crescer.';

  @override
  String get onbGetStarted => 'Começar';

  @override
  String get onbHaveAccount => 'Já tenho conta';

  @override
  String get onbNotifTitle => 'Lembretes gentis, nunca barulho.';

  @override
  String get onbNotifBullet1 => 'Um lembrete diário pra plantar uma árvore';

  @override
  String get onbNotifBullet2 => 'Avisamos antes da sua sequência quebrar';

  @override
  String get onbNotifBullet3 => 'Saiba quando seu círculo está focando';

  @override
  String get onbNotifCta => 'Ativar lembretes';

  @override
  String get onbNotNow => 'Agora não';

  @override
  String get onbSocialTitle => 'Foque do seu jeito.';

  @override
  String get onbSocialSub => 'Você pode mudar isso depois.';

  @override
  String get onbSoloTitle => 'Focar sozinho(a)';

  @override
  String get onbSoloDesc => 'Só você e seu bosque.';

  @override
  String get onbCircleTitle => 'Focar com um círculo';

  @override
  String get onbCircleDesc => 'Cultive um jardim com 6–12 pessoas.';

  @override
  String get onbRecommended => 'Recomendado';

  @override
  String get onbPrivacy =>
      'Só compartilhamos seu primeiro nome e número de árvores.';

  @override
  String get onbGuidedCoach =>
      'Vamos plantar sua primeira árvore. Fique aqui por 5 minutos — só isso.';

  @override
  String get onbBegin => 'Começar';

  @override
  String get onbGuidedDone => 'Sua primeira árvore! 🌱 Essa é por nossa conta.';

  @override
  String get pwTitle => 'Vá além com o Grovely Premium.';

  @override
  String get pwSub => 'Tudo o que você ama, e mais formas de crescer.';

  @override
  String get pwTrialCta => 'Iniciar teste grátis de 21 dias';

  @override
  String pwTrialSub(String price) {
    return 'Grátis por 21 dias, depois $price. Cancele quando quiser em dois toques.';
  }

  @override
  String get pwAnnual => 'Anual';

  @override
  String get pwMonthly => 'Mensal';

  @override
  String get pwSave => 'Economize 40%';

  @override
  String get pwContinueFree => 'Continuar no plano grátis';

  @override
  String get pwRestore => 'Restaurar compras';

  @override
  String get pwFree => 'Grátis';

  @override
  String get pwPremium => 'Premium';

  @override
  String get pwRowSoloFocus => 'Foco solo ilimitado';

  @override
  String get pwRowGarden => 'Jardim e sequência completos';

  @override
  String get pwRowOneCircle => 'Entrar em 1 círculo';

  @override
  String get pwRowCustom => 'Durações personalizadas';

  @override
  String get pwRowSpecies => 'Todas as espécies e árvores sazonais';

  @override
  String get pwRowStats => 'Estatísticas avançadas';

  @override
  String get pwRowMultiCircle => 'Vários círculos';

  @override
  String get pwRowRecap => 'Temas de recap';

  @override
  String get pwPriceTbd => 'preço a definir';

  @override
  String get profileGuest => 'Convidado(a)';

  @override
  String get profileSaveProgress => 'Salvar seu progresso';

  @override
  String get profileFreePlan => 'Plano grátis';

  @override
  String get profileLifetime => 'Total';

  @override
  String get rowAccount => 'Conta';

  @override
  String get rowSubscription => 'Assinatura';

  @override
  String get rowNotifications => 'Notificações';

  @override
  String get rowAppearance => 'Aparência';

  @override
  String get rowPrivacy => 'Privacidade';

  @override
  String get rowTerms => 'Termos';

  @override
  String get rowSignOut => 'Sair';

  @override
  String get rowAbout => 'Sobre';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';
}
