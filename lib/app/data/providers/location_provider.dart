import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationProvider {
  final loc.Location _location = loc.Location();
  loc.LocationData? _lastLocation;

  Future<bool> checkPermission() async {
    final permissionStatus = await _location.hasPermission();
    return permissionStatus == loc.PermissionStatus.granted || permissionStatus == loc.PermissionStatus.grantedLimited;
  }

  Future<bool> requestPermission() async {
    final permissionStatus = await _location.requestPermission();
    return permissionStatus == loc.PermissionStatus.granted || permissionStatus == loc.PermissionStatus.grantedLimited;
  }

  Future<bool> isServiceEnabled() async {
    return await _location.serviceEnabled();
  }

  Future<bool> requestService() async {
    return await _location.requestService();
  }

  Future<loc.LocationData?> getCurrentLocation() async {
    try {
      final isEnabled = await isServiceEnabled();
      if (!isEnabled) {
        final serviceRequested = await requestService();
        if (!serviceRequested) return null;
      }

      final hasPermission = await checkPermission();
      if (!hasPermission) {
        final permissionGranted = await requestPermission();
        if (!permissionGranted) return null;
      }

      final locationData = await _location.getLocation();
      _lastLocation = locationData;
      return locationData;
    } catch (e) {
      print('Get location error: $e');
      return null;
    }
  }

  Stream<loc.LocationData> getLocationStream() {
    return _location.onLocationChanged;
  }

  Future<void> enableBackgroundMode(bool enable) async {
    await _location.enableBackgroundMode(enable: enable);
  }

  Future<void> changeSettings({loc.LocationAccuracy? accuracy, int? interval, double? distanceFilter}) async {
    await _location.changeSettings(
      accuracy: accuracy ?? loc.LocationAccuracy.high,
      interval: interval ?? 5000, // 5 seconds
      distanceFilter: distanceFilter ?? 10, // 10 meters
    );
  }

  Future<String?> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      final components = [place.name, place.locality, place.administrativeArea, place.country].where((e) => e != null && e.isNotEmpty);

      return components.join(', ');
    } catch (e) {
      print('Geocoding error: $e');
      return null;
    }
  }

  loc.LocationData? get lastLocation => _lastLocation;
}
