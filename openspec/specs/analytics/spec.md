# analytics Specification

## Purpose
TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.
## Requirements
### Requirement: Firebase Analytics Integration

The system SHALL integrate Firebase Analytics to track user activities and app usage.

#### Scenario: Initialize Firebase Analytics

- **GIVEN** the app is launched
- **WHEN** app initialization occurs
- **THEN** the system initializes Firebase Core
- **AND** initializes Firebase Analytics
- **AND** sets analytics collection enabled
- **AND** configures automatic screen tracking

#### Scenario: Track App Launch

- **GIVEN** Firebase Analytics is initialized
- **WHEN** app is launched
- **THEN** the system logs "app_launched" event
- **AND** includes platform parameter (iOS/Android)
- **AND** includes app_version parameter

### Requirement: Journey Event Tracking

The system SHALL track all journey-related user actions.

#### Scenario: Track Journey Start

- **GIVEN** user starts a journey
- **WHEN** tracking begins
- **THEN** the system logs "journey_started" event
- **AND** includes has_location_permission parameter (boolean)
- **AND** includes timestamp parameter

#### Scenario: Track Journey Pause

- **GIVEN** user pauses an active journey
- **WHEN** pause action occurs
- **THEN** the system logs "journey_paused" event
- **AND** includes journey_duration_seconds parameter

#### Scenario: Track Journey End

- **GIVEN** user ends a journey
- **WHEN** journey is saved
- **THEN** the system logs "journey_ended" event
- **AND** includes journey_duration_seconds parameter
- **AND** includes journey_distance_km parameter
- **AND** includes average_speed_kmh parameter
- **AND** includes location_points_count parameter
- **AND** includes has_weather parameter (boolean)

#### Scenario: Track Journey View

- **GIVEN** user opens journey detail page
- **WHEN** page is displayed
- **THEN** the system logs "journey_viewed" event
- **AND** includes journey_age_days parameter (days since journey was created)
- **AND** logs screen_view event with screen_name "JourneyDetail"

### Requirement: Feature Usage Tracking

The system SHALL track usage of key app features.

#### Scenario: Track Map View

- **GIVEN** user switches to map view during tracking
- **WHEN** map view is displayed
- **THEN** the system logs "map_viewed" event
- **AND** includes view_context parameter ("tracking" or "detail")

#### Scenario: Track Weather Fetch

- **GIVEN** weather data is successfully fetched
- **WHEN** weather API call succeeds
- **THEN** the system logs "weather_fetched" event
- **AND** includes temperature parameter
- **AND** includes weather_condition parameter
- **AND** includes fetch_context parameter ("home" or "journey_end")

#### Scenario: Track Share Action

- **GIVEN** user shares a journey
- **WHEN** share sheet is opened
- **THEN** the system logs "journey_shared" event
- **AND** includes journey_duration_seconds parameter
- **AND** includes journey_distance_km parameter
- **AND** includes has_weather parameter (boolean)

### Requirement: Referral Event Tracking

The system SHALL track referral system interactions.

#### Scenario: Track Referral Code Generation

- **GIVEN** user's referral code is generated
- **WHEN** code creation occurs
- **THEN** the system logs "referral_code_generated" event
- **AND** event is logged only once per user

#### Scenario: Track Referral Code Entry

- **GIVEN** user enters a referral code
- **WHEN** code is successfully submitted
- **THEN** the system logs "referral_code_entered" event
- **AND** includes has_referred_by parameter (boolean)
- **AND** event is logged only once per user

### Requirement: Error Event Tracking

The system SHALL track errors and exceptions for monitoring.

#### Scenario: Track Location Service Errors

- **GIVEN** location services fail
- **WHEN** error occurs
- **THEN** the system logs "location_error" event
- **AND** includes error_type parameter ("permission_denied", "signal_lost", "service_disabled")
- **AND** includes error_context parameter (e.g., "journey_tracking")

#### Scenario: Track Database Errors

- **GIVEN** database operation fails
- **WHEN** error occurs
- **THEN** the system logs "database_error" event
- **AND** includes operation_type parameter ("read", "write", "delete")
- **AND** includes error_message parameter (sanitized)

#### Scenario: Track API Errors

- **GIVEN** external API call fails
- **WHEN** error occurs
- **THEN** the system logs "api_error" event
- **AND** includes api_name parameter ("open_meteo")
- **AND** includes error_type parameter ("timeout", "network", "invalid_response")

### Requirement: Screen Tracking

The system SHALL automatically track screen views.

#### Scenario: Track Screen Views

- **GIVEN** user navigates between pages
- **WHEN** a new page is displayed
- **THEN** the system logs automatic screen_view event
- **AND** includes screen_name parameter
- **AND** includes screen_class parameter

#### Scenario: Track Navigation Patterns

- **GIVEN** Firebase Analytics automatic tracking is enabled
- **WHEN** user navigates through app
- **THEN** screen names are logged as:
  - "Home" for home page
  - "JourneyTracking" for tracking page
  - "JourneyDetail" for detail page
  - "MyReferral" for referral code display
  - "EnterReferral" for referral code entry

### Requirement: User Property Tracking

The system SHALL set user properties for segmentation.

#### Scenario: Set User Properties

- **GIVEN** Firebase Analytics is initialized
- **WHEN** setting user properties
- **THEN** the system sets "has_completed_journey" property (boolean)
- **AND** sets "total_journeys_count" property (integer)
- **AND** sets "has_used_referral" property (boolean)
- **AND** updates properties when values change

### Requirement: Analytics Privacy Compliance

The system SHALL handle analytics in a privacy-compliant manner.

#### Scenario: Anonymous User Identification

- **GIVEN** Firebase Analytics is initialized
- **WHEN** tracking events
- **THEN** the system uses Firebase auto-generated user IDs
- **AND** does not collect personally identifiable information
- **AND** does not log exact coordinates in event parameters

#### Scenario: Analytics Opt-Out

- **GIVEN** user has disabled analytics (future feature consideration)
- **WHEN** events would be logged
- **THEN** the system respects opt-out preference
- **AND** disables Firebase Analytics collection

### Requirement: Event Batching and Performance

The system SHALL optimize analytics performance.

#### Scenario: Batch Event Uploads

- **GIVEN** multiple events are logged
- **WHEN** sending events to Firebase
- **THEN** the system batches events together
- **AND** uploads when app is backgrounded or network is available
- **AND** does not block UI thread

#### Scenario: Offline Event Queuing

- **GIVEN** app is offline
- **WHEN** events are logged
- **THEN** the system queues events locally
- **AND** uploads queued events when connectivity is restored
- **AND** events are persisted across app restarts

### Requirement: Custom Event Parameters

The system SHALL include meaningful context in event parameters.

#### Scenario: Consistent Parameter Naming

- **GIVEN** events are logged
- **WHEN** adding parameters
- **THEN** the system uses snake_case naming convention
- **AND** uses consistent parameter names across events
- **AND** includes units in parameter names (e.g., "\_seconds", "\_km", "\_kmh")

#### Scenario: Parameter Value Limits

- **GIVEN** event parameters are set
- **WHEN** logging events
- **THEN** string parameters are limited to 100 characters
- **AND** numeric parameters use appropriate data types (int/double)
- **AND** boolean parameters are clearly true/false

