import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsProvider {
  static FirebaseAnalytics? _analytics;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await Firebase.initializeApp();
      _analytics = FirebaseAnalytics.instance;
      _initialized = true;
      print('Firebase Analytics initialized');
    } catch (e) {
      print('Firebase initialization error: $e');
    }
  }

  static FirebaseAnalytics? get analytics => _analytics;

  static bool get isInitialized => _initialized;

  static Future<void> logEvent({required String name, Map<String, Object?>? parameters}) async {
    if (!_initialized || _analytics == null) {
      print('Analytics not initialized, event queued: $name');
      return;
    }

    try {
      await _analytics!.logEvent(name: name, parameters: parameters);
    } catch (e) {
      print('Analytics event error: $e');
    }
  }

  static Future<void> setUserProperty({required String name, required String? value}) async {
    if (!_initialized || _analytics == null) {
      print('Analytics not initialized, user property queued: $name');
      return;
    }

    try {
      await _analytics!.setUserProperty(name: name, value: value);
    } catch (e) {
      print('Analytics user property error: $e');
    }
  }

  static Future<void> setUserId(String? userId) async {
    if (!_initialized || _analytics == null) return;

    try {
      await _analytics!.setUserId(id: userId);
    } catch (e) {
      print('Analytics set user ID error: $e');
    }
  }

  static Future<void> setAnalyticsCollectionEnabled(bool enabled) async {
    if (!_initialized || _analytics == null) return;

    try {
      await _analytics!.setAnalyticsCollectionEnabled(enabled);
    } catch (e) {
      print('Analytics collection toggle error: $e');
    }
  }
}
