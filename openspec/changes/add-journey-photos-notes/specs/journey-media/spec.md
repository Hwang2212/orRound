## ADDED Requirements

### Requirement: Capture Photo During Tracking

The system SHALL allow premium users to capture photos during active journey tracking.

#### Scenario: Take Photo During Journey

- **GIVEN** the user is a premium subscriber
- **AND** journey tracking is active
- **WHEN** the user taps the camera button
- **THEN** the device camera opens
- **WHEN** the user captures a photo
- **THEN** the photo is saved to device storage
- **AND** the photo is geotagged with current GPS coordinates
- **AND** the photo is associated with the current journey
- **AND** a thumbnail appears in the tracking UI

#### Scenario: Free User Camera Tap

- **GIVEN** the user is not a premium subscriber
- **AND** journey tracking is active
- **WHEN** the user taps the camera button
- **THEN** a premium upsell dialog is shown
- **AND** the dialog explains the photos feature
- **AND** provides option to upgrade to premium

#### Scenario: Multiple Photos Per Journey

- **GIVEN** journey tracking is active
- **WHEN** the user captures multiple photos
- **THEN** each photo is saved with its own location/timestamp
- **AND** all photos are associated with the current journey

### Requirement: View Journey Photos

The system SHALL display photos on the journey detail page.

#### Scenario: View Photo Gallery

- **GIVEN** a journey has 5 photos attached
- **WHEN** viewing the journey detail page
- **THEN** a photos section displays a scrollable gallery
- **AND** photos are shown as thumbnails in a horizontal list
- **WHEN** the user taps a thumbnail
- **THEN** the photo opens in full-screen view

#### Scenario: Photo Location on Map

- **GIVEN** a journey has photos with geotagged locations
- **WHEN** viewing the journey detail map
- **THEN** photo markers appear at capture locations
- **AND** markers use a camera icon or photo thumbnail
- **WHEN** the user taps a photo marker
- **THEN** the full photo is displayed

#### Scenario: Journey With No Photos

- **GIVEN** a journey has no photos
- **WHEN** viewing the journey detail page
- **THEN** the photos section shows "No photos"
- **AND** for premium users, shows "Capture photos during your next journey"

### Requirement: Add Journey Notes

The system SHALL allow users to add text notes to journeys.

#### Scenario: Add Note After Journey

- **GIVEN** the user is viewing a journey detail page
- **WHEN** the user taps the notes section
- **THEN** a text editor opens
- **WHEN** the user enters text and saves
- **THEN** the note is saved to the journey
- **AND** the note appears on the detail page

#### Scenario: Edit Existing Note

- **GIVEN** a journey has an existing note
- **WHEN** the user taps the note section
- **THEN** the text editor opens with existing text
- **WHEN** the user modifies and saves
- **THEN** the note is updated

**IMPLEMENTATION NOTES:**

- Use image_picker package (already in project)
- Store photos in app documents directory with journey ID subfolder
- Photo model: id, journeyId, latitude, longitude, timestamp, filePath
- Photos table with foreign key to journeys
- Gallery: horizontal ListView with Image.file()
- Full-screen: PageView with zoom capability
- Notes: simple TextField, stored as TEXT column on journey
