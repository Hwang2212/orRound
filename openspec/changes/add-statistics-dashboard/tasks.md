# Tasks: Add Journey Statistics Dashboard

## 1. Repository Layer - Aggregate Queries

- [ ] Update `JourneyRepository` in `lib/app/data/repositories/journey_repository.dart`
  - [ ] Add `getTotalDistance({DateTime? from, DateTime? to})` method
  - [ ] Add `getTotalJourneys({DateTime? from, DateTime? to})` method
  - [ ] Add `getTotalDuration({DateTime? from, DateTime? to})` method
  - [ ] Add `getLongestJourney()` method returning Journey?
  - [ ] Add `getFastestJourney()` method returning Journey?
  - [ ] Add `getDailyDistances(int days)` method for chart data

## 2. Statistics Module Setup

- [ ] Create `lib/app/modules/statistics/` directory structure
- [ ] Create `StatisticsController` in `controllers/statistics_controller.dart`
  - [ ] Add time period filter state (enum: week, month, year, allTime)
  - [ ] Add computed stats getters (totalDistance, totalJourneys, totalTime)
  - [ ] Add personal records getters (longestJourney, fastestJourney)
  - [ ] Add weekly chart data getter
  - [ ] Add `setTimePeriod(StatsPeriod)` method
  - [ ] Fetch data on init and when filter changes
- [ ] Create `StatisticsBinding` in `bindings/statistics_binding.dart`
- [ ] Create `StatisticsView` in `views/statistics_view.dart`

## 3. Statistics Page UI

- [ ] Build statistics view layout:
  - [ ] App bar with title "Statistics"
  - [ ] Time period filter chips (This Week, This Month, This Year, All Time)
  - [ ] Summary cards grid (distance, journeys, time)
  - [ ] Personal records section (longest, fastest)
  - [ ] Weekly activity chart section
- [ ] Create reusable `StatCard` widget
- [ ] Create `PersonalRecordTile` widget with navigation
- [ ] Create `WeeklyChart` widget using Container bars

## 4. Navigation & Routes

- [ ] Add `STATISTICS` route to `lib/app/modules/routes/routes.dart`
- [ ] Add statistics route to `lib/app/config/routes.dart`
- [ ] Import statistics module files

## 5. Home Page Quick Stats

- [ ] Update `HomeController`
  - [ ] Add quick stats getters (totalDistance, totalJourneys, totalTime)
  - [ ] Load stats on init
- [ ] Update `HomeView`
  - [ ] Add `QuickStatsWidget` below header
  - [ ] Make widget tappable to navigate to statistics page

## 6. Testing & Validation

- [ ] Test aggregate queries with various data sets
- [ ] Test time period filtering
- [ ] Test personal records with edge cases (no journeys, single journey)
- [ ] Test navigation from home to stats
- [ ] Run `openspec validate add-statistics-dashboard --strict`
- [ ] Run `flutter analyze`
