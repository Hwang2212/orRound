# Design: Journey Tracking MVVM Architecture

## Architecture Overview

### MVVM Pattern with GetX

- **Model**: Data classes representing journeys, locations, weather, etc.
- **View**: Flutter widgets for UI presentation
- **ViewModel**: GetX controllers managing state and business logic

### Folder Structure

```
lib/
├── main.dart
├── app/
│   ├── config/
│   │   ├── routes.dart          # GetX route definitions
│   │   ├── theme.dart           # Black & white theme
│   │   └── translations.dart    # i18n setup
│   ├── data/
│   │   ├── models/
│   │   │   ├── journey.dart
│   │   │   ├── location_point.dart
│   │   │   ├── weather_data.dart
│   │   │   └── user_profile.dart
│   │   ├── repositories/
│   │   │   ├── journey_repository.dart
│   │   │   ├── user_repository.dart
│   │   │   ├── weather_repository.dart
│   │   │   └── analytics_repository.dart
│   │   └── providers/
│   │       ├── database_provider.dart    # sqflite setup
│   │       ├── location_provider.dart
│   │       └── weather_api_provider.dart
│   └── modules/
│       ├── home/
│       │   ├── views/
│       │   │   └── home_view.dart
│       │   ├── controllers/
│       │   │   └── home_controller.dart
│       │   └── bindings/
│       │       └── home_binding.dart
│       ├── journey_tracking/
│       │   ├── views/
│       │   │   ├── tracking_view.dart
│       │   │   └── tracking_map_view.dart
│       │   └── controllers/
│       │       └── tracking_controller.dart
│       ├── journey_detail/
│       │   ├── views/
│       │   │   └── detail_view.dart
│       │   └── controllers/
│       │       └── detail_controller.dart
│       └── referral/
│           ├── views/
│           │   ├── my_referral_view.dart
│           │   └── enter_referral_view.dart
│           └── controllers/
│               └── referral_controller.dart
```

## Data Storage Design

### SQLite Schema (sqflite)

```sql
-- Journeys table
CREATE TABLE journeys (
  id TEXT PRIMARY KEY,
  start_time INTEGER NOT NULL,
  end_time INTEGER,
  total_distance REAL DEFAULT 0,
  average_speed REAL DEFAULT 0,
  weather_condition TEXT,
  temperature REAL,
  is_synced INTEGER DEFAULT 0,
  created_at INTEGER NOT NULL
);

-- Location points table
CREATE TABLE location_points (
  id TEXT PRIMARY KEY,
  journey_id TEXT NOT NULL,
  latitude REAL NOT NULL,
  longitude REAL NOT NULL,
  speed REAL,
  timestamp INTEGER NOT NULL,
  FOREIGN KEY (journey_id) REFERENCES journeys(id) ON DELETE CASCADE
);

-- User profile table (for referral codes)
CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  name TEXT,
  email TEXT,
  profile_picture_path TEXT,
  referral_code TEXT UNIQUE NOT NULL,
  referred_by_code TEXT,
  is_synced INTEGER DEFAULT 0,
  server_id TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

-- Referrals table (track who used the code)
CREATE TABLE referrals (
  id TEXT PRIMARY KEY,
  referral_code TEXT NOT NULL,
  used_at INTEGER NOT NULL
);
```

**Design Rationale:**

- SQLite structure mirrors potential Prisma schema for easy sync
- Timestamps stored as Unix epoch integers for cross-platform compatibility
- Foreign keys ensure data integrity
- `is_synced` flag tracks which journeys need cloud sync (future premium feature)

## Location Tracking Design

### Strategy

- Use `location` package with background location tracking
- Record points at configurable intervals (e.g., every 5 seconds or 10 meters)
- Calculate distance using Haversine formula (latlong2 package)
- Store raw lat/lng points for accuracy, calculate metrics in aggregate

### Edge Cases

- **No GPS signal**: Display warning, cache last known location, attempt to resume when signal returns
- **Battery optimization**: Provide user setting for tracking frequency
- **App backgrounded**: Use background location service (platform-specific permissions)
- **Storage full**: Warn user, prevent new journey starts

## Weather Integration

### Open-Meteo API

- Free API, no authentication required
- Endpoints:
  - Current weather: `https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m,weather_code`
  - Historical weather: For journey start time correlation
- Cache weather data with journey records
- Handle offline gracefully: Display "Weather unavailable" if no connection

### Edge Cases

