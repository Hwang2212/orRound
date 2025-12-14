import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

class AnalyticsRepository {
  FirebaseAnalytics? get _analytics {
    try {
      // Check if Firebase is initialized before accessing analytics
      if (Firebase.apps.isEmpty) return null;
      return FirebaseAnalytics.instance;
    } catch (e) {
      return null;
    }
  }

  // App events
  Future<void> logAppLaunched() async {
    await _analytics?.logEvent(name: 'app_launched');
  }

  // Journey events
  Future<void> logJourneyStarted({required bool hasLocationPermission, bool? hasNotificationPermission}) async {
    final parameters = {'has_location_permission': hasLocationPermission ? 1 : 0, 'timestamp': DateTime.now().millisecondsSinceEpoch};

    if (hasNotificationPermission != null) {
      parameters['has_notification_permission'] = hasNotificationPermission ? 1 : 0;
    }

    await _analytics?.logEvent(name: 'journey_started', parameters: parameters);
  }

  Future<void> logJourneyPaused({required int durationSeconds}) async {
    await _analytics?.logEvent(name: 'journey_paused', parameters: {'journey_duration_seconds': durationSeconds});
  }

  Future<void> logJourneyEnded({
    required int durationSeconds,
    required double distanceKm,
    required double averageSpeedKmh,
    required int pointsCount,
    required bool hasWeather,
  }) async {
    await _analytics?.logEvent(
      name: 'journey_ended',
      parameters: {
        'journey_duration_seconds': durationSeconds,
        'journey_distance_km': distanceKm,
        'average_speed_kmh': averageSpeedKmh,
        'location_points_count': pointsCount,
        'has_weather': hasWeather ? 1 : 0,
      },
    );
  }

  Future<void> logJourneyViewed({required int journeyAgeDays}) async {
    await _analytics?.logEvent(name: 'journey_viewed', parameters: {'journey_age_days': journeyAgeDays});
  }

  Future<void> logJourneyShared({required int durationSeconds, required double distanceKm, required bool hasWeather}) async {
    await _analytics?.logEvent(
      name: 'journey_shared',
      parameters: {'journey_duration_seconds': durationSeconds, 'journey_distance_km': distanceKm, 'has_weather': hasWeather ? 1 : 0},
    );
  }

  Future<void> logJourneyTitleEdited({required String journeyId, required int titleLength, required bool isCleared}) async {
    await _analytics?.logEvent(
      name: 'journey_title_edited',
      parameters: {'journey_id': journeyId, 'title_length': titleLength, 'is_cleared': isCleared ? 1 : 0},
    );
  }

  // Map events
  Future<void> logMapViewed({required String viewContext}) async {
    await _analytics?.logEvent(name: 'map_viewed', parameters: {'view_context': viewContext});
  }

  // Weather events
  Future<void> logWeatherFetched({required double temperature, required String condition, required String fetchContext}) async {
    await _analytics?.logEvent(
      name: 'weather_fetched',
      parameters: {'temperature': temperature, 'weather_condition': condition, 'fetch_context': fetchContext},
    );
  }

  // Profile events
  Future<void> logProfileViewed() async {
    await _analytics?.logEvent(name: 'profile_viewed');
  }

  Future<void> logProfileUpdated({required List<String> fieldsUpdated}) async {
    await _analytics?.logEvent(name: 'profile_updated', parameters: {'fields_updated': fieldsUpdated.join(',')});
  }

  Future<void> logProfilePictureUpdated({required String source}) async {
    await _analytics?.logEvent(name: 'profile_picture_updated', parameters: {'source': source});
  }

  // Referral events
  Future<void> logReferralCodeGenerated() async {
    await _analytics?.logEvent(name: 'referral_code_generated');
  }

  Future<void> logReferralCodeEntered({required bool hasReferredBy}) async {
    await _analytics?.logEvent(name: 'referral_code_entered', parameters: {'has_referred_by': hasReferredBy ? 1 : 0});
  }

  // Error events
  Future<void> logLocationError({required String errorType, required String errorContext}) async {
    await _analytics?.logEvent(name: 'location_error', parameters: {'error_type': errorType, 'error_context': errorContext});
  }

  Future<void> logDatabaseError({required String operationType, required String errorMessage}) async {
    await _analytics?.logEvent(name: 'database_error', parameters: {'operation_type': operationType, 'error_message': errorMessage.substring(0, 100)});
  }

  Future<void> logApiError({required String apiName, required String errorType}) async {
    await _analytics?.logEvent(name: 'api_error', parameters: {'api_name': apiName, 'error_type': errorType});
  }

  // User properties
  Future<void> setUserProperty({required String name, required String value}) async {
    await _analytics?.setUserProperty(name: name, value: value);
  }

  Future<void> setHasCompletedJourney(bool value) async {
    await setUserProperty(name: 'has_completed_journey', value: value.toString());
  }

  Future<void> setTotalJourneysCount(int count) async {
    await setUserProperty(name: 'total_journeys_count', value: count.toString());
  }

  Future<void> setHasUsedReferral(bool value) async {
    await setUserProperty(name: 'has_used_referral', value: value.toString());
  }
}
