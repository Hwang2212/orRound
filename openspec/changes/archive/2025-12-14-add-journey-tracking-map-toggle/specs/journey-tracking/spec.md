# journey-tracking Specification Delta

## MODIFIED Requirements

### Requirement: Route Map Visualization

The system SHALL display the tracked route on a map during journey tracking AND allow users to toggle map visibility.

#### Scenario: View Tracking Map

- **GIVEN** the user has started a journey
- **WHEN** viewing the journey tracking page
- **THEN** the map is hidden by default to conserve screen space and battery
- **AND** a toggle button is visible to show/hide the map
- **WHEN** the user taps the map toggle button
- **THEN** the system displays OpenStreetMap tiles as the base map
- **AND** shows a loading indicator while acquiring GPS location
- **AND** centers map on user's location once acquired
- **AND** draws a polyline connecting all recorded points in primary color
- **AND** displays a green start marker at journey start point
- **AND** displays a primary-colored current position marker
- **AND** auto-updates map as new location points are received

#### Scenario: Toggle Map Visibility

- **GIVEN** journey tracking is active
- **WHEN** the user taps the map toggle button
- **THEN** the map visibility toggles between shown and hidden
- **AND** the toggle button icon updates to reflect current state (eye icon when hidden, eye-slash when shown, or map icon)
- **AND** the statistics display area expands when map is hidden
- **AND** the statistics display area contracts when map is shown
- **AND** route recording continues normally regardless of map visibility

#### Scenario: Map Hidden by Default

- **GIVEN** the user starts a new journey
- **WHEN** the journey tracking page loads
- **THEN** the map is hidden by default
- **AND** the statistics display occupies the full available space
- **AND** a hint indicates "Route is being recorded" to confirm tracking is active
- **AND** the toggle button is prominently visible
- **AND** all tracking statistics (time, distance, speed) are displayed

#### Scenario: Map Toggle State Persistence During Session

- **GIVEN** journey tracking is active with map shown
- **WHEN** the user pauses the journey
- **THEN** the map visibility state is maintained
- **WHEN** the user resumes the journey
- **THEN** the map remains in the same visibility state (shown or hidden)

**IMPLEMENTATION NOTES:**

- Map default state: hidden (`showMap = false` initially)
- Map only renders when `showMap = true` to save resources
- Toggle button: FloatingActionButton or IconButton in app bar
- Icon suggestions: `Icons.map` / `Icons.map_outlined` or `Icons.visibility` / `Icons.visibility_off`
- When hidden, statistics container uses `flex: 3` instead of `flex: 1`
- When shown, map uses `flex: 2`, stats use `flex: 1` (current layout)
- Location tracking stream continues regardless of map visibility
- Map state does NOT persist across app restarts or new journeys (resets to hidden)

## MODIFIED Requirements

### Requirement: Map Visibility Control

The system SHALL provide a visible control to toggle map display during journey tracking.

#### Scenario: Access Map Toggle Button

- **GIVEN** journey tracking is active or inactive
- **WHEN** viewing the journey tracking page
- **THEN** a map toggle button is visible and accessible
- **AND** the button displays an appropriate icon indicating current map state
- **AND** the button has a clear tap target (minimum 44x44 points)
- **AND** tapping the button toggles map visibility with smooth transition

#### Scenario: Visual Feedback for Map State

- **GIVEN** the user is viewing the journey tracking page
- **WHEN** the map is hidden
- **THEN** the toggle button shows a "show map" icon (e.g., map icon or visibility icon)
- **AND** a subtle hint text appears: "Route is being recorded"
- **WHEN** the map is shown
- **THEN** the toggle button shows a "hide map" icon (e.g., map outlined or visibility off)
- **AND** the hint text is not displayed

**IMPLEMENTATION NOTES:**

- Toggle button positioned in app bar actions or as FloatingActionButton
- Smooth animation when transitioning between map shown/hidden states (e.g., 300ms)
- Hint text appears below statistics when map is hidden
- Hint text style: `Theme.of(context).textTheme.bodySmall` with secondary color
