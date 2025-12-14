import 'package:get/get.dart';
import '../controllers/journey_detail_controller.dart';

class JourneyDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JourneyDetailController>(() => JourneyDetailController());
  }
}
