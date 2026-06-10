import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/feed_provider.dart';
import '../models/opportunity_model.dart';
import '../constants/app_colors.dart';

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
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
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
