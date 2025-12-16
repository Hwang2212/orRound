# Tasks: Add Milestones & Achievements

## 1. Data Model & Storage

- [ ] Create `Achievement` model in `lib/app/data/models/achievement.dart`
  - [ ] Define AchievementType enum (distance, journeyCount, streak)
  - [ ] Add fields: id, type, title, description, requirement, iconName, unlockedAt
  - [ ] Add `isUnlocked` computed property
- [ ] Create `AchievementDefinitions` class with all achievement definitions
  - [ ] Distance achievements: 10km, 50km, 100km, 500km, 1000km
  - [ ] Journey count achievements: 1, 5, 10, 25, 50, 100
  - [ ] Streak achievements: 3, 7, 14, 30 days
- [ ] Update `DatabaseProvider`
  - [ ] Add `achievements` table (id, type, unlockedAt)
  - [ ] Add database migration

## 2. Repository Layer

- [ ] Create `AchievementRepository` in `lib/app/data/repositories/achievement_repository.dart`
  - [ ] Add `getUnlockedAchievements()` method
  - [ ] Add `unlockAchievement(String id)` method
  - [ ] Add `isAchievementUnlocked(String id)` method
  - [ ] Add `getCurrentStreak()` method
  - [ ] Add `updateStreak()` method
- [ ] Update `JourneyRepository`
  - [ ] Add `getLastJourneyDate()` method for streak calculation

## 3. Achievement Checking Logic

- [ ] Create `AchievementService` in `lib/app/services/achievement_service.dart`
  - [ ] Add `checkAchievements()` method called after journey save
  - [ ] Check distance milestones against total distance
  - [ ] Check journey count milestones
  - [ ] Check streak milestones
  - [ ] Return list of newly unlocked achievements
- [ ] Integrate achievement checking into journey save flow

## 4. Achievements Module

- [ ] Create `lib/app/modules/achievements/` directory structure
- [ ] Create `AchievementsController`
  - [ ] Load all achievements with unlock status
  - [ ] Group by type (distance, count, streak)
  - [ ] Add share achievement method
- [ ] Create `AchievementsBinding`
- [ ] Create `AchievementsView`
  - [ ] Grid layout of achievement badges
  - [ ] Unlocked: full color with check, date shown
  - [ ] Locked: grayscale with requirement text

## 5. Celebration Dialog

- [ ] Create `AchievementCelebrationDialog` widget
  - [ ] Animated badge reveal
  - [ ] Confetti or particle effect (optional)
  - [ ] Title and congratulatory message
  - [ ] Share and Close buttons
- [ ] Show dialog from journey tracking controller on save

## 6. Home Page Integration

- [ ] Update `HomeController`
  - [ ] Add `currentStreak` getter
  - [ ] Load streak on init
- [ ] Update `HomeView`
  - [ ] Add streak widget in header area
  - [ ] Make streak tappable to navigate to achievements

## 7. Navigation & Routes

- [ ] Add `ACHIEVEMENTS` route to routes
- [ ] Add achievements route to AppPages
- [ ] Add navigation from home page

## 8. Share Functionality

- [ ] Create achievement share image generator
  - [ ] RepaintBoundary around badge design
  - [ ] Include badge, title, app branding
- [ ] Integrate with share_plus

## 9. Testing & Validation

- [ ] Test achievement unlock logic
- [ ] Test streak calculation (including edge cases)
- [ ] Test celebration dialog display
- [ ] Test share functionality
- [ ] Run `openspec validate add-milestones-achievements --strict`
- [ ] Run `flutter analyze`
