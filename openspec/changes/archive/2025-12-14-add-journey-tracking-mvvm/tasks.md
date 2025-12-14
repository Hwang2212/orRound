# Implementation Tasks

## 1. Project Setup and Dependencies

- [ ] Update pubspec.yaml with all required dependencies:
  - [ ] Add get: ^4.6.6 (state management, routing, theming)
  - [ ] Add sqflite: ^2.3.0 (local database)
  - [ ] Add path: ^1.8.3 (database path helper)
  - [ ] Add flutter_map: ^6.1.0 (map display)
  - [ ] Add latlong2: ^0.9.0 (coordinates)
  - [ ] Add location: ^5.0.0 (GPS tracking)
  - [ ] Add geocoding: ^2.1.1 (geocoding services)
  - [ ] Add http: ^1.1.0 (HTTP client for weather API)
  - [ ] Add share_plus: ^7.2.1 (sharing functionality)
  - [ ] Add gal: ^2.1.3 (gallery/photo library)
  - [ ] Add firebase_core: ^2.24.2 (Firebase initialization)
  - [ ] Add firebase_analytics: ^10.8.0 (analytics)
  - [ ] Add uuid: ^4.0.0 (unique ID generation)
  - [ ] Add image_picker: ^1.0.7 (profile picture selection)
- [ ] Run `flutter pub get` to install dependencies
- [ ] Configure Firebase for iOS and Android:
  - [ ] Create Firebase project in console
  - [ ] Download google-services.json (Android) to android/app/
  - [ ] Download GoogleService-Info.plist (iOS) to ios/Runner/
  - [ ] Update android/build.gradle.kts with Firebase classpath
  - [ ] Update android/app/build.gradle.kts with Firebase plugin
- [ ] Update platform-specific configurations:
  - [ ] Add location permissions to AndroidManifest.xml
  - [ ] Add location permissions to Info.plist (iOS)
  - [ ] Add camera permissions to Info.plist (iOS)
  - [ ] Add photo library permissions to AndroidManifest.xml (Android 13+)
  - [ ] Add camera permissions to AndroidManifest.xml
  - [ ] Add photo library permissions to Info.plist (iOS)
  - [ ] Enable background location for iOS (Info.plist)

## 2. MVVM Architecture Setup

- [ ] Create folder structure:
  - [ ] Create lib/app/ directory
  - [ ] Create lib/app/config/ for app configuration
  - [ ] Create lib/app/data/ for data layer
  - [ ] Create lib/app/data/models/ for data models
  - [ ] Create lib/app/data/repositories/ for repositories
  - [ ] Create lib/app/data/providers/ for data providers
  - [ ] Create lib/app/modules/ for feature modules
- [ ] Configure GetX:
  - [ ] Create lib/app/config/routes.dart with route definitions
  - [ ] Create lib/app/config/theme.dart with light/dark themes
  - [ ] Create lib/app/config/translations.dart (optional, for future i18n)
  - [ ] Update main.dart to use GetMaterialApp with themes and routes

## 3. Theme Implementation

- [ ] Implement minimalistic black & white theme in lib/app/config/theme.dart:
  - [ ] Define light theme (white background, black text/primary)
  - [ ] Define dark theme (black background, white text/primary)
  - [ ] Configure typography with sans-serif fonts
  - [ ] Style buttons with sharp corners and minimal elevation
  - [ ] Style cards with borders and zero elevation
  - [ ] Style input fields with outline borders
  - [ ] Configure icon theme (monochrome)
  - [ ] Set app bar theme
  - [ ] Configure color scheme for both themes
- [ ] Test theme switching between light and dark modes
- [ ] Verify accessibility contrast ratios (7:1 minimum)

## 4. Database Layer (SQLite with sqflite)

- [ ] Create lib/app/data/providers/database_provider.dart:
  - [ ] Initialize sqflite database
  - [ ] Define database name and version
  - [ ] Create journeys table schema
  - [ ] Create location_points table schema with foreign key
  - [ ] Create user_profile table schema
  - [ ] Add fields: name, email, profile_picture_path
  - [ ] Add fields: referral_code, referred_by_code
  - [ ] Add sync fields: is_synced, server_id, updated_at
  - [ ] Create referrals table schema
  - [ ] Add indexes on journey_id, timestamp, created_at
  - [ ] Implement database migration logic
  - [ ] Add error handling for database operations
- [ ] Test database initialization on first app launch
- [ ] Verify foreign key constraints and cascading deletes

## 5. Data Models

