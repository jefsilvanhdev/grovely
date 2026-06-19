// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Grovely';

  @override
  String get navFocus => 'Focus';

  @override
  String get navGarden => 'Garden';

  @override
  String get navCircle => 'Circle';

  @override
  String get navLeague => 'League';

  @override
  String get navProfile => 'Profile';

  @override
  String get focusTitle => 'Focus session';

  @override
  String get focusSubtitle => 'Plant a tree by staying focused.';

  @override
  String get gardenTitle => 'Your garden';

  @override
  String get gardenEmpty =>
      'No trees yet. Finish a focus session to plant your first.';

  @override
  String get circleTitle => 'Circles';

  @override
  String get circleEmpty => 'Join a circle to grow a garden together.';

  @override
  String get leagueTitle => 'Weekly league';

  @override
  String get profileTitle => 'Profile';

  @override
  String get onboardingWelcome => 'Grow focus, together.';

  @override
  String get paywallTitle => 'Go Premium';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'Something went wrong.';

  @override
  String get focusStart => 'Start focus';

  @override
  String get focusGiveUp => 'Give up';

  @override
  String get focusKeepGrowing => 'Stay in the app to keep your tree growing.';

  @override
  String get focusCompletedTitle => 'Tree planted!';

  @override
  String focusCompletedBody(int minutes) {
    return 'You focused for $minutes minutes.';
  }

  @override
  String get focusWitheredTitle => 'Your tree withered';

  @override
  String get focusWitheredBody =>
      'You left before the session ended. Try again.';

  @override
  String get focusNewSession => 'New session';

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String gardenTreeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trees',
      one: '1 tree',
      zero: 'No trees yet',
    );
    return '$_temp0';
  }
}
