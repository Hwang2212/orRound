## ADDED Requirements

### Requirement: Distance Milestone Achievements

The system SHALL unlock achievements when users reach distance milestones.

#### Scenario: Unlock First 10km Achievement

- **GIVEN** the user's total distance is 8.5 km
- **AND** the user completes a 2 km journey
- **WHEN** the journey is saved
- **THEN** total distance becomes 10.5 km
- **AND** the "10 km Explorer" achievement is unlocked
- **AND** a celebration dialog is displayed

#### Scenario: Already Unlocked Achievement

- **GIVEN** the user has already unlocked "10 km Explorer"
- **WHEN** the user completes another journey
- **THEN** no duplicate achievement is unlocked
- **AND** no celebration is shown for that achievement

#### Scenario: Distance Milestones

- **GIVEN** the defined distance milestones are: 10km, 50km, 100km, 500km, 1000km
- **WHEN** the user reaches each milestone
- **THEN** the corresponding achievement is unlocked:
  - 10 km: "10 km Explorer"
  - 50 km: "50 km Adventurer"
  - 100 km: "100 km Voyager"
  - 500 km: "500 km Pioneer"
  - 1000 km: "1000 km Legend"

### Requirement: Journey Count Achievements

The system SHALL unlock achievements when users complete journey count milestones.

#### Scenario: First Journey Achievement

- **GIVEN** the user has never completed a journey
- **WHEN** the user completes their first journey
- **THEN** the "First Steps" achievement is unlocked

#### Scenario: Journey Count Milestones

- **GIVEN** the defined journey milestones are: 1, 5, 10, 25, 50, 100
- **WHEN** the user reaches each milestone
- **THEN** the corresponding achievement is unlocked:
  - 1: "First Steps"
  - 5: "Getting Started"
  - 10: "Regular Tracker"
  - 25: "Journey Enthusiast"
  - 50: "Dedicated Explorer"
  - 100: "Century Club"

### Requirement: Streak Tracking

The system SHALL track consecutive days with at least one journey.

#### Scenario: Maintain Streak

- **GIVEN** the user has a 3-day streak
- **AND** today is a new day
- **WHEN** the user completes a journey today
- **THEN** the streak increases to 4 days

#### Scenario: Break Streak

- **GIVEN** the user has a 5-day streak
- **AND** the user did not complete any journey yesterday
- **WHEN** viewing the home page today
- **THEN** the streak is reset to 0
- **AND** if a journey is completed today, streak becomes 1

#### Scenario: Streak Achievements

- **GIVEN** streak milestones at 3, 7, 14, 30 days
- **WHEN** the user maintains each streak length
- **THEN** streak achievements are unlocked:
  - 3 days: "3-Day Streak"
  - 7 days: "Week Warrior"
  - 14 days: "Two Week Champion"
  - 30 days: "Monthly Master"

### Requirement: Achievement Celebration

The system SHALL celebrate when a user unlocks a new achievement.

#### Scenario: Show Celebration Dialog

- **GIVEN** the user just unlocked "50 km Adventurer"
- **WHEN** the journey save completes
- **THEN** a celebration dialog appears with:
  - Achievement badge/icon
  - Achievement title
  - Congratulatory message
  - "Share" button
  - "Close" button

#### Scenario: Multiple Achievements at Once

- **GIVEN** the user's journey triggers both distance and count milestones
- **WHEN** the journey is saved
- **THEN** achievements are shown one at a time
- **OR** a combined celebration shows all new achievements

### Requirement: Achievements Page

The system SHALL provide a page displaying all achievements.

#### Scenario: View Unlocked Achievements

- **GIVEN** the user has unlocked 5 achievements
- **WHEN** viewing the achievements page
- **THEN** unlocked achievements display with full color and check mark
- **AND** the unlock date is shown

#### Scenario: View Locked Achievements

- **GIVEN** there are achievements the user hasn't unlocked
- **WHEN** viewing the achievements page
- **THEN** locked achievements display grayed out
- **AND** the requirement is shown (e.g., "Complete 100 km")

#### Scenario: Navigate to Achievements

- **GIVEN** the user is on the home or profile page
- **WHEN** the user taps the achievements/badges icon
- **THEN** the app navigates to the achievements page

### Requirement: Share Achievement

The system SHALL allow users to share unlocked achievements.

#### Scenario: Share Achievement

- **GIVEN** the user has unlocked "Week Warrior"
- **WHEN** the user taps "Share" on the achievement
- **THEN** a share image is generated with:
  - Achievement badge
  - Achievement title
  - App branding
- **AND** the system share sheet opens

**IMPLEMENTATION NOTES:**

- Achievement model: id, type, title, description, requirement, icon, unlockedAt
- Store unlocked achievements in SQLite table
- Check achievements after every journey save
- Streak calculation: compare last journey date to yesterday
- Badge icons: custom or Material icons with colored backgrounds
- Share image: generated via RepaintBoundary screenshot