- [ ] Create lib/app/data/models/journey.dart:
  - [ ] Define Journey model with all fields (id, startTime, endTime, etc.)
  - [ ] Add toMap() method for database serialization
  - [ ] Add fromMap() factory constructor for deserialization
  - [ ] Add validation logic
- [ ] Create lib/app/data/models/location_point.dart:
  - [ ] Define LocationPoint model (id, journeyId, lat, lng, speed, timestamp)
  - [ ] Add toMap() and fromMap() methods
  - [ ] Add toLatLng() method for flutter_map integration
- [ ] Create lib/app/data/models/weather_data.dart:
  - [ ] Define WeatherData model (temperature, condition, code)
  - [ ] Add fromJson() factory for API response parsing
  - [ ] Add weather code to condition text mapping
- [ ] Create lib/app/data/models/user_profile.dart:
  - [ ] Define UserProfile model (id, name, email, profilePicturePath, referralCode, referredByCode)
  - [ ] Add toMap() and fromMap() methods
  - [ ] Add validation methods for name and email
  - [ ] Add fields for sync tracking (isSynced, serverId, updatedAt)

## 6. Repositories

- [ ] Create lib/app/data/repositories/journey_repository.dart:
  - [ ] Implement saveJourney() method
  - [ ] Implement getRecentJourneys(limit) method
  - [ ] Implement getJourneyById(id) method with location points
  - [ ] Implement getJourneyCount() method
  - [ ] Add error handling and logging
- [ ] Create lib/app/data/repositories/location_repository.dart:
  - [ ] Implement saveLocationPoint() method
  - [ ] Implement getLocationPointsForJourney(journeyId) method
  - [ ] Add batch insert for multiple points
- [ ] Create lib/app/data/repositories/user_repository.dart:
  - [ ] Implement getUserProfile() method
  - [ ] Implement createUserProfile(referralCode, name) method
  - [ ] Implement updateUserProfile(name, email, picturePath) method
  - [ ] Implement updateReferredByCode(code) method
  - [ ] Implement getReferralCode() method
  - [ ] Implement checkIfReferralUsed() method
  - [ ] Add name and email validation methods
- [ ] Create lib/app/data/repositories/weather_repository.dart:
  - [ ] Implement getCurrentWeather(lat, lng) method
  - [ ] Add caching logic (30-minute expiry)
  - [ ] Add offline handling
- [ ] Create lib/app/data/repositories/analytics_repository.dart:
  - [ ] Implement wrapper methods for Firebase Analytics events
  - [ ] Add logJourneyStarted(), logJourneyEnded(), etc.
  - [ ] Add user property setters

## 7. Location Provider

- [ ] Create lib/app/data/providers/location_provider.dart:
  - [ ] Initialize location package
  - [ ] Implement requestPermissions() method
  - [ ] Implement checkPermissions() method
  - [ ] Implement getCurrentLocation() method
  - [ ] Implement startLocationStream() for continuous tracking
  - [ ] Configure location accuracy and update intervals
  - [ ] Handle permission denied scenarios
  - [ ] Add background location support

## 8. Weather API Provider

- [ ] Create lib/app/data/providers/weather_api_provider.dart:
  - [ ] Implement fetchCurrentWeather(lat, lng) method
  - [ ] Build Open-Meteo API URL with parameters
  - [ ] Make HTTP GET request with timeout (10 seconds)
  - [ ] Parse JSON response
  - [ ] Handle API errors and timeouts
  - [ ] Return WeatherData model or null
- [ ] Test API integration with sample coordinates
- [ ] Verify error handling for offline scenarios

## 9. Firebase Analytics Provider

- [ ] Create lib/app/data/providers/analytics_provider.dart:
  - [ ] Initialize Firebase Analytics
  - [ ] Create wrapper methods for event logging
  - [ ] Implement custom event methods (journey_started, etc.)
  - [ ] Add parameter validation
  - [ ] Handle offline event queuing
- [ ] Update main.dart to initialize Firebase on app start
- [ ] Test analytics events in Firebase console debug view

## 10. Home Module

- [ ] Create lib/app/modules/home/ structure:
  - [ ] Create views/home_view.dart
  - [ ] Create controllers/home_controller.dart
  - [ ] Create bindings/home_binding.dart
- [ ] Implement HomeController:
  - [ ] Load user profile and display name in header
  - [ ] Load recent journeys from repository
  - [ ] Fetch current weather based on location
  - [ ] Handle weather caching
  - [ ] Implement navigation to journey tracking
  - [ ] Implement navigation to journey detail
  - [ ] Implement navigation to profile page
  - [ ] Implement navigation to referral pages
  - [ ] Add error handling for location/weather failures
