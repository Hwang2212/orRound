import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(child: _buildHeader(context)),

              // Weather
              SliverToBoxAdapter(child: _buildWeatherCard(context)),

              // Recent Journeys Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text('Recent Journeys', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),

              // Journey List
              Obx(() {
                if (controller.isLoadingJourneys.value) {
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                }

                if (controller.recentJourneys.isEmpty) {
                  return SliverFillRemaining(child: _buildEmptyState(context));
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final journey = controller.recentJourneys[index];
                    return _buildJourneyCard(context, journey);
                  }, childCount: controller.recentJourneys.length),
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.navigateToTracking,
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Journey'),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final profile = controller.userProfile.value;
      final hasName = profile?.name != null && profile!.name!.isNotEmpty;

      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            GestureDetector(
              onTap: controller.navigateToProfile,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: profile?.profilePicturePath != null ? AssetImage(profile!.profilePicturePath!) : null,
                child:
                    profile?.profilePicturePath == null
                        ? Text(
                          profile?.avatarLetter ?? '?',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                        )
                        : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(controller.welcomeMessage, style: Theme.of(context).textTheme.titleMedium),
                  if (hasName && controller.totalJourneysCount.value > 0)
                    Text(
                      '${controller.totalJourneysCount.value} ${controller.totalJourneysCount.value == 1 ? 'journey' : 'journeys'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            IconButton(icon: const Icon(Icons.person_outline), onPressed: controller.navigateToProfile),
          ],
        ),
      );
    });
  }

  Widget _buildWeatherCard(BuildContext context) {
    return Obx(() {
      if (controller.weatherDisplay.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Icon(Icons.wb_sunny_outlined, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(controller.weatherDisplay, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      );
    });
  }

  Widget _buildJourneyCard(BuildContext context, journey) {
    final startDate = DateTime.fromMillisecondsSinceEpoch(journey.startTime);
    final dateStr = '${startDate.month}/${startDate.day}/${startDate.year}';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: () => controller.navigateToJourneyDetail(journey),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateStr, style: Theme.of(context).textTheme.titleMedium),
                  Text(journey.formattedDuration, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.straighten, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${journey.totalDistance.toStringAsFixed(2)} km', style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(width: 16),
                  Icon(Icons.speed, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${journey.averageSpeed.toStringAsFixed(1)} km/h', style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text('No journeys yet', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Tap the button below to start tracking', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
