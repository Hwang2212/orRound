import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/achievements_controller.dart';
import '../../../data/models/achievement.dart';

class AchievementsView extends GetView<AchievementsController> {
  const AchievementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshAchievements,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with progress
                _buildHeader(context),

                // Current streak
                _buildStreakSection(context),

                // Distance achievements
                _buildSection(context, 'Distance Milestones', controller.distanceAchievements),

                // Journey count achievements
                _buildSection(context, 'Journey Milestones', controller.journeyCountAchievements),

                // Streak achievements
                _buildSection(context, 'Streak Milestones', controller.streakAchievements),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your Progress', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              '${controller.unlockedCount} of ${controller.totalCount} achievements unlocked',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => LinearProgressIndicator(
              value: controller.totalCount > 0 ? controller.unlockedCount / controller.totalCount : 0,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection(BuildContext context) {
    return Obx(() {
      final streak = controller.currentStreak.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.7)]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.local_fire_department, size: 48, color: Theme.of(context).colorScheme.onPrimary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Current Streak', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                  const SizedBox(height: 4),
                  Text(
                    '$streak ${streak == 1 ? 'day' : 'days'}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSection(BuildContext context, String title, List<Achievement> achievements) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.85),
          itemCount: achievements.length,
          itemBuilder: (context, index) => _buildAchievementCard(context, achievements[index]),
        ),
      ],
    );
  }

  Widget _buildAchievementCard(BuildContext context, Achievement achievement) {
    final isUnlocked = achievement.isUnlocked;
    final iconData = _getIconData(achievement.iconName);

    return Card(
      elevation: isUnlocked ? 4 : 1,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient:
              isUnlocked
                  ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6)],
                  )
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  iconData,
                  size: 48,
                  color: isUnlocked ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.3),
                ),
                if (isUnlocked)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                      child: Icon(Icons.check, size: 16, color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              achievement.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isUnlocked ? null : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isUnlocked ? Theme.of(context).colorScheme.onSurfaceVariant : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (!isUnlocked) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  achievement.requirementText,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (isUnlocked && achievement.unlockedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                _formatUnlockDate(achievement.unlockedAt!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'directions_walk':
        return Icons.directions_walk;
      case 'explore':
        return Icons.explore;
      case 'map':
        return Icons.map;
      case 'terrain':
        return Icons.terrain;
      case 'public':
        return Icons.public;
      case 'flag':
        return Icons.flag;
      case 'trending_up':
        return Icons.trending_up;
      case 'star':
        return Icons.star;
      case 'workspace_premium':
        return Icons.workspace_premium;
      case 'military_tech':
        return Icons.military_tech;
      case 'emoji_events':
        return Icons.emoji_events;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'whatshot':
        return Icons.whatshot;
      case 'auto_awesome':
        return Icons.auto_awesome;
      case 'flash_on':
        return Icons.flash_on;
      default:
        return Icons.emoji_events;
    }
  }

  String _formatUnlockDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Unlocked today';
    } else if (diff.inDays == 1) {
      return 'Unlocked yesterday';
    } else if (diff.inDays < 7) {
      return 'Unlocked ${diff.inDays} days ago';
    } else {
      return 'Unlocked ${date.month}/${date.day}/${date.year}';
    }
  }
}