- [ ] Implement HomeView:
  - [ ] Display header with user name/greeting and profile avatar
  - [ ] Make header tappable to navigate to profile
  - [ ] Display app title/logo
  - [ ] Show current weather widget (temp, condition)
  - [ ] Show "Start Journey" button (prominent, centered)
  - [ ] Display recent journeys list (scrollable)
  - [ ] Show journey items (date, duration, distance)
  - [ ] Handle empty state (no journeys)
  - [ ] Add loading indicators
  - [ ] Add navigation menu/drawer for referral access
- [ ] Test home page functionality
- [ ] Verify weather updates every 30 minutes
- [ ] Verify header displays user name correctly

## 11. Journey Tracking Module

- [ ] Create lib/app/modules/journey_tracking/ structure:
  - [ ] Create views/tracking_view.dart
  - [ ] Create views/tracking_map_view.dart
  - [ ] Create controllers/tracking_controller.dart
  - [ ] Create bindings/tracking_binding.dart
- [ ] Implement TrackingController:
  - [ ] Initialize location tracking on journey start
  - [ ] Start timer for elapsed time
  - [ ] Subscribe to location stream
  - [ ] Record location points to database
  - [ ] Calculate current speed from GPS data
  - [ ] Calculate cumulative distance using Haversine formula
  - [ ] Implement pause/resume functionality
  - [ ] Implement end journey with confirmation dialog
  - [ ] Fetch weather on journey end
  - [ ] Calculate final statistics (avg speed, total distance)
  - [ ] Save journey to database
  - [ ] Navigate to journey detail on end
  - [ ] Handle GPS signal loss
  - [ ] Support background tracking
  - [ ] Log analytics events (started, paused, ended)
- [ ] Implement TrackingView (timer view):
  - [ ] Display elapsed time in HH:MM:SS format
  - [ ] Display current speed in km/h
  - [ ] Display current distance
  - [ ] Show "Switch to Map" button
  - [ ] Show "Pause" and "End Journey" buttons
  - [ ] Add GPS signal indicator
  - [ ] Update UI every second
- [ ] Implement TrackingMapView:
  - [ ] Initialize flutter_map with OSM tiles
  - [ ] Display current location marker (blue dot)
  - [ ] Draw polyline of recorded route
  - [ ] Auto-pan to follow user location
  - [ ] Show zoom controls
  - [ ] Show "Switch to Timer" button
  - [ ] Optimize rendering for long routes
- [ ] Test journey tracking end-to-end
- [ ] Verify background tracking works when app is backgrounded
- [ ] Test offline journey recording

## 12. Journey Detail Module

- [ ] Create lib/app/modules/journey_detail/ structure:
  - [ ] Create views/detail_view.dart
  - [ ] Create controllers/detail_controller.dart
  - [ ] Create bindings/detail_binding.dart
- [ ] Implement DetailController:
  - [ ] Load journey by ID from repository
  - [ ] Load location points for route
  - [ ] Format journey data for display
  - [ ] Implement screenshot capture logic using RepaintBoundary
  - [ ] Implement save to gallery using gal package
  - [ ] Implement share using share_plus package
  - [ ] Log analytics events (journey_viewed, journey_shared)
  - [ ] Handle permission requests for photo library
- [ ] Implement DetailView:
  - [ ] Display journey date and time
  - [ ] Display elapsed time (formatted)
  - [ ] Display total distance
  - [ ] Display average speed
  - [ ] Display weather and temperature (or "unavailable")
  - [ ] Render route map with flutter_map
  - [ ] Draw polyline connecting all points
  - [ ] Add start (green) and end (red) markers
  - [ ] Auto-fit map bounds to route
  - [ ] Add share button in app bar
  - [ ] Wrap shareable content in RepaintBoundary
  - [ ] Add back navigation
  - [ ] Handle loading states
- [ ] Test journey detail display with various journey types
- [ ] Test share functionality (screenshot + share sheet)
- [ ] Verify map displays complete route correctly

## 13. Profile Module

- [ ] Create lib/app/modules/profile/ structure:
  - [ ] Create views/profile_view.dart
  - [ ] Create views/edit_profile_view.dart
  - [ ] Create controllers/profile_controller.dart
  - [ ] Create bindings/profile_binding.dart
- [ ] Implement ProfileController:
  - [ ] Load user profile from repository
  - [ ] Implement navigation to edit profile
  - [ ] Handle profile picture display
  - [ ] Implement default avatar generation (first letter of name)
  - [ ] Implement updateProfile(name, email, picturePath) method
  - [ ] Implement selectProfilePicture() method (camera or gallery)
  - [ ] Implement removeProfilePicture() method
  - [ ] Handle image picker permissions
  - [ ] Compress selected images to under 500KB
  - [ ] Crop images to square format
  - [ ] Validate name (2-50 characters, letters/spaces/hyphens/apostrophes)
  - [ ] Validate email (RFC 5322 format, optional)
  - [ ] Save profile updates to database
  - [ ] Log analytics events (profile_viewed, profile_updated, profile_picture_updated)
