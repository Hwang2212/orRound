import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import '../controllers/journey_detail_controller.dart';

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
                // Map
                _buildMap(context),

                // Stats
                _buildStats(context, journey),

                // Weather
                if (controller.weatherDisplay.isNotEmpty) _buildWeather(context),
              ],
            ),
          ),
        );
      }),
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
          Text(controller.startDateFormatted, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildWeather(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.wb_sunny_outlined, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weather at Start', style: Theme.of(context).textTheme.bodySmall),
                  Text(controller.weatherDisplay, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
