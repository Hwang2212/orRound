# Design: Background Tracking Notifications

## Overview

This design introduces persistent notifications for journey tracking to provide visual feedback when the app is backgrounded and enable quick navigation back to the tracking screen.

## Architecture Decisions

### 1. Notification Provider Pattern

**Decision:** Create a dedicated `NotificationProvider` class following the existing provider pattern.

**Rationale:**

- Maintains consistency with existing architecture (`LocationProvider`, `WeatherProvider`, etc.)
- Encapsulates platform-specific notification logic
- Provides clean separation between notification management and business logic
- Easily testable and mockable

**Implementation:**

- Located at `lib/app/data/providers/notification_provider.dart`
- Uses singleton pattern (instantiated via GetX dependency injection)
- Wraps `flutter_local_notifications` plugin

### 2. Notification Lifecycle Management

**Decision:** Tie notification lifecycle to journey tracking state, not app lifecycle.

**Rationale:**

- Notification should be visible when tracking is active OR paused, regardless of app state
- Simpler mental model: tracking/paused = notification visible, stopped = no notification
- Avoids complex lifecycle tracking across multiple states
- User expects notification to disappear when journey ends, not when app closes
- Paused state shows different notification to prompt user to resume

**Lifecycle Flow:**

```
startTracking()
  └─> showTrackingNotification() - Create initial notification

Timer tick (every 5s when backgrounded)
  └─> updateTrackingNotification() - Update stats

pauseTracking()
  └─> showPausedNotification() - Show "Journey Paused - Tap to resume"

resumeTracking()
  └─> showTrackingNotification() - Resume active notification

stopTracking()
  └─> hideTrackingNotification() - Remove notification
```

### 3. Notification Update Strategy

**Decision:** Update notification every 5 seconds when backgrounded, no updates when foregrounded.

**Rationale:**

- Balances battery efficiency with real-time feel
- 5 seconds aligns with location update interval
- No updates when foregrounded to avoid unnecessary work (user already sees UI)
- Prevents notification spam and excessive battery drain

**Update Throttling:**

- Track `isAppInBackground` state via `WidgetsBindingObserver` in controller
- Only call `updateTrackingNotification()` when backgrounded
- Update includes elapsed time and distance (current speed excluded to reduce update frequency)

### 4. Navigation Handling

**Decision:** Use deep link-style navigation via notification tap to return to tracking page.

**Rationale:**

- Works whether app is backgrounded, terminated, or in different screen
- Leverages GetX navigation which is already in use
- Handles edge cases (app terminated, user navigated away)
- Platform-agnostic approach

**Navigation Flow:**

```
User taps notification
  └─> onNotificationTap callback
      └─> Get.toNamed(Routes.JOURNEY_TRACKING)
          └─> Restores existing tracking session (already in memory via GetX controller)
```

**Edge Cases:**

- If app was terminated: Notification won't show (journey ended automatically on termination)
- If user navigated away from tracking page: Navigation brings them back
- If already on tracking page: No-op (GetX handles duplicate navigation)

### 5. Platform-Specific Configuration

**Decision:** Use platform channels with defensive fallbacks for unsupported features.

**Android Configuration:**

- Notification channel: "journey_tracking" (high priority)
- Ongoing notification (not dismissible by user)
- Shows on lock screen
- Tapping navigates to app
- Icon: App icon

**iOS Configuration:**

- Foreground notification (iOS has different background model)
- Banner style presentation
- Tapping navigates to app
- Background location indicator (system-provided, separate from notification)

**Web/Desktop:**

- No notification support (graceful degradation)
- Background tracking not relevant on these platforms

### 6. Permission Handling

**Decision:** Request notification permissions at journey start, gracefully degrade if denied.

**Rationale:**

- Just-in-time permission request (better UX than upfront)
- Non-blocking: tracking continues even if notification permission denied
- Follows platform best practices

**Permission Flow:**

```
startTracking()
  └─> requestNotificationPermission()
      ├─> Granted → showTrackingNotification()
      └─> Denied → Continue tracking without notification
```

## Data Flow

### Notification Content Update

```
JourneyTrackingController (every 5s when backgrounded)
  └─> _onTimerTick()
      └─> if (isAppInBackground)
          └─> NotificationProvider.updateTrackingNotification(
                elapsedTime: formattedDuration,
                distance: distanceKm.value
              )
              └─> flutter_local_notifications.show()
```

### Notification Tap Handling

```
User taps notification
  └─> NotificationProvider (setup callback in constructor)
      └─> Get.toNamed(Routes.JOURNEY_TRACKING)
          └─> GetX finds existing JourneyTrackingController instance
              └─> UI rebuilds with current tracking state
```

## Testing Strategy

### Unit Tests

- `NotificationProvider` permission handling
- `NotificationProvider` notification content generation
- Update throttling logic

### Integration Tests

- Full tracking flow with notification
- Navigation from notification tap
- Permission denial handling

### Manual Testing Checklist

- [ ] Android: Notification appears when backgrounded
- [ ] Android: Notification updates every 5 seconds
- [ ] Android: Tapping notification navigates to tracking page
- [ ] Android: Notification disappears when journey ends
- [ ] iOS: Notification appears when backgrounded
- [ ] iOS: Tapping notification navigates to tracking page
- [ ] Permission denial: Tracking continues without notification
- [ ] App termination: Notification disappears

## Security & Privacy

- No sensitive data in notification content (only elapsed time and distance)
- Notification only shown during active tracking (no persistent badges)
- User can disable notifications via OS settings without breaking tracking

## Performance Considerations

- Notification updates throttled to 5s interval
- No updates when foregrounded (UI already visible)
- Minimal battery impact (notification API is lightweight)
- No wake locks required (location service already maintains them)

## Migration & Rollout

- No breaking changes
- Feature is additive (existing tracking continues to work)
- Notification can be disabled if issues arise (feature flag potential)
- Graceful degradation on older Android/iOS versions via plugin

## Future Enhancements

- Configurable notification update interval (user preference)
- Rich notification with action buttons (pause/resume)
- Notification sound/vibration on journey milestones
- Apple Watch complication showing journey stats
