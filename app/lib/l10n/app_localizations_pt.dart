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
}
