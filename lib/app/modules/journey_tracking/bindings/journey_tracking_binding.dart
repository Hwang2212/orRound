import 'package:get/get.dart';
import '../controllers/journey_tracking_controller.dart';

class JourneyTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JourneyTrackingController>(() => JourneyTrackingController());
  }
}
