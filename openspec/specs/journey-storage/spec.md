# journey-storage Specification

## Purpose
TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.
## Requirements
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

### Requirement: Location Point Storage

The system SHALL efficiently store and retrieve GPS coordinates for journey routes.

#### Scenario: Store Location Points

- **GIVEN** journey tracking is active
- **WHEN** a new location point is recorded
- **THEN** the system inserts a record into location_points table
- **AND** associates point with current journey_id
- **AND** stores latitude, longitude, speed, and timestamp
- **AND** generates unique ID for the point

#### Scenario: Retrieve Route Points

- **GIVEN** a journey detail is being displayed
- **WHEN** the system loads route data
- **THEN** location points are retrieved ordered by timestamp ASC
- **AND** all points for the journey are returned
- **AND** points are formatted as LatLng objects for map rendering

### Requirement: User Profile Storage

The system SHALL manage user profile data including referral codes in the database.

#### Scenario: Create User Profile on First Launch

- **GIVEN** the app is launched for the first time
- **AND** no user profile exists
- **WHEN** the user profile initializes
- **THEN** the system generates a unique 6-character alphanumeric referral code
- **AND** inserts a profile record with id=1 (singleton)
- **AND** stores referral_code and created_at timestamp
- **AND** leaves referred_by_code as NULL initially

#### Scenario: Update Referred By Code

- **GIVEN** user enters a valid referral code
- **WHEN** the referral is submitted
- **THEN** the system updates user_profile.referred_by_code
- **AND** inserts a record into referrals table with the code and timestamp
- **AND** marks user as referred

### Requirement: Database Performance

The system SHALL maintain acceptable query performance for all database operations.

#### Scenario: Indexed Query Performance

- **GIVEN** database contains 100+ journeys
- **WHEN** querying recent journeys or specific journey details
- **THEN** queries execute in under 100ms
- **AND** indexes on journey_id and created_at are utilized
- **AND** no full table scans occur for common queries

### Requirement: Data Integrity

The system SHALL maintain referential integrity between journeys and location points.

#### Scenario: Cascade Delete Journey

- **GIVEN** a journey with associated location points exists (future feature)
- **WHEN** the journey is deleted
- **THEN** all associated location_points are automatically deleted via CASCADE
- **AND** no orphaned location points remain in database

### Requirement: Offline Data Resilience

The system SHALL handle database operations gracefully during adverse conditions.

#### Scenario: Handle Database Write Failure

- **GIVEN** journey tracking is active
- **WHEN** a database write fails (e.g., disk full)
- **THEN** the system logs error to analytics
- **AND** displays error message to user
- **AND** attempts to cache data in memory
- **AND** retries write operation when possible

#### Scenario: Corrupted Database Recovery

- **GIVEN** database file is corrupted
- **WHEN** app attempts to initialize database
- **THEN** the system detects corruption
- **AND** displays recovery options to user (reset database)
- **AND** backs up corrupted file before reset
- **AND** recreates fresh database schema

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

