import 'package:flutter_foreground_task/flutter_foreground_task.dart';

/// Provider for managing foreground service during journey tracking.
/// This ensures continuous location tracking even when the device enters
/// deep sleep or doze mode.
class ForegroundServiceProvider {
  static const String _channelId = 'journey_tracking_channel';
  static const int _notificationId = 1000;

  /// Initialize the foreground task configuration.
  /// Must be called before starting the service.
  Future<void> initialize() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: _channelId,
        channelName: 'Journey Tracking',
        channelDescription: 'Continuous location tracking for your journeys',
        onlyAlertOnce: true,
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000), // Every 5 seconds
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
  }

  /// Start the foreground service.
  /// This will display a persistent notification and keep the app alive.
  Future<void> startService({
    required String title,
    required String content,
  }) async {
    // Check if the service is already running
    if (await FlutterForegroundTask.isRunningService) {
      return;
    }

    await FlutterForegroundTask.startService(
      serviceId: _notificationId,
      notificationTitle: title,
      notificationText: content,
      callback: _foregroundTaskCallback,
    );
  }

  /// Stop the foreground service.
  Future<void> stopService() async {
    await FlutterForegroundTask.stopService();
  }

  /// Update the foreground service notification content.
  Future<void> updateNotification({
    required String title,
    required String content,
  }) async {
    if (await FlutterForegroundTask.isRunningService) {
      FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: content,
      );
    }
  }

  /// Check if the foreground service is currently running.
  Future<bool> isRunning() async {
    return await FlutterForegroundTask.isRunningService;
  }

  /// Callback for the foreground task.
  /// This runs in an isolate and should be kept minimal.
  @pragma('vm:entry-point')
  static void _foregroundTaskCallback() {
    // This callback is required but can be minimal.
    // The actual location tracking is handled by the location provider,
    // not by this foreground task. This just keeps the app alive.
    FlutterForegroundTask.setTaskHandler(_ForegroundTaskHandler());
  }
}

/// Handler for foreground task events.
class _ForegroundTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('Foreground task started at $timestamp');
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    // This is called every 5 seconds (as configured in eventAction).
    // We don't need to do anything here - the location provider handles tracking.
    // This just ensures the service stays alive.
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print('Foreground task destroyed at $timestamp');
  }

  @override
  void onNotificationButtonPressed(String id) {
    // Not used in this implementation
  }

  @override
  void onNotificationPressed() {
    // When user taps the notification, bring the app to foreground
    FlutterForegroundTask.launchApp('/');
  }
}
