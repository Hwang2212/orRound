## ADDED Requirements

### Requirement: Statistics Summary Cards

The system SHALL display aggregate journey statistics in summary cards.

#### Scenario: View Total Distance

- **GIVEN** the user has completed journeys totaling 42.5 km
- **WHEN** viewing the statistics page
- **THEN** a summary card displays "42.5 km" as total distance
- **AND** the card has a distance icon (straighten)

#### Scenario: View Total Journeys

- **GIVEN** the user has completed 15 journeys
- **WHEN** viewing the statistics page
- **THEN** a summary card displays "15" as total journeys count
- **AND** the card has a journeys icon (route)

#### Scenario: View Total Time

- **GIVEN** the user has spent 8 hours 30 minutes tracking journeys
- **WHEN** viewing the statistics page
- **THEN** a summary card displays "8h 30m" as total time
- **AND** the card has a time icon (timer)

### Requirement: Time Period Filter

The system SHALL allow users to filter statistics by time period.

#### Scenario: Filter by This Week

- **GIVEN** the user is on the statistics page
- **WHEN** the user selects "This Week" filter
- **THEN** all statistics update to show only data from the current week (Monday-Sunday)
- **AND** the "This Week" filter appears selected

#### Scenario: Filter by This Month

- **GIVEN** the user is on the statistics page
- **WHEN** the user selects "This Month" filter
- **THEN** all statistics update to show only data from the current calendar month

#### Scenario: Filter by All Time

- **GIVEN** the user is on the statistics page
- **WHEN** the user selects "All Time" filter
- **THEN** all statistics include data from all journeys ever recorded

### Requirement: Personal Records

The system SHALL display the user's personal records.

#### Scenario: Show Longest Journey

- **GIVEN** the user's longest journey was 25.3 km
- **WHEN** viewing the personal records section
- **THEN** "Longest Journey" shows "25.3 km"
- **AND** the journey date is displayed
- **AND** tapping navigates to that journey's detail page

#### Scenario: Show Fastest Journey

- **GIVEN** the user's fastest average speed was 18.5 km/h
- **WHEN** viewing the personal records section
- **THEN** "Fastest Journey" shows "18.5 km/h"
- **AND** the journey date is displayed

#### Scenario: No Records Yet

- **GIVEN** the user has no completed journeys
- **WHEN** viewing the personal records section
- **THEN** a placeholder message shows "Complete your first journey to see records"

### Requirement: Weekly Activity Chart

The system SHALL display a simple weekly activity visualization.

#### Scenario: View Weekly Distance Chart

- **GIVEN** the user has journeys over the past week
- **WHEN** viewing the activity chart section
- **THEN** a bar chart shows distance per day for the last 7 days
- **AND** days are labeled (Mon, Tue, Wed, etc.)
- **AND** bars are proportional to distance traveled

#### Scenario: No Activity This Week

- **GIVEN** the user has no journeys this week
- **WHEN** viewing the activity chart
- **THEN** all bars show zero height
- **AND** a subtle message encourages "Start a journey today!"

**IMPLEMENTATION NOTES:**

- Use custom painter or simple Container widgets for bars (no external chart library)
- Summary cards in a 2x2 or 3-column grid
- Time filters as `ChoiceChip` row
- Personal records as ListTiles with navigation
- Chart uses fixed 7-day view (last 7 days from today)
