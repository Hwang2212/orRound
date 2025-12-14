import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/analytics_repository.dart';

class EditProfileController extends GetxController {
  final UserRepository _userRepo = UserRepository();
  final AnalyticsRepository _analyticsRepo = AnalyticsRepository();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final RxString errorMessage = ''.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  Future<void> _loadProfile() async {
    final profile = await _userRepo.getUserProfile();
    if (profile != null) {
      nameController.text = profile.name ?? '';
      emailController.text = profile.email ?? '';
    }
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> saveProfile() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    // Validate name
    final nameError = UserProfile.validateName(name);
    if (nameError != null) {
      errorMessage.value = nameError;
      return;
    }

    // Validate email if provided
    if (email.isNotEmpty) {
      final emailError = UserProfile.validateEmail(email);
      if (emailError != null) {
        errorMessage.value = emailError;
        return;
      }
    }

    isSaving.value = true;
    try {
      final fieldsUpdated = <String>[];

      await _userRepo.updateUserProfile(name: name.isNotEmpty ? name : null, email: email.isNotEmpty ? email : null);

      if (name.isNotEmpty) fieldsUpdated.add('name');
      if (email.isNotEmpty) fieldsUpdated.add('email');

      await _analyticsRepo.logProfileUpdated(fieldsUpdated: fieldsUpdated);

      Get.back(result: true);
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      errorMessage.value = 'Failed to save profile';
    } finally {
      isSaving.value = false;
    }
  }
}
