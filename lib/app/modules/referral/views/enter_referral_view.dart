import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/referral_controller.dart';

class EnterReferralView extends GetView<ReferralController> {
  const EnterReferralView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Referral Code')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, size: 80, color: Theme.of(context).colorScheme.primary),

            const SizedBox(height: 24),

            Text('Have a referral code?', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),

            const SizedBox(height: 8),

            Text('Enter the code from a friend to get started with rewards', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),

            const SizedBox(height: 32),

            TextField(
              controller: controller.enterCodeController,
              decoration: const InputDecoration(labelText: 'Referral Code', hintText: 'Enter 6-character code', border: OutlineInputBorder(), counterText: ''),
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(letterSpacing: 8),
              onChanged: (_) => controller.clearError(),
            ),

            const SizedBox(height: 8),

            Obx(() {
              if (controller.errorMessage.value.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(controller.errorMessage.value, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              );
            }),

            const SizedBox(height: 24),

            Obx(() {
              return FilledButton(
                onPressed: controller.isSubmitting.value ? null : controller.submitReferralCode,
                style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                child:
                    controller.isSubmitting.value
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Apply Code'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
