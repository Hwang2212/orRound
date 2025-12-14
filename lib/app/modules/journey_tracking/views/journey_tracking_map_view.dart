import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import '../controllers/journey_tracking_controller.dart';

class JourneyTrackingMapView extends GetView<JourneyTrackingController> {
  const JourneyTrackingMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final points = controller.locationPoints;
      final currentLoc = controller.currentLocation.value;

      // Priority: 1) Latest tracking point, 2) Current location, 3) World view
      final center =
          points.isNotEmpty
              ? points.last.toLatLng()
              : (currentLoc ?? const LatLng(0, 0));
      final hasLocation = points.isNotEmpty || currentLoc != null;

      // Auto-center map on latest location
      if (hasLocation) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            controller.mapController.move(center, 15.0);
          } catch (e) {
            // Ignore errors if map controller not ready
          }
        });
      }

      return FlutterMap(
        mapController: controller.mapController,
        options: MapOptions(
          initialCenter: center,
          initialZoom: hasLocation ? 15.0 : 2.0,
          minZoom: 3.0,
          maxZoom: 18.0,
          interactionOptions: const InteractionOptions(
            flags:
                InteractiveFlag
                    .none, // Disable all interactions (dragging, pinching, rotating)
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.orround.app',
          ),
          if (hasLocation) ...[
            PolylineLayer(
              polylines: [
                Polyline(
                  points: points.map((p) => p.toLatLng()).toList(),
                  strokeWidth: 4.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                // Start marker
                if (points.isNotEmpty)
                  Marker(
                    point: points.first.toLatLng(),
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                // Current position marker
                Marker(
                  point: center,
                  width: 50,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    });
  }
}
