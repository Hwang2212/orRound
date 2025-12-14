import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../modules/routes/routes.dart';

/// Provider for managing journey tracking notifications.
///
/// Handles displaying, updating, and dismissing notifications for active
/// and paused journey tracking sessions.
class NotificationProvider {
  static final NotificationProvider _instance =
      NotificationProvider._internal();
  factory NotificationProvider() => _instance;
  NotificationProvider._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static const String _channelId = 'journey_tracking';
  static const String _channelName = 'Journey Tracking';
  static const int _notificationId = 1;
  bool _isInitialized = false;

  /// Initialize the notification system with platform-specific configuration.
  ///
  /// Should be called once at app startup. Errors are caught and logged
  /// to prevent blocking app initialization.
  Future<void> initialize() async {
    try {
      if (_isInitialized) return;

      // Android-specific initialization
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      // iOS-specific initialization
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTap,
      );

      // Create Android notification channel
      if (Platform.isAndroid) {
        const androidChannel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: 'Notifications for active journey tracking',
          importance: Importance.high,
          playSound: false,
          enableVibration: false,
        );

        await _notifications
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.createNotificationChannel(androidChannel);
      }

      _isInitialized = true;
      print('NotificationProvider initialized successfully');
    } catch (e) {
      print('Error initializing NotificationProvider: $e');
      // Don't rethrow - allow app to continue without notifications
    }
  }

  /// Request notification permissions from the user.
  ///
  /// Returns true if permission is granted, false otherwise.
  /// On Android 12 and below, returns true (permission granted by default).
  Future<bool> requestPermission() async {
    try {
      if (Platform.isAndroid) {
        final androidImplementation =
            _notifications
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();
        final result =
            await androidImplementation?.requestNotificationsPermission();
        return result ?? true; // Default to true for older Android versions
      } else if (Platform.isIOS) {
        final iosImplementation =
            _notifications
                .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin
                >();
        final result = await iosImplementation?.requestPermissions(
          alert: true,
          badge: true,
          sound: false,
        );
        return result ?? false;
      }
      return false; // Unsupported platform
    } catch (e) {
      print('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Display or update the active tracking notification.
  ///
  /// Shows elapsed time and distance in the notification content.
  /// Updates are throttled by the caller (every 5 seconds when backgrounded).
  Future<void> showTrackingNotification({
    required String elapsedTime,
    required double distanceKm,
  }) async {
    try {
      if (!_isInitialized) {
        print('NotificationProvider not initialized, skipping notification');
        return;
      }

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Notifications for active journey tracking',
        importance: Importance.high,
        priority: Priority.high,
        ongoing: true, // Cannot be dismissed by user
        autoCancel: false,
        showWhen: false,
        icon: '@mipmap/ic_launcher',
        playSound: false,
        enableVibration: false,
        silent: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        _notificationId,
        'Journey in Progress',
        'Time: $elapsedTime • Distance: ${distanceKm.toStringAsFixed(2)} km',
        details,
      );
    } catch (e) {
      print('Error showing tracking notification: $e');
    }
  }

  /// Update the existing tracking notification with new stats.
  ///
  /// This is more efficient than recreating the notification.
  /// Functionally identical to showTrackingNotification for this implementation.
  Future<void> updateTrackingNotification({
    required String elapsedTime,
    required double distanceKm,
  }) async {
    // For this implementation, update is the same as show
    await showTrackingNotification(
      elapsedTime: elapsedTime,
      distanceKm: distanceKm,
    );
  }

  /// Display the paused notification with a prompt to resume.
  ///
  /// Shows last recorded stats (frozen, not updating).
  Future<void> showPausedNotification({
    required String elapsedTime,
    required double distanceKm,
  }) async {
    try {
      if (!_isInitialized) {
        print('NotificationProvider not initialized, skipping notification');
        return;
      }

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: 'Notifications for active journey tracking',
        importance: Importance.high,
        priority: Priority.high,
        ongoing: true,
        autoCancel: false,
        showWhen: false,
        icon: '@mipmap/ic_launcher',
        playSound: false,
        enableVibration: false,
        silent: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
      );

      final details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        _notificationId,
        'Journey Paused',
        'Tap to resume tracking • Time: $elapsedTime • Distance: ${distanceKm.toStringAsFixed(2)} km',
        details,
      );
    } catch (e) {
      print('Error showing paused notification: $e');
    }
  }

  /// Dismiss the tracking notification.
  ///
  /// Called when journey ends or is stopped.
  Future<void> hideTrackingNotification() async {
    try {
      await _notifications.cancel(_notificationId);
    } catch (e) {
      print('Error hiding tracking notification: $e');
    }
  }

  /// Handle notification tap events.
  ///
  /// Navigates to the journey tracking page when notification is tapped.
  void _onNotificationTap(NotificationResponse response) {
    try {
      print('Notification tapped, navigating to journey tracking');
      Get.toNamed(Routes.JOURNEY_TRACKING);
    } catch (e) {
      print('Error handling notification tap: $e');
    }
  }
}
