# Tasks: Add Screen Wake During Journey Tracking

## 1. Add Dependencies

- [x] Add `wakelock_plus` package to `pubspec.yaml`
- [x] Add `screen_brightness` package to `pubspec.yaml`
- [x] Run `flutter pub get`

## 2. Create Screen Wake Provider

- [x] Create `lib/app/data/providers/screen_wake_provider.dart`
  - [x] Add `enableWakeLock()` method using `WakelockPlus.enable()`
  - [x] Add `disableWakeLock()` method using `WakelockPlus.disable()`
  - [x] Add `_originalBrightness` field to store original brightness
  - [x] Add `dimScreen()` method to reduce brightness to 0.2
  - [x] Add `restoreBrightness()` method to restore saved brightness
  - [x] Add `enableTrackingMode()` method that calls both wake lock and dim
  - [x] Add `disableTrackingMode()` method that calls both disable and restore

## 3. Integrate with Journey Tracking Controller

- [x] Update `lib/app/modules/journey_tracking/controllers/journey_tracking_controller.dart`:
  - [x] Import `ScreenWakeProvider`
  - [x] Add `final ScreenWakeProvider _screenWakeProvider = ScreenWakeProvider();`
  - [x] In `startTracking()`: call `_screenWakeProvider.enableTrackingMode()` after permissions check
  - [x] In `_stopTracking()`: call `_screenWakeProvider.disableTrackingMode()` before cleanup
  - [x] Ensure wake lock persists during pause (no disable on pause)

## 4. Testing

- [ ] Manual test: Start tracking, verify screen does not turn off after timeout
- [ ] Manual test: Verify screen is dimmed during tracking
- [ ] Manual test: End tracking, verify screen can turn off normally
- [ ] Manual test: End tracking, verify brightness is restored
- [ ] Manual test: Pause tracking, verify screen stays on
- [ ] Manual test: Background app while tracking, verify screen behavior
- [ ] Test on Android device
- [ ] Test on iOS device (if available)

## 5. Validation

- [x] Run `openspec validate add-screen-wake-during-tracking --strict`
- [x] Run `flutter analyze` to ensure no lint issues
- [ ] Test full journey flow: start → track → pause → resume → end
