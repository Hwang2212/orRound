# Add Journey Photos & Notes

## Phase

**Phase 2** - Premium Feature

## Why

Journeys are memories, not just data points. Users want to capture the experience of their journeys beyond GPS coordinates. Photos and notes transform journey tracking from a utility into a memory keeper. This feature:

- Adds emotional value to journey records
- Creates richer shareable content
- Provides context for why/where journeys happened
- Differentiates premium from free tier

## What Changes

- **NEW**: Capture photos during active journey tracking
- **NEW**: Photos geotagged with capture location
- **NEW**: Add text notes to journeys
- **NEW**: Gallery view of journey photos on detail page
- **NEW**: Photos displayed on map at capture locations
- **NEW**: Premium paywall for photo/notes features
- **MODIFIED**: Journey tracking page with camera button
- **MODIFIED**: Journey detail page with photos section
- **MODIFIED**: Journey model to include photos and notes

## Impact

- Affected specs: `journey-tracking` (MODIFIED), `journey-detail` (MODIFIED), `journey-storage` (MODIFIED), new spec `premium-features`
- Affected code:
  - `lib/app/data/models/journey_photo.dart` (new)
  - `lib/app/data/providers/database_provider.dart`
  - `lib/app/modules/journey_tracking/`
  - `lib/app/modules/journey_detail/`
  - Storage for photo files

## User Experience

- **Positive**: Rich memory capture during journeys
- **Positive**: Beautiful photo galleries on detail pages
- **Positive**: Map markers showing where photos were taken
- **Consideration**: Premium feature requires subscription

## Implementation Approach

1. Create JourneyPhoto model with location, timestamp, path
2. Add photos table to database
3. Add camera button during tracking (premium check)
4. Store photos in app documents directory
5. Show photos in detail page gallery
6. Show photo markers on route map
7. Implement premium paywall check

## Acceptance Criteria

1. Premium users can tap camera during tracking
2. Photo is saved with current GPS coordinates
3. Photos appear in journey detail gallery
4. Photos show as markers on route map
5. Free users see premium upsell when tapping camera
6. Notes can be added/edited on journey detail
7. Photos persist across app restarts
