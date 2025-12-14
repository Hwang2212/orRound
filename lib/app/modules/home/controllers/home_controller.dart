import 'package:get/get.dart';
import '../../../data/models/journey.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/weather_data.dart';
import '../../../data/repositories/journey_repository.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/weather_repository.dart';
import '../../../data/repositories/analytics_repository.dart';
import '../../../data/providers/location_provider.dart';
import '../../routes/routes.dart';

class HomeController extends GetxController {
  final JourneyRepository _journeyRepo = JourneyRepository();
  final UserRepository _userRepo = UserRepository();
  final WeatherRepository _weatherRepo = WeatherRepository();
  final AnalyticsRepository _analyticsRepo = AnalyticsRepository();
  final LocationProvider _locationProvider = LocationProvider();

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final RxList<Journey> recentJourneys = <Journey>[].obs;
  final Rx<WeatherData?> currentWeather = Rx<WeatherData?>(null);
  final RxBool isLoadingJourneys = false.obs;
  final RxBool isLoadingWeather = false.obs;
  final RxInt totalJourneysCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeHome();
  }

  Future<void> _initializeHome() async {
    await _loadUserProfile();
    await _loadRecentJourneys();
    await _loadWeather();
    await _analyticsRepo.logAppLaunched();
  }

  Future<void> _loadUserProfile() async {
    UserProfile? profile = await _userRepo.getUserProfile();

    if (profile == null) {
      // First time user - create default profile
      profile = await _userRepo.createUserProfile();
      await _analyticsRepo.logReferralCodeGenerated();
    }

    userProfile.value = profile;
  }

  Future<void> _loadRecentJourneys() async {
    isLoadingJourneys.value = true;
    try {
      recentJourneys.value = await _journeyRepo.getRecentJourneys(limit: 10);
      totalJourneysCount.value = await _journeyRepo.getJourneyCount();

      if (totalJourneysCount.value > 0) {
        await _analyticsRepo.setHasCompletedJourney(true);
        await _analyticsRepo.setTotalJourneysCount(totalJourneysCount.value);
      }
    } catch (e) {
      await _analyticsRepo.logDatabaseError(operationType: 'load_journeys', errorMessage: e.toString());
      Get.snackbar('Error', 'Failed to load journeys');
    } finally {
      isLoadingJourneys.value = false;
    }
  }

  Future<void> _loadWeather() async {
    isLoadingWeather.value = true;
    try {
      final location = await _locationProvider.getCurrentLocation();
      if (location != null && location.latitude != null && location.longitude != null) {
        final weather = await _weatherRepo.getCurrentWeather(location.latitude!, location.longitude!);

        if (weather != null) {
          currentWeather.value = weather;
          await _analyticsRepo.logWeatherFetched(temperature: weather.temperature, condition: weather.condition, fetchContext: 'home_page');
        }
      }
    } catch (e) {
      print('Weather load error: $e');
      await _analyticsRepo.logApiError(apiName: 'open_meteo', errorType: e.toString());
    } finally {
      isLoadingWeather.value = false;
    }
  }

  void navigateToProfile() {
    _analyticsRepo.logProfileViewed();
    Get.toNamed(Routes.PROFILE);
  }

  void navigateToTracking() {
    Get.toNamed(Routes.JOURNEY_TRACKING);
  }

  void navigateToJourneyDetail(Journey journey) {
    final ageDays = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(journey.startTime)).inDays;

    _analyticsRepo.logJourneyViewed(journeyAgeDays: ageDays);
    Get.toNamed(Routes.JOURNEY_DETAIL, arguments: journey.id);
  }

  Future<void> refreshData() async {
    await Future.wait([_loadRecentJourneys(), _loadWeather()]);
  }

  String get welcomeMessage {
    final profile = userProfile.value;
    if (profile?.name != null && profile!.name!.isNotEmpty) {
      return 'Hello, ${profile.displayName}';
    }
    return 'Welcome to Orround';
  }

  String get weatherDisplay {
    final weather = currentWeather.value;
    if (weather == null) return '';
    return '${weather.formattedTemperature} • ${weather.condition}';
  }
}
