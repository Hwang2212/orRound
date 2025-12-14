# journey-tracking Specification Delta

## MODIFIED Requirements

### Requirement: Background Tracking

The system SHALL continue tracking when the app is backgrounded AND display a persistent notification with real-time journey statistics.

#### Scenario: Track in Background with Notification

- **GIVEN** journey tracking is active
- **WHEN** the user backgrounds the app
- **THEN** the system continues recording location data
- **AND** maintains elapsed timer
- **AND** displays a persistent notification showing "Journey in Progress"
- **AND** updates notification content every 5 seconds with current elapsed time and distance
- **AND** notification is not dismissible by the user (ongoing notification on Android)
- **AND** notification shows on lock screen

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
- **AND** continues normal journey end flow (save, navigate to detail)

#### Scenario: Show Paused Notification

- **GIVEN** journey tracking is active with notification displayed
- **WHEN** the user pauses the journey
- **THEN** the system immediately updates the notification
- **AND** notification title changes to "Journey Paused"
- **AND** notification content shows "Tap to resume tracking"
- **AND** notification shows last recorded elapsed time and distance (not updating)
- **AND** notification remains visible while paused

#### Scenario: Return to Foreground

- **GIVEN** journey tracking is active or paused with notification displayed
- **WHEN** the user brings the app to foreground on tracking page
- **THEN** the notification remains visible (for consistency)
- **AND** notification updates stop if tracking is active (optimization)
- **AND** notification updates resume when backgrounded again

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
- **AND** no notification is displayed
- **AND** no error message is shown to user
- **AND** all other tracking features work as expected

## ADDED Requirements

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
- **AND** channel importance is HIGH (shows on lock screen, makes sound)
- **AND** channel description is "Notifications for active journey tracking"

#### Scenario: Android Ongoing Notification

- **GIVEN** journey tracking is active on Android
- **WHEN** the tracking notification is shown
- **THEN** notification is marked as "ongoing" (not user-dismissible)
- **AND** notification shows in persistent notification area
- **AND** notification icon is the app icon
- **AND** notification color matches app primary color

#### Scenario: iOS Notification Behavior

- **GIVEN** journey tracking is active on iOS
- **WHEN** the tracking notification is shown
- **THEN** notification appears as banner/alert based on user's notification settings
- **AND** notification can be dismissed by user (iOS limitation)
- **AND** background location indicator (blue bar) shows separately (system-provided)

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

#### Scenario: Notification Tap Callback Registration

- **GIVEN** NotificationProvider is initialized
- **WHEN** a journey tracking notification is tapped
- **THEN** the registered callback executes
- **AND** navigates to Routes.JOURNEY_TRACKING using Get.toNamed()
- **AND** restores existing journey tracking session if controller exists
- **AND** callback works whether app is backgrounded or terminated

## IMPLEMENTATION NOTES

**Notification Update Optimization:**

- Check app lifecycle state using `WidgetsBindingObserver`
- Only update notification when `AppLifecycleState.paused` or `AppLifecycleState.inactive`
- Pause notification updates when `AppLifecycleState.resumed`

**Notification Content Format:**

```
Title: "Journey in Progress"
Body: "Time: 12:34 • Distance: 5.67 km"
```

**Dependencies:**

- Add `flutter_local_notifications: ^17.0.0` to pubspec.yaml
- Plugin handles platform-specific native code

**Android Permissions (AndroidManifest.xml):**

```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

**iOS Configuration:**

- No special configuration needed (notifications enabled by default)
- Background location already configured via existing location package

**Error Handling:**

- All notification operations wrapped in try-catch
- Failures logged but never block tracking functionality
- Missing permissions handled gracefully without user-facing errors
