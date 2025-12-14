# journey-storage Spec Delta

## ADDED Requirements

### Requirement: Journey Title Storage

The system SHALL store optional journey titles in the database.

#### Scenario: Save Journey with Empty Title

- **GIVEN** a user finishes a tracking session
- **WHEN** the system saves the journey
- **THEN** the journey is saved with title set to NULL
- **AND** all other journey data (points, stats, weather) is saved normally

#### Scenario: Save Custom Journey Title

- **GIVEN** a user has edited a journey title
- **WHEN** the system saves the updated journey
- **THEN** the custom title is stored in journeys.title column
- **AND** title is stored as-is without truncation
- **AND** empty or whitespace-only titles are stored as NULL

#### Scenario: Update Existing Journey Title

- **GIVEN** an existing journey with or without a title
- **WHEN** a user edits the title
- **THEN** the system updates only the title field
- **AND** preserves all other journey data
- **AND** handles NULL and non-NULL title updates correctly

#### Scenario: Retrieve Journey with Title

- **GIVEN** a journey exists in the database
- **WHEN** the journey is retrieved
- **THEN** the title field is included in the Journey object
- **AND** title may be null for journeys without custom titles

## MODIFIED Requirements

### Requirement: SQLite Database Initialization

The system SHALL initialize and manage a local SQLite database for offline journey storage.

**Changes**: Added title column to journeys table schema.

#### Scenario: Initialize Database on First Launch

- **GIVEN** the app is launched for the first time
- **WHEN** the database provider initializes
- **THEN** the system creates a SQLite database file
- **AND** executes schema creation SQL for journeys table **with title TEXT column**
- **AND** executes schema creation SQL for location_points table
- **AND** executes schema creation SQL for user_profile table
- **AND** executes schema creation SQL for referrals table
- **AND** creates indexes on journey_id, timestamp, and created_at fields

#### Scenario: Handle Database Migration from v1 to v2

- **GIVEN** the app is updated with schema changes for journey titles
- **WHEN** the database provider initializes and detects version 1
- **THEN** the system adds title TEXT column to journeys table with default NULL
- **AND** existing journeys retain NULL titles (no auto-generation during migration)
- **AND** updates schema version to 2
- **AND** all existing data remains intact

### Requirement: Journey Persistence

The system SHALL save journey data with all related location points to the database.

**Changes**: Title is now included in journey persistence.

#### Scenario: Save Completed Journey

- **GIVEN** a user finishes a tracking session
- **WHEN** the system saves the journey
- **THEN** a new record is inserted into journeys table with unique ID
- **AND** **journey title is set to NULL (no auto-generation at save time)**
- **AND** all recorded location points are inserted into location_points table
- **AND** journey statistics (distance, avg speed) are calculated and stored
- **AND** weather data is stored if available
- **AND** is_synced flag is set to 0 (not synced)
- **AND** created_at timestamp is set to current time

### Requirement: Journey Retrieval

The system SHALL retrieve journey data with all related information from the database.

**Changes**: Title is now included in all journey retrievals.

#### Scenario: Load Recent Journeys

- **GIVEN** journeys exist in the database
- **WHEN** the home page requests recent journeys
- **THEN** the system queries the 10 most recent journeys ordered by start_time DESC
- **AND** returns journey summary (id, **title**, start_time, duration, distance)
- **AND** query executes within 100ms for performance

#### Scenario: Load Journey Details

- **GIVEN** a specific journey ID is requested
- **WHEN** the detail page requests journey data
- **THEN** the system queries the journey record
- **AND** **includes the journey title in the result**
- **AND** joins with location_points to retrieve route data
- **AND** returns complete journey object with all location points
- **AND** handles missing journey gracefully with error message
