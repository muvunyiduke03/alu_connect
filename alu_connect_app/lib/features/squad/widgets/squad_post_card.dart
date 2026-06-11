import 'package:flutter/material.dart';
import '../models/squad_model.dart';

class SquadPostCard extends StatelessWidget {
  final SquadPost post;
  final VoidCallback onInterestTap;
  final VoidCallback? onTap;

  const SquadPostCard({
    super.key,
    required this.post,
    required this.onInterestTap,
    this.onTap,
  });

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hackathon tag strip
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFF2F0EB),
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt_rounded,
                      size: 13, color: Color(0xFF8A8A8A)),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      post.hackathonTitle,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5A5A5A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _timeAgo(post.timestamp),
                    style: const TextStyle(
                        fontSize: 10, color: Color(0xFF8A8A8A)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Poster row
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: post.posterAvatarColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            post.initials,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.posterName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF100774),
                            ),
                          ),
                          Text(
                            post.cohort,
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF8A8A8A)),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Text(
                    post.description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2D2D2D),
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // My skills → I bring
                  _SkillRow(
                    label: 'I bring',
                    skills: post.mySkills,
                    color: const Color(0xFF1565C0),
                    bgColor: const Color(0xFFE3F2FD),
                  ),
                  const SizedBox(height: 6),

                  // Seeking skills → Looking for
                  _SkillRow(
                    label: 'Need',
                    skills: post.seekingSkills,
                    color: const Color(0xFFD92B2B),
                    bgColor: const Color(0xFFFFEBEE),
                  ),

                  const SizedBox(height: 12),

                  Divider(color: const Color(0xFFE8E6E1), height: 1),

                  const SizedBox(height: 10),

                  // Footer row
                  Row(
                    children: [
                      // Contact handle
                      Row(
                        children: [
                          const Icon(Icons.alternate_email_rounded,
                              size: 13, color: Color(0xFF8A8A8A)),
                          const SizedBox(width: 4),
                          Text(
                            post.contactHandle,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF8A8A8A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Interested button
                      GestureDetector(
                        onTap: onInterestTap,
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: post.isInterested
                                ? const Color(0xFF100774)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF100774),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                post.isInterested
                                    ? Icons.check_rounded
                                    : Icons.waving_hand_rounded,
                                size: 13,
                                color: post.isInterested
                                    ? Colors.white
                                    : const Color(0xFF100774),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                post.isInterested
                                    ? 'Interested ✓'
                                    : 'I\'m in! (${post.interestedCount})',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: post.isInterested
                                      ? Colors.white
                                      : const Color(0xFF100774),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _SkillRow extends StatelessWidget {
  final String label;
  final List<String> skills;
  final Color color;
  final Color bgColor;

  const _SkillRow({
    required this.label,
    required this.skills,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Wrap(
            spacing: 5,
            runSpacing: 4,
            children: skills
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
