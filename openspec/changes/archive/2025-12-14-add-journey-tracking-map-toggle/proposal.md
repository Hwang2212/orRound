# Add Journey Tracking Map Toggle

## Problem Statement

During journey tracking, the map is always visible and takes up significant screen space. Users who want to focus on tracking statistics (time, distance, speed) or want to conserve battery may prefer to hide the map while tracking is active.

## Proposed Solution

Add a toggle button to the journey tracking view that allows users to show/hide the map display. The map will be hidden by default to:

1. Reduce visual clutter and focus on key tracking metrics
2. Save battery by not rendering map tiles continuously
3. Give users control over what information they prioritize during tracking

When the map is hidden, the space can be used to display tracking statistics more prominently.

## Affected Capabilities

- `journey-tracking` (MODIFIED) - Add map visibility toggle with default hidden state

## User Impact

- **Positive**: Users can choose to hide the map for cleaner UI and better battery life
- **Positive**: More screen space for tracking statistics when map is hidden
- **Positive**: Faster UI rendering without continuous map updates
- **Neutral**: Map hidden by default - users must toggle to see route visualization
- **Note**: Hiding the map does NOT affect route recording - all location points are still captured

## Technical Approach

1. Add `showMap` reactive boolean state to `JourneyTrackingController` (default: `false`)
2. Add toggle button (icon button or floating action button) to the journey tracking view
3. Conditionally render the map widget based on `showMap` state
4. When map is hidden, expand the statistics display area
5. Persist user preference (optional - for future enhancement)

## Success Criteria

1. Toggle button is visible and accessible during journey tracking
2. Map can be shown/hidden with a single tap
3. Map is hidden by default when journey tracking starts
4. Route recording continues normally regardless of map visibility
5. Toggle state persists during pause/resume of the same journey session
6. UI layout adjusts smoothly when toggling map visibility

## Dependencies

None - uses existing controller and view architecture

## Risks & Mitigations

**Risk**: Users don't realize map is hidden by default

- _Mitigation_: Use clear icon (eye/eye-slash) and tooltip for toggle button

**Risk**: Users think hiding map stops route recording

- _Mitigation_: Add brief inline hint "Route is still being recorded" when map is hidden

## Open Questions

- Should we persist the user's map visibility preference across journeys? (Answer: No, keep it simple for MVP - reset to hidden each time)