- [ ] Implement ProfileView:
  - [ ] Display user name (or "Traveler" if not set)
  - [ ] Display email (or placeholder if not set)
  - [ ] Display profile picture or default avatar
  - [ ] Display referral code
  - [ ] Display account creation date
  - [ ] Add "Edit Profile" button
  - [ ] Handle loading states
  - [ ] Show "Complete your profile" message if incomplete
- [ ] Implement EditProfileView:
  - [ ] Display text input for name (pre-filled)
  - [ ] Display text input for email (pre-filled)
  - [ ] Display profile picture with edit/remove options
  - [ ] Add "Take Photo" and "Choose from Gallery" options
  - [ ] Show image crop interface for selected photos
  - [ ] Display validation errors in real-time
  - [ ] Add "Save" and "Cancel" buttons
  - [ ] Show discard changes confirmation dialog on cancel
  - [ ] Display success message on save
  - [ ] Navigate back to profile page on save
- [ ] Test profile display and editing
- [ ] Test profile picture selection from camera
- [ ] Test profile picture selection from gallery
- [ ] Test image compression and cropping
- [ ] Test validation for name and email
- [ ] Verify profile updates persist across app restarts
- [ ] Test navigation from home header to profile

## 14. Referral Module

- [ ] Create lib/app/modules/referral/ structure:
  - [ ] Create views/my_referral_view.dart
  - [ ] Create views/enter_referral_view.dart
  - [ ] Create controllers/referral_controller.dart
  - [ ] Create bindings/referral_binding.dart
- [ ] Implement ReferralController:
  - [ ] Load or generate user's referral code on init
  - [ ] Implement copyToClipboard() method
  - [ ] Implement validateReferralCode() method
  - [ ] Implement submitReferralCode() method
  - [ ] Check if user already used a referral code
  - [ ] Prevent self-referral
  - [ ] Save referral data to database
  - [ ] Log analytics events
- [ ] Implement MyReferralView:
  - [ ] Display user's referral code in large text
  - [ ] Use monospace font for code
  - [ ] Add "Copy Code" button
  - [ ] Show copy confirmation message
  - [ ] Add instructions text
  - [ ] Style with minimalistic theme
- [ ] Implement EnterReferralView:
  - [ ] Display text input for code entry
  - [ ] Auto-convert input to uppercase
  - [ ] Validate format (6 alphanumeric)
  - [ ] Show error messages for invalid format
  - [ ] Disable if code already used
  - [ ] Show submit button
  - [ ] Display success message on submission
  - [ ] Navigate back to home on success
- [ ] Test referral code generation
- [ ] Test code entry and validation
- [ ] Test self-referral prevention

## 15. Route Configuration

- [ ] Update lib/app/config/routes.dart:
  - [ ] Define route names as constants
  - [ ] Configure route for home page
  - [ ] Configure route for profile page
  - [ ] Configure route for edit profile page
  - [ ] Configure route for journey tracking
  - [ ] Configure route for journey detail (with parameter)
  - [ ] Configure route for my referral
  - [ ] Configure route for enter referral
  - [ ] Set home as initial route
  - [ ] Add bindings for each route
- [ ] Test navigation between all pages
- [ ] Verify route parameters work correctly (journey ID)

## 16. User Profile Initialization

- [ ] Update main.dart or create app initialization:
  - [ ] Check if user profile exists on app launch
  - [ ] Generate unique 6-character referral code if needed
  - [ ] Save user profile to database with default values
  - [ ] Ensure code is alphanumeric uppercase
  - [ ] Log analytics event for code generation

## 17. Testing and Edge Cases

- [ ] Test location permission flows:
  - [ ] Permission granted
  - [ ] Permission denied
  - [ ] Permission permanently denied
- [ ] Test GPS scenarios:
  - [ ] Normal tracking
  - [ ] Signal loss during journey
  - [ ] Indoor tracking (weak signal)
- [ ] Test offline scenarios:
  - [ ] Journey tracking offline
  - [ ] Weather unavailable
  - [ ] Map tiles from cache
- [ ] Test database scenarios:
  - [ ] First launch (schema creation)
  - [ ] App upgrade (migration - future)
  - [ ] Storage full
