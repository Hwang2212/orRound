import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/journey_repository.dart';
import '../../../data/repositories/analytics_repository.dart';
import '../../routes/routes.dart';

class ProfileController extends GetxController {
  final UserRepository _userRepo = UserRepository();
  final JourneyRepository _journeyRepo = JourneyRepository();
  final AnalyticsRepository _analyticsRepo = AnalyticsRepository();
  final ImagePicker _imagePicker = ImagePicker();

  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final RxInt totalJourneys = 0.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    isLoading.value = true;
    try {
      userProfile.value = await _userRepo.getUserProfile();
      totalJourneys.value = await _journeyRepo.getJourneyCount();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfilePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        await _userRepo.updateUserProfile(profilePicturePath: image.path);
        await _loadProfile();

        await _analyticsRepo.logProfilePictureUpdated(source: 'gallery');
        Get.snackbar('Success', 'Profile picture updated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile picture');
    }
  }

  Future<void> takeProfilePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        await _userRepo.updateUserProfile(profilePicturePath: image.path);
        await _loadProfile();

        await _analyticsRepo.logProfilePictureUpdated(source: 'camera');
        Get.snackbar('Success', 'Profile picture updated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to take profile picture');
    }
  }

  void navigateToEditProfile() {
    Get.toNamed(Routes.EDIT_PROFILE)?.then((_) => _loadProfile());
  }

  void navigateToMyReferral() {
    Get.toNamed(Routes.MY_REFERRAL);
  }

  void navigateToEnterReferral() {
    Get.toNamed(Routes.ENTER_REFERRAL)?.then((result) {
      if (result == true) {
        _loadProfile();
      }
    });
  }

  void showPictureOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                takeProfilePicture();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                updateProfilePicture();
              },
            ),
          ],
        ),
      ),
    );
  }

  String get displayName => userProfile.value?.displayName ?? 'User';

  String get email => userProfile.value?.email ?? '';

  bool get hasEmail => email.isNotEmpty;

  String? get profilePicturePath => userProfile.value?.profilePicturePath;

  String get avatarLetter => userProfile.value?.avatarLetter ?? '?';
}
