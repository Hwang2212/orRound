import 'dart:async';
import 'dart:math';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/journey.dart';
import '../../../data/models/location_point.dart';
import '../../../data/models/weather_data.dart';
import '../../../data/repositories/journey_repository.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../../data/repositories/analytics_repository.dart';
import '../../../data/providers/location_provider.dart';

class JourneyTrackingController extends GetxController {
  final JourneyRepository _journeyRepo = JourneyRepository();
  final WeatherRepository _weatherRepo = WeatherRepository();
  final AnalyticsRepository _analyticsRepo = AnalyticsRepository();
  final LocationProvider _locationProvider = LocationProvider();

  final RxList<LocationPoint> locationPoints = <LocationPoint>[].obs;
  final Rx<WeatherData?> startWeather = Rx<WeatherData?>(null);
  final RxBool isTracking = false.obs;
  final RxBool isPaused = false.obs;
  final RxInt elapsedSeconds = 0.obs;
  final RxDouble distanceKm = 0.0.obs;
  final RxDouble currentSpeedKmh = 0.0.obs;
  final RxBool hasLocationPermission = false.obs;
  final Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  final MapController mapController = MapController();

  late String _journeyId;
  int? _startTime;
  int? _pauseStartTime;
  int _totalPausedMillis = 0;
  Timer? _timer;
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void onInit() {
    super.onInit();
    _checkPermissions();
    _getInitialLocation();
  }

  @override
  void onClose() {
    _stopTracking();
    super.onClose();
  }

  Future<void> _getInitialLocation() async {
    try {
      final location = await _locationProvider.getCurrentLocation();
      if (location != null && location.latitude != null && location.longitude != null) {
        currentLocation.value = LatLng(location.latitude!, location.longitude!);
        print('Initial location set: ${currentLocation.value}');
      }
    } catch (e) {
      print('Error getting initial location: $e');
    }
  }

  Future<void> _checkPermissions() async {
    hasLocationPermission.value = await _locationProvider.checkPermission();

    if (!hasLocationPermission.value) {
      hasLocationPermission.value = await _locationProvider.requestPermission();
    }
  }

  Future<void> startTracking() async {
    print('startTracking called');
    if (!hasLocationPermission.value) {
      await _checkPermissions();
      if (!hasLocationPermission.value) {
        Get.snackbar('Permission Required', 'Location permission is needed to track your journey');
        return;
      }
    }

    _journeyId = _journeyRepo.generateJourneyId();
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _totalPausedMillis = 0;
    locationPoints.clear();
    distanceKm.value = 0.0;

    isTracking.value = true;
    isPaused.value = false;

    print('Journey started: $_journeyId, startTime: $_startTime');

    // Start timer immediately
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
    print('Timer started');

    // Configure location provider for tracking
    await _locationProvider.changeSettings(accuracy: loc.LocationAccuracy.high, interval: 5000, distanceFilter: 10);

    // Try to enable background mode (may fail if background permission not granted)
    try {
      await _locationProvider.enableBackgroundMode(true);
      print('Background mode enabled');
    } catch (e) {
      print('Background mode not available (requires background location permission): $e');
      // Continue without background mode - foreground tracking will still work
    }

    // Start location tracking stream
    _locationSubscription = _locationProvider.getLocationStream().listen(_onLocationUpdate);
    print('Location stream started');

    // Get initial weather and location (async, don't block)
    _locationProvider
        .getCurrentLocation()
        .then((currentLocation) {
          print('Got initial location: lat=${currentLocation?.latitude}, lng=${currentLocation?.longitude}');
          if (currentLocation != null && currentLocation.latitude != null && currentLocation.longitude != null) {
            // Add initial location point for map display
            final initialPoint = LocationPoint(
              id: _journeyRepo.generatePointId(),
              journeyId: _journeyId,
              latitude: currentLocation.latitude!,
              longitude: currentLocation.longitude!,
              speed: currentLocation.speed,
              timestamp: DateTime.now().millisecondsSinceEpoch,
            );
            locationPoints.add(initialPoint);
            print('Added initial location point, total points: ${locationPoints.length}');

            // Get weather
            _weatherRepo.getCurrentWeather(currentLocation.latitude!, currentLocation.longitude!).then((weather) {
              startWeather.value = weather;
            });
          } else {
            print('ERROR: getCurrentLocation returned null or invalid data');
          }
        })
        .catchError((error) {
          print('ERROR fetching location: $error');
        });

    await _analyticsRepo.logJourneyStarted(hasLocationPermission: hasLocationPermission.value);
  }

