## MODIFIED Requirements

### Requirement: Quick Stats on Home Page

The system SHALL display a condensed statistics summary on the home page.

#### Scenario: View Quick Stats

- **GIVEN** the user has journeys recorded
- **WHEN** viewing the home page
- **THEN** a quick stats row displays below the header
- **AND** shows total distance, journey count, and total time in compact format
- **AND** a "View All" or arrow button links to full statistics page

#### Scenario: Tap Quick Stats

- **GIVEN** the user is on the home page
- **WHEN** the user taps the quick stats section
- **THEN** the app navigates to the full statistics page

#### Scenario: Empty State Quick Stats

- **GIVEN** the user has no journeys
- **WHEN** viewing the home page
- **THEN** quick stats shows "0 km", "0 journeys", "0h 0m"
- **AND** tapping still navigates to stats page

**IMPLEMENTATION NOTES:**

- Quick stats widget: horizontal row with 3 compact stat items
- Position: below greeting, above "Recent Journeys" title
- Compact format: "12.5 km • 5 journeys • 2h 15m"
- Entire row tappable with InkWell
