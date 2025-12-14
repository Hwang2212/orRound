# journey-tracking Specification

## Purpose

TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.

## Requirements

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

The system SHALL display the tracked route on a map during journey tracking AND allow users to toggle map visibility.

#### Scenario: View Tracking Map

- **GIVEN** the user has started a journey
- **WHEN** viewing the journey tracking page
- **THEN** the map is hidden by default to conserve screen space and battery
- **AND** a toggle button is visible to show/hide the map
- **WHEN** the user taps the map toggle button
- **THEN** the system displays OpenStreetMap tiles as the base map
- **AND** shows a loading indicator while acquiring GPS location
- **AND** centers map on user's location once acquired
- **AND** draws a polyline connecting all recorded points in primary color
- **AND** displays a green start marker at journey start point
- **AND** displays a primary-colored current position marker
- **AND** auto-updates map as new location points are received

#### Scenario: Toggle Map Visibility

- **GIVEN** journey tracking is active
- **WHEN** the user taps the map toggle button
- **THEN** the map visibility toggles between shown and hidden
- **AND** the toggle button icon updates to reflect current state (eye icon when hidden, eye-slash when shown, or map icon)
- **AND** the statistics display area expands when map is hidden
- **AND** the statistics display area contracts when map is shown
- **AND** route recording continues normally regardless of map visibility

#### Scenario: Map Hidden by Default

- **GIVEN** the user starts a new journey
- **WHEN** the journey tracking page loads
- **THEN** the map is hidden by default
- **AND** the statistics display occupies the full available space
- **AND** a hint indicates "Route is being recorded" to confirm tracking is active
- **AND** the toggle button is prominently visible
- **AND** all tracking statistics (time, distance, speed) are displayed

#### Scenario: Map Toggle State Persistence During Session

- **GIVEN** journey tracking is active with map shown
- **WHEN** the user pauses the journey
- **THEN** the map visibility state is maintained
- **WHEN** the user resumes the journey
- **THEN** the map remains in the same visibility state (shown or hidden)

**IMPLEMENTATION NOTES:**

- Map default state: hidden (`showMap = false` initially)
- Map only renders when `showMap = true` to save resources
- Toggle button: FloatingActionButton or IconButton in app bar
- Icon suggestions: `Icons.map` / `Icons.map_outlined` or `Icons.visibility` / `Icons.visibility_off`
- When hidden, statistics container uses `flex: 3` instead of `flex: 1`
- When shown, map uses `flex: 2`, stats use `flex: 1` (current layout)
- Location tracking stream continues regardless of map visibility
- Map state does NOT persist across app restarts or new journeys (resets to hidden)
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

The system SHALL continue tracking when the app is backgrounded AND SHALL maintain location recording even when the device enters deep sleep or doze mode AND display a persistent notification with real-time journey statistics.

#### Scenario: Track in Background with Notification

- **GIVEN** journey tracking is active
- **WHEN** the user backgrounds the app
- **THEN** the system continues recording location data
- **AND** maintains elapsed timer
- **AND** displays a persistent notification showing "Journey in Progress"
- **AND** updates notification content every 5 seconds with current elapsed time and distance
- **AND** notification is not dismissible by the user (ongoing notification on Android)
- **AND** notification shows on lock screen
- **AND** notification is silent (no sound or vibration)

#### Scenario: Track During Device Deep Sleep

- **GIVEN** journey tracking is active and app is backgrounded
- **WHEN** the device screen is locked and enters doze/deep sleep mode
- **THEN** the system continues recording location data without interruption
- **AND** location points are captured at the configured interval (5 seconds or 10 meters)
- **AND** no gaps appear in the recorded route
- **AND** elapsed timer continues accurately
- **AND** notification remains visible on lock screen
- **AND** distance calculations include all movement during sleep

**IMPLEMENTATION NOTES:**

- On Android: Uses foreground service with location service type
- On iOS: Uses UIBackgroundModes location configuration
- Foreground service notification reuses the existing tracking notification
- Service lifecycle matches journey tracking lifecycle (start/stop)
- Location updates configured for high accuracy with 5-second/10-meter intervals

