import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: controller.navigateToEditProfile,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Profile Picture
              _buildProfilePicture(context),

              const SizedBox(height: 16),

              // Name
              Text(
                controller.displayName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              // Email
              if (controller.hasEmail) ...[
                const SizedBox(height: 4),
                Text(
                  controller.email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],

              const SizedBox(height: 32),

              // Stats
              _buildStats(context),

              const SizedBox(height: 24),

              // Options
              _buildOptions(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return GestureDetector(
      onTap: controller.showPictureOptions,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).colorScheme.primary,
            backgroundImage:
                controller.profilePicturePath != null
                    ? FileImage(File(controller.profilePicturePath!))
                    : null,
            child:
                controller.profilePicturePath == null
                    ? Text(
                      controller.avatarLetter,
                      style: TextStyle(
                        fontSize: 48,
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                    : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                size: 20,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              context,
              icon: Icons.explore_outlined,
              label: 'Journeys',
              value: '${controller.totalJourneys}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildOptions(BuildContext context) {
    final profile = controller.userProfile.value;
    final hasUsedReferral = profile?.referredByCode != null;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Edit Profile'),
          trailing: const Icon(Icons.chevron_right),
          onTap: controller.navigateToEditProfile,
        ),
        const Divider(height: 1),
        ListTile(
          leading: const Icon(Icons.card_giftcard_outlined),
          title: const Text('My Referral Code'),
          trailing: const Icon(Icons.chevron_right),
          onTap: controller.navigateToMyReferral,
        ),
        if (!hasUsedReferral) ...[
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.person_add_outlined),
            title: const Text('Enter Referral Code'),
            trailing: const Icon(Icons.chevron_right),
            onTap: controller.navigateToEnterReferral,
          ),
        ],
      ],
    );
  }
}
