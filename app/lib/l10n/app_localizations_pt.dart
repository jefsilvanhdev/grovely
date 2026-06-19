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
  String get focusTitle => 'Foco';

  @override
  String get focusSubtitle => 'Fique no foco e veja ela crescer.';

  @override
  String get gardenTitle => 'Seu jardim';

  @override
  String get gardenEmpty =>
      'Nenhuma árvore ainda — seu primeiro foco planta uma.';

  @override
  String get circleTitle => 'Círculos';

  @override
  String get circleEmpty =>
      'Entre num círculo para cultivar um jardim em grupo.';

  @override
  String get leagueTitle => 'Liga';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get onboardingWelcome => 'Cultive seu foco. Junto.';

  @override
  String get paywallTitle => 'Grovely Premium';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonRetry => 'Tentar de novo';

  @override
  String get commonLoading => 'Carregando…';

  @override
  String get commonError => 'Não rolou — vamos tentar de novo.';

  @override
  String get focusStart => 'Começar foco';

  @override
  String get focusGiveUp => 'Parar';

  @override
  String get focusKeepGrowing => 'Fica por aqui. Ela está crescendo.';

  @override
  String get focusCompletedTitle => 'Árvore plantada!';

  @override
  String focusCompletedBody(int minutes) {
    return '$minutes minutos de foco bem gastos.';
  }

  @override
  String get focusWitheredTitle => 'Ela não resistiu';

  @override
  String get focusWitheredBody => 'Você saiu antes do fim. Acontece.';

  @override
  String get focusNewSession => 'Recomeçar';

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
  String get streakStart => 'Começar uma sequência';

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
    return '$species pronto em $minutes min.';
  }

  @override
  String get focusPlant => 'Plantar e focar';

  @override
  String get focusGiveUpConfirmTitle => 'Sair agora? Ela não vai resistir.';

  @override
  String get focusKeepFocusing => 'Continuar';

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
  String get viewGarden => 'Ver meu jardim';

  @override
  String get reviveWithVideo => 'Trazer de volta com um vídeo curto';

  @override
  String get startFresh => 'Começar de novo';

  @override
  String get reviveSheetBody => 'Um vídeo de 30s traz essa árvore de volta.';

  @override
  String get watchAndRevive => 'Assistir e trazer de volta';

  @override
  String get noThanks => 'Agora não';

  @override
  String get reviveUnavailable => 'Sem vídeo agora — mas dá pra replantar.';

  @override
  String get witheredBodyKind =>
      'Saiu antes do fim — acontece. Quer trazer de volta?';

  @override
  String get plantFirst => 'Plantar minha primeira árvore';

  @override
  String get gardenWaiting => 'Seu jardim começa aqui.';

  @override
  String get gardenWaitingSub =>
      'Uma sessão de foco e nasce sua primeira árvore.';

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
      'Cada minuto de foco planta uma árvore. Veja seu bosque crescer.';

  @override
  String get onbGetStarted => 'Plantar minha primeira árvore';

  @override
  String get onbHaveAccount => 'Já tenho conta';

  @override
  String get onbNotifTitle => 'Um toque quando ajuda. Nunca barulho.';

  @override
  String get onbNotifBullet1 => 'Um lembrete diário pra plantar uma árvore';

  @override
  String get onbNotifBullet2 => 'Um aviso antes da sua sequência escapar';

  @override
  String get onbNotifBullet3 => 'Um sinal quando seu círculo começa a focar';

  @override
  String get onbNotifCta => 'Ativar lembretes';

  @override
  String get onbNotNow => 'Talvez depois';

  @override
  String get onbSocialTitle => 'Foque do seu jeito.';

  @override
  String get onbSocialSub => 'Dá pra mudar quando quiser.';

  @override
  String get onbSoloTitle => 'Por conta própria';

  @override
  String get onbSoloDesc => 'Só você e seu bosque.';

  @override
  String get onbCircleTitle => 'Com um círculo';

  @override
  String get onbCircleDesc => 'Cultivem um jardim, de 6 a 12 pessoas.';

  @override
  String get onbRecommended => 'Recomendado';

  @override
  String get onbPrivacy => 'Só seu primeiro nome e quantas árvores você tem.';

  @override
  String get onbGuidedCoach =>
      'Vamos plantar a primeira. É só ficar aqui 30 segundos.';

  @override
  String get onbBegin => 'Plantar';

  @override
  String get onbGuidedDone => 'Sua primeira árvore. 🌱 Essa é por nossa conta.';

  @override
  String get pwTitle => 'Mais espaço pra crescer.';

  @override
  String get pwSub => 'Tudo que já é grátis, e um pouco mais.';

  @override
  String get pwTrialCta => 'Testar grátis por 21 dias';

  @override
  String pwTrialSub(String price) {
    return 'Grátis por 21 dias, depois $price. Cancela quando quiser, em dois toques.';
  }

  @override
  String get pwAnnual => 'Anual';

  @override
  String get pwMonthly => 'Mensal';

  @override
  String get pwSave => 'Economize 40%';

  @override
  String get pwContinueFree => 'Seguir no grátis';

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
  String get profileGuest => 'Visitante';

  @override
  String get profileSaveProgress => 'Salvar meu progresso';

  @override
  String get profileFreePlan => 'Grátis';

  @override
  String get profileLifetime => 'Desde o começo';

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

  @override
  String get recapTitle => 'Sua semana';

  @override
  String recapHero(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count árvores esta semana',
      one: '1 árvore esta semana',
    );
    return '$_temp0';
  }

  @override
  String recapHeroLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'árvores esta semana',
      one: 'árvore esta semana',
    );
    return '$_temp0';
  }

  @override
  String recapSub(int hours, int minutes) {
    return '${hours}h ${minutes}m focado';
  }

  @override
  String get recapFooter => 'Plantado com o Grovely';

  @override
  String get recapShare => 'Compartilhar minha semana';

  @override
  String get recapEmpty => 'Uma semana nova pra crescer.';

  @override
  String get recapEmptySub => 'Plante uma árvore pra começar a semana.';

  @override
  String get circleEmptyTitle => 'Cresçam juntos.';

  @override
  String get circleEmptySub =>
      '6 a 12 pessoas, um jardim em comum e uma liga toda semana.';

  @override
  String get circleCreate => 'Criar um círculo';

  @override
  String get circleJoin => 'Entrar com código';

  @override
  String get circlePrivacy => 'Os membros só veem seu nome e suas árvores.';

  @override
  String get circleNameLabel => 'Nome do círculo';

  @override
  String get circleNameHint => 'ex.: Clube do Foco';

  @override
  String get circleCreateCta => 'Criar círculo';

  @override
  String get circleJoinTitle => 'Entrar num círculo';

  @override
  String get circleCodeLabel => 'Código de convite';

  @override
  String get circleJoinCta => 'Entrar';

  @override
  String get circleInvalidCode => 'Não achamos um círculo com esse código.';

  @override
  String get circleFull => 'Esse círculo está cheio por enquanto.';

  @override
  String get circleInvite => 'Compartilhar convite';

  @override
  String get circleMembers => 'Membros';

  @override
  String circleGoal(int planted, int goal) {
    return '$planted de $goal árvores esta semana';
  }

  @override
  String get circleLeave => 'Sair do círculo';

  @override
  String get circleLeaveConfirm => 'Sair do círculo?';

  @override
  String get circleLeaveBody => 'Dá pra voltar quando quiser, é só o código.';

  @override
  String get circleStay => 'Ficar';

  @override
  String memberWeekly(int count) {
    return '$count esta semana';
  }

  @override
  String get leagueSolo => 'Entre num círculo e a liga abre.';

  @override
  String get leagueTitleWeek => 'Esta semana';

  @override
  String get leagueYou => 'Você';
}
