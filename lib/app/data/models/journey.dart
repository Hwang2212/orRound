class Journey {
  final String id;
  final int startTime;
  final int? endTime;
  final double totalDistance;
  final double averageSpeed;
  final String? weatherCondition;
  final double? temperature;
  final int isSynced;
  final int createdAt;

  Journey({
    required this.id,
    required this.startTime,
    this.endTime,
    this.totalDistance = 0,
    this.averageSpeed = 0,
    this.weatherCondition,
    this.temperature,
    this.isSynced = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_time': startTime,
      'end_time': endTime,
      'total_distance': totalDistance,
      'average_speed': averageSpeed,
      'weather_condition': weatherCondition,
      'temperature': temperature,
      'is_synced': isSynced,
      'created_at': createdAt,
    };
  }

  factory Journey.fromMap(Map<String, dynamic> map) {
    return Journey(
      id: map['id'] as String,
      startTime: map['start_time'] as int,
      endTime: map['end_time'] as int?,
      totalDistance: (map['total_distance'] as num?)?.toDouble() ?? 0,
      averageSpeed: (map['average_speed'] as num?)?.toDouble() ?? 0,
      weatherCondition: map['weather_condition'] as String?,
      temperature: (map['temperature'] as num?)?.toDouble(),
      isSynced: map['is_synced'] as int? ?? 0,
      createdAt: map['created_at'] as int,
    );
  }

  Duration get duration {
    if (endTime == null) return Duration.zero;
    return Duration(milliseconds: endTime! - startTime);
  }

  String get formattedDuration {
    final d = duration;
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else {
      return '${minutes}m ${seconds}s';
    }
  }
}
