enum AchievementType { distance, journeyCount, streak }

class Achievement {
  final String id;
  final AchievementType type;
  final String title;
  final String description;
  final int requirement;
  final String iconName;
  final int? unlockedAt; // Timestamp in milliseconds, null if locked

  const Achievement({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.requirement,
    required this.iconName,
    this.unlockedAt,
  });

  bool get isUnlocked => unlockedAt != null;

  String get requirementText {
    switch (type) {
      case AchievementType.distance:
        return '${requirement}km total distance';
      case AchievementType.journeyCount:
        return '$requirement ${requirement == 1 ? 'journey' : 'journeys'} completed';
      case AchievementType.streak:
        return '$requirement day${requirement == 1 ? '' : 's'} streak';
    }
  }

  Achievement copyWith({String? id, AchievementType? type, String? title, String? description, int? requirement, String? iconName, int? unlockedAt}) {
    return Achievement(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      requirement: requirement ?? this.requirement,
      iconName: iconName ?? this.iconName,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'type': type.name, 'unlockedAt': unlockedAt};
  }

  factory Achievement.fromMap(
    Map<String, dynamic> map, {
    required String id,
    required AchievementType type,
    required String title,
    required String description,
    required int requirement,
    required String iconName,
  }) {
    return Achievement(
      id: id,
      type: type,
      title: title,
      description: description,
      requirement: requirement,
      iconName: iconName,
      unlockedAt: map['unlockedAt'] as int?,
    );
  }
}

class AchievementDefinitions {
  static const List<Achievement> all = [
    // Distance achievements
    Achievement(
      id: 'distance_10',
      type: AchievementType.distance,
      title: 'First Steps',
      description: 'Traveled 10 kilometers',
      requirement: 10,
      iconName: 'directions_walk',
    ),
    Achievement(
      id: 'distance_50',
      type: AchievementType.distance,
      title: 'Explorer',
      description: 'Traveled 50 kilometers',
      requirement: 50,
      iconName: 'explore',
    ),
    Achievement(
      id: 'distance_100',
      type: AchievementType.distance,
      title: 'Wanderer',
      description: 'Traveled 100 kilometers',
      requirement: 100,
      iconName: 'map',
    ),
    Achievement(
      id: 'distance_500',
      type: AchievementType.distance,
      title: 'Road Warrior',
      description: 'Traveled 500 kilometers',
      requirement: 500,
      iconName: 'terrain',
    ),
    Achievement(
      id: 'distance_1000',
      type: AchievementType.distance,
      title: 'Globetrotter',
      description: 'Traveled 1000 kilometers',
      requirement: 1000,
      iconName: 'public',
    ),

    // Journey count achievements
    Achievement(
      id: 'journey_1',
      type: AchievementType.journeyCount,
      title: 'New Beginning',
      description: 'Completed your first journey',
      requirement: 1,
      iconName: 'flag',
    ),
    Achievement(
      id: 'journey_5',
      type: AchievementType.journeyCount,
      title: 'Getting Started',
      description: 'Completed 5 journeys',
      requirement: 5,
      iconName: 'trending_up',
    ),
    Achievement(
      id: 'journey_10',
      type: AchievementType.journeyCount,
      title: 'Regular Tracker',
      description: 'Completed 10 journeys',
      requirement: 10,
      iconName: 'star',
    ),
    Achievement(
      id: 'journey_25',
      type: AchievementType.journeyCount,
      title: 'Committed',
      description: 'Completed 25 journeys',
      requirement: 25,
      iconName: 'workspace_premium',
    ),
    Achievement(
      id: 'journey_50',
      type: AchievementType.journeyCount,
      title: 'Dedicated',
      description: 'Completed 50 journeys',
      requirement: 50,
      iconName: 'military_tech',
    ),
    Achievement(
      id: 'journey_100',
      type: AchievementType.journeyCount,
      title: 'Century Club',
      description: 'Completed 100 journeys',
      requirement: 100,
      iconName: 'emoji_events',
    ),

    // Streak achievements
    Achievement(
      id: 'streak_3',
      type: AchievementType.streak,
      title: 'On a Roll',
      description: '3 day streak',
      requirement: 3,
      iconName: 'local_fire_department',
    ),
    Achievement(id: 'streak_7', type: AchievementType.streak, title: 'Week Warrior', description: '7 day streak', requirement: 7, iconName: 'whatshot'),
    Achievement(id: 'streak_14', type: AchievementType.streak, title: 'Habit Builder', description: '14 day streak', requirement: 14, iconName: 'auto_awesome'),
    Achievement(id: 'streak_30', type: AchievementType.streak, title: 'Unstoppable', description: '30 day streak', requirement: 30, iconName: 'flash_on'),
  ];

  static Achievement? getById(String id) {
    try {
      return all.firstWhere((achievement) => achievement.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<Achievement> getByType(AchievementType type) {
    return all.where((achievement) => achievement.type == type).toList();
  }
}