#### Scenario: Resume from Deep Sleep

- **GIVEN** journey tracking is active with device in deep sleep
- **WHEN** the user wakes the device or opens the app
- **THEN** the system displays all location points recorded during sleep
- **AND** route visualization shows continuous path with no jumps
- **AND** distance and elapsed time are accurate
- **AND** current location marker is at the most recent recorded position

#### Scenario: Foreground Service Lifecycle on Android

- **GIVEN** journey tracking is active
- **WHEN** the journey starts
- **THEN** the system starts a foreground service with location service type
- **AND** displays the tracking notification as the foreground service notification
- **WHEN** the journey is paused
- **THEN** the foreground service continues running
- **AND** notification updates to show paused state
- **WHEN** the journey ends or is stopped
- **THEN** the foreground service is stopped
- **AND** notification is removed

#### Scenario: Notification Displays Journey Stats

- **GIVEN** journey tracking is active and app is backgrounded
- **WHEN** the notification is displayed
- **THEN** notification title is "Journey in Progress"
- **AND** notification content shows elapsed time in MM:SS or HH:MM:SS format
- **AND** notification content shows distance traveled in km (e.g., "Distance: 2.34 km")
- **AND** notification updates these values every 5 seconds

#### Scenario: Navigate Back via Notification Tap

- **GIVEN** journey tracking is active and notification is displayed
- **WHEN** the user taps the notification
- **THEN** the app opens/comes to foreground
- **AND** navigates to the journey tracking page
- **AND** displays the active tracking session with current state
- **AND** map, timer, and stats are all current

#### Scenario: Hide Notification When Journey Ends

- **GIVEN** journey tracking is active with notification displayed
- **WHEN** the user stops the journey
- **THEN** the system immediately removes the notification
- **AND** stops the foreground service (Android)
- **AND** continues normal journey end flow (save, navigate to detail)

#### Scenario: Show Paused Notification

- **GIVEN** journey tracking is active with notification displayed
- **WHEN** the user pauses the journey
- **THEN** the system immediately updates the notification
- **AND** notification title changes to "Journey Paused"
- **AND** notification content shows "Tap to resume tracking"
- **AND** notification shows last recorded elapsed time and distance (not updating)
- **AND** notification remains visible while paused
- **AND** foreground service continues running (Android)

#### Scenario: Return to Foreground

- **GIVEN** journey tracking is active or paused with notification displayed
- **WHEN** the user brings the app to foreground on tracking page
- **THEN** the notification remains visible (for consistency)
- **AND** notification updates stop if tracking is active (optimization)
- **AND** notification updates resume when backgrounded again
- **AND** foreground service continues running (Android)

#### Scenario: Resume via Paused Notification Tap

- **GIVEN** journey is paused with paused notification displayed
- **WHEN** the user taps the paused notification
- **THEN** the app opens/comes to foreground
- **AND** navigates to the journey tracking page
- **AND** displays the paused journey state
- **AND** user can tap Resume button to continue tracking

#### Scenario: Permission Denied Graceful Degradation

- **GIVEN** user has denied notification permissions
- **WHEN** journey tracking starts
- **THEN** the system continues tracking normally
- **AND** foreground service runs without notification (Android, with warning logged)
- **AND** no error message is shown to user
- **AND** all other tracking features work as expected

### Requirement: Notification Permission Management

The system SHALL request notification permissions when journey tracking starts and handle permission states gracefully.

#### Scenario: Request Permission on First Track

- **GIVEN** the user has never been asked for notification permissions
- **WHEN** the user starts journey tracking for the first time
- **THEN** the system requests notification permission via platform dialog
- **AND** continues with tracking regardless of user response
- **AND** shows notification if permission granted
- **AND** proceeds without notification if permission denied

#### Scenario: Permission Already Granted

- **GIVEN** the user has previously granted notification permissions
- **WHEN** the user starts journey tracking
- **THEN** the system does not show permission dialog again
- **AND** immediately displays the tracking notification

#### Scenario: Permission Already Denied

