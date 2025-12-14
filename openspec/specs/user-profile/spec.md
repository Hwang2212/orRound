# user-profile Specification

## Purpose
TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.
## Requirements
### Requirement: User Profile Data Storage

The system SHALL store user profile information in local SQLite database for offline access.

#### Scenario: Initialize User Profile

- **GIVEN** the app is launched for the first time
- **WHEN** user profile is initialized
- **THEN** the system creates a user profile record in database
- **AND** sets default values for all fields
- **AND** generates unique referral code
- **AND** sets created_at timestamp

#### Scenario: Store User Profile Data

- **GIVEN** user updates their profile
- **WHEN** saving profile changes
- **THEN** the system stores name, email, and profile picture path in database
- **AND** sets updated_at timestamp
- **AND** marks is_synced flag as 0 (for future cloud sync)
- **AND** persists data across app restarts

#### Scenario: Retrieve User Profile

- **GIVEN** user profile exists in database
- **WHEN** the app requests user data
- **THEN** the system retrieves the complete profile record
- **AND** returns user name, email, profile picture, and referral code
- **AND** query executes within 50ms

### Requirement: Profile Page Display

The system SHALL display user profile information on a dedicated profile page.

#### Scenario: View Profile

- **GIVEN** user navigates to profile page
- **WHEN** page loads
- **THEN** the system displays user's name
- **AND** displays user's email (if set)
- **AND** displays profile picture or default avatar
- **AND** displays referral code
- **AND** displays account creation date
- **AND** provides "Edit Profile" button

#### Scenario: View Incomplete Profile

- **GIVEN** user has not completed their profile
- **WHEN** viewing profile page
- **THEN** the system shows fields with placeholder values
- **AND** displays "Complete your profile" message
- **AND** highlights missing information

#### Scenario: Navigate to Edit Profile

- **GIVEN** user is viewing their profile
- **WHEN** user taps "Edit Profile" button
- **THEN** the system navigates to edit profile page
- **AND** pre-fills form with current profile data

### Requirement: Edit Profile Functionality

The system SHALL allow users to edit their profile information.

#### Scenario: Edit User Name

- **GIVEN** user is on edit profile page
- **WHEN** user enters a new name
- **THEN** the system validates name is not empty
- **AND** validates name length (2-50 characters)
- **AND** allows alphabetic characters and spaces
- **AND** shows validation errors immediately

#### Scenario: Edit Email Address

- **GIVEN** user is on edit profile page
- **WHEN** user enters an email address
- **THEN** the system validates email format
- **AND** allows saving with valid email or empty field
- **AND** shows validation error for invalid format

#### Scenario: Save Profile Changes

- **GIVEN** user has made changes to profile
- **AND** all fields are valid
- **WHEN** user taps "Save" button
- **THEN** the system updates user profile in database
- **AND** sets updated_at timestamp
- **AND** displays success message
- **AND** navigates back to profile page
- **AND** logs "profile_updated" analytics event

#### Scenario: Cancel Profile Edit

- **GIVEN** user is editing profile
- **WHEN** user taps "Cancel" or back button
- **THEN** the system displays discard changes confirmation dialog
- **AND** on confirmation, navigates back without saving
- **AND** retains original profile data

#### Scenario: Validate Required Fields

- **GIVEN** user is editing profile
- **WHEN** attempting to save with invalid data
- **THEN** the system prevents save action
- **AND** highlights fields with errors
- **AND** displays specific error messages per field
- **AND** keeps user on edit page

### Requirement: Profile Picture Management

The system SHALL allow users to add and update their profile picture.

#### Scenario: Add Profile Picture

- **GIVEN** user is on edit profile page
- **WHEN** user taps on profile picture placeholder
- **THEN** the system displays options: "Take Photo" or "Choose from Gallery"
- **AND** requests camera/photo library permissions if needed

#### Scenario: Select Photo from Gallery

- **GIVEN** user chooses "Choose from Gallery"
- **AND** photo library permissions are granted
- **WHEN** user selects an image
- **THEN** the system displays the selected image in preview
- **AND** allows cropping to square format
- **AND** compresses image to under 500KB
- **AND** stores image file path in profile

