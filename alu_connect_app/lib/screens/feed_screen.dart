import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/feed_provider.dart';
import '../models/opportunity_model.dart';
import '../widgets/opportunity_card.dart';
import '../constants/app_colors.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text(
          'Opportunities',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () => _showCreateMenu(context),
              child: Tooltip(
                message: 'Create',
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_circle_outline, size: 22),
                    SizedBox(height: 2),
                    Text(
                      'Create',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<FeedProvider>(
        builder: (context, feedProvider, _) {
          return Column(
            children: [
              // Filter Tabs
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterTab(
                        context,
                        label: 'All',
                        isSelected: feedProvider.selectedFilter == null,
                        onTap: () => feedProvider.setFilter(null),
                      ),
                      _buildFilterTab(
                        context,
                        label: 'Events',
                        isSelected:
                            feedProvider.selectedFilter ==
                            OpportunityType.event,
                        onTap: () =>
                            feedProvider.setFilter(OpportunityType.event),
                      ),
                      _buildFilterTab(
                        context,
                        label: 'Hackathons',
                        isSelected:
                            feedProvider.selectedFilter ==
                            OpportunityType.hackathon,
                        onTap: () =>
                            feedProvider.setFilter(OpportunityType.hackathon),
                      ),
                      _buildFilterTab(
                        context,
                        label: 'Startups',
                        isSelected:
                            feedProvider.selectedFilter ==
                            OpportunityType.startup,
                        onTap: () =>
                            feedProvider.setFilter(OpportunityType.startup),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Opportunities List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: feedProvider.filteredOpportunities.length,
                  itemBuilder: (context, index) {
                    final opportunity =
                        feedProvider.filteredOpportunities[index];
                    return OpportunityCard(
                      opportunity: opportunity,
                      isRsvpd: feedProvider.isRsvpd(opportunity.id),
                      onTap: () => _navigateToDetails(context, opportunity),
                      onRsvpTap: () => feedProvider.toggleRsvp(opportunity.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterTab(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.red : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.red : AppColors.lightGray,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.navyBlue,
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, OpportunityModel opportunity) {
    Navigator.of(
      context,
    ).pushNamed('/opportunity-details', arguments: opportunity.id);
  }

  void _showCreateMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create New',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.navyBlue,
              ),
            ),
            const SizedBox(height: 16),
            _buildMenuOption(
              icon: Icons.event,
              label: 'Event',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  '/create-opportunity',
                  arguments: OpportunityType.event,
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              icon: Icons.code,
              label: 'Hackathon',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  '/create-opportunity',
                  arguments: OpportunityType.hackathon,
                );
              },
            ),
            const SizedBox(height: 12),
            _buildMenuOption(
              icon: Icons.rocket_launch,
              label: 'Startup',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  '/create-opportunity',
                  arguments: OpportunityType.startup,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.red, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.navyBlue,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward, color: AppColors.gray, size: 20),
          ],
        ),
      ),
    );
  }
}
