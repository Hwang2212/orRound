import '../data/models/achievement.dart';
import '../data/repositories/achievement_repository.dart';
import '../data/repositories/journey_repository.dart';

class AchievementService {
  final AchievementRepository _achievementRepo = AchievementRepository();
  final JourneyRepository _journeyRepo = JourneyRepository();

  /// Checks for newly unlocked achievements after a journey is saved
  /// Returns a list of newly unlocked achievements
  Future<List<Achievement>> checkAchievements() async {
    final List<Achievement> newlyUnlocked = [];

    // Check distance achievements
    final totalDistance = await _journeyRepo.getTotalDistance();
    for (final achievement in AchievementDefinitions.getByType(AchievementType.distance)) {
      if (totalDistance >= achievement.requirement) {
        final isUnlocked = await _achievementRepo.isAchievementUnlocked(achievement.id);
        if (!isUnlocked) {
          await _achievementRepo.unlockAchievement(achievement.id);
          newlyUnlocked.add(achievement.copyWith(unlockedAt: DateTime.now().millisecondsSinceEpoch));
        }
      }
    }

    // Check journey count achievements
    final journeyCount = await _journeyRepo.getJourneyCount();
    for (final achievement in AchievementDefinitions.getByType(AchievementType.journeyCount)) {
      if (journeyCount >= achievement.requirement) {
        final isUnlocked = await _achievementRepo.isAchievementUnlocked(achievement.id);
        if (!isUnlocked) {
          await _achievementRepo.unlockAchievement(achievement.id);
          newlyUnlocked.add(achievement.copyWith(unlockedAt: DateTime.now().millisecondsSinceEpoch));
        }
      }
    }

    // Check streak achievements
    final currentStreak = await _achievementRepo.getCurrentStreak();
    for (final achievement in AchievementDefinitions.getByType(AchievementType.streak)) {
      if (currentStreak >= achievement.requirement) {
        final isUnlocked = await _achievementRepo.isAchievementUnlocked(achievement.id);
        if (!isUnlocked) {
          await _achievementRepo.unlockAchievement(achievement.id);
          newlyUnlocked.add(achievement.copyWith(unlockedAt: DateTime.now().millisecondsSinceEpoch));
        }
      }
    }

    return newlyUnlocked;
  }
}