- **No internet**: Skip weather recording, allow journey to continue
- **API timeout**: Retry once, then proceed without weather data
- **Invalid response**: Log error to analytics, continue without weather

## Map Display

### flutter_map with OpenStreetMap

- Tile source: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
- Cache tiles locally for offline viewing of previously viewed areas
- Display user's current location with blue dot
- Draw polyline for journey route using recorded points
- Zoom controls and pan gestures

### Performance

- Limit points rendered (simplify polyline if >1000 points)
- Lazy load historical journey maps
- Use `InteractiveFlag` to disable interactions during active tracking for performance

## Sharing Design

### Screenshot Workflow

1. User taps "Share" on journey detail page
2. Render detail view (stats + map) as image using `RepaintBoundary`
3. Save image to gallery using `gal` package
4. Open share sheet using `share_plus` with image attachment
5. User selects platform (WhatsApp, Instagram, etc.)

### Analytics Events

- Track share initiation
- Track share completion
- Track platform selected (if available from share_plus callback)

## Referral System

### Offline-First Implementation

- Generate unique 6-character alphanumeric code on first app launch
- Store in `user_profile` table
- Display on "My Referral" page with QR code (optional enhancement)
- "Enter Referral" page validates format only (no server validation yet)
- Store entered codes locally in `referrals` table
- Future premium feature: Sync to server and unlock rewards

## Theme Design

### Minimalistic Black & White

```dart
ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.grey[800],
    surface: Colors.white,
    background: Colors.white,
  ),
  textTheme: TextTheme(
    // All black text on white background
  ),
  iconTheme: IconThemeData(color: Colors.black),
  // Minimal elevation, sharp corners
  cardTheme: CardTheme(elevation: 0, shape: RoundedRectangleBorder()),
)
```

Dark mode variant: Invert colors (white on black)

## Analytics Design

### Firebase Analytics Events

- App launched
- Journey started
- Journey paused
- Journey ended
- Journey viewed (detail page)
- Journey shared
- Referral code generated
- Referral code entered
- Map viewed
- Weather data fetched

### Parameters

- Journey duration
- Distance traveled
- Average speed
- Weather conditions (when available)

## Error Handling

### Location Permissions

- Request permissions on first journey start
- If denied: Show in-app explanation and link to settings
- If permanently denied: Disable tracking feature

### Offline Handling

- Queue weather API calls for retry when online
- Display cached data when offline
- Show connection status indicator

### Database Errors

- Log to analytics
- Display user-friendly error message
- Provide "Retry" option
- Clear corrupted data if necessary (with user confirmation)

## Performance Considerations

1. **Location tracking**: Optimize interval based on speed (slower = less frequent updates)
2. **Map rendering**: Virtualize polyline points, render only visible segments
3. **Database**: Index on `journey_id`, `timestamp`, `created_at`
4. **Weather API**: Debounce calls, cache responses for 30 minutes
5. **Analytics**: Batch events, send on app background/close

## Future Considerations

### User Profile Management

**Folder Structure Addition:**

```
└── modules/
    └── profile/
        ├── views/
        │   ├── profile_view.dart
        │   └── edit_profile_view.dart
        └── controllers/
            └── profile_controller.dart
```

**Database Schema Update:**

```sql
-- Extended user profile table
CREATE TABLE user_profile (
  id INTEGER PRIMARY KEY CHECK (id = 1),
  name TEXT,
  email TEXT,
  profile_picture_path TEXT,
  referral_code TEXT UNIQUE NOT NULL,
  referred_by_code TEXT,
  is_synced INTEGER DEFAULT 0,
  server_id TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);
```

**Design Decisions:**

- Profile pictures stored locally as files with paths in database
- Image compression to max 500KB for efficient storage
- Square crop format for consistent display
- Default avatar uses first letter of user's name
- Name validation: 2-50 characters, letters/spaces/hyphens/apostrophes
- Email validation: standard RFC 5322 format, optional field
- Profile changes set `is_synced=0` for future cloud sync
- Use image_picker package for camera/gallery integration

### Premium Sync Feature

- REST API endpoints for Prisma DB
- Authentication (Firebase Auth or JWT)
- Conflict resolution (last-write-wins vs server-wins)
- Delta sync (only new/modified journeys)
- Stripe subscription management
- User profile sync with server

### Deferred Features

- Journey editing/deletion (add later)
- Export journeys as GPX/KML
- Journey statistics dashboard
- Social features (leaderboards, challenges)
- Multi-language support (GetX translations ready)
