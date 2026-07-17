// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Grovely';

  @override
  String get navFocus => 'Enfoque';

  @override
  String get navGarden => 'Jardín';

  @override
  String get navCircle => 'Círculo';

  @override
  String get navLeague => 'Liga';

  @override
  String get navProfile => 'Perfil';

  @override
  String get focusTitle => 'Enfoque';

  @override
  String get focusSubtitle => 'Concéntrate y mírala crecer.';

  @override
  String get gardenTitle => 'Tu jardín';

  @override
  String get gardenEmpty =>
      'Aún no hay árboles — tu primer enfoque planta uno.';

  @override
  String get circleTitle => 'Círculos';

  @override
  String get circleEmpty =>
      'Únete a un círculo para cultivar un jardín juntos.';

  @override
  String get leagueTitle => 'Liga';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get onboardingWelcome => 'Haz crecer tu enfoque. Juntos.';

  @override
  String get paywallTitle => 'Grovely Premium';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonRetry => 'Intentar de nuevo';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonLoading => 'Cargando…';

  @override
  String get commonError => 'No funcionó — probemos de nuevo.';

  @override
  String get focusStart => 'Empezar a concentrarme';

  @override
  String get focusGiveUp => 'Parar';

  @override
  String get focusKeepGrowing => 'Quédate aquí. Tu árbol está creciendo.';

  @override
  String get focusDeepWork => 'Trabajo profundo';

  @override
  String focusSessionMeta(String species, int minutes) {
    return '$species · $minutes min';
  }

  @override
  String get focusCompletedTitle => '¡Árbol plantado!';

  @override
  String focusCompletedBody(int minutes) {
    return '$minutes minutos de enfoque bien invertidos.';
  }

  @override
  String get focusWitheredTitle => 'Tu árbol no lo logró';

  @override
  String get focusWitheredBody => 'Saliste antes de que terminara. Pasa.';

  @override
  String get focusNewSession => 'Empezar de nuevo';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String gardenTreeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count árboles',
      one: '1 árbol',
      zero: 'Aún no hay árboles',
    );
    return '$_temp0';
  }

  @override
  String get streakStart => 'Empezar una racha';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'racha de $count días',
      one: 'racha de 1 día',
    );
    return '$_temp0';
  }

  @override
  String focusLiveNow(int count) {
    return '$count concentrados ahora';
  }

  @override
  String focusPreview(String species, int minutes) {
    return 'Un $species, crecido en $minutes min.';
  }

  @override
  String get focusPlant => 'Plantar y concentrarme';

  @override
  String get focusGiveUpConfirmTitle => '¿Salir ahora? Tu árbol no lo logrará.';

  @override
  String get focusKeepFocusing => 'Seguir creciendo';

  @override
  String statMinFocused(int minutes) {
    return '$minutes min de enfoque';
  }

  @override
  String statTrees(int count) {
    return '$count árboles';
  }

  @override
  String statHoursFocused(int hours) {
    return '${hours}h de enfoque';
  }

  @override
  String statLongest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return 'Récord: $_temp0';
  }

  @override
  String statSpecies(int count) {
    return '$count/6 especies';
  }

  @override
  String get addedToGarden => 'Añadido a tu jardín';

  @override
  String get plantAnother => 'Plantar otro';

  @override
  String get viewGarden => 'Ver mi jardín';

  @override
  String get reviveWithVideo => 'Recupéralo con un video corto';

  @override
  String get startFresh => 'Empezar de cero';

  @override
  String get reviveSheetBody => 'Un video de 30 segundos recupera este árbol.';

  @override
  String get watchAndRevive => 'Ver y recuperarlo';

  @override
  String get noThanks => 'No, gracias';

  @override
  String get reviveUnavailable =>
      'No hay video ahora — pero puedes replantarlo.';

  @override
  String get witheredBodyKind =>
      'Saliste antes de que terminara — pasa. ¿Lo recuperamos?';

  @override
  String get plantFirst => 'Plantar mi primer árbol';

  @override
  String get gardenWaiting => 'Tu jardín empieza aquí.';

  @override
  String get gardenWaitingSub =>
      'Una sesión de enfoque planta tu primer árbol.';

  @override
  String get speciesOak => 'roble';

  @override
  String get speciesPine => 'pino';

  @override
  String get speciesRoundBush => 'arbusto';

  @override
  String get speciesWillow => 'sauce';

  @override
  String get speciesBirch => 'abedul';

  @override
  String get speciesCherryBlossom => 'cerezo';

  @override
  String get commonSkip => 'Saltar';

  @override
  String get onbWelcomeSub =>
      'Cada minuto de enfoque planta un árbol. Mira crecer tu bosque.';

  @override
  String get onbGetStarted => 'Plantar mi primer árbol';

  @override
  String get onbHaveAccount => 'Ya tengo una cuenta';

  @override
  String get onbNotifTitle => 'Un recordatorio cuando ayuda. Nunca ruido.';

  @override
  String get onbNotifBullet1 => 'Un aviso diario para plantar un árbol';

  @override
  String get onbNotifBullet2 => 'Un aviso antes de perder tu racha';

  @override
  String get onbNotifBullet3 =>
      'Una señal cuando tu círculo empieza a concentrarse';

  @override
  String get onbNotifCta => 'Activar recordatorios';

  @override
  String get onbNotNow => 'Quizá después';

  @override
  String get onbSocialTitle => 'Concéntrate a tu manera.';

  @override
  String get onbSocialSub => 'Puedes cambiarlo cuando quieras.';

  @override
  String get onbSoloTitle => 'Por mi cuenta';

  @override
  String get onbSoloDesc => 'Solo tú y tu bosque.';

  @override
  String get onbCircleTitle => 'Con un círculo';

  @override
  String get onbCircleDesc => 'Cultiva un jardín con 6 a 12 personas.';

  @override
  String get onbRecommended => 'Recomendado';

  @override
  String get onbPrivacy =>
      'Solo se comparten tu nombre y tu conteo de árboles.';

  @override
  String get onbGuidedCoach =>
      'Plantemos el primero. Solo quédate aquí 30 segundos.';

  @override
  String get onbBegin => 'Plantarlo';

  @override
  String get onbGuidedDone => 'Tu primer árbol. 🌱 Va por nuestra cuenta.';

  @override
  String get pwTitle => 'Más espacio para crecer.';

  @override
  String get pwSub => 'Todo sigue gratis, desbloquea un poco más.';

  @override
  String get pwTrialCta => 'Probar gratis 21 días';

  @override
  String get pwTrialSub =>
      'Gratis por 21 días. Cancela cuando quieras, en dos toques.';

  @override
  String get focusRule =>
      'Salir de la app antes de tiempo marchita el árbol — los cambios rápidos tienen margen.';

  @override
  String get pwAnnual => 'Anual';

  @override
  String get pwMonthly => 'Mensual';

  @override
  String get pwSave => 'Ahorra 40%';

  @override
  String get pwContinueFree => 'Seguir gratis';

  @override
  String get pwRestore => 'Restaurar compras';

  @override
  String get pwFree => 'Gratis';

  @override
  String get pwPremium => 'Premium';

  @override
  String get pwRowSoloFocus => 'Enfoque en solitario ilimitado';

  @override
  String get pwRowGarden => 'Jardín y racha completos';

  @override
  String get pwRowOneCircle => 'Unirte a 1 círculo';

  @override
  String get pwRowCustom => 'Duraciones personalizadas';

  @override
  String get pwRowSpecies => 'Todas las especies y árboles de temporada';

  @override
  String get pwRowStats => 'Estadísticas avanzadas';

  @override
  String get pwRowMultiCircle => 'Múltiples círculos';

  @override
  String get pwRowRecap => 'Temas del resumen';

  @override
  String get profileGuest => 'Invitado';

  @override
  String get profileSaveProgress => 'Guardar mi progreso';

  @override
  String get profileFreePlan => 'Gratis';

  @override
  String get profileLifetime => 'Desde el inicio';

  @override
  String get rowAccount => 'Cuenta';

  @override
  String get rowSubscription => 'Suscripción';

  @override
  String get rowNotifications => 'Notificaciones';

  @override
  String get notifStreakTitle => 'Hora de crecer 🌱';

  @override
  String get notifStreakBody => 'Planta un árbol hoy y mantén viva tu racha.';

  @override
  String get notifReminderSheetTitle => 'Recordatorio diario';

  @override
  String get notifReminderSheetBody =>
      'Un aviso diario y suave para concentrarte y mantener tu racha.';

  @override
  String get notifReminderOn => 'Recordatorio diario activado';

  @override
  String get notifReminderOff => 'Recordatorios desactivados';

  @override
  String get notifPermissionDenied =>
      'Las notificaciones están desactivadas. Actívalas en los ajustes del sistema.';

  @override
  String get rowAppearance => 'Apariencia';

  @override
  String get rowLanguage => 'Idioma';

  @override
  String get languageSystem => 'Predeterminado del sistema';

  @override
  String get rowPrivacy => 'Privacidad';

  @override
  String get rowTerms => 'Términos';

  @override
  String get rowSignOut => 'Cerrar sesión';

  @override
  String get rowAbout => 'Acerca de';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get recapTitle => 'Tu semana';

  @override
  String recapHero(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count árboles esta semana',
      one: '1 árbol esta semana',
    );
    return '$_temp0';
  }

  @override
  String recapHeroLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'árboles esta semana',
      one: 'árbol esta semana',
    );
    return '$_temp0';
  }

  @override
  String recapSub(int hours, int minutes) {
    return '${hours}h ${minutes}m de enfoque';
  }

  @override
  String get recapFooter => 'Cultivado con Grovely';

  @override
  String get recapShare => 'Compartir mi semana';

  @override
  String get recapEmpty => 'Una semana nueva para crecer.';

  @override
  String get recapEmptySub => 'Planta tu primer árbol para empezar la semana.';

  @override
  String get circleEmptyTitle => 'Crezcan juntos.';

  @override
  String get circleEmptySub =>
      '6 a 12 amigos, un jardín compartido, una liga semanal amistosa.';

  @override
  String get circleCreate => 'Crear un círculo';

  @override
  String get circleJoin => 'Unirme con un código';

  @override
  String get circlePrivacy =>
      'Los miembros solo ven tu nombre y tu conteo de árboles.';

  @override
  String get circleNameLabel => 'Nombre del círculo';

  @override
  String get circleNameHint => 'ej. Club de Trabajo Profundo';

  @override
  String get circleCreateCta => 'Crear círculo';

  @override
  String get circleJoinTitle => 'Unirse a un círculo';

  @override
  String get circleCodeLabel => 'Código de invitación';

  @override
  String get circleJoinCta => 'Unirme';

  @override
  String get circleInvalidCode =>
      'No encontramos ningún círculo con ese código.';

  @override
  String get circleFull => 'Este círculo está lleno por ahora.';

  @override
  String get circleInvite => 'Compartir invitación';

  @override
  String get circleMembers => 'Miembros';

  @override
  String get circleGroveOverline => 'Bosque compartido · esta semana';

  @override
  String circleFocusingNow(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n concentrados ahora',
      one: '1 concentrado ahora',
      zero: 'Nadie concentrado ahora',
    );
    return '$_temp0';
  }

  @override
  String get circleOffline =>
      'Sin conexión ahora — revisa tu internet e intenta de nuevo.';

  @override
  String get notifChannelName => 'Recordatorios de racha';

  @override
  String get notifChannelDesc =>
      'Te recuerda concentrarte y mantener viva tu racha.';

  @override
  String circleGoal(int planted, int goal) {
    return '$planted de $goal árboles esta semana';
  }

  @override
  String circleGoalReached(int planted) {
    return '$planted árboles esta semana — ¡meta alcanzada! 🎉';
  }

  @override
  String get circleLeave => 'Salir del círculo';

  @override
  String get circleLeaveConfirm => '¿Salir del círculo?';

  @override
  String get circleLeaveBody => 'Puedes volver cuando quieras con el código.';

  @override
  String get circleStay => 'Quedarme';

  @override
  String memberWeekly(int count) {
    return '$count esta semana';
  }

  @override
  String get leagueSolo => 'Únete a un círculo y se abre la liga.';

  @override
  String get leagueTitleWeek => 'Esta semana';

  @override
  String get leagueYou => 'Tú';

  @override
  String leagueScore(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n árboles',
      one: '1 árbol',
    );
    return '$_temp0';
  }

  @override
  String leagueEndsIn(String time) {
    return 'termina en $time';
  }

  @override
  String leagueYourPlace(String rank, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n árboles',
      one: '1 árbol',
    );
    return '$rank lugar · $_temp0';
  }

  @override
  String leagueDeltaAhead(String name, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n árboles',
      one: '1 árbol',
    );
    return '$name está a $_temp0 de ti 🔥';
  }

  @override
  String leagueDeltaBehind(int n, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Faltan $n árboles',
      one: 'Falta 1 árbol',
    );
    return '$_temp0 para pasar a $name';
  }

  @override
  String get circleWhoPlanted => 'Quién plantó esta semana';

  @override
  String get circleCopyCode => 'Copiar código';

  @override
  String get circleCodeCopied => '¡Código copiado!';

  @override
  String get planPlusOverline => 'GROVELY PLUS';

  @override
  String get planActiveBadge => 'Activo';

  @override
  String get planTrialBadge => 'Prueba';

  @override
  String planMemberSince(String date) {
    return 'Miembro desde $date';
  }

  @override
  String planRenews(String date) {
    return 'Se renueva el $date';
  }

  @override
  String planTrialDaysLeft(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Quedan $n días de prueba',
      one: 'Queda 1 día de prueba',
    );
    return '$_temp0';
  }

  @override
  String get planManage => 'Gestionar suscripción';

  @override
  String get planBenefitCircles => 'Todos los círculos';

  @override
  String get planBenefitSpecies => 'Todas las especies';

  @override
  String get planBenefitThemes => 'Temas de jardín';

  @override
  String get planBenefitStats => 'Estadísticas avanzadas';

  @override
  String get planFreeUpsell => 'Conoce Grovely Plus';

  @override
  String get pwAlreadyPlus => 'Ya eres Plus — todo está desbloqueado.';

  @override
  String get profileChangePhoto => 'Cambiar foto';

  @override
  String get profileRemovePhoto => 'Quitar foto';

  @override
  String get profileNameLabel => 'Tu nombre';

  @override
  String get profileNameHint => 'Cómo te ve tu círculo';

  @override
  String get profileEditName => 'Editar nombre';
}
