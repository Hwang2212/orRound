import 'package:latlong2/latlong.dart';

class LocationPoint {
  final String id;
  final String journeyId;
  final double latitude;
  final double longitude;
  final double? speed;
  final int timestamp;

  LocationPoint({
    required this.id,
    required this.journeyId,
    required this.latitude,
    required this.longitude,
    this.speed,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'journey_id': journeyId,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'timestamp': timestamp,
    };
  }

  factory LocationPoint.fromMap(Map<String, dynamic> map) {
    return LocationPoint(
      id: map['id'] as String,
      journeyId: map['journey_id'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      speed: (map['speed'] as num?)?.toDouble(),
      timestamp: map['timestamp'] as int,
    );
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
