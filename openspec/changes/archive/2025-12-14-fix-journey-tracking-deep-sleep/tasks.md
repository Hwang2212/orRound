# Implementation Tasks

This document outlines the implementation tasks for fixing journey tracking during device deep sleep.

## Prerequisites

- [ ] Review current journey tracking implementation in `JourneyTrackingController`
- [ ] Review notification implementation in `NotificationProvider`
- [ ] Verify Android and iOS permissions are correctly configured

## Task 1: Add Foreground Service Package

- [ ] Add `flutter_foreground_task: ^8.0.0` to `pubspec.yaml` dependencies
- [ ] Run `flutter pub get` to install the package
- [ ] Review package documentation for Android and iOS setup requirements

**Validation**: Package appears in `pubspec.lock` and builds successfully

## Task 2: Configure Android Foreground Service

- [ ] Update `android/app/src/main/AndroidManifest.xml`:
  - [ ] Add `FOREGROUND_SERVICE` permission
  - [ ] Add `FOREGROUND_SERVICE_LOCATION` permission (API 34+)
  - [ ] Verify `ACCESS_BACKGROUND_LOCATION` permission exists
  - [ ] Add `WAKE_LOCK` permission for keeping CPU awake during doze
- [ ] No Kotlin/Java native code required (package handles service internally)

**Validation**: Build succeeds on Android, no manifest merge errors

## Task 3: Configure iOS Background Capabilities

- [ ] Update `ios/Runner/Info.plist`:
  - [ ] Verify `UIBackgroundModes` includes `location`
  - [ ] Verify location usage descriptions are present
- [ ] Ensure background location capability is enabled in Xcode project (if not already)

**Validation**: Build succeeds on iOS, no capability warnings

## Task 4: Create Foreground Service Provider

- [ ] Create `lib/app/data/providers/foreground_service_provider.dart`
- [ ] Implement `ForegroundServiceProvider` class with:
  - [ ] `startService()` method to initialize foreground task
  - [ ] `stopService()` method to terminate foreground task
  - [ ] `updateNotification()` method to update foreground notification
  - [ ] Platform-specific configurations (Android service type, iOS background handling)
  - [ ] Callback handler for foreground task (can be minimal - location handled separately)
- [ ] Configure foreground task with:
  - [ ] Android: `ForegroundTaskOptions` with location service type
  - [ ] iOS: `IOSNotificationOptions` for background location
  - [ ] Notification channel settings matching existing notification provider

**Validation**: Provider compiles without errors, basic service lifecycle works

## Task 5: Integrate Foreground Service into Journey Tracking

- [ ] Update `lib/app/modules/journey_tracking/controllers/journey_tracking_controller.dart`:
  - [ ] Add `ForegroundServiceProvider` dependency
  - [ ] Call `startService()` when journey tracking starts (after permissions check)
  - [ ] Call `stopService()` in `_stopTracking()` method
  - [ ] Update service notification when stats change (if needed)
  - [ ] Handle service start failures gracefully (log warning, continue tracking)
- [ ] Ensure foreground service lifecycle matches tracking lifecycle:
  - [ ] Service starts when tracking starts
  - [ ] Service continues when tracking paused
  - [ ] Service stops only when tracking ends

**Validation**: Journey tracking starts foreground service successfully

## Task 6: Update Notification Integration

- [ ] Modify `lib/app/data/providers/notification_provider.dart`:
  - [ ] Ensure notification channel allows foreground service display
  - [ ] Verify notification is non-dismissible (already implemented)
  - [ ] Coordinate notification updates between providers (avoid duplicate updates)
- [ ] Option A: Use `NotificationProvider` for all notifications, have `ForegroundServiceProvider` reference it
- [ ] Option B: Let `flutter_foreground_task` manage the notification, update `NotificationProvider` to delegate to it

**Validation**: Single notification displays correctly, updates every 5 seconds

## Task 7: Test Deep Sleep Scenario

- [ ] Test on Android device:
  - [ ] Start journey tracking
  - [ ] Background the app
  - [ ] Lock device and wait 5-10 minutes (trigger doze mode)
  - [ ] Unlock and verify continuous location points (no gaps)
  - [ ] Verify notification remained visible and updated
- [ ] Test on iOS device:
  - [ ] Start journey tracking
  - [ ] Background the app
  - [ ] Lock device and wait 5-10 minutes
  - [ ] Unlock and verify continuous location points
  - [ ] Verify notification behavior
- [ ] Test pause/resume during deep sleep
- [ ] Test ending journey while device locked

**Validation**: No route gaps in any test scenario, all location points captured

## Task 8: Test Battery Impact

- [ ] Run journey tracking for extended period (30+ minutes)
- [ ] Monitor battery usage in device settings
- [ ] Compare to baseline (other fitness tracking apps)
- [ ] Document expected battery consumption

**Validation**: Battery usage is reasonable and comparable to similar apps

## Task 9: Handle Edge Cases

- [ ] Test behavior when:
  - [ ] GPS signal is lost during deep sleep
  - [ ] Low memory situation (service survival)
  - [ ] App is force-stopped by user
  - [ ] App crashes during tracking
  - [ ] Notification permissions denied
- [ ] Ensure graceful degradation in all cases
- [ ] Add appropriate error logging

**Validation**: App handles all edge cases without crashes

## Task 10: Update Analytics and Documentation

- [ ] Add analytics events for:
  - [ ] Foreground service start/stop
  - [ ] Deep sleep tracking sessions (if detectable)
  - [ ] Service failures or errors
- [ ] Update code comments in affected files
- [ ] Update app documentation if user-facing (probably not needed)

**Validation**: Analytics events appear in Firebase console

## Testing Checklist

After implementation, verify all existing journey tracking scenarios still work:

- [ ] Start tracking with location permission granted
- [ ] Start tracking without location permission (prompt appears)
- [ ] Pause and resume tracking
- [ ] End tracking and save journey
- [ ] Background tracking with notification
- [ ] Notification tap opens app
- [ ] Map displays route correctly
- [ ] Timer counts accurately
- [ ] Distance calculates correctly
- [ ] Speed displays correctly
- [ ] Weather data fetches correctly

## Deployment Notes

- Requires users to update app (code changes, new dependency)
- No database migrations needed
- No API changes
- Android users may need to re-grant background location permission (verify in testing)
- iOS users may see new permission prompts (verify in testing)

## Success Criteria

✅ Journey tracking continues recording locations when device is locked and in doze mode
✅ No route gaps appear in recorded journeys
✅ Notification remains visible and updates during deep sleep
✅ All existing journey tracking functionality continues to work
✅ Battery usage is acceptable
✅ No crashes or errors in foreground service lifecycle
