import 'package:flutter/material.dart';
import '../models/community_model.dart';

class CommunityPostCard extends StatelessWidget {
  final CommunityPost post;
  final Color communityColor;
  final VoidCallback onLikeTap;

  const CommunityPostCard({
    super.key,
    required this.post,
    required this.communityColor,
    required this.onLikeTap,
  });

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${diff.inDays ~/ 7}w ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author row
            Row(
              children: [
                // Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: post.authorAvatarColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      post.authorInitials,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF100774),
                        ),
                      ),
                      Text(
                        _timeAgo(post.timestamp),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A8A8A),
                        ),
                      ),
                    ],
                  ),
                ),
                if (post.isPinned)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFD54F)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.push_pin_rounded, size: 10, color: Color(0xFFFF8F00)),
                        SizedBox(width: 3),
                        Text(
                          'Pinned',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF8F00),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // Content
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A2E),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            // Divider + action row
            Divider(color: const Color(0xFFE8E6E1), height: 1, thickness: 1),
            const SizedBox(height: 10),

            Row(
              children: [
                // Like button
                GestureDetector(
                  onTap: onLikeTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          post.isLiked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(post.isLiked),
                          size: 20,
                          color: post.isLiked
                              ? const Color(0xFFD92B2B)
                              : const Color(0xFF8A8A8A),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${post.likeCount}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: post.isLiked
                              ? const Color(0xFFD92B2B)
                              : const Color(0xFF8A8A8A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
