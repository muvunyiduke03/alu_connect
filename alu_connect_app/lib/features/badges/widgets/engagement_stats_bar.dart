import 'package:flutter/material.dart';
import '../models/engagement_badge_model.dart';

/// EngagementStatsBar — shows a breakdown of badge counts per event type.
/// Displayed at the top of StudentBadgesScreen below the identity header.
class EngagementStatsBar extends StatelessWidget {
  final Map<String, int> counts;
  final int total;

  const EngagementStatsBar({
    super.key,
    required this.counts,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E3454),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Engagement History',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623).withAlpha(38),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$total ${total == 1 ? 'badge' : 'badges'}',
                  style: const TextStyle(
                    color: Color(0xFFF5A623),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: EngagementBadgeModel.typeConfig.entries.map((entry) {
              final count = counts[entry.key] ?? 0;
              final color = Color(entry.value['color'] as int);
              return _StatChip(
                emoji: entry.value['emoji'] as String,
                label: entry.value['label'] as String,
                count: count,
                color: color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String emoji;
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.emoji,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = count > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withAlpha(isActive ? 38 : 13),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? color.withAlpha(128) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: TextStyle(
              color: isActive ? color : const Color(0xFF8A91B4),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
