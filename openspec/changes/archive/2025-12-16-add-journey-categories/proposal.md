# Add Journey Categories & Tags

## Phase

**Phase 1** - Core Feature

## Why

Currently, all journeys are stored as a flat list without any categorization. Users who track different types of activities (walking, running, cycling, driving, hiking) have no way to organize or filter their journeys. This makes it difficult to:

- Find specific types of journeys
- Compare performance within the same activity type
- Get meaningful insights for each activity category

## What Changes

- **NEW**: Journey categories (Walk, Run, Bike, Drive, Hike, Other)
- **NEW**: Custom tags for flexible organization (e.g., "commute", "vacation", "exercise")
- **NEW**: Category selection during journey start or on journey detail page
- **NEW**: Tag management on journey detail page
- **NEW**: Filter journeys by category on home page
- **NEW**: Category-specific icons and colors in the UI
- **MODIFIED**: Journey model to include category and tags fields
- **MODIFIED**: Home page to show category filters
- **MODIFIED**: Journey detail page to show/edit category and tags

## Impact

- Affected specs: `journey-tracking` (MODIFIED), `journey-storage` (MODIFIED), `journey-detail` (MODIFIED), `home-page` (MODIFIED)
- Affected code:
  - `lib/app/data/models/journey.dart`
  - `lib/app/data/providers/database_provider.dart`
  - `lib/app/modules/journey_tracking/` - category selection
  - `lib/app/modules/journey_detail/` - category/tag editing
  - `lib/app/modules/home/` - filtering

## User Experience

- **Positive**: Easy organization of different activity types
- **Positive**: Quick filtering to find specific journeys
- **Positive**: Visual distinction between journey types with icons
- **Neutral**: One extra step when starting a journey (optional category selection)

## Implementation Approach

1. Add `category` (enum) and `tags` (JSON array) columns to journey database
2. Create category enum with predefined values + icons
3. Add category selector chip row on journey tracking page (optional, defaults to "Other")
4. Add category/tags section on journey detail page
5. Add horizontal filter chips on home page above journey list
6. Migrate existing journeys to "Other" category

## Acceptance Criteria

1. User can select a category when starting a journey
2. User can change category on journey detail page
3. User can add/remove custom tags on journey detail page
4. Home page shows filter chips for each category
5. Filtering by category shows only matching journeys
6. Each category has a distinct icon
7. Existing journeys migrate to "Other" category
