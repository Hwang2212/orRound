import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/models/journey_category.dart';
import '../../../utils/journey_title_generator.dart';

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

              // Quick Stats
              SliverToBoxAdapter(child: _buildQuickStats(context)),

              // Weather
              SliverToBoxAdapter(child: _buildWeatherCard(context)),

              // Streak
              SliverToBoxAdapter(child: _buildStreakCard(context)),

              // Recent Journeys Title
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text('Recent Journeys', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),

              // Category Filter
              SliverToBoxAdapter(child: _buildCategoryFilter(context)),

              // Journey List
              Obx(() {
                if (controller.isLoadingJourneys.value) {
                  return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                }

                final journeys = controller.filteredJourneys;
                if (journeys.isEmpty) {
                  return SliverFillRemaining(child: _buildEmptyState(context));
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final journey = journeys[index];
                    return _buildJourneyCard(context, journey);
                  }, childCount: journeys.length),
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

  Widget _buildQuickStats(BuildContext context) {
    return Obx(() {
      if (controller.totalJourneysCount.value == 0) {
        return const SizedBox.shrink();
      }

      return GestureDetector(
        onTap: () => Get.toNamed('/statistics'),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bar_chart, size: 16, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        const SizedBox(width: 8),
                        Text(
                          'Your Stats',
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.formattedTotalDistance,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                              Text(
                                'Distance',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.formattedTotalDuration,
                                style: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimaryContainer),
                              ),
                              Text(
                                'Time',
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onPrimaryContainer),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // All filter
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: const Text('All'),
                  selected: controller.selectedCategoryFilter.value == null,
                  onSelected: (selected) {
                    if (selected) {
                      controller.selectedCategoryFilter.value = null;
                    }
                  },
                ),
              ),

              // Category filters
              ...JourneyCategory.values.map((category) {
                final isSelected = controller.selectedCategoryFilter.value == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: Icon(category.icon, size: 16),
                    label: Text(category.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      controller.selectedCategoryFilter.value = selected ? category : null;
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildStreakCard(BuildContext context) {
    return Obx(() {
      final streak = controller.currentStreak.value;
      if (streak == 0) return const SizedBox.shrink();

      return GestureDetector(
        onTap: controller.navigateToAchievements,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withOpacity(0.7)]),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.local_fire_department, size: 32, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$streak ${streak == 1 ? 'day' : 'days'} streak',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Keep it going!',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onPrimary),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildJourneyCard(BuildContext context, journey) {
    final startDate = DateTime.fromMillisecondsSinceEpoch(journey.startTime);
    final dateStr = '${startDate.month}/${startDate.day}/${startDate.year}';

    // Display custom title or auto-generated title
    final displayTitle = (journey.title != null && journey.title!.isNotEmpty) ? journey.title! : generateDisplayTitle(journey.startTime);

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
                  Row(
                    children: [
                      Icon(journey.category.icon, size: 20, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(displayTitle, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Text(journey.formattedDuration, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 4),
              Text(dateStr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
