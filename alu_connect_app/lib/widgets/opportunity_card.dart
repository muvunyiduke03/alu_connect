import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/opportunity_model.dart';
import '../constants/app_colors.dart';

class OpportunityCard extends StatelessWidget {
  final OpportunityModel opportunity;
  final VoidCallback onTap;
  final VoidCallback onRsvpTap;
  final bool isRsvpd;

  const OpportunityCard({
    super.key,
    required this.opportunity,
    required this.onTap,
    required this.onRsvpTap,
    required this.isRsvpd,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(opportunity.date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with tag and RSVP
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
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
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: opportunity.tagColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onRsvpTap,
                    child: Icon(
                      isRsvpd ? Icons.bookmark : Icons.bookmark_outline,
                      color: isRsvpd ? AppColors.red : AppColors.gray,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                opportunity.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navyBlue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Date, Time, Location
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.gray,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$formattedDate at ${opportunity.time}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.gray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: AppColors.gray,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          opportunity.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Footer: Category, Organizer, RSVP Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity.category,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.gray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              opportunity.organizer.avatar,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                opportunity.organizer.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.navyBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.offWhite,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${opportunity.rsvpCount} RSVPs',
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
          ],
        ),
      ),
    );
  }
}
