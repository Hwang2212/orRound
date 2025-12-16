# Add Journey Statistics Dashboard

## Phase

**Phase 1** - Core Feature

## Why

Users who track journeys regularly want to see their overall progress and trends. Currently, the home page only shows recent journeys without any aggregate statistics. A dedicated statistics dashboard would:

- Motivate users by showing total progress
- Enable goal tracking and progress monitoring
- Provide insights into activity patterns
- Create a sense of accomplishment

## What Changes

- **NEW**: Statistics page accessible from home page
- **NEW**: Summary cards (total distance, total journeys, total time)
- **NEW**: Time period filters (This Week, This Month, This Year, All Time)
- **NEW**: Personal records section (longest journey, fastest average speed)
- **NEW**: Activity breakdown by category (if categories feature is implemented)
- **NEW**: Weekly/monthly activity chart (simple bar chart)
- **MODIFIED**: Home page to show quick stats summary and link to full stats page
- **MODIFIED**: Navigation to include stats route

## Impact

- Affected specs: `home-page` (MODIFIED), new spec `statistics`
- Affected code:
  - New module: `lib/app/modules/statistics/`
  - `lib/app/modules/home/` - quick stats widget
  - `lib/app/data/repositories/journey_repository.dart` - aggregate queries
  - `lib/app/config/routes.dart` - new route

## User Experience

- **Positive**: Clear visibility of overall progress
- **Positive**: Motivation through personal records
- **Positive**: Understanding of activity patterns
- **Neutral**: Additional navigation to access full stats

## Implementation Approach

1. Create statistics module with controller, view, binding
2. Add aggregate query methods to JourneyRepository
3. Design summary cards with total distance, journeys, time
4. Add time period filter (chips or segmented control)
5. Add personal records section
6. Add simple activity chart (weekly bars)
7. Add quick stats widget on home page header

## Acceptance Criteria

1. Stats page shows total distance traveled
2. Stats page shows total number of journeys
3. Stats page shows total time spent
4. User can filter stats by time period
5. Personal records section shows longest and fastest journeys
6. Home page shows condensed stats summary
7. Stats update immediately when new journey is saved