- [ ] Test journey edge cases:
  - [ ] Very short journey (< 1 minute)
  - [ ] Very long journey (> 1 hour)
  - [ ] Journey with few points
  - [ ] Journey with 1000+ points
- [ ] Test sharing:
  - [ ] Screenshot quality
  - [ ] Save to gallery
  - [ ] Share to various apps
  - [ ] Permission denied
- [ ] Test referral system:
  - [ ] Code generation uniqueness
  - [ ] Code entry validation
  - [ ] Self-referral prevention
  - [ ] Already used code prevention
- [ ] Test profile management:
  - [ ] Profile creation on first launch
  - [ ] Name and email validation
  - [ ] Profile picture selection (camera)
  - [ ] Profile picture selection (gallery)
  - [ ] Image compression and cropping
  - [ ] Profile updates persist
  - [ ] Default avatar generation
  - [ ] Navigation from home header

## 18. Performance Optimization

- [ ] Optimize location tracking:
  - [ ] Configure update interval based on speed
  - [ ] Batch database inserts for location points
- [ ] Optimize map rendering:
  - [ ] Simplify polylines with 1000+ points
  - [ ] Lazy load journey maps
  - [ ] Cache map tiles
- [ ] Optimize database queries:
  - [ ] Verify indexes are used
  - [ ] Limit query results appropriately
  - [ ] Use transactions for batch operations
- [ ] Test app performance:
  - [ ] Measure FPS during tracking
  - [ ] Check memory usage
  - [ ] Profile database operations

## 19. Analytics Verification

- [ ] Verify all analytics events are logging:
  - [ ] app_launched
  - [ ] journey_started, journey_paused, journey_ended
  - [ ] journey_viewed, journey_shared
  - [ ] map_viewed, weather_fetched
  - [ ] profile_viewed, profile_updated, profile_picture_updated
  - [ ] referral_code_generated, referral_code_entered
  - [ ] Error events (location_error, database_error, api_error)
- [ ] Verify user properties are set correctly
- [ ] Test analytics in Firebase console
- [ ] Verify event parameters are included

## 20. UI/UX Polish

- [ ] Ensure consistent spacing (8px multiples)
- [ ] Verify all fonts and sizes match theme
- [ ] Add loading indicators for async operations
- [ ] Add error messages for failures
- [ ] Implement confirmation dialogs where needed
- [ ] Add haptic feedback for button presses (optional)
- [ ] Verify touch targets are at least 44x44 points
- [ ] Test on both light and dark themes
- [ ] Verify accessibility (contrast, semantics)
- [ ] Test profile header displays correctly in all states
- [ ] Verify default avatar generation looks good

## 21. Platform-Specific Testing

- [ ] Test on iOS:
  - [ ] Location permissions
  - [ ] Background location
  - [ ] Photo library permissions
  - [ ] Camera permissions
  - [ ] Share sheet
  - [ ] Theme appearance
  - [ ] Profile picture selection
- [ ] Test on Android:
  - [ ] Location permissions
  - [ ] Background location
  - [ ] Storage permissions
  - [ ] Camera permissions
  - [ ] Share sheet
  - [ ] Notification for background tracking
  - [ ] Theme appearance
  - [ ] Profile picture selection

## 22. Documentation

- [ ] Update README.md with:
  - [ ] Project description
  - [ ] Features list
  - [ ] Setup instructions
  - [ ] Firebase configuration steps
  - [ ] Dependencies explanation
- [ ] Add code comments for complex logic
- [ ] Document database schema
- [ ] Document API integrations

## 23. Final Validation

- [ ] Run `flutter analyze` and fix any issues
- [ ] Run `flutter test` for any unit tests
- [ ] Test complete user flow end-to-end:
  - [ ] First app launch → profile creation → code generation
  - [ ] Set up profile (name, picture)
  - [ ] Start journey → track → end → view details
  - [ ] Share journey
  - [ ] Enter referral code
  - [ ] View home with journey history and profile header
  - [ ] Edit profile and verify updates
- [ ] Verify app works completely offline
- [ ] Test app on multiple devices (iOS and Android)
- [ ] Verify Firebase Analytics data appears in console
- [ ] Verify database persists correctly across app restarts

## Dependencies Between Tasks

- Tasks 1-2 must be completed first (setup)
- Task 3 (theme) can be done in parallel with data layer
- Tasks 4-9 (data layer) should be completed before modules
- Tasks 10-14 (modules) depend on data layer
- Task 13 (profile module) should include user_repository from task 6
- Task 15 (routing) should be done after modules are created
- Task 16 (user profile init) should be done after user_repository exists
- Tasks 17-23 (testing/polish) should be done after core features
