# journey-detail Specification

## Purpose
TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.
## Requirements
### Requirement: Comprehensive Journey Information Display

The system SHALL display all journey details including statistics, weather, and route map.

#### Scenario: View Journey Details

- **GIVEN** a journey has been completed
- **WHEN** the user opens the journey detail page
- **THEN** the system displays journey start date and time
- **AND** displays total elapsed time
- **AND** displays total distance traveled
- **AND** displays average speed
- **AND** displays weather condition and temperature (if recorded)
- **AND** all statistics are formatted with appropriate units

#### Scenario: View Journey Without Weather Data

- **GIVEN** a journey was completed offline without weather data
- **WHEN** the user views journey details
- **THEN** the system displays "Weather data unavailable" for weather fields
- **AND** all other journey statistics are displayed normally

### Requirement: Journey Route Map Display

The system SHALL display the complete journey route on an interactive map.

#### Scenario: View Journey Route

- **GIVEN** the user is viewing journey details
- **WHEN** the map section is displayed
- **THEN** the system renders the complete route as a polyline on OpenStreetMap
- **AND** displays start point marker
- **AND** displays end point marker
- **AND** automatically fits map bounds to show entire route
- **AND** allows user to pan and zoom the map

#### Scenario: View Journey with Few Points

- **GIVEN** a journey has less than 10 recorded location points
- **WHEN** viewing the journey map
- **THEN** the system displays all points as markers
- **AND** connects them with a polyline
- **AND** shows a notice if data quality may be low

### Requirement: Journey Sharing

The system SHALL allow users to share journey details as a screenshot image.

#### Scenario: Share Journey as Screenshot

- **GIVEN** the user is viewing journey details
- **WHEN** the user taps the "Share" button
- **THEN** the system captures the detail view (stats + map) as an image
- **AND** saves the image to device gallery using gal package
- **AND** opens system share sheet with the image attached
- **AND** logs "journey_shared" analytics event with journey duration parameter

#### Scenario: Share to Social Media

- **GIVEN** the share sheet is displayed
- **WHEN** the user selects a sharing destination (e.g., WhatsApp, Instagram)
- **THEN** the system passes the journey screenshot to the selected app
- **AND** pre-fills share text with "Check out my journey on Orround!" (if platform supports)

#### Scenario: Share Without Gallery Permission

- **GIVEN** gallery/photo permissions are not granted
- **WHEN** the user attempts to share a journey
- **THEN** the system requests gallery permissions
- **AND** only saves to gallery if permissions are granted
- **AND** proceeds with share sheet regardless of save outcome

### Requirement: Journey Detail Navigation

The system SHALL provide navigation back to home page from journey details.

#### Scenario: Return to Home

- **GIVEN** the user is viewing journey details
- **WHEN** the user taps the back button or swipes back
- **THEN** the system navigates back to the home page
- **AND** refreshes the journey list to reflect any changes

### Requirement: Journey Metadata Display

The system SHALL display formatted timestamps and human-readable journey information.

#### Scenario: Format Journey Timestamps

- **GIVEN** a journey was completed
- **WHEN** viewing journey details
- **THEN** start time is displayed as "MMM DD, YYYY at HH:MM AM/PM"
- **AND** duration is displayed as "Xh YYm ZZs" or "YYm ZZs" for journeys under 1 hour
- **AND** all times use user's local timezone

