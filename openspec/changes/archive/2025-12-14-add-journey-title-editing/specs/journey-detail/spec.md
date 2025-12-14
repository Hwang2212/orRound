# journey-detail Spec Delta

## ADDED Requirements

### Requirement: Journey Title Display and Editing

The system SHALL display journey titles and allow users to edit them for completed journeys.

#### Scenario: Display Auto-Generated Title for Empty Title

- **GIVEN** a journey has a null or empty title in the database
- **WHEN** the detail view loads
- **THEN** the system generates a display title using one of these random patterns:
  - "Journey on [MMM DD, YYYY]" (e.g., "Journey on Dec 15, 2025")
  - "Travelling on [MMM DD, YYYY]" (e.g., "Travelling on Dec 15, 2025")
- **AND** uses the journey start_time for date formatting
- **AND** displays the generated title prominently at the top
- **AND** does not save the generated title to the database
- **AND** an edit icon or tap gesture indicates the title is editable

#### Scenario: Display Custom Journey Title

- **GIVEN** a journey has a custom title stored in the database
- **WHEN** the detail view loads
- **THEN** the custom title is displayed prominently at the top
- **AND** long titles are truncated with ellipsis to fit available space
- **AND** an edit icon or tap gesture indicates the title is editable

#### Scenario: Edit Journey Title

- **GIVEN** a user is viewing a completed journey
- **WHEN** the user taps on the title or edit icon
- **THEN** the system displays a text input dialog/field
- **AND** pre-fills with the custom title if one exists, or the auto-generated display title if not
- **AND** allows user to modify the title
- **AND** provides "Save" and "Cancel" actions

#### Scenario: Save Edited Title

- **GIVEN** a user has edited a journey title
- **WHEN** the user saves a non-empty title
- **THEN** the system updates the journey title in the database
- **AND** displays the updated title immediately in the UI
- **AND** shows a success indicator (e.g., brief toast or checkmark)
- **AND** logs "journey_title_edited" analytics event

#### Scenario: Cancel Title Edit

- **GIVEN** a user is editing a journey title
- **WHEN** the user taps "Cancel" or dismisses the dialog
- **THEN** the system discards changes
- **AND** displays the original custom title or auto-generated title
- **AND** no database update occurs

#### Scenario: Clear Title to Empty

- **GIVEN** a user edits a journey title
- **WHEN** the user submits an empty or whitespace-only title
- **THEN** the system stores NULL in the database
- **AND** reverts to displaying an auto-generated title (not saved to DB)
- **AND** shows a message "Title cleared, showing auto-generated"

#### Scenario: Handle Long Titles in Display

- **GIVEN** a journey has a very long title (100+ characters)
- **WHEN** the title is displayed in the detail view
- **THEN** the system shows the full title with ellipsis if needed
- **AND** optionally allows title to wrap to multiple lines (2-3 max)
- **AND** maintains readability and UI layout integrity

#### Scenario: Title Editing Not Available During Tracking

- **GIVEN** a journey is currently in progress (not completed)
- **WHEN** the user views the tracking screen
- **THEN** no title editing capability is shown
- **AND** only the "Journey in Progress" or similar status is displayed
- **AND** title editing becomes available after journey completion

## MODIFIED Requirements

### Requirement: Comprehensive Journey Information Display

The system SHALL display all journey details including statistics, weather, and route map.

**Changes**: Title is now the primary identifier instead of date.

#### Scenario: View Journey Details

- **GIVEN** a journey has been completed
- **WHEN** the user opens the journey detail page
- **THEN** **the system displays the journey title prominently**
- **AND** displays journey start date and time (secondary to title)
- **AND** displays total elapsed time
- **AND** displays total distance traveled
- **AND** displays average speed
- **AND** displays weather condition and temperature (if recorded)
- **AND** all statistics are formatted with appropriate units

### Requirement: Journey Sharing

The system SHALL allow users to share journey details as a screenshot image.

**Changes**: Shared screenshot now includes journey title.

#### Scenario: Share Journey as Screenshot

- **GIVEN** the user is viewing journey details
- **WHEN** the user taps the "Share" button
- **THEN** the system captures the detail view **(including title,** stats + map) as an image
- **AND** saves the image to device gallery using gal package
- **AND** opens system share sheet with the image attached
- **AND** logs "journey_shared" analytics event with journey duration parameter