#### Scenario: Take Photo with Camera

- **GIVEN** user chooses "Take Photo"
- **AND** camera permissions are granted
- **WHEN** user captures a photo
- **THEN** the system displays captured photo in preview
- **AND** allows retake option
- **AND** crops to square format
- **AND** compresses to under 500KB
- **AND** stores image file path in profile

#### Scenario: Remove Profile Picture

- **GIVEN** user has a profile picture set
- **WHEN** user taps "Remove Photo" option
- **THEN** the system displays confirmation dialog
- **AND** on confirmation, removes profile picture
- **AND** reverts to default avatar
- **AND** deletes image file from storage

#### Scenario: Handle Permission Denied

- **GIVEN** user attempts to add photo
- **WHEN** camera/photo permissions are denied
- **THEN** the system displays permission explanation dialog
- **AND** provides link to app settings
- **AND** does not crash or block other profile editing

### Requirement: Profile Data Validation

The system SHALL validate all profile data before saving.

#### Scenario: Name Validation

- **GIVEN** user enters a name
- **WHEN** validating the input
- **THEN** the system checks name is at least 2 characters
- **AND** checks name is no more than 50 characters
- **AND** allows letters, spaces, hyphens, and apostrophes
- **AND** rejects empty names or only whitespace

#### Scenario: Email Validation

- **GIVEN** user enters an email
- **WHEN** validating the input
- **THEN** the system checks email matches standard format (RFC 5322)
- **AND** allows empty email (optional field)
- **AND** displays specific error for invalid format

### Requirement: Profile Navigation

The system SHALL provide navigation to and from profile pages.

#### Scenario: Access Profile from Home

- **GIVEN** user is on home page
- **WHEN** user taps on header profile section
- **THEN** the system navigates to profile page

#### Scenario: Access Profile from Menu

- **GIVEN** user opens app menu or settings
- **WHEN** user selects "Profile" option
- **THEN** the system navigates to profile page

#### Scenario: Return from Profile

- **GIVEN** user is on profile page
- **WHEN** user taps back button
- **THEN** the system navigates to previous page (typically home)
- **AND** updates header if name was changed

### Requirement: Profile Analytics Tracking

The system SHALL track profile-related user actions.

#### Scenario: Track Profile View

- **GIVEN** user navigates to profile page
- **WHEN** page is displayed
- **THEN** the system logs "profile_viewed" event to Firebase Analytics

#### Scenario: Track Profile Edit

- **GIVEN** user saves profile changes
- **WHEN** save is successful
- **THEN** the system logs "profile_updated" event
- **AND** includes fields_updated parameter (name, email, picture)

#### Scenario: Track Profile Picture Update

- **GIVEN** user adds or changes profile picture
- **WHEN** photo is saved
- **THEN** the system logs "profile_picture_updated" event
- **AND** includes source parameter ("camera" or "gallery")

### Requirement: Default Avatar Display

The system SHALL display a default avatar when no profile picture is set.

#### Scenario: Show Default Avatar

- **GIVEN** user has not set a profile picture
- **WHEN** profile or header is displayed
- **THEN** the system displays a default avatar
- **AND** avatar uses first letter of user's name if available
- **AND** avatar uses "T" (Traveler) if no name is set
- **AND** avatar has solid background color (black or white based on theme)

### Requirement: Profile Data for Future Sync

The system SHALL structure profile data for future cloud synchronization.

#### Scenario: Mark Profile as Unsynced

- **GIVEN** user updates profile
- **WHEN** saving to database
- **THEN** the system sets is_synced flag to 0
- **AND** sets updated_at timestamp
- **AND** data is ready for future sync to cloud

#### Scenario: Maintain Sync Status

- **GIVEN** profile data exists
- **WHEN** viewing or editing profile
- **THEN** the system maintains sync status fields
- **AND** preserves server_id field (null for offline-only)
- **AND** tracks last_synced_at timestamp (future feature)

