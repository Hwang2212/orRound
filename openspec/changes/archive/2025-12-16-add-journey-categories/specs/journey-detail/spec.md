## MODIFIED Requirements

### Requirement: Edit Journey Category

The system SHALL allow users to change the category of a saved journey.

#### Scenario: View Current Category

- **GIVEN** the user is viewing a journey detail page
- **WHEN** the page loads
- **THEN** the current category is displayed with its icon
- **AND** the category is shown in a tappable chip or button

#### Scenario: Change Category

- **GIVEN** the user is on the journey detail page
- **WHEN** the user taps the category chip
- **THEN** a bottom sheet or dialog appears with all category options
- **WHEN** the user selects a different category
- **THEN** the journey's category is updated in the database
- **AND** the UI immediately reflects the new category

### Requirement: Manage Journey Tags

The system SHALL allow users to add and remove custom tags on a journey.

#### Scenario: View Existing Tags

- **GIVEN** a journey has tags ["vacation", "beach"]
- **WHEN** viewing the journey detail page
- **THEN** all tags are displayed as chips below the category
- **AND** each tag chip has a delete (x) icon

#### Scenario: Add New Tag

- **GIVEN** the user is on the journey detail page
- **WHEN** the user taps the "Add tag" chip/button
- **THEN** a text input field appears or a dialog opens
- **WHEN** the user enters "roadtrip" and confirms
- **THEN** the tag is added to the journey
- **AND** the tag chip appears in the tags section

#### Scenario: Remove Tag

- **GIVEN** a journey has tag "exercise"
- **WHEN** the user taps the delete icon on the "exercise" chip
- **THEN** the tag is removed from the journey
- **AND** the chip disappears from the UI

**IMPLEMENTATION NOTES:**

- Tags section placed below the stats area
- Tags displayed as `InputChip` widgets with `onDeleted` callback
- "Add tag" shown as `ActionChip` with add icon
- Tag input via `showDialog` with TextField
- Maximum 10 tags per journey to prevent abuse
