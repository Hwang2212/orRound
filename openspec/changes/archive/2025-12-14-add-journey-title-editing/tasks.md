# Implementation Tasks

## Database Layer

- [x] Add `title TEXT` column to journeys table schema in `database_provider.dart` (defaults to NULL)
- [x] Implement database migration from version 1 to version 2
  - [x] Add migration logic to detect version 1 and upgrade to version 2
  - [x] Add title column with ALTER TABLE, defaulting to NULL
  - [x] Verify migration preserves all existing data (no title auto-generation)
- [ ] Test database migration with mock data (unit test)

## Model Layer

- [x] Add nullable `title` field to `Journey` model class
  - [x] Add optional title parameter to constructor
  - [x] Include title in `toMap()` serialization (handle NULL)
  - [x] Include title in `fromMap()` deserialization (handle NULL)
  - [ ] Update `copyWith` method (if exists) to include title

## Utility Layer

- [x] Implement title auto-generation utility for display
  - [x] Create `generateDisplayTitle(int startTime)` helper function
  - [x] Implement random selection between "Journey on [date]" and "Travelling on [date]"
  - [x] Format date as "MMM DD, YYYY"
  - [ ] Add unit tests for display title generation
  - [x] Ensure function is pure (no side effects, no DB writes)

## Repository Layer

- [x] Update journey repository to handle titles
  - [x] Modify `saveJourney()` to save with NULL title (no auto-generation)
  - [x] Add `updateJourneyTitle(String journeyId, String? title)` method
  - [x] Handle NULL title updates (clear title to empty)
  - [x] Update retrieval methods to include nullable title field

## Controller Layer (Journey Detail)

- [x] Add title display and editing logic to `JourneyDetailController`
  - [x] Add computed property for display title (custom or auto-generated)
  - [x] Add observable for edit mode state
  - [x] Implement `startEditingTitle()` method
  - [x] Implement `saveTitle(String newTitle)` method
    - [x] Handle empty/whitespace titles (save as NULL)
    - [x] Handle non-empty titles (save to DB)
  - [x] Implement `cancelEditingTitle()` method
  - [x] Add analytics event for "journey_title_edited"

## View Layer (Journey Detail)

- [x] Update `JourneyDetailView` to display journey title
  - [x] Show custom title or auto-generated display title at top
  - [x] Add edit icon button next to title
  - [x] Implement title tap gesture for editing
  - [x] Handle long titles with ellipsis or multi-line wrapping
- [x] Create title editing dialog/bottom sheet
  - [x] Pre-fill TextField with custom title or auto-generated display title
  - [x] Add "Save" and "Cancel" buttons
  - [x] Handle empty title submission (clear to NULL, show message)
  - [x] Display success indicator on save
  - [x] Implement auto-dismiss on save
- [x] Update screenshot capture to include displayed title in shared image

## Home Page Updates (Optional Enhancement)

- [x] Update journey list items to display titles
  - [x] Show custom title or auto-generated display title as primary text
  - [x] Show date/time as secondary text
  - [x] Handle title ellipsis in list view
  - [x] Generate display titles on-the-fly for each list item

## Analytics

- [x] Add "journey_title_edited" event to analytics provider
  - [x] Include journey_id parameter
  - [x] Include title_length parameter (0 for cleared titles)
  - [x] Include is_cleared boolean parameter (true when set to NULL)

## Testing

- [ ] Write unit tests for Journey model with nullable title
- [ ] Write unit tests for display title auto-generation utility
- [ ] Write unit tests for NULL title handling in repository
- [ ] Write widget tests for title display in detail view (custom and auto-generated)
- [ ] Write widget tests for title editing dialog
- [ ] Write integration tests for title editing flow
- [ ] Test database migration manually with existing data
- [ ] Test empty title submission (clears to NULL and shows auto-generated)
- [ ] Test very long titles (100+ characters)
- [ ] Test offline title editing and persistence
- [ ] Test that auto-generated titles are not saved to database

## Validation

- [x] Run `dart format .` to ensure code formatting
- [x] Run `flutter analyze` to check for lint errors
- [ ] Verify all tests pass
- [ ] Test on both iOS and Android
- [ ] Verify journey sharing includes displayed title in screenshot
- [ ] Verify existing journeys show auto-generated titles without database changes

## Documentation

- [x] Update code comments for new title-related methods
- [x] Add inline documentation for title auto-generation logic