- **GIVEN** the user has previously denied notification permissions
- **WHEN** the user starts journey tracking
- **THEN** the system does not request permission again
- **AND** proceeds with tracking without notification
- **AND** logs permission status to analytics

### Requirement: Platform-Specific Notification Configuration

The system SHALL configure notifications appropriately for each platform.

#### Scenario: Android Notification Channel Setup

- **GIVEN** the app is running on Android
- **WHEN** the notification system initializes
- **THEN** creates a notification channel with ID "journey_tracking"
- **AND** channel name is "Journey Tracking"
- **AND** channel importance is HIGH (shows on lock screen)
- **AND** channel description is "Notifications for active journey tracking"
- **AND** sound and vibration are disabled

#### Scenario: Android Ongoing Notification

- **GIVEN** journey tracking is active on Android
- **WHEN** the tracking notification is shown
- **THEN** notification is marked as "ongoing" (not user-dismissible)
- **AND** notification shows in persistent notification area
- **AND** notification icon is the app icon
- **AND** notification is silent (no sound or vibration)

#### Scenario: iOS Notification Behavior

- **GIVEN** journey tracking is active on iOS
- **WHEN** the tracking notification is shown
- **THEN** notification appears as banner/alert based on user's notification settings
- **AND** notification can be dismissed by user (iOS limitation)
- **AND** background location indicator (blue bar) shows separately (system-provided)
- **AND** notification is silent

#### Scenario: Unsupported Platforms

- **GIVEN** the app is running on Web, Windows, Linux, or macOS
- **WHEN** journey tracking starts
- **THEN** the system logs that notifications are not supported
- **AND** continues tracking without notification
- **AND** no error is shown to user

### Requirement: Notification Provider Initialization

The system SHALL initialize the notification provider at app startup.

#### Scenario: App Startup Notification Setup

- **GIVEN** the app is launching
- **WHEN** main() initializes
- **THEN** NotificationProvider is instantiated
- **AND** platform-specific notification plugins are configured
- **AND** notification tap callback is registered to navigate to Routes.JOURNEY_TRACKING
- **AND** initialization errors are caught and logged without crashing app

### Requirement: Map Visibility Control

The system SHALL provide a visible control to toggle map display during journey tracking.

#### Scenario: Access Map Toggle Button

- **GIVEN** journey tracking is active or inactive
- **WHEN** viewing the journey tracking page
- **THEN** a map toggle button is visible and accessible
- **AND** the button displays an appropriate icon indicating current map state
- **AND** the button has a clear tap target (minimum 44x44 points)
- **AND** tapping the button toggles map visibility with smooth transition

#### Scenario: Visual Feedback for Map State

- **GIVEN** the user is viewing the journey tracking page
- **WHEN** the map is hidden
- **THEN** the toggle button shows a "show map" icon (e.g., map icon or visibility icon)
- **AND** a subtle hint text appears: "Route is being recorded"
- **WHEN** the map is shown
- **THEN** the toggle button shows a "hide map" icon (e.g., map outlined or visibility off)
- **AND** the hint text is not displayed

**IMPLEMENTATION NOTES:**

- Toggle button positioned in app bar actions or as FloatingActionButton
- Smooth animation when transitioning between map shown/hidden states (e.g., 300ms)
- Hint text appears below statistics when map is hidden
- Hint text style: `Theme.of(context).textTheme.bodySmall` with secondary color

### Requirement: Battery Efficiency During Deep Sleep Tracking

The system SHALL optimize battery usage while maintaining continuous location tracking during device deep sleep.

#### Scenario: Efficient Location Updates

- **GIVEN** journey tracking is active with foreground service running
- **WHEN** the device enters doze mode
- **THEN** location updates continue at the configured interval
- **AND** battery drain is comparable to other fitness tracking apps
- **AND** system uses GPS efficiently (not constant polling)

**IMPLEMENTATION NOTES:**

- Location interval: 5 seconds or 10 meters (whichever comes first)
- High accuracy mode for GPS tracking
- Foreground service type: `location` (Android)
- Background location capability enabled (iOS)

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
