## MODIFIED Requirements

### Requirement: Store Journey Category and Tags

The system SHALL persist journey category and tags in the database.

#### Scenario: Save Journey With Category

- **GIVEN** a journey is being saved
- **AND** the journey has category "Run"
- **WHEN** the journey is persisted to SQLite
- **THEN** the category field is stored as a string value "run"
- **AND** the journey can be retrieved with its category intact

#### Scenario: Save Journey With Tags

- **GIVEN** a journey has tags ["morning", "exercise"]
- **WHEN** the journey is persisted to SQLite
- **THEN** the tags field is stored as a JSON array string '["morning","exercise"]'
- **AND** the journey can be retrieved with its tags intact

#### Scenario: Migrate Existing Journeys

- **GIVEN** the database has journeys without category/tags fields
- **WHEN** the app is updated and database migration runs
- **THEN** existing journeys receive category "other" as default
- **AND** existing journeys receive empty tags array []
- **AND** no data is lost during migration

**IMPLEMENTATION NOTES:**

- Add `category TEXT DEFAULT 'other'` column to journeys table
- Add `tags TEXT DEFAULT '[]'` column to journeys table
- Database version increment triggers migration
- Categories stored as lowercase strings for consistency
