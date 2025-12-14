# Change: Add Background Tracking Notifications

## Why

Journey tracking currently continues in the background via location services, but users have no visual indication that tracking is active when the app is backgrounded. This creates uncertainty about whether tracking is still working and makes it difficult to return to the tracking screen. A persistent notification solves both problems by providing status visibility and a quick navigation path.

## What Changes

- Add `flutter_local_notifications` package dependency for cross-platform notification support
- Create a notification service provider to manage tracking notifications
- Display a persistent notification when journey tracking is active
- Update notification content with real-time journey statistics (elapsed time, distance)
- Implement tap action on notification to navigate back to journey tracking page
- Show notification when app is backgrounded during active tracking
- Show a different notification when journey is paused ("Journey Paused - Tap to resume")
- Remove notification when journey ends
- Integrate notification lifecycle with existing journey tracking controller

## Impact

**Affected specs:**

- `journey-tracking` - Enhanced with notification display and background behavior

**Affected code:**

- `lib/app/data/providers/` - New `notification_provider.dart` for notification management
- `lib/app/modules/journey_tracking/controllers/journey_tracking_controller.dart` - Integration with notification lifecycle
- `lib/main.dart` - Notification initialization on app startup
- `pubspec.yaml` - Add flutter_local_notifications dependency
- `android/app/src/main/AndroidManifest.xml` - Android notification permissions and configuration
- `ios/Runner/Info.plist` - iOS notification configuration (if needed)

**User Experience:**

- Users will see a persistent notification showing journey is active
- Tapping notification returns user to the active tracking page
- Notification displays real-time journey metrics (time, distance)
- Reduces anxiety about whether tracking is still running in background

**Technical Impact:**

- Minimal performance overhead (notification updates throttled to every 5-10 seconds)
- Platform-specific configuration required for Android/iOS
- Notification persists across app lifecycle states (foreground, background, terminated)
