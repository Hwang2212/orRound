# Add Milestones & Achievements

## Phase

**Phase 1** - Core Feature

## Why

Gamification increases user engagement and retention. Users who see their progress celebrated through achievements are more likely to continue using the app. Currently, there's no recognition for user accomplishments like completing their first journey or reaching distance milestones. This feature:

- Celebrates user progress
- Provides motivation to keep tracking
- Creates shareable moments
- Builds habit through streak tracking

## What Changes

- **NEW**: Achievements/badges system for distance milestones
- **NEW**: Streak tracking (consecutive days with journeys)
- **NEW**: Personal records tracking (longest, fastest, etc.)
- **NEW**: Achievement unlock notifications/celebrations
- **NEW**: Achievements page showing earned and locked badges
- **NEW**: Share achievement capability
- **MODIFIED**: Home page to show current streak
- **MODIFIED**: Journey completion flow to check for new achievements

## Impact

- Affected specs: `home-page` (MODIFIED), new spec `achievements`
- Affected code:
  - New module: `lib/app/modules/achievements/`
  - New model: `lib/app/data/models/achievement.dart`
  - `lib/app/data/providers/database_provider.dart` - achievements table
  - `lib/app/modules/home/` - streak display
  - Journey save flow - achievement checking

## User Experience

- **Positive**: Dopamine hit when unlocking achievements
- **Positive**: Motivation through visible progress
- **Positive**: Social sharing of accomplishments
- **Positive**: Streak maintenance encourages daily use

## Implementation Approach

1. Define achievement types and milestones
2. Create achievements database table
3. Create achievement model with unlocked state and date
4. Build achievement checking logic (runs after journey save)
5. Create celebration dialog/animation for new unlocks
6. Build achievements page with grid of badges
7. Add streak tracking to home page
8. Add share functionality for achievements

## Acceptance Criteria

1. Distance milestones unlock at 10km, 50km, 100km, 500km, 1000km
2. Journey count milestones at 5, 10, 25, 50, 100 journeys
3. Streak displayed on home page
4. Achievement celebration shown when milestone reached
5. Achievements page shows all badges (locked and unlocked)
6. Locked badges show requirements
7. User can share unlocked achievements
