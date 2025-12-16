# Tasks: Add Export & Backup

## 1. Export Utilities

- [ ] Create `GpxExporter` in `lib/app/utils/gpx_exporter.dart`
  - [ ] Add `generateGpx(Journey, List<LocationPoint>)` method
  - [ ] Follow GPX 1.1 schema
  - [ ] Include metadata, track, track points
- [ ] Create `KmlExporter` in `lib/app/utils/kml_exporter.dart`
  - [ ] Add `generateKml(Journey, List<LocationPoint>)` method
  - [ ] Include LineString geometry
  - [ ] Include start/end placemarks
- [ ] Create `JsonExporter` in `lib/app/utils/json_exporter.dart`
  - [ ] Add `exportAllJourneys(List<Journey>)` method
  - [ ] Include all journey data and location points

## 2. Import Utilities

- [ ] Create `GpxImporter` in `lib/app/utils/gpx_importer.dart`
  - [ ] Add `parseGpx(String content)` method
  - [ ] Extract track points with coordinates and timestamps
  - [ ] Return Journey and LocationPoint list
- [ ] Add file_picker package to pubspec.yaml

## 3. Journey Detail Export

- [ ] Update `JourneyDetailController`
  - [ ] Add `exportAsGpx()` method
  - [ ] Add `exportAsKml()` method
  - [ ] Check premium status before export
- [ ] Update `JourneyDetailView`
  - [ ] Add export button (share icon or menu)
  - [ ] Show export format options (GPX, KML)
  - [ ] Show premium upsell for free users

## 4. Settings/Profile Export & Backup

- [ ] Update `ProfileController` or create `BackupController`
  - [ ] Add `exportAllJourneys()` method
  - [ ] Add `createBackup()` method
  - [ ] Add `restoreBackup(File)` method
  - [ ] Add `importGpx(File)` method
- [ ] Update `ProfileView` or create settings page
  - [ ] Add "Export & Backup" section
  - [ ] Add "Export All Journeys" button
  - [ ] Add "Backup Data" button
  - [ ] Add "Restore Backup" button
  - [ ] Add "Import GPX" button

## 5. File Handling

- [ ] Create file save utility
  - [ ] Save to temporary directory
  - [ ] Share via share_plus
  - [ ] Option to save to Downloads

## 6. Premium Integration

- [ ] Use `PremiumService` for feature gating
- [ ] Show upsell dialogs for free users

## 7. Testing & Validation

- [ ] Test GPX generation and format validity
- [ ] Test KML generation and Google Earth compatibility
- [ ] Test bulk JSON export
- [ ] Test GPX import with various files
- [ ] Test backup/restore cycle
- [ ] Run `openspec validate add-export-backup --strict`
- [ ] Run `flutter analyze`
