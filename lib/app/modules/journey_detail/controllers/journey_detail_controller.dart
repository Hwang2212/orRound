import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/models/journey.dart';
import '../../../data/models/location_point.dart';
import '../../../data/repositories/journey_repository.dart';
import '../../../data/repositories/analytics_repository.dart';

class JourneyDetailController extends GetxController {
  final JourneyRepository _journeyRepo = JourneyRepository();
  final AnalyticsRepository _analyticsRepo = AnalyticsRepository();

  final Rx<Journey?> journey = Rx<Journey?>(null);
  final RxList<LocationPoint> locationPoints = <LocationPoint>[].obs;
  final RxBool isLoading = true.obs;
  final GlobalKey screenshotKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    final journeyId = Get.arguments as String?;
    if (journeyId != null) {
      _loadJourney(journeyId);
    }
  }

  Future<void> _loadJourney(String id) async {
    isLoading.value = true;
    try {
      journey.value = await _journeyRepo.getJourneyById(id);
      if (journey.value != null) {
        locationPoints.value = await _journeyRepo.getLocationPointsForJourney(id);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load journey details');
      Get.back();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> shareJourney() async {
    final j = journey.value;
    if (j == null) return;

    try {
      final screenshot = await _captureScreenshot();
      if (screenshot == null) {
        Get.snackbar('Error', 'Failed to capture screenshot');
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/journey_${j.id}.png');
      await file.writeAsBytes(screenshot);

      final text = 'Journey: ${j.formattedDuration} • ${j.totalDistance.toStringAsFixed(2)} km';

      await Share.shareXFiles([XFile(file.path)], text: text);

      await _analyticsRepo.logJourneyShared(durationSeconds: j.duration.inSeconds, distanceKm: j.totalDistance, hasWeather: j.weatherCondition != null);
    } catch (e) {
      Get.snackbar('Error', 'Failed to share journey');
    }
  }

  Future<void> saveToGallery() async {
    try {
      final screenshot = await _captureScreenshot();
      if (screenshot == null) {
        Get.snackbar('Error', 'Failed to capture screenshot');
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/journey_${journey.value!.id}.png');
      await file.writeAsBytes(screenshot);

      await Gal.putImage(file.path);

      Get.snackbar('Saved', 'Journey saved to gallery');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save to gallery');
    }
  }

  Future<Uint8List?> _captureScreenshot() async {
    try {
      final boundary = screenshotKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print('Screenshot error: $e');
      return null;
    }
  }

  String get startDateFormatted {
    final j = journey.value;
    if (j == null) return '';

    final date = DateTime.fromMillisecondsSinceEpoch(j.startTime);
    return '${date.month}/${date.day}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String get weatherDisplay {
    final j = journey.value;
    if (j == null || j.weatherCondition == null) return '';

    if (j.temperature != null) {
      return '${j.temperature!.toStringAsFixed(1)}°C • ${j.weatherCondition}';
    }
    return j.weatherCondition!;
  }
}
