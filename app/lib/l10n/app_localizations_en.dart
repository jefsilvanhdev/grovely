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
  String get focusTitle => 'Focus';

  @override
  String get focusSubtitle => 'Stay focused and watch it grow.';

  @override
  String get gardenTitle => 'Your garden';

  @override
  String get gardenEmpty => 'No trees yet — your first focus plants one.';

  @override
  String get circleTitle => 'Circles';

  @override
  String get circleEmpty => 'Join a circle to grow a garden together.';

  @override
  String get leagueTitle => 'League';

  @override
  String get profileTitle => 'Profile';

  @override
  String get onboardingWelcome => 'Grow your focus. Together.';

  @override
  String get paywallTitle => 'Grovely Premium';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonSave => 'Save';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonError => 'That didn\'t work — let\'s try again.';

  @override
  String get focusStart => 'Start focus';

  @override
  String get focusGiveUp => 'Stop';

  @override
  String get focusKeepGrowing => 'Stay here. Your tree\'s growing.';

  @override
  String get focusDeepWork => 'Deep work';

  @override
  String focusSessionMeta(String species, int minutes) {
    return '$species · $minutes min';
  }

  @override
  String get focusCompletedTitle => 'Tree planted!';

  @override
  String focusCompletedBody(int minutes) {
    return '$minutes minutes of focus, well spent.';
  }

  @override
  String get focusWitheredTitle => 'Your tree didn\'t make it';

  @override
  String get focusWitheredBody =>
      'You stepped away before it finished. It happens.';

  @override
  String get focusNewSession => 'Start again';

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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-day streak',
      one: '1-day streak',
    );
    return '$_temp0';
  }

  @override
  String focusLiveNow(int count) {
    return '$count focusing now';
  }

  @override
  String focusPreview(String species, int minutes) {
    return 'A $species, grown in $minutes min.';
  }

  @override
  String get focusPlant => 'Plant & focus';

  @override
  String get focusGiveUpConfirmTitle => 'Leave now? Your tree won\'t make it.';

  @override
  String get focusKeepFocusing => 'Keep growing';

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
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Best: $_temp0';
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
  String get viewGarden => 'See my garden';

  @override
  String get reviveWithVideo => 'Bring it back with a short video';

  @override
  String get startFresh => 'Start fresh';

  @override
  String get reviveSheetBody => 'A 30-second video brings this tree back.';

  @override
  String get watchAndRevive => 'Watch & bring it back';

  @override
  String get noThanks => 'No thanks';

  @override
  String get reviveUnavailable =>
      'No video right now — but you can replant it.';

  @override
  String get witheredBodyKind =>
      'You stepped away before it finished — it happens. Want it back?';

  @override
  String get plantFirst => 'Plant my first tree';

  @override
  String get gardenWaiting => 'Your garden starts here.';

  @override
  String get gardenWaitingSub => 'One focused session plants your first tree.';

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
      'Every focused minute plants a tree. Watch your grove grow.';

  @override
  String get onbGetStarted => 'Plant my first tree';

  @override
  String get onbHaveAccount => 'I already have an account';

  @override
  String get onbNotifTitle => 'A nudge when it helps. Never noise.';

  @override
  String get onbNotifBullet1 => 'A daily nudge to plant one tree';

  @override
  String get onbNotifBullet2 => 'A heads-up before your streak slips';

  @override
  String get onbNotifBullet3 => 'A ping when your circle starts focusing';

  @override
  String get onbNotifCta => 'Turn on reminders';

  @override
  String get onbNotNow => 'Maybe later';

  @override
  String get onbSocialTitle => 'Focus your way.';

  @override
  String get onbSocialSub => 'Change this anytime.';

  @override
  String get onbSoloTitle => 'On my own';

  @override
  String get onbSoloDesc => 'Just you and your grove.';

  @override
  String get onbCircleTitle => 'With a circle';

  @override
  String get onbCircleDesc => 'Grow one garden with 6–12 people.';

  @override
  String get onbRecommended => 'Recommended';

  @override
  String get onbPrivacy =>
      'Only your first name and tree count are ever shared.';

  @override
  String get onbGuidedCoach =>
      'Let\'s plant your first one. Just stay here 30 seconds.';

  @override
  String get onbBegin => 'Plant it';

  @override
  String get onbGuidedDone => 'Your first tree. 🌱 On us.';

  @override
  String get pwTitle => 'More room to grow.';

  @override
  String get pwSub => 'Keep everything free, unlock a little more.';

  @override
  String get pwTrialCta => 'Try free for 21 days';

  @override
  String get pwTrialSub => 'Free for 21 days. Cancel anytime, two taps.';

  @override
  String get focusRule =>
      'Leaving the app before time\'s up withers the tree — quick switches get a grace period.';

  @override
  String get pwAnnual => 'Annual';

  @override
  String get pwMonthly => 'Monthly';

  @override
  String get pwSave => 'Save 40%';

  @override
  String get pwContinueFree => 'Stay on Free';

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
  String get profileGuest => 'Guest';

  @override
  String get profileSaveProgress => 'Save my progress';

  @override
  String get profileFreePlan => 'Free';

  @override
  String get profileLifetime => 'All time';

  @override
  String get rowAccount => 'Account';

  @override
  String get rowSubscription => 'Subscription';

  @override
  String get rowNotifications => 'Notifications';

  @override
  String get notifStreakTitle => 'Time to grow 🌱';

  @override
  String get notifStreakBody =>
      'Plant a tree today and keep your streak alive.';

  @override
  String get notifReminderSheetTitle => 'Daily reminder';

  @override
  String get notifReminderSheetBody =>
      'A gentle daily nudge to focus and keep your streak.';

  @override
  String get notifReminderOn => 'Daily reminder on';

  @override
  String get notifReminderOff => 'Reminders off';

  @override
  String get notifPermissionDenied =>
      'Notifications are off. Enable them in system settings.';

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
  String get recapTitle => 'Your week';

  @override
  String recapHero(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trees this week',
      one: '1 tree this week',
    );
    return '$_temp0';
  }

  @override
  String recapHeroLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'trees this week',
      one: 'tree this week',
    );
    return '$_temp0';
  }

  @override
  String recapSub(int hours, int minutes) {
    return '${hours}h ${minutes}m in focus';
  }

  @override
  String get recapFooter => 'Grown with Grovely';

  @override
  String get recapShare => 'Share my week';

  @override
  String get recapEmpty => 'A fresh week to grow.';

  @override
  String get recapEmptySub => 'Plant your first tree to start the week.';

  @override
  String get circleEmptyTitle => 'Grow together.';

  @override
  String get circleEmptySub =>
      '6–12 friends, one shared garden, a friendly weekly league.';

  @override
  String get circleCreate => 'Start a circle';

  @override
  String get circleJoin => 'Join with a code';

  @override
  String get circlePrivacy =>
      'Members only see your first name and tree count.';

  @override
  String get circleNameLabel => 'Circle name';

  @override
  String get circleNameHint => 'e.g. Deep Work Club';

  @override
  String get circleCreateCta => 'Create circle';

  @override
  String get circleJoinTitle => 'Join a circle';

  @override
  String get circleCodeLabel => 'Invite code';

  @override
  String get circleJoinCta => 'Join';

  @override
  String get circleInvalidCode => 'We couldn\'t find a circle for that code.';

  @override
  String get circleFull => 'This circle\'s full for now.';

  @override
  String get circleInvite => 'Share invite';

  @override
  String get circleMembers => 'Members';

  @override
  String get circleGroveOverline => 'Shared grove · this week';

  @override
  String get circleOffline =>
      'No connection right now — check your internet and try again.';

  @override
  String get notifChannelName => 'Streak reminders';

  @override
  String get notifChannelDesc =>
      'Reminds you to focus and keep your streak alive.';

  @override
  String circleGoal(int planted, int goal) {
    return '$planted of $goal trees this week';
  }

  @override
  String circleGoalReached(int planted) {
    return '$planted trees this week — goal reached! 🎉';
  }

  @override
  String get circleLeave => 'Leave circle';

  @override
  String get circleLeaveConfirm => 'Leave circle?';

  @override
  String get circleLeaveBody => 'You can come back anytime with the code.';

  @override
  String get circleStay => 'Stay';

  @override
  String memberWeekly(int count) {
    return '$count this week';
  }

  @override
  String get leagueSolo => 'Join a circle and the league opens up.';

  @override
  String get leagueTitleWeek => 'This week';

  @override
  String get leagueYou => 'You';

  @override
  String leagueScore(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n trees',
      one: '1 tree',
    );
    return '$_temp0';
  }

  @override
  String leagueEndsIn(String time) {
    return 'ends in $time';
  }

  @override
  String leagueYourPlace(String rank, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n trees',
      one: '1 tree',
    );
    return '$rank place · $_temp0';
  }

  @override
  String leagueDeltaAhead(String name, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n trees',
      one: '1 tree',
    );
    return '$name is $_temp0 behind you 🔥';
  }

  @override
  String leagueDeltaBehind(int n, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n trees',
      one: '1 tree',
    );
    return '$_temp0 to pass $name';
  }

  @override
  String get circleWhoPlanted => 'Who planted this week';

  @override
  String get circleCopyCode => 'Copy code';

  @override
  String get circleCodeCopied => 'Code copied!';

  @override
  String get planPlusOverline => 'GROVELY PLUS';

  @override
  String get planActiveBadge => 'Active';

  @override
  String get planTrialBadge => 'Trial';

  @override
  String planMemberSince(String date) {
    return 'Member since $date';
  }

  @override
  String planRenews(String date) {
    return 'Renews $date';
  }

  @override
  String planTrialDaysLeft(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days left in your trial',
      one: '1 day left in your trial',
    );
    return '$_temp0';
  }

  @override
  String get planManage => 'Manage subscription';

  @override
  String get planBenefitCircles => 'All circles';

  @override
  String get planBenefitSpecies => 'Every species';

  @override
  String get planBenefitThemes => 'Garden themes';

  @override
  String get planBenefitStats => 'Deep-focus stats';

  @override
  String get planFreeUpsell => 'Meet Grovely Plus';

  @override
  String get pwAlreadyPlus => 'You\'re already Plus — everything\'s unlocked.';

  @override
  String get profileNameLabel => 'Your name';

  @override
  String get profileNameHint => 'How your circle sees you';

  @override
  String get profileEditName => 'Edit name';
}
