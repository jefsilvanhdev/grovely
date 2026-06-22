import 'package:flutter_test/flutter_test.dart';
import 'package:grovely/data/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Nota: `enableStreakReminder`/`disableStreakReminder` chamam `init()`, que
// resolve o registrant de plataforma do flutter_local_notifications — ausente
// em unit test puro (LateInitializationError). O agendamento é coberto por
// teste manual no emulador (ver ROADMAP / QA). Aqui cobrimos a lógica pura:
// o estado de persistência do toggle.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('NotificationService', () {
    test('lembrete começa desligado por padrão', () async {
      expect(
        await NotificationService.instance.isStreakReminderEnabled(),
        false,
      );
    });

    test('lê o estado persistido em shared_preferences', () async {
      SharedPreferences.setMockInitialValues({'notif_streak_enabled': true});
      expect(
        await NotificationService.instance.isStreakReminderEnabled(),
        true,
      );
    });
  });
}
