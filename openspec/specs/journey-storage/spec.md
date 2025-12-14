# journey-storage Specification

## Purpose
TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.
## Requirements
### Requirement: SQLite Database Initialization

The system SHALL initialize and manage a local SQLite database for offline journey storage.

#### Scenario: Initialize Database on First Launch

- **GIVEN** the app is launched for the first time
- **WHEN** the database provider initializes
- **THEN** the system creates a SQLite database file
- **AND** executes schema creation SQL for journeys table
- **AND** executes schema creation SQL for location_points table
- **AND** executes schema creation SQL for user_profile table
- **AND** executes schema creation SQL for referrals table
- **AND** creates indexes on journey_id, timestamp, and created_at fields

#### Scenario: Handle Database Migration

- **GIVEN** the app is updated with schema changes
- **WHEN** the database provider initializes
- **THEN** the system detects current schema version
- **AND** applies necessary migration scripts sequentially
- **AND** updates schema version in metadata table

### Requirement: Journey Persistence

The system SHALL save journey data with all related location points to the database.

#### Scenario: Save Completed Journey

- **GIVEN** a journey has been completed
- **WHEN** the system saves the journey
- **THEN** a new record is inserted into journeys table with unique ID
- **AND** all recorded location points are inserted into location_points table
- **AND** journey statistics (distance, avg speed) are calculated and stored
- **AND** weather data is stored if available
- **AND** is_synced flag is set to 0 (not synced)
- **AND** created_at timestamp is set to current time

#### Scenario: Save Journey Without Weather

- **GIVEN** a journey completed offline
- **WHEN** the system saves the journey
- **THEN** weather_condition and temperature fields are set to NULL
- **AND** all other journey data is saved normally
- **AND** journey is marked as successfully saved

### Requirement: Journey Retrieval

The system SHALL retrieve journey data with all related information from the database.

#### Scenario: Load Recent Journeys

- **GIVEN** journeys exist in the database
- **WHEN** the home page requests recent journeys
- **THEN** the system queries the 10 most recent journeys ordered by start_time DESC
- **AND** returns journey summary (id, start_time, duration, distance)
- **AND** query executes within 100ms for performance

#### Scenario: Load Journey Details

- **GIVEN** a specific journey ID is requested
- **WHEN** the detail page requests journey data
- **THEN** the system queries the journey record
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

