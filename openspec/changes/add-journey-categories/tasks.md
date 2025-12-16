# Tasks: Add Journey Categories & Tags

## 1. Data Model Updates

- [ ] Create `JourneyCategory` enum in `lib/app/data/models/journey_category.dart`
  - [ ] Define values: walk, run, bike, drive, hike, other
  - [ ] Add `icon` getter returning appropriate IconData
  - [ ] Add `displayName` getter returning capitalized name
- [ ] Update `Journey` model in `lib/app/data/models/journey.dart`
  - [ ] Add `category` field (JourneyCategory, default: other)
  - [ ] Add `tags` field (List<String>, default: [])
  - [ ] Update `toMap()` to serialize category and tags
  - [ ] Update `fromMap()` to deserialize category and tags

## 2. Database Migration

- [ ] Update `DatabaseProvider` in `lib/app/data/providers/database_provider.dart`
  - [ ] Increment database version
  - [ ] Add migration to add `category TEXT DEFAULT 'other'` column
  - [ ] Add migration to add `tags TEXT DEFAULT '[]'` column
  - [ ] Test migration with existing data

## 3. Journey Tracking - Category Selection

- [ ] Update `JourneyTrackingController`
  - [ ] Add `selectedCategory` reactive state (default: other)
  - [ ] Pass category to journey when saving
- [ ] Update `JourneyTrackingView`
  - [ ] Add category chip row above Start button (when not tracking)
  - [ ] Show selected category icon during tracking
  - [ ] Hide category selector during active tracking

## 4. Journey Detail - Category & Tags Editing

- [ ] Update `JourneyDetailController`
  - [ ] Add `updateCategory(JourneyCategory)` method
  - [ ] Add `addTag(String)` method
  - [ ] Add `removeTag(String)` method
- [ ] Update `JourneyRepository`
  - [ ] Add `updateJourneyCategory()` method
  - [ ] Add `updateJourneyTags()` method
- [ ] Update `JourneyDetailView`
  - [ ] Add category display with edit tap handler
  - [ ] Add category selection bottom sheet
  - [ ] Add tags section with InputChips
  - [ ] Add "Add tag" ActionChip with dialog

## 5. Home Page - Category Filtering

- [ ] Update `HomeController`
  - [ ] Add `selectedFilter` reactive state (default: null = all)
  - [ ] Add `filteredJourneys` computed getter
  - [ ] Add `setFilter(JourneyCategory?)` method
- [ ] Update `HomeView`
  - [ ] Add filter chip row below header
  - [ ] Update journey list to use `filteredJourneys`
  - [ ] Add category icon to journey card items

## 6. Testing & Validation

- [ ] Test database migration with existing journeys
- [ ] Test category selection flow during tracking
- [ ] Test category editing on detail page
- [ ] Test tag add/remove on detail page
- [ ] Test filtering on home page
- [ ] Run `openspec validate add-journey-categories --strict`
- [ ] Run `flutter analyze`