  void pauseTracking() {
    if (!isTracking.value || isPaused.value) return;

    isPaused.value = true;
    _pauseStartTime = DateTime.now().millisecondsSinceEpoch;
    _locationSubscription?.pause();

    _analyticsRepo.logJourneyPaused(durationSeconds: elapsedSeconds.value);
  }

  void resumeTracking() {
    if (!isTracking.value || !isPaused.value) return;

    if (_pauseStartTime != null) {
      _totalPausedMillis += DateTime.now().millisecondsSinceEpoch - _pauseStartTime!;
      _pauseStartTime = null;
    }

    isPaused.value = false;
    _locationSubscription?.resume();
  }

  Future<void> stopTracking() async {
    if (!isTracking.value) return;

    _stopTracking();

    // Save journey
    if (locationPoints.length >= 2) {
      final journey = Journey(
        id: _journeyId,
        startTime: _startTime!,
        endTime: DateTime.now().millisecondsSinceEpoch,
        totalDistance: distanceKm.value,
        averageSpeed: _calculateAverageSpeed(),
        weatherCondition: startWeather.value?.condition,
        temperature: startWeather.value?.temperature,
        createdAt: _startTime!,
      );

      await _journeyRepo.saveJourney(journey, locationPoints);

      await _analyticsRepo.logJourneyEnded(
        durationSeconds: elapsedSeconds.value,
        distanceKm: distanceKm.value,
        averageSpeedKmh: journey.averageSpeed,
        pointsCount: locationPoints.length,
        hasWeather: startWeather.value != null,
      );

      Get.back(result: journey.id);
      Get.snackbar('Journey Saved', 'Your journey has been saved');
    } else {
      Get.back();
      Get.snackbar('Journey Too Short', 'Not enough data to save');
    }
  }

  void _stopTracking() {
    isTracking.value = false;
    isPaused.value = false;
    _timer?.cancel();
    _locationSubscription?.cancel();
    _locationProvider.enableBackgroundMode(false);
  }

  void _onLocationUpdate(loc.LocationData location) {
    print('Location update received: lat=${location.latitude}, lng=${location.longitude}');
    if (isPaused.value || location.latitude == null || location.longitude == null) {
      return;
    }

    final point = LocationPoint(
      id: _journeyRepo.generatePointId(),
      journeyId: _journeyId,
      latitude: location.latitude!,
      longitude: location.longitude!,
      speed: location.speed,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    locationPoints.add(point);

    // Update distance
    if (locationPoints.length > 1) {
      final prev = locationPoints[locationPoints.length - 2];
      distanceKm.value += _calculateDistance(prev.latitude, prev.longitude, point.latitude, point.longitude);
    }

    // Update speed
    if (location.speed != null) {
      currentSpeedKmh.value = (location.speed! * 3.6).clamp(0, 999);
    }
  }

  void _onTimerTick(Timer timer) {
    if (isPaused.value) return;

    if (_startTime == null) {
      print('ERROR: _startTime is null in timer tick');
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsed = now - _startTime! - _totalPausedMillis;
    elapsedSeconds.value = (elapsed / 1000).floor();
    print('Timer tick: elapsed=${elapsedSeconds.value}s');
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // Earth radius in km
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * asin(sqrt(a));
    return R * c;
  }

  double _toRadians(double degrees) => degrees * pi / 180.0;

  double _calculateAverageSpeed() {
    if (elapsedSeconds.value == 0) return 0.0;
    return (distanceKm.value / elapsedSeconds.value) * 3600;
  }

  String get formattedDuration {
    final hours = elapsedSeconds.value ~/ 3600;
    final minutes = (elapsedSeconds.value % 3600) ~/ 60;
    final seconds = elapsedSeconds.value % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
