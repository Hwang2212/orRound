# Tasks: Add Journey Statistics Dashboard

## 1. Repository Layer - Aggregate Queries

- [x] Update `JourneyRepository` in `lib/app/data/repositories/journey_repository.dart`
  - [x] Add `getTotalDistance({DateTime? from, DateTime? to})` method
  - [x] Add `getTotalJourneys({DateTime? from, DateTime? to})` method
  - [x] Add `getTotalDuration({DateTime? from, DateTime? to})` method
  - [x] Add `getLongestJourney()` method returning Journey?
  - [x] Add `getFastestJourney()` method returning Journey?
  - [x] Add `getDailyDistances(int days)` method for chart data

## 2. Statistics Module Setup

- [x] Create `lib/app/modules/statistics/` directory structure
- [x] Create `StatisticsController` in `controllers/statistics_controller.dart`
  - [x] Add time period filter state (enum: week, month, year, allTime)
  - [x] Add computed stats getters (totalDistance, totalJourneys, totalTime)
  - [x] Add personal records getters (longestJourney, fastestJourney)
  - [x] Add weekly chart data getter
  - [x] Add `setTimePeriod(StatsPeriod)` method
  - [x] Fetch data on init and when filter changes
- [x] Create `StatisticsBinding` in `bindings/statistics_binding.dart`
- [x] Create `StatisticsView` in `views/statistics_view.dart`

## 3. Statistics Page UI

- [x] Build statistics view layout:
  - [x] App bar with title "Statistics"
  - [x] Time period filter chips (This Week, This Month, This Year, All Time)
  - [x] Summary cards grid (distance, journeys, time)
  - [x] Personal records section (longest, fastest)
  - [x] Weekly activity chart section
- [x] Create reusable `StatCard` widget
- [x] Create `PersonalRecordTile` widget with navigation
- [x] Create `WeeklyChart` widget using Container bars

## 4. Navigation & Routes

- [x] Add `STATISTICS` route to `lib/app/modules/routes/routes.dart`
- [x] Add statistics route to `lib/app/config/routes.dart`
- [x] Import statistics module files

## 5. Home Page Quick Stats

- [x] Update `HomeController`
  - [x] Add quick stats getters (totalDistance, totalJourneys, totalTime)
  - [x] Load stats on init
- [x] Update `HomeView`
  - [x] Add `QuickStatsWidget` below header
  - [x] Make widget tappable to navigate to statistics page

## 6. Testing & Validation

- [x] Test aggregate queries with various data sets
- [x] Test time period filtering
- [x] Test personal records with edge cases (no journeys, single journey)
- [x] Test navigation from home to stats
- [x] Run `openspec validate add-statistics-dashboard --strict`
- [x] Run `flutter analyze`
