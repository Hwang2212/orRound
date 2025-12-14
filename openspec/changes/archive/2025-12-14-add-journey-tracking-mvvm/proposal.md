# Change: Add Journey Tracking with MVVM Architecture

## Why

Orround needs core journey tracking functionality to fulfill its purpose as an offline-first journey tracking application. Users need to record their journeys with location data, weather information, and view journey history with detailed analytics. The app must work offline by default, with premium sync features planned for future implementation.

## What Changes

- Add MVVM architecture pattern with GetX for state management, routing, and theming
- Implement offline-first journey tracking with location recording (latitude/longitude points)
- Add home page with user profile header, recent journey history, and current weather display
- Add user profile management with profile and edit profile pages
- Add journey tracking page with real-time metrics (time elapsed, speed, route map)
- Add journey detail page with comprehensive journey information and map visualization
- Implement journey sharing as screenshots via social media
- Add referral system with unique codes (offline implementation, sync deferred)
- Integrate SQLite (sqflite) for offline data storage compatible with future Prisma DB sync
- Integrate Open-Meteo API for weather data
- Integrate OpenStreetMap with flutter_map for map displays
- Add Firebase Analytics for user activity tracking
- Implement minimalistic black-and-white 2-tone UI theme

## Impact

- **Affected specs**: All new capabilities (no existing specs to modify)
  - home-page
  - user-profile
  - journey-tracking
  - journey-detail
  - journey-storage
  - weather-integration
  - map-display
  - sharing
  - referral-system
  - analytics
  - theming
- **Affected code**: Complete app restructure
  - New MVVM folder structure under `lib/`
  - New models, views, viewmodels
  - Database schema and migrations
  - API integrations
  - Theme configuration
- **New dependencies**:
  - GetX (state management, routing, theming, translations)
  - sqflite (offline storage)
  - flutter_map (map display)
  - geocoding, location, latlong2 (location services)
  - open_meteo_api or http (weather API)
  - share_plus (sharing functionality)
  - gal (image processing for screenshots)
  - image_picker (profile picture selection)
  - firebase_core, firebase_analytics (analytics)
  - Stripe-related packages (for future premium features)

## Migration Path

This is a greenfield implementation on a new Flutter project. No migration needed.

## Related Changes

None (first major feature implementation)
