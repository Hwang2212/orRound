## ADDED Requirements

### Requirement: Screen Wake During Active Tracking

The system SHALL keep the device screen awake and prevent sleep when journey tracking is active (foreground or background).

#### Scenario: Enable Screen Wake on Tracking Start

- **GIVEN** the user has location permissions granted
- **WHEN** the user starts a new journey
- **THEN** the system enables screen wake lock to prevent device sleep
- **AND** the screen remains on until tracking ends

#### Scenario: Disable Screen Wake on Tracking End

- **GIVEN** journey tracking is active with screen wake enabled
- **WHEN** the user ends the journey
- **THEN** the system disables the screen wake lock
- **AND** normal screen sleep behavior is restored

#### Scenario: Screen Wake During Pause

- **GIVEN** journey tracking is active with screen wake enabled
- **WHEN** the user pauses the journey
- **THEN** the screen wake lock remains enabled
- **AND** the screen does not go to sleep while paused
- **AND** the user can quickly resume without unlocking the device

#### Scenario: Screen Wake Persists in Background

- **GIVEN** journey tracking is active
- **WHEN** the app is backgrounded (user switches to another app)
- **THEN** the screen wake lock remains active
- **AND** the device does not enter sleep mode

**IMPLEMENTATION NOTES:**

- Use `wakelock_plus` package for cross-platform wake lock support
- Wake lock is enabled at the same time as foreground service starts
- Wake lock is disabled when `stopTracking()` is called
- Wake lock persists during pause state to allow quick resume

### Requirement: Screen Dimming During Active Tracking

The system SHALL dim the screen brightness during active tracking to conserve battery while keeping the screen visible.

#### Scenario: Dim Screen on Tracking Start

- **GIVEN** the user starts a new journey
- **WHEN** screen wake lock is enabled
- **THEN** the system saves the current screen brightness level
- **AND** reduces screen brightness to approximately 20% (0.2)
- **AND** the screen remains readable for checking statistics

#### Scenario: Restore Brightness on Tracking End

- **GIVEN** journey tracking is active with dimmed screen
- **WHEN** the user ends the journey
- **THEN** the system restores the original screen brightness
- **AND** system brightness controls return to normal behavior

#### Scenario: User Interaction Temporarily Restores Brightness

- **GIVEN** journey tracking is active with dimmed screen
- **WHEN** the user actively interacts with the tracking screen (taps, swipes)
- **THEN** the screen brightness temporarily increases to system default or saved level
- **AND** after 5 seconds of inactivity, brightness dims again

**IMPLEMENTATION NOTES:**

- Use `screen_brightness` package for cross-platform brightness control
- Default tracking brightness: 0.2 (20%)
- Store original brightness before dimming
- Restore original brightness on tracking end
- Optional: Implement activity-based brightness boost (stretch goal)
