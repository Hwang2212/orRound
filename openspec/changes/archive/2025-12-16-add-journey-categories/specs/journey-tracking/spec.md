## MODIFIED Requirements

### Requirement: Journey Category Selection

The system SHALL allow users to select a category for their journey when starting tracking.

#### Scenario: Select Category Before Tracking

- **GIVEN** the user is on the journey tracking page
- **AND** tracking has not yet started
- **WHEN** the user views the pre-tracking screen
- **THEN** the system displays a row of category chips (Walk, Run, Bike, Drive, Hike, Other)
- **AND** "Other" is selected by default
- **AND** each category shows its corresponding icon

#### Scenario: Start Journey With Selected Category

- **GIVEN** the user has selected a category (e.g., "Run")
- **WHEN** the user taps the Start button
- **THEN** the journey is created with the selected category
- **AND** tracking begins normally

#### Scenario: Category Displayed During Tracking

- **GIVEN** journey tracking is active with category "Bike"
- **WHEN** viewing the tracking page
- **THEN** the selected category icon is displayed in the app bar or stats area
- **AND** the category cannot be changed while tracking is active

**IMPLEMENTATION NOTES:**

- Category chips: horizontal scrollable row with `ChoiceChip` widgets
- Icons: Walk (directions_walk), Run (directions_run), Bike (directions_bike), Drive (directions_car), Hike (hiking), Other (route)
- Category stored in controller state and passed to journey on save
