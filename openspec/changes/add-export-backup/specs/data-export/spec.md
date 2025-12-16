## ADDED Requirements

### Requirement: Export Journey as GPX

The system SHALL allow premium users to export a journey as a GPX file.

#### Scenario: Export Single Journey to GPX

- **GIVEN** the user is a premium subscriber
- **AND** viewing a journey detail page
- **WHEN** the user taps the export button and selects "GPX"
- **THEN** a GPX file is generated with all route points
- **AND** the file includes timestamps, coordinates, and elevation (if available)
- **AND** the share sheet opens to save or share the file

#### Scenario: GPX File Format

- **GIVEN** a journey with 100 location points
- **WHEN** exported to GPX
- **THEN** the file follows GPX 1.1 schema
- **AND** includes metadata (journey name, date)
- **AND** includes a track with track segment
- **AND** each point has lat, lon, time elements

#### Scenario: Free User Export Attempt

- **GIVEN** the user is not a premium subscriber
- **WHEN** the user taps the export button
- **THEN** a premium upsell dialog is shown
- **AND** explains the export feature benefits

### Requirement: Export Journey as KML

The system SHALL allow premium users to export a journey as a KML file.

#### Scenario: Export Single Journey to KML

- **GIVEN** the user is a premium subscriber
- **WHEN** the user exports to KML
- **THEN** a KML file is generated compatible with Google Earth
- **AND** includes the route as a LineString
- **AND** includes start and end placemarks

### Requirement: Bulk Export All Journeys

The system SHALL allow premium users to export all journeys at once.

#### Scenario: Export All as JSON

- **GIVEN** the user has 50 journeys
- **WHEN** the user selects "Export All" in settings
- **THEN** a JSON file is generated with all journey data
- **AND** includes all location points for each journey
- **AND** the share sheet opens

#### Scenario: Large Export Progress

- **GIVEN** the user has many journeys with thousands of points
- **WHEN** bulk export is initiated
- **THEN** a progress indicator is shown
- **AND** the app remains responsive
- **AND** export can be cancelled

### Requirement: Manual Backup

The system SHALL allow users to create a manual backup.

#### Scenario: Create Backup

- **GIVEN** the user is in settings/profile
- **WHEN** the user taps "Backup Data"
- **THEN** a complete backup file is created
- **AND** includes all journeys, photos (paths), achievements
- **AND** saved to device Downloads or shared

#### Scenario: Restore from Backup

- **GIVEN** the user has a backup file
- **WHEN** the user selects "Restore Backup"
- **AND** selects the backup file
- **THEN** a confirmation dialog warns about overwriting
- **WHEN** confirmed
- **THEN** all data is restored from the backup

### Requirement: Import from GPX

The system SHALL allow users to import journeys from GPX files.

#### Scenario: Import GPX File

- **GIVEN** the user has a GPX file from another app
- **WHEN** the user selects "Import" in settings
- **AND** selects a GPX file
- **THEN** the GPX is parsed
- **AND** a new journey is created with the route points
- **AND** the journey appears in the journey list

#### Scenario: Invalid GPX File

- **GIVEN** the user selects an invalid or corrupted file
- **WHEN** import is attempted
- **THEN** an error message is shown
- **AND** no data is imported

**IMPLEMENTATION NOTES:**

- GPX format: XML with gpx > trk > trkseg > trkpt structure
- KML format: XML with Document > Placemark > LineString
- Use xml package for generation/parsing
- Bulk export: consider background isolate for large data
- File picker for import: file_picker package
- Save to downloads: use path_provider downloads directory
