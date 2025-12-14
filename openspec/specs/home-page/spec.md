# home-page Specification

## Purpose
TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.
## Requirements
### Requirement: User Profile Header Display

The system SHALL display a header with the user's name on the home page.

#### Scenario: Display User Name in Header

- **GIVEN** the user has set their name in profile
- **WHEN** the user opens the home page
- **THEN** the system displays the user's name in the header
- **AND** shows a greeting message with the name (e.g., "Hello, [Name]")

#### Scenario: Display Default Name

- **GIVEN** the user has not set their name
- **WHEN** the user opens the home page
- **THEN** the system displays a default greeting "Hello, Traveler"
- **AND** provides a visual indicator to complete profile

#### Scenario: Navigate to Profile from Header

- **GIVEN** the user is on the home page
- **WHEN** the user taps on their name or profile avatar in header
- **THEN** the system navigates to the profile page
- **AND** displays full user profile information

### Requirement: Recent Journey History Display

The system SHALL display a list of recent journeys on the home page showing key journey information.

#### Scenario: View Recent Journeys

- **GIVEN** the user has completed at least one journey
- **WHEN** the user opens the home page
- **THEN** the system displays a scrollable list of recent journeys (up to 10)
- **AND** each journey item shows date, duration, and distance
- **AND** journey items are ordered by most recent first

#### Scenario: No Journeys Available

- **GIVEN** the user has not completed any journeys
- **WHEN** the user opens the home page
- **THEN** the system displays an empty state message
- **AND** shows instructions to start their first journey

#### Scenario: Navigate to Journey Detail

- **GIVEN** journey history is displayed
- **WHEN** the user taps on a journey item
- **THEN** the system navigates to the journey detail page
- **AND** displays full information for that journey

### Requirement: Current Weather Display

The system SHALL display current weather for the user's location when internet connectivity is available.

#### Scenario: Display Current Weather

- **GIVEN** the app has internet connectivity
- **AND** location permissions are granted
- **WHEN** the user opens the home page
- **THEN** the system fetches current weather from Open-Meteo API
- **AND** displays temperature and weather condition
- **AND** updates weather data every 30 minutes

#### Scenario: Offline Weather State

- **GIVEN** the app has no internet connectivity
- **WHEN** the user opens the home page
- **THEN** the system displays "Weather unavailable" message
- **AND** shows last cached weather data if available

#### Scenario: Location Permission Denied

- **GIVEN** location permissions are denied
- **WHEN** the user opens the home page
- **THEN** the system displays weather status as "Location access needed"
- **AND** does not attempt to fetch weather data

### Requirement: Start Journey Action

The system SHALL provide a prominent button to start journey tracking from the home page.

#### Scenario: Start New Journey

- **GIVEN** the user is on the home page
- **AND** location permissions are granted
- **WHEN** the user taps the "Start Journey" button
- **THEN** the system navigates to the journey tracking page
- **AND** immediately begins recording location data
- **AND** logs a "journey_started" analytics event

#### Scenario: Start Journey Without Location Permission

- **GIVEN** the user is on the home page
- **AND** location permissions are not granted
- **WHEN** the user taps the "Start Journey" button
- **THEN** the system displays a permission request dialog
- **AND** does not navigate until permissions are granted

### Requirement: Navigation to Referral System

The system SHALL provide access to the referral system from the home page.

#### Scenario: Access My Referral Code

- **GIVEN** the user is on the home page
- **WHEN** the user taps on the referral menu option
- **THEN** the system navigates to the "My Referral" page
- **AND** displays the user's unique referral code

