# Spec: Sharing

## ADDED Requirements

### Requirement: Journey Screenshot Capture

The system SHALL capture journey detail view as a screenshot image.

#### Scenario: Capture Detail View

- **GIVEN** user is viewing journey details
- **WHEN** user taps "Share" button
- **THEN** the system renders journey stats and map using RepaintBoundary
- **AND** captures the view as a PNG image
- **AND** image resolution matches device screen resolution
- **AND** image includes journey date, duration, distance, speed, weather, and map

#### Scenario: Optimize Screenshot Quality

- **GIVEN** screenshot is being captured
- **WHEN** rendering the image
- **THEN** the system uses pixelRatio of 2.0 for clarity
- **AND** ensures map is fully rendered before capture
- **AND** waits for all async content to load
- **AND** image size is optimized to under 2MB

### Requirement: Gallery Save Integration

The system SHALL save journey screenshots to device gallery.

#### Scenario: Save to Gallery

- **GIVEN** journey screenshot is captured
- **WHEN** the share process initiates
- **THEN** the system uses gal package to save image to Photos/Gallery
- **AND** image is saved with filename "orround*journey*{timestamp}.png"
- **AND** image appears in user's default photo gallery app
- **AND** confirms save with a brief success message

#### Scenario: Handle Gallery Permission Request

- **GIVEN** user initiates share
- **AND** photo library permissions not yet granted
- **WHEN** saving to gallery
- **THEN** the system requests photo library permissions
- **AND** displays permission rationale to user
- **AND** proceeds with save only if permissions granted
- **AND** continues with share even if save fails

#### Scenario: Handle Gallery Save Failure

- **GIVEN** screenshot capture succeeded
- **WHEN** saving to gallery fails (storage full, permission denied)
- **THEN** the system logs error to analytics
- **AND** displays error message to user
- **AND** continues with share sheet (shares temp file)
- **AND** does not block sharing functionality

### Requirement: System Share Sheet Integration

The system SHALL open native share sheet with journey screenshot.

#### Scenario: Open Share Sheet

- **GIVEN** journey screenshot is captured
- **WHEN** share process continues
- **THEN** the system uses share_plus package to open system share sheet
- **AND** attaches screenshot image to share
- **AND** includes default text "Check out my journey on Orround!"
- **AND** share sheet displays available sharing apps

#### Scenario: Share to Social Media Apps

- **GIVEN** share sheet is displayed
- **WHEN** user selects a sharing destination
- **THEN** the system passes image and text to selected app
- **AND** selected app opens with pre-filled content
- **AND** user can complete share in destination app

#### Scenario: Cancel Share

- **GIVEN** share sheet is displayed
- **WHEN** user cancels or dismisses share sheet
- **THEN** the system closes share sheet
- **AND** returns user to journey detail page
- **AND** saved gallery image remains in photos

### Requirement: Share Analytics Tracking

The system SHALL track sharing events for analytics.

#### Scenario: Log Share Initiation

- **GIVEN** user taps "Share" button
- **WHEN** share process begins
- **THEN** the system logs "journey_shared" event to Firebase Analytics
- **AND** includes journey_duration_seconds parameter
- **AND** includes journey_distance_km parameter
- **AND** includes has_weather (boolean) parameter

#### Scenario: Track Share Completion

- **GIVEN** share sheet was opened
- **WHEN** user completes or cancels share
- **THEN** the system logs share outcome (if detectable via share_plus)
- **AND** updates analytics with share completion status

### Requirement: Share Button Visibility

The system SHALL provide accessible share button on journey detail page.

#### Scenario: Display Share Button

- **GIVEN** journey detail page is displayed
- **WHEN** page renders
- **THEN** the system displays a share icon button in app bar
- **AND** button is clearly visible with share icon
- **AND** button is accessible with proper semantics label "Share journey"

### Requirement: Screenshot Content Formatting

The system SHALL format screenshot content for optimal sharing.

#### Scenario: Format Stats for Screenshot

- **GIVEN** screenshot is being generated
- **WHEN** rendering journey stats
- **THEN** the system formats all text for readability
- **AND** uses high-contrast black text on white background
- **AND** displays app branding/logo
- **AND** includes disclaimer "Tracked with Orround" at bottom
- **AND** ensures all text is legible at shared resolution

### Requirement: Share Performance

The system SHALL complete share operations efficiently.

#### Scenario: Fast Screenshot Generation

- **GIVEN** user initiates share
- **WHEN** capturing screenshot
- **THEN** the system completes capture within 2 seconds
- **AND** displays loading indicator during capture
- **AND** opens share sheet immediately after capture completes
