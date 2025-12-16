import 'package:get/get.dart';
import '../modules/routes/routes.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/journey_tracking/views/journey_tracking_view.dart';
import '../modules/journey_tracking/bindings/journey_tracking_binding.dart';
import '../modules/journey_detail/views/journey_detail_view.dart';
import '../modules/journey_detail/bindings/journey_detail_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/edit_profile_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/referral/views/my_referral_view.dart';
import '../modules/referral/views/enter_referral_view.dart';
import '../modules/referral/bindings/referral_binding.dart';
import '../modules/achievements/views/achievements_view.dart';
import '../modules/achievements/bindings/achievements_binding.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: Routes.JOURNEY_TRACKING, page: () => const JourneyTrackingView(), binding: JourneyTrackingBinding()),
    GetPage(name: Routes.JOURNEY_DETAIL, page: () => const JourneyDetailView(), binding: JourneyDetailBinding()),
    GetPage(name: Routes.PROFILE, page: () => const ProfileView(), binding: ProfileBinding()),
    GetPage(name: Routes.EDIT_PROFILE, page: () => const EditProfileView(), binding: ProfileBinding()),
    GetPage(name: Routes.MY_REFERRAL, page: () => const MyReferralView(), binding: ReferralBinding()),
    GetPage(name: Routes.ENTER_REFERRAL, page: () => const EnterReferralView(), binding: ReferralBinding()),
    GetPage(name: Routes.ACHIEVEMENTS, page: () => const AchievementsView(), binding: AchievementsBinding()),
  ];
}
