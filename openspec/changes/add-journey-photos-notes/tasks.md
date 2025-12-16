# Tasks: Add Journey Photos & Notes

## 1. Data Model & Storage

- [ ] Create `JourneyPhoto` model in `lib/app/data/models/journey_photo.dart`
  - [ ] Fields: id, journeyId, latitude, longitude, timestamp, filePath
  - [ ] Add toMap() and fromMap() methods
- [ ] Update `Journey` model
  - [ ] Add `notes` field (String?)
- [ ] Update `DatabaseProvider`
  - [ ] Add `journey_photos` table
  - [ ] Add `notes TEXT` column to journeys table
  - [ ] Add migration

## 2. Repository Layer

- [ ] Create `JourneyPhotoRepository`
  - [ ] Add `savePhoto(JourneyPhoto)` method
  - [ ] Add `getPhotosForJourney(String journeyId)` method
  - [ ] Add `deletePhoto(String id)` method
- [ ] Update `JourneyRepository`
  - [ ] Add `updateJourneyNotes(String id, String notes)` method

## 3. Premium Check Service

- [ ] Create `PremiumService` in `lib/app/services/premium_service.dart`
  - [ ] Add `isPremium` getter (stub for now, returns false)
  - [ ] Add `showPremiumUpsell(BuildContext, String feature)` method
  - [ ] Prepare for future Stripe integration

## 4. Journey Tracking - Photo Capture

- [ ] Update `JourneyTrackingController`
  - [ ] Add `capturedPhotos` list
  - [ ] Add `takePhoto()` method
  - [ ] Check premium status before allowing photo
  - [ ] Use image_picker to capture
  - [ ] Save photo with current location
- [ ] Update `JourneyTrackingView`
  - [ ] Add camera FAB during active tracking
  - [ ] Show photo count indicator
  - [ ] Show premium upsell if not premium

## 5. Journey Detail - Photos & Notes

- [ ] Update `JourneyDetailController`
  - [ ] Load photos for journey
  - [ ] Add `updateNotes(String)` method
- [ ] Update `JourneyDetailView`
  - [ ] Add photos gallery section (horizontal scroll)
  - [ ] Add photo markers to map
  - [ ] Add full-screen photo viewer
  - [ ] Add notes section with edit capability

## 6. Photo Storage

- [ ] Create photo storage utility
  - [ ] Save photos to documents/journey_photos/{journeyId}/
  - [ ] Generate unique filenames
  - [ ] Clean up photos when journey deleted

## 7. Testing & Validation

- [ ] Test photo capture during tracking
- [ ] Test photo display in gallery
- [ ] Test photo markers on map
- [ ] Test notes add/edit
- [ ] Test premium upsell for free users
- [ ] Run `openspec validate add-journey-photos-notes --strict`
- [ ] Run `flutter analyze`
