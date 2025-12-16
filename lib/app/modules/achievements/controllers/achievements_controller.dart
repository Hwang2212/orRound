import 'package:get/get.dart';
import '../../../data/models/achievement.dart';
import '../../../data/repositories/achievement_repository.dart';

class AchievementsController extends GetxController {
  final AchievementRepository _achievementRepo = AchievementRepository();

  final RxList<Achievement> achievements = <Achievement>[].obs;
  final RxBool isLoading = true.obs;
  final RxInt currentStreak = 0.obs;

  List<Achievement> get distanceAchievements => achievements.where((a) => a.type == AchievementType.distance).toList();

  List<Achievement> get journeyCountAchievements => achievements.where((a) => a.type == AchievementType.journeyCount).toList();

  List<Achievement> get streakAchievements => achievements.where((a) => a.type == AchievementType.streak).toList();

  int get unlockedCount => achievements.where((a) => a.isUnlocked).length;
  int get totalCount => achievements.length;

  @override
  void onInit() {
    super.onInit();
    _loadAchievements();
    _loadStreak();
  }

  Future<void> _loadAchievements() async {
    isLoading.value = true;
    try {
      achievements.value = await _achievementRepo.getAllAchievements();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load achievements');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadStreak() async {
    try {
      currentStreak.value = await _achievementRepo.getCurrentStreak();
    } catch (e) {
      currentStreak.value = 0;
    }
  }

  Future<void> refreshAchievements() async {
    await _loadAchievements();
    await _loadStreak();
  }
}
