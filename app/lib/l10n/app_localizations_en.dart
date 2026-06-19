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

  @override
  String get streakStart => 'Start a streak';

  @override
  String streakDays(int count) {
    return '$count-day streak';
  }

  @override
  String focusLiveNow(int count) {
    return '$count focusing now';
  }

  @override
  String focusPreview(String species, int minutes) {
    return 'A young $species in $minutes min.';
  }

  @override
  String get focusPlant => 'Plant & focus';

  @override
  String get focusGiveUpConfirmTitle => 'Leave now? Your tree will wither.';

  @override
  String get focusKeepFocusing => 'Keep focusing';

  @override
  String statMinFocused(int minutes) {
    return '$minutes min focused';
  }

  @override
  String statTrees(int count) {
    return '$count trees';
  }

  @override
  String statHoursFocused(int hours) {
    return '${hours}h focused';
  }

  @override
  String statLongest(int count) {
    return 'Longest: $count days';
  }

  @override
  String statSpecies(int count) {
    return '$count/6 species';
  }

  @override
  String get addedToGarden => 'Added to your garden';

  @override
  String get plantAnother => 'Plant another';

  @override
  String get viewGarden => 'View garden';

  @override
  String get reviveWithVideo => 'Revive with a short video';

  @override
  String get startFresh => 'Start fresh';

  @override
  String get reviveSheetBody => 'Watch a 30-second video to revive this tree.';

  @override
  String get watchAndRevive => 'Watch & revive';

  @override
  String get noThanks => 'No thanks';

  @override
  String get reviveUnavailable =>
      'Couldn\'t load the video — your tree\'s still here to replant.';

  @override
  String get witheredBodyKind =>
      'You left before the session finished — it happens. Want to bring it back?';

  @override
  String get plantFirst => 'Plant your first tree';

  @override
  String get gardenWaiting => 'Your garden is waiting.';

  @override
  String get gardenWaitingSub =>
      'Finish a focus session to plant your first tree.';

  @override
  String get speciesOak => 'oak';

  @override
  String get speciesPine => 'pine';

  @override
  String get speciesRoundBush => 'bush';

  @override
  String get speciesWillow => 'willow';

  @override
  String get speciesBirch => 'birch';

  @override
  String get speciesCherryBlossom => 'cherry blossom';

  @override
  String get commonSkip => 'Skip';

  @override
  String get onbWelcomeSub =>
      'Plant a tree with every focused session. Watch your grove grow.';

  @override
  String get onbGetStarted => 'Get started';

  @override
  String get onbHaveAccount => 'I already have an account';

  @override
  String get onbNotifTitle => 'Gentle nudges, never noise.';

  @override
  String get onbNotifBullet1 => 'A daily reminder to plant one tree';

  @override
  String get onbNotifBullet2 =>
      'We\'ll help you save a streak before it breaks';

  @override
  String get onbNotifBullet3 => 'Know when your circle is focusing';

  @override
  String get onbNotifCta => 'Turn on reminders';

  @override
  String get onbNotNow => 'Not now';

  @override
  String get onbSocialTitle => 'Focus your way.';

  @override
  String get onbSocialSub => 'You can always change this later.';

  @override
  String get onbSoloTitle => 'Focus solo';

  @override
  String get onbSoloDesc => 'Just you and your grove.';

  @override
  String get onbCircleTitle => 'Focus with a circle';

  @override
  String get onbCircleDesc => 'Grow a shared garden with 6–12 people.';

  @override
  String get onbRecommended => 'Recommended';

  @override
  String get onbPrivacy => 'We only ever share your first name and tree count.';

  @override
  String get onbGuidedCoach =>
      'Let\'s plant your first tree. Stay here for 5 minutes — that\'s it.';

  @override
  String get onbBegin => 'Begin';

  @override
  String get onbGuidedDone => 'Your first tree! 🌱 This one\'s on us.';

  @override
  String get pwTitle => 'Go deeper with Grovely Premium.';

  @override
  String get pwSub => 'Everything you love, plus more ways to grow.';

  @override
  String get pwTrialCta => 'Start 21-day free trial';

  @override
  String pwTrialSub(String price) {
    return 'Free for 21 days, then $price. Cancel anytime in two taps.';
  }

  @override
  String get pwAnnual => 'Annual';

  @override
  String get pwMonthly => 'Monthly';

  @override
  String get pwSave => 'Save 40%';

  @override
  String get pwContinueFree => 'Continue with Free';

  @override
  String get pwRestore => 'Restore purchases';

  @override
  String get pwFree => 'Free';

  @override
  String get pwPremium => 'Premium';

  @override
  String get pwRowSoloFocus => 'Unlimited solo focus';

  @override
  String get pwRowGarden => 'Full garden & streak';

  @override
  String get pwRowOneCircle => 'Join 1 circle';

  @override
  String get pwRowCustom => 'Custom durations';

  @override
  String get pwRowSpecies => 'All species & seasonal trees';

  @override
  String get pwRowStats => 'Advanced stats';

  @override
  String get pwRowMultiCircle => 'Multiple circles';

  @override
  String get pwRowRecap => 'Recap themes';

  @override
  String get pwPriceTbd => 'price TBD';

  @override
  String get profileGuest => 'Guest';

  @override
  String get profileSaveProgress => 'Save your progress';

  @override
  String get profileFreePlan => 'Free plan';

  @override
  String get profileLifetime => 'Lifetime';

  @override
  String get rowAccount => 'Account';

  @override
  String get rowSubscription => 'Subscription';

  @override
  String get rowNotifications => 'Notifications';

  @override
  String get rowAppearance => 'Appearance';

  @override
  String get rowPrivacy => 'Privacy';

  @override
  String get rowTerms => 'Terms';

  @override
  String get rowSignOut => 'Sign out';

  @override
  String get rowAbout => 'About';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get recapTitle => 'Weekly recap';

  @override
  String recapHero(int count) {
    return '$count trees this week';
  }

  @override
  String recapSub(int hours, int minutes) {
    return '${hours}h ${minutes}m focused';
  }

  @override
  String get recapFooter => 'Made with Grovely';

  @override
  String get recapShare => 'Share my week';

  @override
  String get recapEmpty => 'A fresh week to grow.';

  @override
  String get recapEmptySub => 'Plant a tree to start this week\'s recap.';
}
