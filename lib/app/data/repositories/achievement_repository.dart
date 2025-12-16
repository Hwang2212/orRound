import 'package:sqflite/sqflite.dart';
import '../models/achievement.dart';
import '../providers/database_provider.dart';

class AchievementRepository {
  final DatabaseProvider _dbProvider = DatabaseProvider();

  /// Gets all unlocked achievements from the database
  Future<List<Achievement>> getUnlockedAchievements() async {
    final db = await _dbProvider.database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');

    final List<Achievement> unlockedAchievements = [];
    for (final map in maps) {
      final definition = AchievementDefinitions.getById(map['id'] as String);
      if (definition != null) {
        unlockedAchievements.add(definition.copyWith(unlockedAt: map['unlocked_at'] as int));
      }
    }

    return unlockedAchievements;
  }

  /// Gets all achievements (both locked and unlocked) with their unlock status
  Future<List<Achievement>> getAllAchievements() async {
    final unlocked = await getUnlockedAchievements();
    final unlockedIds = unlocked.map((a) => a.id).toSet();

    final all =
        AchievementDefinitions.all.map((definition) {
          if (unlockedIds.contains(definition.id)) {
            return unlocked.firstWhere((a) => a.id == definition.id);
          }
          return definition;
        }).toList();

    return all;
  }

  /// Unlocks an achievement
  Future<void> unlockAchievement(String id) async {
    final db = await _dbProvider.database;
    final now = DateTime.now().millisecondsSinceEpoch;

    final definition = AchievementDefinitions.getById(id);
    if (definition == null) return;

    await db.insert(
      'achievements',
      {'id': id, 'type': definition.type.name, 'unlocked_at': now},
      conflictAlgorithm: ConflictAlgorithm.ignore, // Don't unlock twice
    );
  }

  /// Checks if an achievement is unlocked
  Future<bool> isAchievementUnlocked(String id) async {
    final db = await _dbProvider.database;
    final result = await db.query('achievements', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty;
  }

  /// Gets the current streak (consecutive days with journeys)
  Future<int> getCurrentStreak() async {
    final db = await _dbProvider.database;

    // Get all journey dates ordered by most recent
    final result = await db.rawQuery('''
      SELECT DISTINCT date(start_time / 1000, 'unixepoch', 'localtime') as journey_date
      FROM journeys
      ORDER BY journey_date DESC
    ''');

    if (result.isEmpty) return 0;

    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    int streak = 0;
    DateTime checkDate = today;

    for (final row in result) {
      final journeyDateStr = row['journey_date'] as String;
      final journeyDate = DateTime.parse(journeyDateStr);

      // Normalize to date only (remove time)
      final normalizedJourneyDate = DateTime(journeyDate.year, journeyDate.month, journeyDate.day);
      final normalizedCheckDate = DateTime(checkDate.year, checkDate.month, checkDate.day);

      if (normalizedJourneyDate.isAtSameMomentAs(normalizedCheckDate)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (normalizedJourneyDate.isBefore(normalizedCheckDate)) {
        // Gap in streak - check if it's just one day
        final daysDiff = normalizedCheckDate.difference(normalizedJourneyDate).inDays;
        if (daysDiff == 1) {
          streak++;
          checkDate = normalizedJourneyDate.subtract(const Duration(days: 1));
        } else {
          // Streak broken
          break;
        }
      }
    }

    return streak;
  }

  /// Gets the last journey date for streak calculation
  Future<DateTime?> getLastJourneyDate() async {
    final db = await _dbProvider.database;
    final result = await db.query('journeys', columns: ['start_time'], orderBy: 'start_time DESC', limit: 1);

    if (result.isEmpty) return null;
    return DateTime.fromMillisecondsSinceEpoch(result.first['start_time'] as int);
  }
}
