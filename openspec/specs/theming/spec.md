# theming Specification

## Purpose
TBD - created by archiving change add-journey-tracking-mvvm. Update Purpose after archive.
## Requirements
### Requirement: Minimalistic Black and White Theme

The system SHALL implement a minimalistic 2-tone black and white color scheme throughout the app.

#### Scenario: Light Theme Configuration

- **GIVEN** the app initializes
- **WHEN** applying light theme
- **THEN** the system sets scaffold background to pure white (#FFFFFF)
- **AND** sets primary color to pure black (#000000)
- **AND** sets secondary color to dark grey (#424242)
- **AND** sets all text to black on white backgrounds
- **AND** uses minimal elevation (0-2) for components

#### Scenario: Dark Theme Configuration

- **GIVEN** the app initializes
- **WHEN** applying dark theme
- **THEN** the system sets scaffold background to pure black (#000000)
- **AND** sets primary color to pure white (#FFFFFF)
- **AND** sets secondary color to light grey (#E0E0E0)
- **AND** sets all text to white on black backgrounds
- **AND** uses minimal elevation (0-2) for components

### Requirement: Typography

The system SHALL use clean, readable typography consistent with minimalistic design.

#### Scenario: Text Styles

- **GIVEN** text is displayed
- **WHEN** rendering typography
- **THEN** the system uses sans-serif font family (default system font)
- **AND** uses font weights: 400 (regular), 600 (semi-bold), 700 (bold)
- **AND** ensures minimum font size of 14pt for body text
- **AND** uses 24pt or larger for headlines
- **AND** maintains high contrast ratio (at least 7:1)

#### Scenario: Consistent Text Colors

- **GIVEN** text is displayed in the app
- **WHEN** applying text colors
- **THEN** primary text is black in light theme, white in dark theme
- **AND** secondary text is grey (#757575 in light, #BDBDBD in dark)
- **AND** disabled text is light grey (#BDBDBD in light, #616161 in dark)

### Requirement: Component Styling

The system SHALL style UI components with minimal, clean aesthetics.

#### Scenario: Button Styling

- **GIVEN** buttons are displayed
- **WHEN** rendering buttons
- **THEN** primary buttons have black background with white text (light theme)
- **AND** primary buttons have white background with black text (dark theme)
- **AND** buttons use sharp corners (borderRadius = 4)
- **AND** buttons have no shadow or minimal elevation
- **AND** text buttons use black text with no background

#### Scenario: Card Styling

- **GIVEN** cards are displayed (e.g., journey list items)
- **WHEN** rendering cards
- **THEN** cards have white background (light theme) or black background (dark theme)
- **AND** cards have 1px border in grey (#E0E0E0 in light, #424242 in dark)
- **AND** cards have zero elevation
- **AND** cards use sharp or minimal border radius (0-4px)

#### Scenario: Input Field Styling

- **GIVEN** input fields are displayed
- **WHEN** rendering text inputs
- **THEN** inputs have border outline in black (light) or white (dark)
- **AND** inputs have transparent background
- **AND** cursor and selection color is black (light) or white (dark)
- **AND** focus state shows thicker border (2px)

### Requirement: Icon Styling

The system SHALL use monochrome icons consistent with the theme.

#### Scenario: Icon Colors

- **GIVEN** icons are displayed
- **WHEN** rendering icons
- **THEN** all icons are black in light theme
- **AND** all icons are white in dark theme
- **AND** no colored or gradient icons are used
- **AND** icon size is consistent (24px standard, 48px for large)

### Requirement: Map Styling

The system SHALL style map elements to match the minimalistic theme.

#### Scenario: Map Route Styling

- **GIVEN** journey route is displayed on map
- **WHEN** rendering the polyline
- **THEN** polyline color is pure black
- **AND** polyline width is 4 pixels
- **AND** no gradient or decorative effects are applied

#### Scenario: Map Marker Styling

- **GIVEN** map markers are displayed
- **WHEN** rendering markers
- **THEN** start marker is solid black circle
- **AND** end marker is solid black square
- **AND** current location marker is solid black circle with white border
- **AND** markers are simple geometric shapes

### Requirement: Theme Switching

The system SHALL support switching between light and dark themes.

#### Scenario: Detect System Theme Preference

- **GIVEN** the app initializes
- **WHEN** determining theme
- **THEN** the system detects OS theme preference (light/dark)
- **AND** applies matching theme automatically
- **AND** updates theme when system preference changes

#### Scenario: Manual Theme Toggle

- **GIVEN** user is in app settings (future feature)
- **WHEN** user selects theme preference
- **THEN** the system allows selection of Light, Dark, or System default
- **AND** persists user preference
- **AND** applies theme immediately without restart

### Requirement: Accessibility

The system SHALL maintain accessibility standards with the minimalistic theme.

#### Scenario: Contrast Ratios

- **GIVEN** any UI element is displayed
- **WHEN** checking color contrast
- **THEN** text contrast ratio is at least 7:1 (AAA standard)
- **AND** interactive elements have clear visual distinction
- **AND** theme passes WCAG 2.1 Level AAA guidelines

#### Scenario: Touch Target Sizes

- **GIVEN** interactive elements are displayed
- **WHEN** rendering buttons and tappable areas
- **THEN** minimum touch target size is 44x44 points
- **AND** adequate spacing exists between interactive elements
- **AND** theme styling does not compromise usability

### Requirement: GetX Theme Integration

The system SHALL use GetX for theme management and switching.

#### Scenario: Configure GetX Theme

- **GIVEN** app uses GetX
- **WHEN** configuring MaterialApp
- **THEN** the system uses GetMaterialApp for root widget
- **AND** defines theme in GetX ThemeData
- **AND** defines darkTheme in GetX ThemeData
- **AND** uses Get.changeTheme() for runtime theme switching

### Requirement: Consistent Visual Language

The system SHALL maintain visual consistency across all screens.

#### Scenario: Spacing Consistency

- **GIVEN** any screen is displayed
- **WHEN** applying layout spacing
- **THEN** the system uses multiples of 8px for spacing (8, 16, 24, 32)
- **AND** padding is consistent across similar components
- **AND** maintains visual rhythm throughout the app

#### Scenario: Border Consistency

- **GIVEN** UI components use borders
- **WHEN** rendering borders
- **THEN** all borders are 1px width (normal state)
- **AND** focused borders are 2px width
- **AND** border color is consistent (#E0E0E0 light, #424242 dark)
- **AND** no border radius exceeds 4px

### Requirement: Loading and State Indicators

The system SHALL style loading and state indicators minimally.

#### Scenario: Loading Spinner

- **GIVEN** data is loading
- **WHEN** displaying progress indicator
- **THEN** the system uses a simple circular progress indicator
- **AND** indicator color is black (light theme) or white (dark theme)
- **AND** no colorful or complex animations are used

#### Scenario: Empty States

- **GIVEN** no data is available (e.g., no journeys)
- **WHEN** displaying empty state
- **THEN** the system shows simple text message in grey
- **AND** optionally displays a minimal icon
- **AND** maintains clean, uncluttered appearance

