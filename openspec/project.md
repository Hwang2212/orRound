# Project Context

## Purpose

Orround is an offline-first journey tracking mobile application that allows users to record, store, and share their travel journeys with GPS tracking, weather data, and route visualization. The app is designed to work completely offline, with premium sync features planned for future implementation.

## Tech Stack

- **Framework**: Flutter (Dart SDK ^3.7.2)
- **Language**: Dart
- **UI**: Material Design with minimalistic black & white theme
- **Platforms**: iOS, Android (primary), Web, Linux, macOS, Windows
- **State Management**: GetX
- **Routing**: GetX Navigation
- **Database**: SQLite (sqflite) - structured for future Prisma DB sync
- **Maps**: flutter_map with OpenStreetMap tiles
- **Location**: location, geocoding, latlong2 packages
- **Weather API**: Open-Meteo (https://open-meteo.com/)
- **Sharing**: share_plus, gal (gallery)
- **Analytics**: Firebase Analytics
- **Testing**: flutter_test
- **Linting**: flutter_lints ^5.0.0

## Project Conventions

### Code Style

- Follow the official Flutter lints package (flutter_lints ^5.0.0)
- Use Dart's recommended formatting (run `dart format .`)
- Naming conventions:
  **MVVM (Model-View-ViewModel)** architecture pattern
- **GetX** for state management across all controllers
- **Repository pattern** for data access abstraction
- **Provider pattern** for external service integration (database, location, weather, analytics)
- StatelessWidget for UI components (Views)
- GetX Controllers (ViewModels) for business logic and state
- Material Design patterns for UI consistency
- Widget composition for building complex UIs from smaller, reusable widgets
- Offline-first data storage with future sync capability
- Always use `const` constructors where possible for performance
- Use named parameters with curly braces for widget constructors

### Architecture Patterns

- StatelessWidget for UI components without state
- StatefulWidget for components requiring state management
- Material Design patterns for UI consistency
- Widget composition for building complex UIs from smaller, reusable widgets
  Journey tracking application focused on:
- **GPS Journey Recording**: Continuous tracking of latitude/longitude points during user journeys
- **Offline-First Design**: All core features work without internet connectivity
- **Journey Metrics**: Time elapsed, distance traveled, average speed, current speed
- **Weather Integration**: Recording weather conditions at journey completion
- **Route Visualization**: Display tracked routes on maps with start/end markers
- **Social Sharing**: Share journey details as screenshots to social media
- **Referral System**: Unique codes for user referrals (offline, future premium sync)
- **Open-Meteo API**: Free weather API for current conditions and temperature
- **OpenStreetMap**: Map tile provider via flutter_map
- **Firebase**: Analytics for user activity tracking
- **Stripe** (future): Payment processing for premium subscriptions
- **Prisma DB** (future): Cloud database for premium sync
- Platform-specific build tools (Gradle for Android, Xcode for iOS/macOS, etc.)
- Location services (GPS) on device
- Unit tests using flutter_test package
- Widget tests for UI components
- Integration tests for end-to-end workflows
- Test files should mirror lib/ structure in test/ directory

### Git Workflow

- Follow conventional commit messages
- Use feature branches for new development
- Keep commits atomic and descriptive

## Domain Context

Currently a minimal Flutter application displaying "Hello World!" - domain knowledge will expand as the application develops.

## Important Constraints

- Minimum Dart SDK: 3.7.2
- No package publishing (publish_to: 'none' in pubspec.yaml)
- Must maintain cross-platform compatibility across all 6 supported platforms

## External Dependencies

- Flutter SDK (includes Material Design components)
- Platform-specific build tools (Gradle for Android, Xcode for iOS/macOS, etc.)
