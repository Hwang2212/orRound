# Spec: Journey Tracking

## ADDED Requirements

### Requirement: Real-Time Journey Recording

The system SHALL continuously record location data during an active journey.

#### Scenario: Record Location Points

- **GIVEN** the user has started a journey
- **AND** location permissions are granted
- **WHEN** the tracking is active
- **THEN** the system records GPS coordinates (latitude, longitude) every 5 seconds or 10 meters
- **AND** stores each point with timestamp and current speed
- **AND** calculates cumulative distance using Haversine formula

#### Scenario: Handle GPS Signal Loss

- **GIVEN** journey tracking is active
- **WHEN** GPS signal is lost
- **THEN** the system displays a warning indicator
- **AND** continues tracking using last known location
- **AND** resumes normal recording when signal returns
- **AND** logs signal loss event to analytics

### Requirement: Time Elapsed Display

The system SHALL display the elapsed time since journey start in real-time.

#### Scenario: Show Running Timer

- **GIVEN** the user has started a journey
- **WHEN** viewing the tracking page
- **THEN** the system displays elapsed time in MM:SS or HH:MM:SS format
- **AND** updates the timer every second via Timer.periodic
- **AND** timer starts immediately when Start button is pressed
- **AND** timer continues accurately when app is backgrounded
- **AND** excludes paused time from elapsed calculation

**IMPLEMENTATION NOTES:**

- Timer initialization is non-blocking (starts before location is acquired)
- Elapsed time calculation: (currentTime - startTime - totalPausedTime) / 1000
- Format: MM:SS for < 1 hour, HH:MM:SS for >= 1 hour
- Uses tabular figure font features for monospaced digits

### Requirement: Current Speed Display

The system SHALL display the user's current speed during journey tracking.

#### Scenario: Show Current Speed

- **GIVEN** journey tracking is active
- **WHEN** GPS data is available
- **THEN** the system displays current speed in km/h
- **AND** updates speed display every 2 seconds
- **AND** shows "0 km/h" when stationary (speed < 0.5 km/h)

### Requirement: Route Map Visualization

The system SHALL display the tracked route on a map during journey tracking.

#### Scenario: View Tracking Map

- **GIVEN** the user has started a journey
- **WHEN** viewing the journey tracking page
- **THEN** the system displays OpenStreetMap tiles as the base map
- **AND** shows a loading indicator while acquiring GPS location
- **AND** centers map on user's location once acquired
- **AND** draws a polyline connecting all recorded points in primary color
- **AND** displays a green start marker at journey start point
- **AND** displays a primary-colored current position marker
- **AND** auto-updates map as new location points are received

**IMPLEMENTATION NOTES:**

- Map always renders (even before location is acquired) to avoid blank screen
- Initial zoom level is 2.0 (world view) when no location, 15.0 when tracking
- Map uses flutter_map with OpenStreetMap tiles
- Timer starts immediately when Start button is pressed (non-blocking)
- Location acquisition happens asynchronously to prevent UI blocking
- Location stream provides continuous updates every 5 seconds or 10 meters

### Requirement: Journey Control Actions

The system SHALL provide controls to pause, resume, and end journey tracking.

#### Scenario: End Journey

- **GIVEN** journey tracking is active
- **WHEN** the user taps "End Journey" button
- **THEN** the system displays a confirmation dialog
- **AND** on confirmation, stops location recording
- **AND** calculates final statistics (total distance, average speed)
- **AND** fetches current weather data if online
- **AND** saves journey to database
- **AND** logs "journey_ended" analytics event
- **AND** navigates to journey detail page

#### Scenario: Pause Journey

- **GIVEN** journey tracking is active
- **WHEN** the user taps "Pause" button
- **THEN** the system pauses location recording
- **AND** pauses the elapsed timer
- **AND** displays "Resume" button
- **AND** logs "journey_paused" analytics event

#### Scenario: Resume Journey

- **GIVEN** journey is paused
- **WHEN** the user taps "Resume" button
- **THEN** the system resumes location recording
- **AND** resumes the elapsed timer
- **AND** continues from current location

### Requirement: Background Tracking

The system SHALL continue tracking when the app is backgrounded.

#### Scenario: Track in Background

- **GIVEN** journey tracking is active
- **WHEN** the user backgrounds the app
- **THEN** the system continues recording location data
- **AND** maintains elapsed timer
- **AND** displays persistent notification (Android) or background indicator (iOS)

### Requirement: Weather Recording at Journey End

The system SHALL record weather conditions when a journey ends.

#### Scenario: Capture Weather on Journey End

- **GIVEN** journey tracking has ended
- **AND** internet connectivity is available
- **WHEN** saving the journey
- **THEN** the system fetches current weather from Open-Meteo API
- **AND** stores temperature and weather condition with journey
- **AND** uses journey end location for weather lookup

#### Scenario: Offline Journey End

- **GIVEN** journey tracking has ended
- **AND** no internet connectivity
- **WHEN** saving the journey
- **THEN** the system saves journey without weather data
- **AND** marks weather fields as null
- **AND** allows journey to be saved successfully

### Requirement: Journey Statistics Calculation

The system SHALL calculate and display journey statistics during and after tracking.

#### Scenario: Calculate Average Speed

- **GIVEN** journey is active or completed
- **WHEN** the system calculates statistics
- **THEN** average speed is computed as total distance / total time
- **AND** displayed in km/h
- **AND** excludes paused time from calculation
