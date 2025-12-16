import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/achievement.dart';

class AchievementCelebrationDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementCelebrationDialog({super.key, required this.achievement});

  static void show(Achievement achievement) {
    Get.dialog(AchievementCelebrationDialog(achievement: achievement), barrierDismissible: false);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
                child: Icon(_getIconData(achievement.iconName), size: 64, color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),

            const SizedBox(height: 24),

            // Celebration text
            Text(
              '🎉 Achievement Unlocked! 🎉',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Achievement title
            Text(achievement.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),

            const SizedBox(height: 8),

            // Achievement description
            Text(
              achievement.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Get.back(), child: const Text('Close'))),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Get.back();
                      Get.toNamed('/achievements');
                    },
                    child: const Text('View All'),
                  ),
                ),
              ],
            ),
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
}
