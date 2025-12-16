import 'package:flutter/material.dart';

enum JourneyCategory {
  walk,
  run,
  bike,
  drive,
  hike,
  other;

  String get displayName {
    switch (this) {
      case JourneyCategory.walk:
        return 'Walk';
      case JourneyCategory.run:
        return 'Run';
      case JourneyCategory.bike:
        return 'Bike';
      case JourneyCategory.drive:
        return 'Drive';
      case JourneyCategory.hike:
        return 'Hike';
      case JourneyCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case JourneyCategory.walk:
        return Icons.directions_walk;
      case JourneyCategory.run:
        return Icons.directions_run;
      case JourneyCategory.bike:
        return Icons.directions_bike;
      case JourneyCategory.drive:
        return Icons.directions_car;
      case JourneyCategory.hike:
        return Icons.hiking;
      case JourneyCategory.other:
        return Icons.route;
    }
  }

  static JourneyCategory fromString(String value) {
    return JourneyCategory.values.firstWhere((category) => category.name == value.toLowerCase(), orElse: () => JourneyCategory.other);
  }
}
