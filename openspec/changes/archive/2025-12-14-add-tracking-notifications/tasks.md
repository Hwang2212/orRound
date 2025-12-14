# Implementation Tasks

## 1. Dependencies and Configuration

- [x] Add `flutter_local_notifications: ^17.0.0` to `pubspec.yaml`
- [x] Run `flutter pub get` to install the dependency
- [x] Add `<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>` to `android/app/src/main/AndroidManifest.xml`
- [ ] Test build on Android to verify dependency integration

**Validation:** `flutter build apk` succeeds without errors

---

## 2. Create NotificationProvider

- [x] Create `lib/app/data/providers/notification_provider.dart`
- [x] Implement singleton pattern consistent with other providers
- [x] Add method `initialize()` to set up platform-specific notification channels
- [x] Add method `requestPermission()` to request notification permissions
- [x] Add method `showTrackingNotification({required String elapsedTime, required double distanceKm})` to display active tracking notification
- [x] Add method `updateTrackingNotification({required String elapsedTime, required double distanceKm})` to update existing notification
- [x] Add method `showPausedNotification({required String elapsedTime, required double distanceKm})` to display paused notification
- [x] Add method `hideTrackingNotification()` to dismiss notification
- [x] Configure notification tap callback to navigate to `Routes.JOURNEY_TRACKING`
- [x] Wrap all notification operations in try-catch with error logging
- [ ] Test on Android device/emulator to verify notification display

**Validation:** Unit tests for permission handling; manual test shows notification when called

---

## 3. Initialize Notification System at App Startup

- [x] Import `NotificationProvider` in `lib/main.dart`
- [x] Call `NotificationProvider.initialize()` in `main()` before `runApp()`
- [x] Verify initialization doesn't block app startup (errors logged, not thrown)
- [ ] Test app launch on Android to confirm notification setup

**Validation:** App launches successfully, no crashes or delays

---

## 4. Integrate Notifications with Journey Tracking Controller

- [x] Add `final NotificationProvider _notificationProvider = NotificationProvider();` to `JourneyTrackingController`
- [x] Add `WidgetsBindingObserver` mixin to `JourneyTrackingController` to track app lifecycle
- [x] Override `didChangeAppLifecycleState()` to track `isAppInBackground` flag
- [x] In `startTracking()`, request notification permission and show initial notification
- [x] In `_onTimerTick()`, check `isAppInBackground` and update notification every 5 seconds
- [x] In `stopTracking()`, hide notification before ending journey
- [x] In `pauseTracking()`, show paused notification with current stats
- [x] In `resumeTracking()`, show active tracking notification again with current stats
- [x] Add lifecycle observer in `onInit()` via `WidgetsBinding.instance.addObserver(this)`
- [x] Remove lifecycle observer in `onClose()` via `WidgetsBinding.instance.removeObserver(this)`

**Validation:** Start tracking, background app, verify notification shows and updates; tap notification and verify navigation back to tracking page

---

## 5. Handle Edge Cases and Permissions

- [x] Test with notification permission denied - verify tracking continues without notification
- [x] Test notification tap when already on tracking page - verify no duplicate navigation
- [x] Test notification tap after navigating away - verify returns to tracking page
- [x] Test journey end - verify notification immediately disappears
- [x] Test pause - verify notification changes to paused state with "Tap to resume" message
- [x] Test resume - verify notification returns to active tracking state
- [x] Test tap on paused notification - verify navigates to tracking page
- [x] Test app termination during tracking - verify notification disappears (system behavior)

**Validation:** All edge cases handled gracefully without crashes or errors

---

## 6. Platform-Specific Testing

- [ ] Test on Android 13+ (requires runtime notification permission)
- [ ] Test on Android 12 and below (notification permission granted by default)
- [ ] Test notification appearance on Android lock screen
- [ ] Test ongoing notification cannot be dismissed by user on Android
- [ ] Test on iOS simulator/device to verify notification display (if available)
- [ ] Verify graceful degradation on Web/Desktop platforms

**Validation:** Notifications work correctly on all supported platforms

---

## 7. Analytics Integration

- [x] Log notification permission status in `AnalyticsRepository.logJourneyStarted()` event
- [x] Add parameter `hasNotificationPermission: bool` to journey_started event
- [x] Log notification-related errors to analytics (permission denied, initialization failures)

**Validation:** Firebase Analytics shows notification permission status in journey_started events

---

## 8. Code Quality and Documentation

- [x] Run `dart format .` to format all modified files
- [x] Run `dart analyze` to check for linting issues
- [x] Fix any warnings or errors from analyzer
- [x] Add code comments explaining notification lifecycle in controller
- [x] Add dartdoc comments to public methods in `NotificationProvider`

**Validation:** `dart analyze` returns no errors; code follows project conventions

---

## 9. User Acceptance Testing

- [ ] Start a journey and verify notification appears when backgrounded
- [ ] Verify notification updates show increasing time and distance
- [ ] Tap notification and verify navigation to tracking page
- [ ] Complete journey and verify notification disappears
- [ ] Pause journey and verify notification changes to "Journey Paused - Tap to resume"
- [ ] Resume journey and verify notification returns to active tracking state
- [ ] Tap paused notification and verify navigation to tracking page
- [ ] Test with notification permission denied and verify tracking works

**Validation:** All user-facing scenarios work as specified

---

## Dependencies Between Tasks

- Tasks 1 must complete before Task 2 (need dependency installed)
- Tasks 2-3 can be done in parallel
- Task 4 depends on Tasks 2-3 (need provider and initialization)
- Tasks 5-7 depend on Task 4 (need integration complete)
- Task 8 can be done in parallel with Tasks 5-7
- Task 9 is final validation of all previous tasks

## Estimated Effort

- Tasks 1-3: ~30 minutes (setup and provider creation)
- Task 4: ~45 minutes (controller integration)
- Tasks 5-6: ~45 minutes (testing edge cases)
- Tasks 7-8: ~15 minutes (analytics and cleanup)
- Task 9: ~30 minutes (user acceptance testing)

**Total: ~3 hours**
