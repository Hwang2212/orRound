## MODIFIED Requirements

### Requirement: Filter Journeys by Category

The system SHALL allow users to filter the journey list by category on the home page.

#### Scenario: Display Category Filter Chips

- **GIVEN** the user is on the home page
- **WHEN** the page loads
- **THEN** a horizontal row of filter chips is displayed above the journey list
- **AND** chips include: All, Walk, Run, Bike, Drive, Hike, Other
- **AND** "All" is selected by default
- **AND** each category chip shows its corresponding icon

#### Scenario: Filter by Single Category

- **GIVEN** the user is on the home page with journeys of various categories
- **WHEN** the user taps the "Run" filter chip
- **THEN** only journeys with category "Run" are displayed
- **AND** the "Run" chip appears selected (filled/highlighted)
- **AND** the journey count updates to show filtered count

#### Scenario: Clear Filter

- **GIVEN** the user has filtered to show only "Bike" journeys
- **WHEN** the user taps the "All" filter chip
- **THEN** all journeys are displayed regardless of category
- **AND** the "All" chip appears selected

#### Scenario: Show Category Icons in Journey Cards

- **GIVEN** journeys are displayed in the list
- **WHEN** viewing a journey card
- **THEN** the journey's category icon is displayed alongside the title or date
- **AND** the icon matches the category (Walk, Run, Bike, etc.)

**IMPLEMENTATION NOTES:**

- Filter chips: horizontal `ListView` with `FilterChip` widgets
- Position: below the header, above "Recent Journeys" section
- Filter state stored in HomeController
- Filtering done client-side (no database query change needed for MVP)
- Icon size in cards: 16-20px inline with text
