import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/journey_tracking_controller.dart';
import 'journey_tracking_map_view.dart';

class JourneyTrackingView extends GetView<JourneyTrackingController> {
  const JourneyTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Tracking'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => _showStopDialog(context)),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(controller.showMap.value ? Icons.visibility_off : Icons.visibility),
              tooltip: controller.showMap.value ? 'Hide map' : 'Show map',
              onPressed: controller.toggleMap,
            ),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          children: [
            // Map
            if (controller.showMap.value) Expanded(flex: 2, child: const JourneyTrackingMapView()),

            // Stats
            Expanded(flex: controller.showMap.value ? 1 : 3, child: _buildStats(context)),
          ],
        ),
      ),
      bottomNavigationBar: _buildControls(context),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Obx(() {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer
            Text(
              controller.formattedDuration,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, fontFeatures: [const FontFeature.tabularFigures()]),
            ),
            const SizedBox(height: 32),

            // Distance and Speed
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(context, icon: Icons.straighten, label: 'Distance', value: '${controller.distanceKm.value.toStringAsFixed(2)} km'),
                _buildStatItem(context, icon: Icons.speed, label: 'Speed', value: '${controller.currentSpeedKmh.value.toStringAsFixed(1)} km/h'),
              ],
            ),

            // Hint text when map is hidden
            if (!controller.showMap.value) ...[
              const SizedBox(height: 24),
              Text('Route is being recorded', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.secondary)),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildStatItem(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }

  Widget _buildControls(BuildContext context) {
    return Obx(() {
      final isTracking = controller.isTracking.value;
      final isPaused = controller.isPaused.value;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (!isTracking) ...[
                Expanded(
                  child: FilledButton.icon(
                    onPressed: controller.startTracking,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isPaused ? controller.resumeTracking : controller.pauseTracking,
                    icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                    label: Text(isPaused ? 'Resume' : 'Pause'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showStopDialog(context),
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop'),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  void _showStopDialog(BuildContext context) {
    if (!controller.isTracking.value) {
      Get.back();
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Stop Journey?'),
        content: const Text('Are you sure you want to stop tracking this journey?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Get.back();
              controller.stopTracking();
            },
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  }
}
