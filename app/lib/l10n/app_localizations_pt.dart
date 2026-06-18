// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Plantio Coletivo';

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
}
