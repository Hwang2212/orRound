# Add Export & Backup

## Phase

**Phase 2** - Premium Feature

## Why

Power users want control over their data. The ability to export journeys ensures:

- Data portability (use in other apps like Strava, Google Maps)
- Personal backup for data safety
- Sharing detailed route data with others
- Compliance with data ownership expectations
- Premium value differentiation

## What Changes

- **NEW**: Export individual journey as GPX file
- **NEW**: Export individual journey as KML file
- **NEW**: Bulk export all journeys as JSON
- **NEW**: Manual backup to device storage
- **NEW**: Import journeys from GPX files
- **NEW**: Export/backup options in settings
- **MODIFIED**: Journey detail page with export button
- **MODIFIED**: Profile/settings with backup options

## Impact

- Affected specs: `journey-detail` (MODIFIED), `user-profile` (MODIFIED), new spec `data-export`
- Affected code:
  - New utility: `lib/app/utils/gpx_exporter.dart`
  - New utility: `lib/app/utils/kml_exporter.dart`
  - `lib/app/modules/journey_detail/`
  - `lib/app/modules/profile/`

## User Experience

- **Positive**: Full control over personal data
- **Positive**: Interoperability with other apps
- **Positive**: Peace of mind with backups
- **Consideration**: Premium feature requires subscription

## Implementation Approach

1. Create GPX generator utility (XML format)
2. Create KML generator utility (Google Earth format)
3. Create JSON bulk exporter
4. Add export button to journey detail
5. Add backup/export section in settings
6. Use share_plus for sharing exported files
7. Implement GPX import parser

## Acceptance Criteria

1. Premium users can export journey as GPX
2. Premium users can export journey as KML
3. Exported files open correctly in other apps
4. Bulk export creates ZIP with all journeys
5. Backup saves to device Downloads folder
6. GPX import creates new journey with points
7. Free users see premium upsell on export
