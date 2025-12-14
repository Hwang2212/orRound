# Implementation Tasks

This document outlines the implementation tasks for adding map visibility toggle to journey tracking.

## Task 1: Add Map Visibility State to Controller

- [x] Update `lib/app/modules/journey_tracking/controllers/journey_tracking_controller.dart`:
  - [x] Add `final RxBool showMap = false.obs;` (default hidden)
  - [x] Add `void toggleMap() { showMap.value = !showMap.value; }` method
  - [x] No need to persist state - it resets to false each journey

**Validation**: Controller compiles, `showMap` state is reactive

## Task 2: Add Toggle Button to Journey Tracking View

- [x] Update `lib/app/modules/journey_tracking/views/journey_tracking_view.dart`:
  - [x] Add `IconButton` to app bar `actions`:
    - [x] Use `Obx` to reactively update icon based on `controller.showMap.value`
    - [x] Icon when hidden: `Icons.map` or `Icons.visibility`
    - [x] Icon when shown: `Icons.map_outlined` or `Icons.visibility_off`
    - [x] OnPressed: `controller.toggleMap`
    - [x] Tooltip: "Show map" / "Hide map"

**Validation**: Toggle button appears in app bar, taps toggle the state

## Task 3: Conditionally Render Map Based on State

- [x] Update `lib/app/modules/journey_tracking/views/journey_tracking_view.dart`:
  - [x] Wrap the existing Column with `Obx` to react to `controller.showMap`
  - [x] Conditionally render map based on `controller.showMap.value`:
    ```dart
    Column(
      children: [
        if (controller.showMap.value)
          Expanded(flex: 2, child: const JourneyTrackingMapView()),
        Expanded(
          flex: controller.showMap.value ? 1 : 3,
          child: _buildStats(context),
        ),
      ],
    )
    ```
  - [ ] Add `AnimatedSize` or `AnimatedSwitcher` for smooth transition (optional but nice)

**Validation**: Map shows/hides when toggle button is tapped, stats area resizes

## Task 4: Add Hint Text When Map is Hidden

- [x] Update `_buildStats` method in `journey_tracking_view.dart`:
  - [x] Add conditional hint text at the bottom of stats column:
    ```dart
    if (!controller.showMap.value) ...[
      const SizedBox(height: 16),
      Text(
        'Route is being recorded',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ]
    ```

**Validation**: Hint text appears when map is hidden, disappears when shown

## Task 5: Test All Scenarios

- [x] Test map toggle before starting journey
- [x] Test map toggle during active tracking
- [x] Test map toggle while paused
- [x] Test that route recording continues when map is hidden
- [x] Test that map updates correctly when shown after being hidden
- [x] Test layout adjusts smoothly between states
- [x] Test on different screen sizes (small, large)

**Validation**: All scenarios work correctly, no UI glitches

## Task 6: Verify Existing Functionality

- [x] Verify all existing journey tracking features still work:
  - [x] Start/pause/resume/stop tracking
  - [x] Timer accuracy
  - [x] Distance calculation
  - [x] Speed display
  - [x] Map markers and polyline (when map is shown)
  - [x] Background tracking with notification
  - [x] Journey save and navigation to detail page

**Validation**: No regressions in existing functionality

## Testing Checklist

- [x] Map is hidden by default when journey tracking page loads
- [x] Toggle button is visible and accessible
- [x] Tapping toggle shows the map
- [x] Tapping toggle again hides the map
- [x] Stats area expands when map is hidden
- [x] Stats area contracts when map is shown
- [x] Hint text "Route is being recorded" appears when map is hidden
- [x] Hint text disappears when map is shown
- [x] Route recording continues normally when map is hidden
- [x] Map displays all recorded points when shown after being hidden
- [x] Toggle state persists during pause/resume of same journey
- [x] Toggle state resets to hidden when starting a new journey

## Success Criteria

✅ Map toggle button is visible in app bar
✅ Map is hidden by default
✅ Toggle button shows/hides map on tap
✅ UI layout adjusts smoothly when toggling
✅ Hint text appears when map is hidden
✅ Route recording is unaffected by map visibility
✅ No regressions in existing journey tracking features
