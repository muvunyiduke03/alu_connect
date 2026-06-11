import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/engagement_badge_model.dart';

/// BadgeCard — displays a single earned engagement badge.
/// Used inside StudentBadgesScreen's badge list.
class EngagementBadgeCard extends StatelessWidget {
  final EngagementBadgeModel badge;

  const EngagementBadgeCard({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final config = EngagementBadgeModel.typeConfig[badge.eventType] ??
        EngagementBadgeModel.typeConfig['community']!;
    final color = Color(config['color'] as int);
    final emoji = config['emoji'] as String;
    final label = config['label'] as String;
    final formattedDate = DateFormat('MMM d, yyyy').format(badge.awardedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E3454),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(102), width: 1),
      ),
      child: Row(
        children: [
          // Badge icon circle
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha(38),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),

          // Badge info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.eventName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Type pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withAlpha(51),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (badge.isVerified) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.verified,
                          color: Color(0xFFF5A623), size: 14),
                      const SizedBox(width: 3),
                      const Text(
                        'Verified',
                        style: TextStyle(
                          color: Color(0xFFF5A623),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$formattedDate · Awarded by ${badge.awardedBy}',
                  style: const TextStyle(
                    color: Color(0xFF8A91B4),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
