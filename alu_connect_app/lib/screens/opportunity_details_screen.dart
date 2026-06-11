import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/feed_provider.dart';
import '../providers/user_provider.dart';
import '../models/opportunity_model.dart';
import '../constants/app_colors.dart';
import '../features/badges/screens/organizer_attendance_screen.dart';

class OpportunityDetailsScreen extends StatefulWidget {
  final String opportunityId;

  const OpportunityDetailsScreen({super.key, required this.opportunityId});

  @override
  State<OpportunityDetailsScreen> createState() =>
      _OpportunityDetailsScreenState();
}

class _OpportunityDetailsScreenState extends State<OpportunityDetailsScreen> {
  late OpportunityModel opportunity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    opportunity = feedProvider.getOpportunityById(widget.opportunityId)!;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMMM dd, yyyy');
    final formattedDate = dateFormat.format(opportunity.date);

    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text(
          'Opportunity',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        actions: [
          Consumer<FeedProvider>(
            builder: (context, feedProvider, _) {
              final isRsvpd = feedProvider.isRsvpd(widget.opportunityId);
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        feedProvider.toggleRsvp(widget.opportunityId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isRsvpd
                                  ? 'Removed from your opportunities'
                                  : 'Added to your opportunities',
                            ),
                            backgroundColor:
                                isRsvpd ? AppColors.gray : AppColors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Icon(
                        isRsvpd ? Icons.bookmark : Icons.bookmark_outline,
                        color: isRsvpd ? AppColors.red : AppColors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: _shareOpportunity,
                      child: const Icon(Icons.share_outlined, size: 22),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Tag & Category
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: opportunity.tagColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: opportunity.tagColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      opportunity.typeLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: opportunity.tagColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      opportunity.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navyBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                opportunity.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyBlue,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Date, Time, Location Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date & Time',
                      value: '$formattedDate at ${opportunity.time}',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: opportunity.location,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    opportunity.description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.gray,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSquadSection(),
            const SizedBox(height: 20),
            // Organizer Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Organizer',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navyBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          opportunity.organizer.avatar,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                opportunity.organizer.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.navyBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Event Organizer',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // RSVP Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Already Attending',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gray,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${opportunity.rsvpCount}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.red,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.group_rounded,
                      size: 48,
                      color: AppColors.red.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      // Floating organizer action: Mark Attendance & Award Badges
      bottomNavigationBar: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final isOrganizer = userProvider.user.role == 'Organizer' ||
              userProvider.user.role == 'Club Leader';
          if (!isOrganizer) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrganizerAttendanceScreen(
                        eventId: opportunity.id,
                        eventName: opportunity.title,
                        eventType: opportunity.type.name,
                        organizerName: userProvider.user.name,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.how_to_reg_rounded, size: 18),
                label: const Text(
                  'Mark Attendance & Award Badges',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.navyBlue,
                  side: const BorderSide(color: AppColors.navyBlue, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) 
  {
    return Row(
      children: [
        Icon(icon, color: AppColors.red, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.gray,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navyBlue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

    Widget _buildSquadSection() {
    // Only show for hackathons and startups
    if (opportunity.type != OpportunityType.hackathon &&
        opportunity.type != OpportunityType.startup) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Consumer<FeedProvider>(
        builder: (context, feedProvider, _) {
          final isLooking = feedProvider.isLookingForTeammates(opportunity.id);
          final seekers = feedProvider.getTeammateSeekers(opportunity.id);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find a Squad',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyBlue,
                ),
              ),
              const SizedBox(height: 12),

              // Toggle card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Looking for teammates?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navyBlue,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isLooking
                                ? 'You\'re visible to other students'
                                : 'Let others know you need a team',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isLooking,
                      activeColor: AppColors.red,
                      onChanged: (value) {
                        if (value) {
                          _showSkillDialog(context, feedProvider);
                        } else {
                          feedProvider.toggleLookingForTeammates(
                            opportunity.id,
                            '', // not used when turning off
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // List of current seekers
              if (seekers.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'No one is looking for teammates yet. Be the first!',
                    style: const TextStyle(fontSize: 13, color: AppColors.gray),
                  ),
                )
              else
                ...seekers.map((seeker) {
                  final parts = seeker.split(' - ');
                  final name = parts[0];
                  final skill = parts.length > 1 ? parts[1] : '';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.red.withValues(alpha: 0.1),
                          child: Text(
                            name.isNotEmpty ? name[0] : '?',
                            style: const TextStyle(
                              color: AppColors.red,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navyBlue,
                                ),
                              ),
                              if (skill.isNotEmpty)
                                Text(
                                  skill,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.gray,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
  
  void _showSkillDialog(BuildContext context, FeedProvider feedProvider) {
  final TextEditingController skillController = TextEditingController();
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('What can you bring to a team?'),
        content: TextField(
          controller: skillController,
          decoration: const InputDecoration(
            hintText: 'e.g. Frontend Development, UI/UX Design',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final skill = skillController.text.trim();
              if (skill.isEmpty) return;

              final entry = '${userProvider.user.name} - $skill';
              feedProvider.toggleLookingForTeammates(opportunity.id, entry);
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

  void _shareOpportunity() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shared: ${opportunity.title}'),
        backgroundColor: AppColors.navyBlue,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
