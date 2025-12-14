# journey-tracking Specification Delta

## MODIFIED Requirements

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
