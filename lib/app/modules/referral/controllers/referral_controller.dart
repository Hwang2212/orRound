import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/repositories/analytics_repository.dart';

class ReferralController extends GetxController {
  final UserRepository _userRepo = UserRepository();
  final AnalyticsRepository _analyticsRepo = AnalyticsRepository();

  final RxString referralCode = ''.obs;
  final enterCodeController = TextEditingController();
  final RxString errorMessage = ''.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadReferralCode();
  }

  @override
  void onClose() {
    enterCodeController.dispose();
    super.onClose();
  }

  Future<void> _loadReferralCode() async {
    referralCode.value = await _userRepo.getReferralCode();
  }

  Future<void> copyReferralCode() async {
    if (referralCode.value.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar('Copied', 'Referral code copied to clipboard');
  }

  void clearError() {
    errorMessage.value = '';
  }

  Future<void> submitReferralCode() async {
    final code = enterCodeController.text.trim().toUpperCase();

    if (code.isEmpty) {
      errorMessage.value = 'Please enter a referral code';
      return;
    }

    if (code.length != 6) {
      errorMessage.value = 'Referral code must be 6 characters';
      return;
    }

    if (code == referralCode.value) {
      errorMessage.value = 'You cannot use your own referral code';
      return;
    }

    isSubmitting.value = true;
    try {
      await _userRepo.updateReferredByCode(code);

      await _analyticsRepo.logReferralCodeEntered(hasReferredBy: true);
      await _analyticsRepo.setHasUsedReferral(true);

      Get.back(result: true);
      Get.snackbar('Success', 'Referral code applied successfully');
    } catch (e) {
      errorMessage.value = 'Failed to apply referral code';
    } finally {
      isSubmitting.value = false;
    }
  }
}
