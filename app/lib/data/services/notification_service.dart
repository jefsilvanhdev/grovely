import 'package:flutter/painting.dart' show Color;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notificações locais (lembrete de streak). MVP: um lembrete diário recorrente
/// — `periodicallyShow(RepeatInterval.daily)` evita lidar com timezone e fuso,
/// e sobrevive a reboot via o receiver do plugin (ver AndroidManifest).
///
/// Best-effort: nunca lança no boot. iOS fica preparado mas o foco é Android.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const _streakId = 1001;
  static const _channelId = 'streak_reminder';
  static const _prefEnabled = 'notif_streak_enabled';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    // Ícone monocromático (drawable/ic_stat_grove) — o launcher colorido virava
    // um quadrado branco na status bar (QA M6). O Android tinge pelo alpha.
    const android = AndroidInitializationSettings('ic_stat_grove');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: darwin),
    );
    _initialized = true;
  }

  /// Pede permissão de notificação (Android 13+ / iOS). Retorna true se concedida.
  Future<bool> requestPermission() async {
    await init();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return false;
  }

  /// Liga o lembrete diário de streak com a copy passada (já localizada).
  /// [channelName]/[channelDescription] aparecem nas configurações do sistema
  /// — também localizados (QA M4: eram PT fixo pra usuários EN).
  Future<void> enableStreakReminder({
    required String title,
    required String body,
    required String channelName,
    required String channelDescription,
  }) async {
    await init();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        icon: 'ic_stat_grove',
        color: const Color(0xFF2E7D52),
      ),
    );
    await _plugin.periodicallyShow(
      id: _streakId,
      title: title,
      body: body,
      repeatInterval: RepeatInterval.daily,
      notificationDetails: details,
      // Inexato: não exige permissão de alarme exato e poupa bateria.
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    await _setEnabled(true);
  }

  Future<void> disableStreakReminder() async {
    await init();
    await _plugin.cancel(id: _streakId);
    await _setEnabled(false);
  }

  Future<bool> isStreakReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefEnabled) ?? false;
  }

  Future<void> _setEnabled(bool v) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefEnabled, v);
  }
}
