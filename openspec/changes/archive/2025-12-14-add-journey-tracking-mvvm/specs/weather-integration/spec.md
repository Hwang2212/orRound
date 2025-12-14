# Spec: Weather Integration

## ADDED Requirements

### Requirement: Open-Meteo API Integration

The system SHALL integrate with Open-Meteo API for weather data retrieval.

#### Scenario: Fetch Current Weather

- **GIVEN** internet connectivity is available
- **AND** user location is known
- **WHEN** the system requests current weather
- **THEN** an HTTP GET request is made to `https://api.open-meteo.com/v1/forecast`
- **AND** request includes latitude, longitude, and current weather parameters
- **AND** response is parsed to extract temperature_2m and weather_code
- **AND** temperature is converted to user's preferred unit (Celsius by default)

#### Scenario: Handle API Timeout

- **GIVEN** a weather API request is in progress
- **WHEN** the request exceeds 10 seconds
- **THEN** the system cancels the request
- **AND** retries once with a 5-second timeout
- **AND** if retry fails, returns null weather data
- **AND** logs timeout event to analytics

#### Scenario: Handle Invalid API Response

- **GIVEN** weather API returns a response
- **WHEN** the response status is not 200 OK
- **OR** response JSON is malformed
- **THEN** the system logs error to analytics
- **AND** returns null weather data
- **AND** does not crash or block user actions

### Requirement: Weather Data Caching

The system SHALL cache weather data to reduce API calls and support offline display.

#### Scenario: Cache Current Weather

- **GIVEN** current weather is successfully fetched
- **WHEN** the weather data is received
- **THEN** the system stores weather data in memory cache
- **AND** associates cache with location coordinates
- **AND** stores cache timestamp
- **AND** cache expires after 30 minutes

#### Scenario: Serve Cached Weather

- **GIVEN** cached weather data exists for current location
- **AND** cache is less than 30 minutes old
- **WHEN** the home page requests current weather
- **THEN** the system returns cached data without API call
- **AND** displays "Updated X minutes ago" indicator

### Requirement: Weather Display Formatting

The system SHALL format weather data for user-friendly display.

#### Scenario: Format Temperature

- **GIVEN** weather data is available
- **WHEN** displaying temperature
- **THEN** temperature is shown as integer with degree symbol (e.g., "22°C")
- **AND** rounds to nearest whole number

#### Scenario: Format Weather Condition

- **GIVEN** weather code is received from API
- **WHEN** displaying weather condition
- **THEN** the system maps weather code to human-readable text:
  - 0: Clear sky
  - 1-3: Partly cloudy
  - 45, 48: Fog
  - 51-67: Rain
  - 71-77: Snow
  - 80-99: Thunderstorm
- **AND** displays appropriate text instead of numeric code

### Requirement: Offline Weather Handling

The system SHALL gracefully handle weather requests when offline.

#### Scenario: Request Weather Offline

- **GIVEN** no internet connectivity
- **WHEN** the system attempts to fetch weather
- **THEN** network request fails immediately
- **AND** system checks for cached weather data
- **AND** if cache exists, displays cached data with "Offline" indicator
- **AND** if no cache, displays "Weather unavailable"

### Requirement: Journey Weather Recording

The system SHALL associate weather data with journey records.

#### Scenario: Record Weather with Journey

- **GIVEN** a journey is ending
- **AND** internet connectivity is available
- **WHEN** saving the journey
- **THEN** the system fetches weather for journey end location
- **AND** stores weather_condition and temperature in journey record
- **AND** journey is saved even if weather fetch fails

### Requirement: Location-Based Weather

The system SHALL request weather for accurate user location.

#### Scenario: Use Current GPS Location

- **GIVEN** location permissions are granted
- **WHEN** requesting weather data
- **THEN** the system uses current GPS coordinates
- **AND** requests weather for those specific coordinates
- **AND** coordinates are accurate to at least 2 decimal places

#### Scenario: Use Journey End Location for Recording

- **GIVEN** a journey has ended
- **WHEN** recording weather with journey
- **THEN** the system uses the last recorded location point
- **AND** fetches weather for that location
- **AND** stores weather at journey completion time
