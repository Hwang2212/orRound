# Fix Journey Tracking During Device Deep Sleep

## Problem Statement

When journey tracking is active and the app is backgrounded, location tracking works correctly. However, when the device enters deep sleep/doze mode (e.g., screen locked for extended periods), the location stream stops receiving updates. This causes the route to "jump" from the last recorded point before sleep to the current point after wake, missing all intermediate route data.

## Root Cause

The current implementation relies on the `location` package's background mode, which uses background location updates that can be suspended by the OS during deep sleep/doze mode. The app does not use a foreground service to maintain continuous location tracking when the device enters power-saving states.

## Proposed Solution

Implement a foreground service on Android that:

1. Runs continuously during journey tracking to prevent the OS from suspending location updates
2. Displays a persistent notification (already implemented) that doubles as the foreground service notification
3. Ensures location updates continue even when the device is locked or in doze mode
4. On iOS, configure the location manager for continuous background tracking with appropriate capabilities

## Affected Capabilities

- `journey-tracking` (MODIFIED) - Enhanced background tracking to work during device deep sleep

## User Impact

- **Positive**: Users will no longer experience route gaps when their device goes to sleep during journey tracking
- **Positive**: More accurate and complete journey recordings
- **Neutral**: No visible UI changes (uses existing notification system)
- **Neutral**: Slightly higher battery usage (necessary trade-off for continuous tracking)

## Technical Approach

### Android

1. Add `flutter_foreground_task` package for foreground service management
2. Configure foreground service in AndroidManifest.xml with location service type
3. Start foreground service when journey tracking begins
4. Use existing notification as the foreground service notification
5. Stop foreground service when journey tracking ends

### iOS

1. Configure `Info.plist` with `UIBackgroundModes` including `location`
2. Ensure location manager is configured for continuous background updates
3. Leverage existing notification for background indication

## Success Criteria

1. Journey tracking continues to record location points when device is locked
2. Journey tracking continues during device doze mode
3. No route gaps appear when resuming from deep sleep
4. Battery usage remains reasonable (minimal increase over current implementation)
5. All existing journey tracking scenarios continue to work

## Dependencies

- New dependency: `flutter_foreground_task` package
- Platform permissions: Already have `ACCESS_BACKGROUND_LOCATION` and location background modes

## Risks & Mitigations

**Risk**: Increased battery consumption

- _Mitigation_: This is inherent to the feature requirement; document expected battery usage

**Risk**: User confusion about persistent notification

- _Mitigation_: Notification already exists; no change to UX

**Risk**: OS killing the service on extreme low memory

- _Mitigation_: Foreground services have highest priority; rare edge case

## Open Questions

None - implementation path is clear based on Flutter best practices for background location tracking.
