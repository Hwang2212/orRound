# map-display Specification

## Purpose
TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.
## Requirements
### Requirement: OpenStreetMap Tile Integration

The system SHALL display maps using OpenStreetMap tiles via flutter_map.

#### Scenario: Load Map Tiles

- **GIVEN** a map view is displayed
- **WHEN** the map initializes
- **THEN** the system loads tiles from `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- **AND** displays tiles for current viewport
- **AND** applies proper attribution text "© OpenStreetMap contributors"
- **AND** respects OSM tile usage policy (max 1 request per second)

#### Scenario: Handle Tile Loading Failure

- **GIVEN** map is displayed
- **WHEN** a tile fails to load (network error, 404)
- **THEN** the system displays a placeholder for that tile
- **AND** retries loading failed tiles after 5 seconds
- **AND** map remains interactive

### Requirement: Current Location Display

The system SHALL display user's current location on the map.

#### Scenario: Show Current Location Marker

- **GIVEN** location permissions are granted
- **WHEN** viewing a map with tracking active
- **THEN** the system displays a blue dot marker at current GPS location
- **AND** centers map on current location initially
- **AND** updates marker position as user moves
- **AND** marker is visually distinct from route markers

#### Scenario: Center on Current Location

- **GIVEN** user is viewing a map
- **WHEN** user taps "Center" button
- **THEN** the system pans map to current location
- **AND** sets zoom level to 15 (city streets view)
- **AND** maintains current location marker visibility

### Requirement: Journey Route Rendering

The system SHALL render journey routes as polylines on the map.

#### Scenario: Display Route Polyline

- **GIVEN** journey location points are available
- **WHEN** viewing journey on map
- **THEN** the system draws a polyline connecting all points in order
- **AND** polyline color is black (matching app theme)
- **AND** polyline width is 4 pixels
- **AND** polyline is displayed above map tiles but below markers

#### Scenario: Render Long Routes Efficiently

- **GIVEN** a journey has more than 1000 location points
- **WHEN** rendering the route
- **THEN** the system simplifies the polyline using Douglas-Peucker algorithm
- **AND** reduces points to maximum 500 for display
- **AND** maintains route shape accuracy
- **AND** renders without UI lag

### Requirement: Map Interaction Controls

The system SHALL provide standard map interaction controls.

#### Scenario: Pan and Zoom

- **GIVEN** a map is displayed
- **WHEN** user performs gestures
- **THEN** pinch-to-zoom zooms the map in/out
- **AND** drag gesture pans the map
- **AND** double-tap zooms in one level
- **AND** interactions are smooth (60 FPS)

#### Scenario: Zoom Controls

- **GIVEN** a map is displayed
- **WHEN** viewing the map
- **THEN** the system displays zoom in (+) and zoom out (-) buttons
- **AND** buttons are positioned in bottom-right corner
- **AND** tapping buttons adjusts zoom by 1 level
- **AND** zoom is limited to levels 3-18

### Requirement: Route Bounds Fitting

The system SHALL automatically fit map view to display complete journey routes.

#### Scenario: Auto-Fit Journey Route

- **GIVEN** a journey detail page is opened
- **WHEN** the map is displayed
- **THEN** the system calculates bounding box of all route points
- **AND** sets map zoom and center to fit entire route
- **AND** adds 10% padding around route bounds
- **AND** ensures both start and end points are visible

### Requirement: Route Markers

The system SHALL display markers for journey start and end points.

#### Scenario: Display Start/End Markers

- **GIVEN** a journey route is displayed
- **WHEN** rendering route markers
- **THEN** the system places a green marker at journey start point
- **AND** places a red marker at journey end point
- **AND** markers are displayed above the polyline
- **AND** markers include labels "Start" and "End"

#### Scenario: Single Point Journey

- **GIVEN** a journey has only one location point (edge case)
- **WHEN** displaying on map
- **THEN** the system displays a single marker
- **AND** centers map on that point
- **AND** sets appropriate zoom level

### Requirement: Map Performance Optimization

The system SHALL optimize map rendering for smooth performance.

#### Scenario: Lazy Load Map

- **GIVEN** user navigates to a page with a map
- **WHEN** the page loads
- **THEN** the map initializes asynchronously
- **AND** displays a loading indicator during initialization
- **AND** page UI remains responsive

#### Scenario: Offline Map Display

- **GIVEN** no internet connectivity
- **WHEN** viewing a map
- **THEN** the system displays previously cached tiles
- **AND** shows "Offline mode" indicator
- **AND** map interactions remain functional for cached areas

### Requirement: Map Tile Caching

The system SHALL cache map tiles for offline viewing.

#### Scenario: Cache Viewed Tiles

- **GIVEN** user views a map area
- **WHEN** tiles are loaded
- **THEN** the system caches tiles locally
- **AND** cached tiles are used when viewing same area offline
- **AND** cache respects storage limits (max 50MB)
- **AND** oldest tiles are evicted when cache is full

