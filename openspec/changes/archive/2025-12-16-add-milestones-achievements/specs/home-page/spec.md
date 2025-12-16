## MODIFIED Requirements

### Requirement: Display Current Streak on Home Page

The system SHALL show the user's current streak on the home page.

#### Scenario: Show Active Streak

- **GIVEN** the user has a 7-day streak
- **WHEN** viewing the home page
- **THEN** a streak indicator shows "🔥 7 day streak"
- **AND** the indicator is visually prominent

#### Scenario: Show Zero Streak

- **GIVEN** the user has no active streak
- **WHEN** viewing the home page
- **THEN** the streak shows "Start a streak today!"
- **OR** shows "🔥 0 days" with subtle styling

#### Scenario: Streak Milestone Celebration

- **GIVEN** the user just reached a 7-day streak
- **WHEN** viewing the home page
- **THEN** the streak indicator has celebratory styling
- **AND** the "Week Warrior" achievement unlock is triggered

### Requirement: Quick Access to Achievements

The system SHALL provide easy access to achievements from the home page.

#### Scenario: Navigate to Achievements

- **GIVEN** the user is on the home page
- **WHEN** the user taps the streak indicator or achievements icon
- **THEN** the app navigates to the achievements page

**IMPLEMENTATION NOTES:**

- Streak widget position: in header area near profile avatar
- Fire emoji (🔥) for visual streak representation
- Tappable to navigate to achievements
- Consider animation for milestone streaks
