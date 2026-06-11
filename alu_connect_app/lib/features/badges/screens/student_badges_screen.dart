import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/badges_provider.dart';
import '../widgets/engagement_badge_card.dart';
import '../widgets/engagement_stats_bar.dart';

/// StudentBadgesScreen
///
/// Displays a student's full badge collection and engagement stats.
/// Reached from the Profile tab by tapping "My Engagement Badges".
///
/// Usage:
///   Navigator.push(context, MaterialPageRoute(builder: (_) =>
///     StudentBadgesScreen(
///       studentId: currentUser.id,
///       studentName: currentUser.name,
///     )));
class StudentBadgesScreen extends StatefulWidget {
  final String studentId;
  final String studentName;

  const StudentBadgesScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<StudentBadgesScreen> createState() => _StudentBadgesScreenState();
}

class _StudentBadgesScreenState extends State<StudentBadgesScreen> {
  @override
  void initState() {
    super.initState();
    // Load badges after first frame so Provider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BadgesProvider>().loadBadgesForStudent(widget.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1F36),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1F36),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Engagement Badges',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined,
                color: Color(0xFFF5A623), size: 22),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Consumer<BadgesProvider>(
        builder: (context, provider, _) {
          // Loading state
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFF5A623)),
            );
          }

          // Error state
          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('⚠️', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF8A91B4), fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadBadgesForStudent(widget.studentId);
                    },
                    child: const Text('Try again',
                        style: TextStyle(color: Color(0xFFF5A623))),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFFF5A623),
            backgroundColor: const Color(0xFF2E3454),
            onRefresh: () =>
                provider.loadBadgesForStudent(widget.studentId),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Student identity header
                _StudentHeader(
                  name: widget.studentName,
                  totalBadges: provider.totalBadges,
                ),

                const SizedBox(height: 24),

                // Engagement stats breakdown
                EngagementStatsBar(
                  counts: provider.badgeCounts,
                  total: provider.totalBadges,
                ),

                const SizedBox(height: 24),

                // Section header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Badges',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (provider.totalBadges > 0)
                      Text(
                        '${provider.totalBadges} total',
                        style: const TextStyle(
                            color: Color(0xFF8A91B4), fontSize: 13),
                      ),
                  ],
                ),

                const SizedBox(height: 14),

                if (provider.studentBadges.isEmpty)
                  const _EmptyBadgesState()
                else
                  ...provider.studentBadges
                      .map((b) => EngagementBadgeCard(badge: b)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _StudentHeader extends StatelessWidget {
  final String name;
  final int totalBadges;

  const _StudentHeader({required this.name, required this.totalBadges});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFFF5A623).withAlpha(51),
          child: Text(
            _initials,
            style: const TextStyle(
              color: Color(0xFFF5A623),
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '$totalBadges verified engagement${totalBadges == 1 ? '' : 's'}',
              style: const TextStyle(
                color: Color(0xFF8A91B4),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmptyBadgesState extends StatelessWidget {
  const _EmptyBadgesState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: const [
          Text('🎖️', style: TextStyle(fontSize: 52)),
          SizedBox(height: 16),
          Text(
            'No badges yet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Attend events and get marked as\npresent by organizers to earn badges.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color(0xFF8A91B4), fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}
