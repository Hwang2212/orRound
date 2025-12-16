import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:screen_brightness/screen_brightness.dart';

/// Provider for managing screen wake lock and brightness during journey tracking.
/// This ensures the device screen stays on and dims to save battery while
/// maintaining continuous GPS tracking.
class ScreenWakeProvider {
  final ScreenBrightness _screenBrightness = ScreenBrightness();
  double? _originalBrightness;

  /// The brightness level to use during tracking (20%).
  static const double trackingBrightness = 0.2;

  /// Enable wake lock to prevent device from sleeping.
  Future<void> enableWakeLock() async {
    try {
      await WakelockPlus.enable();
      print('Wake lock enabled');
    } catch (e) {
      print('Error enabling wake lock: $e');
    }
  }

  /// Disable wake lock to allow device to sleep normally.
  Future<void> disableWakeLock() async {
    try {
      await WakelockPlus.disable();
      print('Wake lock disabled');
    } catch (e) {
      print('Error disabling wake lock: $e');
    }
  }

  /// Dim the screen to conserve battery during tracking.
  /// Saves the current brightness level before dimming.
  Future<void> dimScreen() async {
    try {
      // Save current brightness before dimming
      _originalBrightness = await _screenBrightness.current;
      print('Original brightness saved: $_originalBrightness');

      // Only dim if current brightness is higher than tracking brightness
      if (_originalBrightness != null && _originalBrightness! > trackingBrightness) {
        await _screenBrightness.setScreenBrightness(trackingBrightness);
        print('Screen dimmed to $trackingBrightness');
      }
    } catch (e) {
      print('Error dimming screen: $e');
      // Continue without dimming if it fails
    }
  }

  /// Restore the original screen brightness.
  Future<void> restoreBrightness() async {
    try {
      if (_originalBrightness != null) {
        await _screenBrightness.setScreenBrightness(_originalBrightness!);
        print('Screen brightness restored to $_originalBrightness');
        _originalBrightness = null;
      } else {
        // If we don't have a saved brightness, reset to system default
        await _screenBrightness.resetScreenBrightness();
        print('Screen brightness reset to system default');
      }
    } catch (e) {
      print('Error restoring screen brightness: $e');
      // Try to reset to system default as fallback
      try {
        await _screenBrightness.resetScreenBrightness();
      } catch (e) {
        print('Error resetting screen brightness: $e');
      }
    }
  }

  /// Enable tracking mode: wake lock + dim screen.
  /// Call this when journey tracking starts.
  Future<void> enableTrackingMode() async {
    await enableWakeLock();
    await dimScreen();
  }

  /// Disable tracking mode: restore brightness + disable wake lock.
  /// Call this when journey tracking ends.
  Future<void> disableTrackingMode() async {
    await restoreBrightness();
    await disableWakeLock();
  }

  /// Check if wake lock is currently enabled.
  Future<bool> isWakeLockEnabled() async {
    try {
      return await WakelockPlus.enabled;
    } catch (e) {
      print('Error checking wake lock status: $e');
      return false;
    }
  }
}
