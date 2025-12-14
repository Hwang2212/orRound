# Orround - Journey Tracking App

Offline-first Flutter journey tracking application with map visualization, weather integration, and referral system.

## Features

### Core Features

- **Journey Tracking**: Real-time GPS tracking with live map display
- **Journey History**: View past journeys with detailed statistics and map routes
- **Weather Integration**: Automatic weather capture at journey start using Open-Meteo API
- **Map Display**: Interactive maps using OpenStreetMap tiles via flutter_map
- **Profile Management**: User profiles with customizable pictures
- **Referral System**: Built-in referral code generation and tracking
- **Journey Sharing**: Share journey screenshots and save to gallery
- **Analytics**: Firebase Analytics integration for usage tracking

### Technical Features

- **Offline-First**: Full SQLite database with sync-ready architecture
- **MVVM Architecture**: Clean separation with GetX state management
- **Background Location**: Continuous tracking even when app is backgrounded
- **Minimalistic Design**: 2-tone black/white theme with system preference support

## Tech Stack

- **Framework**: Flutter ^3.7.2, Dart
- **State Management**: GetX ^4.6.6
- **Database**: SQLite (sqflite ^2.3.0)
- **Maps**: flutter_map ^6.1.0 with OpenStreetMap
- **Location**: location ^5.0.0, geocoding ^2.1.1
- **Weather**: Open-Meteo API (free) via http ^1.1.0
- **Analytics**: Firebase Analytics ^10.8.0
- **Sharing**: share_plus ^7.2.1, gal ^2.1.3
- **Images**: image_picker ^1.0.7

## Project Structure

```
lib/
├── app/
│   ├── config/
│   │   ├── theme.dart           # Light/dark themes
│   │   └── routes.dart          # GetX routes configuration
│   ├── data/
│   │   ├── models/              # Data models (Journey, LocationPoint, etc.)
│   │   ├── providers/           # Database, location, weather, analytics providers
│   │   └── repositories/        # Data access layer
│   └── modules/
│       ├── home/                # Home page with journey list
│       ├── journey_tracking/    # Live tracking with map
│       ├── journey_detail/      # Journey details with sharing
│       ├── profile/             # User profile and edit
│       ├── referral/            # Referral code management
│       └── routes/              # Route constants
└── main.dart                    # App entry point
```

## Database Schema

### journeys

- id (PRIMARY KEY)
- start_time, end_time
- total_distance, average_speed
- weather_condition, temperature
- is_synced, created_at

### location_points

- id (PRIMARY KEY)
- journey_id (FOREIGN KEY)
- latitude, longitude, speed
- timestamp

### user_profile

- id (always 1 - single user)
- name, email, profile_picture_path
- referral_code, referred_by_code
- created_at, updated_at, is_synced

### referrals

- id (PRIMARY KEY)
- referral_code, used_at

## Getting Started

### Prerequisites

- Flutter SDK ^3.7.2
- Xcode (for iOS)
- Android Studio (for Android)

### Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd orround
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

### Platform Setup

#### iOS

Permissions are configured in `ios/Runner/Info.plist`:

- Location (Always and When In Use)
- Camera
- Photo Library

Background location mode is enabled in capabilities.

#### Android

Permissions are configured in `android/app/src/main/AndroidManifest.xml`:

- Fine and Coarse Location
- Background Location (Android 10+)
- Camera
- Storage
- Internet

## Features by Module

### Home Module

- Welcome header with user profile picture/name
- Current weather display
- Journey list with pull-to-refresh
- Quick stats (duration, distance, speed)
- Navigate to tracking, profile, or journey details

### Journey Tracking Module

- Real-time GPS tracking
- Live map with route polyline
- Current speed and distance display
- Timer with pause/resume
- Start/stop with confirmation
- Weather capture at start
- Background location support

### Journey Detail Module

- Map with complete route (start/end markers)
- Detailed statistics grid
- Weather conditions at start
- Share journey as image
- Save screenshot to gallery

### Profile Module

- Profile picture from camera/gallery
- Name and email management
- Journey count statistics
- Access to referral system

### Referral Module

- Auto-generated 6-character codes
- Copy code to clipboard
- Enter friend's referral code
- Validation and tracking

## Analytics Events

- App launched
- Journey started/paused/ended
- Journey viewed/shared
- Profile updated
- Referral code generated/entered
- Weather fetched
- Error tracking (location, database, API)

## State Management

All modules use GetX for:

- Reactive state with `.obs` observables
- Dependency injection with bindings
- Navigation with `Get.toNamed()`
- Snackbars for user feedback

## Styling

- **Theme**: Minimalistic black/white with 7:1 contrast
- **Typography**: System fonts with consistent sizing
- **Cards**: Zero elevation, 4px border radius
- **Icons**: Material Design icons
- **Spacing**: 8px grid system

## Offline-First Architecture

- All journeys stored locally in SQLite
- `is_synced` flag for future server sync
- `server_id` field for mapping to online database
- Weather cached for 30 minutes
- Analytics queued when offline

## Future Enhancements

- Prisma Postgres sync for premium users
- Social features (journey sharing)
- Journey templates and goals
- Advanced analytics dashboard
- Export journeys to GPX/KML
- Apple Watch / Wear OS support

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]
