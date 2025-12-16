# Add Screen Wake During Journey Tracking

## Why

When journey tracking is active (foreground or background), the device screen can lock or go to sleep. Although the app uses a foreground service with CPU wake lock (`allowWakeLock: true`), location tracking can still become unreliable when the screen is off because some devices throttle background processes aggressively. Keeping the screen on (dimmed) ensures continuous, accurate GPS tracking.

## What Changes

- **NEW**: When tracking starts, prevent the device screen from sleeping
- **NEW**: Dim the screen brightness during tracking to conserve battery
- **NEW**: When tracking ends (or pauses), restore normal screen sleep and brightness behavior
- Add `wakelock_plus` package for cross-platform screen wake control
- Add `screen_brightness` package for dimming functionality

## Impact

- Affected specs: `journey-tracking` (MODIFIED)
- Affected code:
  - `lib/app/modules/journey_tracking/controllers/journey_tracking_controller.dart`
  - New provider: `lib/app/data/providers/screen_wake_provider.dart`
  - `pubspec.yaml` (new dependencies)

## User Experience

- **Positive**: Reliable GPS tracking during long journeys without route gaps
- **Positive**: Screen stays on so users can glance at stats without unlocking
- **Neutral**: Slight battery impact (mitigated by dimming)
- **UX**: Screen dims to ~10-20% brightness during tracking (configurable)

## Implementation Approach

1. Add `wakelock_plus` package for preventing device sleep
2. Add `screen_brightness` package for screen dimming control
3. Create `ScreenWakeProvider` to encapsulate screen control logic
4. Enable wake lock and dim screen when `startTracking()` is called
5. Disable wake lock and restore brightness when `stopTracking()` is called
6. Handle pause/resume: keep wake lock active during pause (user may want to resume)

## Acceptance Criteria

1. Device screen stays on during active journey tracking
2. Screen brightness is reduced (~20%) during tracking to save battery
3. Original brightness is restored when tracking ends
4. Wake lock is released when tracking ends
5. Works on both iOS and Android

## Technical Considerations

- `wakelock_plus`: Cross-platform, maintained fork of wakelock, works on iOS/Android/Web
- `screen_brightness`: Cross-platform brightness control, allows saving/restoring original brightness
- No additional permissions required beyond existing ones

## Risks

1. **Battery drain**: Screen always on drains battery faster
   - _Mitigation_: Dim screen to minimum usable brightness (~20%)
2. **User annoyance if screen won't turn off**: Could frustrate users who pocket the phone
   - _Mitigation_: Clear UX that tracking keeps screen on; prompt to pause/end tracking
