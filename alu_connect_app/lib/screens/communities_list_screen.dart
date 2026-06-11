import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/mock_communities.dart';
import 'community_room_screen.dart';

class CommunitiesListScreen extends StatefulWidget {
  const CommunitiesListScreen({super.key});

  @override
  State<CommunitiesListScreen> createState() => _CommunitiesListScreenState();
}

class _CommunitiesListScreenState extends State<CommunitiesListScreen> {

  // Tracks which communities the user has joined (by id)
  final Set<String> _joinedIds = {};

  void _toggleJoin(String communityId) {
    setState(() {
      if (_joinedIds.contains(communityId)) {
        _joinedIds.remove(communityId);
      } else {
        _joinedIds.add(communityId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [

            // Header
            Container(
              width: double.infinity,
              color: AppColors.navyBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Communities',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Clubs, cohorts, and teams at ALU',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),

            // List of communities
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: mockCommunities.length,
                itemBuilder: (context, index) {
                  final community = mockCommunities[index];
                  final bool joined = _joinedIds.contains(community.id);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.lightGray),
                    ),
                    child: Row(
                      children: [

                        // Icon
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _categoryIcon(community.category),
                            color: AppColors.red,
                            size: 22,
                          ),
                        ),

                        const SizedBox(width: 14),

                        // Name + description + member count
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CommunityRoomScreen(
                                    community: community,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  community.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navyBlue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  community.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.group_outlined,
                                        size: 13, color: AppColors.gray),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${community.memberCount} members',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Join / Joined button
                        GestureDetector(
                          onTap: () => _toggleJoin(community.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: joined ? AppColors.offWhite : AppColors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: joined
                                  ? Border.all(color: AppColors.lightGray)
                                  : null,
                            ),
                            child: Text(
                              joined ? 'Joined' : 'Join',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: joined ? AppColors.gray : Colors.white,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  // Pick an icon based on the community's category
  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Tech':
        return Icons.code_rounded;
      case 'Entrepreneurship':
        return Icons.lightbulb_outline_rounded;
      case 'Cohort':
        return Icons.groups_rounded;
      default:
        return Icons.group_outlined;
    }
  }
}