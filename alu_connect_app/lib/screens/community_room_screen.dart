import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/mock_communities.dart';
import 'chat_screen.dart';

class CommunityRoomScreen extends StatelessWidget {
  final Community community;

  const CommunityRoomScreen({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [

            // Header with back button
            Container(
              width: double.infinity,
              color: AppColors.navyBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          community.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Row(
                      children: [
                        const Icon(Icons.group_outlined, size: 13, color: Colors.white60),
                        const SizedBox(width: 4),
                        Text(
                          '${community.memberCount} members',
                          style: const TextStyle(fontSize: 12, color: Colors.white60),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [

                  // Description
                  Text(
                    community.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Pinned announcements section
                  if (community.announcements.isNotEmpty) ...[
                    const Text(
                      'PINNED ANNOUNCEMENTS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gray,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // One announcement card per item
                    ...community.announcements.map((announcement) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.errorBox,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.red.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.push_pin_rounded,
                              color: AppColors.red,
                              size: 16,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                announcement,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.navyBlue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],

                  // Open chat button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(community: community),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                              color: AppColors.navyBlue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Open Chat',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.navyBlue,
                                  ),
                                ),
                                Text(
                                  'Message members of this community',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: AppColors.gray,
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}