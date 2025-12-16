import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import '../controllers/journey_detail_controller.dart';
import '../../../data/models/journey_category.dart';

class JourneyDetailView extends GetView<JourneyDetailController> {
  const JourneyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journey Details'),
        actions: [
          IconButton(icon: const Icon(Icons.save_alt), onPressed: controller.saveToGallery),
          IconButton(icon: const Icon(Icons.share), onPressed: controller.shareJourney),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final journey = controller.journey.value;
        if (journey == null) {
          return const Center(child: Text('Journey not found'));
        }

        return RepaintBoundary(
          key: controller.screenshotKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title section
                _buildTitle(context),

                // Map
                _buildMap(context),

                // Stats
                _buildStats(context, journey),

                // Category and Tags section
                _buildCategoryAndTags(context, journey),

                // Achievements
                _buildAchievementsCard(context),

                // Weather
                if (controller.weatherDisplay.isNotEmpty) _buildWeather(context),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCategoryAndTags(BuildContext context, journey) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category
            Row(
              children: [
                Icon(Icons.category_outlined, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('Category', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => InkWell(
                onTap: () => _showCategoryPicker(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(controller.journey.value!.category.icon, size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(controller.journey.value!.category.displayName, style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(width: 8),
                      Icon(Icons.edit, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tags
            Row(
              children: [
                Icon(Icons.label_outline, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text('Tags', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...controller.journey.value!.tags.map(
                    (tag) => Chip(label: Text(tag), deleteIcon: const Icon(Icons.close, size: 16), onDeleted: () => controller.removeTag(tag)),
                  ),
                  ActionChip(avatar: const Icon(Icons.add, size: 18), label: const Text('Add Tag'), onPressed: () => _showAddTagDialog(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Category', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  JourneyCategory.values.map((category) {
                    return ChoiceChip(
                      avatar: Icon(category.icon, size: 18),
                      label: Text(category.displayName),
                      selected: controller.journey.value?.category == category,
                      onSelected: (selected) {
                        if (selected) {
                          controller.updateCategory(category);
                          Get.back();
                        }
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Tag'),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: 'Enter tag name', border: OutlineInputBorder()),
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.addTag(value.trim());
                  Get.back();
                }
              },
            ),
            actions: [
              TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
              FilledButton(
                onPressed: () {
                  final tag = textController.text.trim();
                  if (tag.isNotEmpty) {
                    controller.addTag(tag);
                    Get.back();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showEditTitleDialog(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.displayTitle,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.startDateFormatted,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditTitleDialog(context), tooltip: 'Edit title'),
          ],
        ),
      ),
    );
  }

  void _showEditTitleDialog(BuildContext context) {
    final textController = TextEditingController(text: controller.displayTitle);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Journey Title'),
            content: TextField(
              controller: textController,
              decoration: const InputDecoration(hintText: 'Enter journey title', border: OutlineInputBorder()),
              autofocus: true,
              maxLines: 2,
              maxLength: 100,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.cancelEditingTitle();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.saveTitle(textController.text);
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  Widget _buildMap(BuildContext context) {
    return Obx(() {
      final points = controller.locationPoints;

      if (points.isEmpty) {
        return Container(height: 300, color: Theme.of(context).colorScheme.surfaceContainerHighest, child: const Center(child: Text('No route data')));
      }

      final latLngs = points.map((p) => p.toLatLng()).toList();

      return SizedBox(
        height: 300,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: latLngs.first,
            initialZoom: 13.0,
            minZoom: 3.0,
            maxZoom: 18.0,
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
          ),
          children: [
            TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', userAgentPackageName: 'com.orround.app'),
            PolylineLayer(polylines: [Polyline(points: latLngs, strokeWidth: 4.0, color: Theme.of(context).colorScheme.primary)]),
            MarkerLayer(
              markers: [
                Marker(point: latLngs.first, width: 40, height: 40, child: const Icon(Icons.location_on, color: Colors.green, size: 40)),
                Marker(point: latLngs.last, width: 40, height: 40, child: const Icon(Icons.flag, color: Colors.red, size: 40)),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStats(BuildContext context, journey) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Grid of stats
          Row(
            children: [
              Expanded(child: _buildStatCard(context, icon: Icons.timer_outlined, label: 'Duration', value: journey.formattedDuration)),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard(context, icon: Icons.straighten, label: 'Distance', value: '${journey.totalDistance.toStringAsFixed(2)} km')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildStatCard(context, icon: Icons.speed, label: 'Avg Speed', value: '${journey.averageSpeed.toStringAsFixed(1)} km/h')),
              const SizedBox(width: 8),
              Expanded(child: _buildStatCard(context, icon: Icons.location_on_outlined, label: 'Points', value: '${controller.locationPoints.length}')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {required IconData icon, required String label, required String value}) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeather(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.wb_sunny_outlined, color: Theme.of(context).colorScheme.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weather at Start', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 4),
                  Text(controller.weatherDisplay, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/achievements'),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 0,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.emoji_events, color: Theme.of(context).colorScheme.onPrimary, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievements',
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'View your progress and milestones',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}
