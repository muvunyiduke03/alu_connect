import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/mock_opportunities.dart';
import '../data/mock_communities.dart';
import '../models/opportunity_model.dart';
import 'opportunity_details_screen.dart';
import 'community_room_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  // Read what the user types in the search bar
  final TextEditingController _searchController = TextEditingController();

  // Track the search text so we can filter live as they type
  String _searchQuery = '';

  // Track which top toggle is active: "Opportunities" or "Communities"
  bool _showingOpportunities = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Filter opportunities by title or category matching the search query
  List<OpportunityModel> get _filteredOpportunities {
    if (_searchQuery.isEmpty) return mockOpportunities;
    final query = _searchQuery.toLowerCase();
    return mockOpportunities.where((opp) {
      return opp.title.toLowerCase().contains(query) ||
          opp.category.toLowerCase().contains(query) ||
          opp.typeLabel.toLowerCase().contains(query);
    }).toList();
  }

  // Filter communities by name or category
  List<Community> get _filteredCommunities {
    if (_searchQuery.isEmpty) return mockCommunities;
    final query = _searchQuery.toLowerCase();
    return mockCommunities.where((c) {
      return c.name.toLowerCase().contains(query) ||
          c.category.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [

            // Header + search bar
            Container(
              width: double.infinity,
              color: AppColors.navyBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Find opportunities and communities at ALU',
                    style: TextStyle(fontSize: 13, color: Colors.white60),
                  ),
                  const SizedBox(height: 16),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      onChanged: (value) {
                        // Update the filter live as the user type
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search events, hackathons, clubs...',
                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 20),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                                child: const Icon(Icons.close, color: Colors.white38, size: 18),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Toggle: Opportunities vs Communities
            Container(
              color: AppColors.navyBlue,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                children: [
                  Expanded(child: _buildToggleButton('Opportunities', true)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildToggleButton('Communities', false)),
                ],
              ),
            ),

            // Results
            Expanded(
              child: _showingOpportunities
                  ? _buildOpportunitiesList()
                  : _buildCommunitiesList(),
            ),

          ],
        ),
      ),
    );
  }

  // Toggle button for switching between Opportunities and Communities
  Widget _buildToggleButton(String label, bool isOpportunities) {
    final bool active = _showingOpportunities == isOpportunities;
    return GestureDetector(
      onTap: () => setState(() => _showingOpportunities = isOpportunities),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.red : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: active ? Colors.white : Colors.white60,
          ),
        ),
      ),
    );
  }

  // List of opportunity results
  Widget _buildOpportunitiesList() {
    final results = _filteredOpportunities;

    if (results.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off_rounded,
        message: 'No opportunities found for "$_searchQuery"',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final opp = results[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OpportunityDetailsScreen(opportunityId: opp.id),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lightGray),
            ),
            child: Row(
              children: [
                // Colored type indicator
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: opp.tagColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(_typeIcon(opp.type), color: opp.tagColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opp.typeLabel.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: opp.tagColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        opp.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navyBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        opp.category,
                        style: const TextStyle(fontSize: 12, color: AppColors.gray),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.gray),
              ],
            ),
          ),
        );
      },
    );
  }

  // List of community results
  Widget _buildCommunitiesList() {
    final results = _filteredCommunities;

    if (results.isEmpty) {
      return _buildEmptyState(
        icon: Icons.search_off_rounded,
        message: 'No communities found for "$_searchQuery"',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final community = results[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommunityRoomScreen(community: community),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lightGray),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.group_rounded, color: AppColors.red, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navyBlue,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${community.category} · ${community.memberCount} members',
                        style: const TextStyle(fontSize: 12, color: AppColors.gray),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.gray),
              ],
            ),
          ),
        );
      },
    );
  }

  // Reusable empty state widget
  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.gray),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.gray),
            ),
          ],
        ),
      ),
    );
  }

  // Maps an OpportunityType to an icon
  IconData _typeIcon(OpportunityType type) {
    switch (type) {
      case OpportunityType.event:
        return Icons.event_rounded;
      case OpportunityType.hackathon:
        return Icons.code_rounded;
      case OpportunityType.startup:
        return Icons.rocket_launch_rounded;
    }
  }
}