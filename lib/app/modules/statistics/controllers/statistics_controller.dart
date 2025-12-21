import 'package:get/get.dart';
import '../../../data/models/journey.dart';
import '../../../data/repositories/journey_repository.dart';

enum StatsPeriod { week, month, year, allTime }

class StatisticsController extends GetxController {
  final JourneyRepository _journeyRepository = JourneyRepository();

  final currentPeriod = StatsPeriod.allTime.obs;
  final totalDistance = 0.0.obs;
  final totalJourneys = 0.obs;
  final totalDuration = 0.obs;
  final longestJourney = Rxn<Journey>();
  final fastestJourney = Rxn<Journey>();
  final weeklyData = <DateTime, double>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
  }

  void setTimePeriod(StatsPeriod period) {
    currentPeriod.value = period;
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    isLoading.value = true;

    try {
      final dateRange = _getDateRange();

      // Load aggregate statistics
      final distance = await _journeyRepository.getTotalDistance(from: dateRange.$1, to: dateRange.$2);
      final journeys = await _journeyRepository.getTotalJourneys(from: dateRange.$1, to: dateRange.$2);
      final duration = await _journeyRepository.getTotalDuration(from: dateRange.$1, to: dateRange.$2);

      totalDistance.value = distance;
      totalJourneys.value = journeys;
      totalDuration.value = duration;

      // Load personal records (always all-time)
      longestJourney.value = await _journeyRepository.getLongestJourney();
      fastestJourney.value = await _journeyRepository.getFastestJourney();

      // Load weekly chart data
      final days = currentPeriod.value == StatsPeriod.week ? 7 : 30;
      weeklyData.value = await _journeyRepository.getDailyDistances(days);
    } catch (e) {
      print('Error loading statistics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  (DateTime?, DateTime?) _getDateRange() {
    final now = DateTime.now();

    switch (currentPeriod.value) {
      case StatsPeriod.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return (DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day), DateTime(now.year, now.month, now.day, 23, 59, 59));
      case StatsPeriod.month:
        return (DateTime(now.year, now.month, 1), DateTime(now.year, now.month, now.day, 23, 59, 59));
      case StatsPeriod.year:
        return (DateTime(now.year, 1, 1), DateTime(now.year, now.month, now.day, 23, 59, 59));
      case StatsPeriod.allTime:
        return (null, null);
    }
  }

  String get formattedDistance {
    if (totalDistance.value >= 1000) {
      return '${(totalDistance.value / 1000).toStringAsFixed(1)} km';
    }
    return '${totalDistance.value.toStringAsFixed(0)} m';
  }

  String get formattedDuration {
    final hours = totalDuration.value ~/ 3600;
    final minutes = (totalDuration.value % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get periodLabel {
    switch (currentPeriod.value) {
      case StatsPeriod.week:
        return 'This Week';
      case StatsPeriod.month:
        return 'This Month';
      case StatsPeriod.year:
        return 'This Year';
      case StatsPeriod.allTime:
        return 'All Time';
    }
  }
}
