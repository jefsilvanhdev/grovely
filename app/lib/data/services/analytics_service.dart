import 'package:firebase_analytics/firebase_analytics.dart';

/// Wrapper fino sobre o Firebase Analytics.
///
/// Centraliza o logging de eventos para manter os nomes consistentes e
/// facilitar trocar de provedor depois. Só funciona se o Firebase foi
/// inicializado (ver `main.dart`).
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  FirebaseAnalytics get _analytics => FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object>? params}) =>
      _analytics.logEvent(name: name, parameters: params);

  FirebaseAnalyticsObserver get navObserver =>
      FirebaseAnalyticsObserver(analytics: _analytics);
}
