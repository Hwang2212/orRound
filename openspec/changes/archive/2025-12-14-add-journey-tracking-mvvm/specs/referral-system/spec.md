# Spec: Referral System

## ADDED Requirements

### Requirement: Unique Referral Code Generation

The system SHALL generate a unique referral code for each user on first app launch.

#### Scenario: Generate Referral Code

- **GIVEN** the app is launched for the first time
- **AND** no user profile exists
- **WHEN** initializing user profile
- **THEN** the system generates a 6-character alphanumeric code
- **AND** code contains uppercase letters and numbers only (A-Z, 0-9)
- **AND** code is cryptographically random
- **AND** code is stored in user_profile table
- **AND** code persists across app sessions

#### Scenario: Prevent Duplicate Codes

- **GIVEN** a referral code is being generated
- **WHEN** checking uniqueness
- **THEN** the system verifies code doesn't exist in database
- **AND** regenerates if duplicate found (edge case)
- **AND** ensures final code is unique

### Requirement: Display User's Referral Code

The system SHALL display the user's referral code on a dedicated page.

#### Scenario: View My Referral Code

- **GIVEN** user navigates to "My Referral" page
- **WHEN** page loads
- **THEN** the system displays user's unique referral code in large, readable text
- **AND** displays code in monospace font for clarity
- **AND** provides "Copy Code" button to copy code to clipboard
- **AND** displays instructions on how to share the code

#### Scenario: Copy Referral Code

- **GIVEN** user is viewing their referral code
- **WHEN** user taps "Copy Code" button
- **THEN** the system copies code to device clipboard
- **AND** displays "Code copied!" confirmation message
- **AND** message auto-dismisses after 2 seconds

### Requirement: Referral Code Entry

The system SHALL provide a page for users to enter a referral code.

#### Scenario: Enter Referral Code

- **GIVEN** user navigates to "Enter Referral Code" page
- **AND** user has not previously entered a referral code
- **WHEN** user enters a 6-character code
- **THEN** the system validates code format (6 alphanumeric characters)
- **AND** converts input to uppercase automatically
- **AND** enables submit button when valid format

#### Scenario: Submit Valid Referral Code

- **GIVEN** user entered a valid format code
- **WHEN** user taps "Submit" button
- **THEN** the system stores code in user_profile.referred_by_code
- **AND** inserts record into referrals table with timestamp
- **AND** displays success message "Referral code accepted!"
- **AND** logs "referral_code_entered" analytics event
- **AND** navigates back to home page

#### Scenario: Prevent Multiple Referral Entries

- **GIVEN** user has already entered a referral code
- **WHEN** user navigates to "Enter Referral Code" page
- **THEN** the system displays message "You've already used a referral code"
- **AND** shows the previously entered code
- **AND** disables input field and submit button

#### Scenario: Invalid Referral Code Format

- **GIVEN** user is entering a referral code
- **WHEN** input is less than 6 characters or contains invalid characters
- **THEN** the system displays format error message
- **AND** submit button remains disabled
- **AND** shows hint "Code must be 6 letters/numbers"

#### Scenario: Submit Own Referral Code

- **GIVEN** user enters their own referral code
- **WHEN** validating the code
- **THEN** the system detects self-referral
- **AND** displays error "You cannot use your own referral code"
- **AND** prevents submission

### Requirement: Referral Code Validation

The system SHALL validate referral codes before accepting them.

#### Scenario: Format Validation

- **GIVEN** user submits a referral code
- **WHEN** validating the code
- **THEN** the system checks code is exactly 6 characters
- **AND** checks code contains only A-Z and 0-9
- **AND** rejects codes with special characters or spaces
- **AND** displays appropriate error message for format issues

### Requirement: Referral Navigation

The system SHALL provide navigation to referral pages from home page.

#### Scenario: Access Referral Menu

- **GIVEN** user is on home page
- **WHEN** user opens menu or settings
- **THEN** the system displays "My Referral Code" option
- **AND** displays "Enter Referral Code" option (if not already used)
- **AND** tapping options navigates to respective pages

### Requirement: Referral Data Storage

The system SHALL store referral information offline for future sync.

#### Scenario: Store Referral Relationship

- **GIVEN** user successfully enters a referral code
- **WHEN** storing the data
- **THEN** the system saves referred_by_code in user_profile
- **AND** creates referral record with used_at timestamp
- **AND** data is available for future premium sync feature
- **AND** is_synced flag remains 0 (offline only for now)

### Requirement: Referral Analytics

The system SHALL track referral events for analytics.

#### Scenario: Track Referral Code Generation

- **GIVEN** user's referral code is generated
- **WHEN** code is created
- **THEN** the system logs "referral_code_generated" event to Firebase Analytics

#### Scenario: Track Referral Code Entry

- **GIVEN** user successfully enters a referral code
- **WHEN** code is submitted
- **THEN** the system logs "referral_code_entered" event
- **AND** includes has_referred_by parameter (boolean)

### Requirement: Referral Code Display Formatting

The system SHALL format referral codes for optimal readability and sharing.

#### Scenario: Format Code Display

- **GIVEN** referral code is displayed
- **WHEN** rendering the code
- **THEN** the system displays code in uppercase
- **AND** uses monospace font (e.g., 'Courier New')
- **AND** font size is large and readable (24pt minimum)
- **AND** code has high contrast against background
