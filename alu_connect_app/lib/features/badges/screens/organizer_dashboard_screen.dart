import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../providers/event_provider.dart';
import '../../../providers/feed_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../models/opportunity_model.dart';
import '../../badges/screens/organizer_attendance_screen.dart';

class OrganizerDashboardScreen extends StatefulWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  State<OrganizerDashboardScreen> createState() =>
      _OrganizerDashboardScreenState();
}

class _OrganizerDashboardScreenState extends State<OrganizerDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _broadcastController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _broadcastController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _typeColor(OpportunityType type) {
    switch (type) {
      case OpportunityType.event:
        return const Color(0xFF1565C0);
      case OpportunityType.hackathon:
        return const Color(0xFFE65100);
      case OpportunityType.startup:
        return const Color(0xFF2E7D32);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Consumer3<UserProvider, EventProvider, FeedProvider>(
      builder: (context, userProvider, eventProvider, feedProvider, _) {
        final user = userProvider.user;
        // Events from EventProvider (calendar-style events)
        final myEvents = eventProvider.events;
        // Opportunities the user "created" — for demo we take all from FeedProvider
        final myOpps = feedProvider.opportunities;

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              _buildHeader(context, user, myEvents.length, myOpps.length),
            ],
            body: Column(
              children: [
                // Tab bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFFE65100),
                    unselectedLabelColor: AppColors.gray,
                    indicatorColor: const Color(0xFFE65100),
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(icon: Icon(Icons.event_note_rounded, size: 18), text: 'Events'),
                      Tab(icon: Icon(Icons.rocket_launch_rounded, size: 18), text: 'Opportunities'),
                      Tab(icon: Icon(Icons.campaign_rounded, size: 18), text: 'Broadcast'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEventsTab(context, user, eventProvider, myEvents),
                      _buildOppsTab(context, user, feedProvider, myOpps),
                      _buildBroadcastTab(context, user, eventProvider),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, dynamic user, int eventCount, int oppCount) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xFF1A0F9E),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF100774), Color(0xFFE65100)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(right: -40, top: -40, child: _circle(160, 0.06)),
              Positioned(left: -20, bottom: -30, child: _circle(120, 0.05)),
              Positioned(right: 60, bottom: 20, child: _circle(50, 0.08)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 56, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.dashboard_customize_rounded,
                                    color: Colors.white, size: 12),
                                SizedBox(width: 5),
                                Text(
                                  'ORGANIZER MODE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Hi, ${user.name.split(' ').first} 👋',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Manage your events, view RSVPs & broadcast messages.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Stat row
                      Row(
                        children: [
                          _statChip(Icons.event_rounded, '$eventCount', 'Events'),
                          const SizedBox(width: 10),
                          _statChip(Icons.people_rounded, '—', 'Attendees'),
                          const SizedBox(width: 10),
                          _statChip(Icons.rocket_launch_rounded, '$oppCount', 'Opportunities'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circle(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: opacity),
        ),
      );

  Widget _statChip(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 9, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Tab 1: Events ─────────────────────────────────────────────────────────

  Widget _buildEventsTab(
    BuildContext context,
    dynamic user,
    EventProvider eventProvider,
    List<EventModel> events,
  ) {
    if (events.isEmpty) {
      return _emptyState(
        Icons.event_note_rounded,
        'No events yet',
        'Events you create will appear here.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: events.length,
      itemBuilder: (context, i) {
        final event = events[i];
        final isRsvpd = eventProvider.isRsvpd(event.id);
        // Simulate RSVP count: events RSVPd by "others"
        final rsvpCount = (event.id.hashCode % 40).abs() + 8;

        return _EventOrganizerCard(
          event: event,
          rsvpCount: rsvpCount,
          onMarkAttendance: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OrganizerAttendanceScreen(
                eventId: event.id,
                eventName: event.title,
                eventType: _categoryToEventType(event.category),
                organizerName: user.name,
              ),
            ),
          ),
          formatDate: _formatDate,
          isRsvpd: isRsvpd,
        );
      },
    );
  }

  String _categoryToEventType(String category) {
    final lower = category.toLowerCase();
    if (lower.contains('hack')) return 'hackathon';
    if (lower.contains('lead')) return 'leadership';
    if (lower.contains('startup') || lower.contains('entrepreneur')) return 'startup';
    if (lower.contains('community') || lower.contains('social')) return 'community';
    return 'workshop';
  }

  // ── Tab 2: Opportunities ──────────────────────────────────────────────────

  Widget _buildOppsTab(
    BuildContext context,
    dynamic user,
    FeedProvider feedProvider,
    List<OpportunityModel> opps,
  ) {
    if (opps.isEmpty) {
      return _emptyState(
        Icons.rocket_launch_rounded,
        'No opportunities posted',
        'Create opportunities from the Feed screen.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      itemCount: opps.length,
      itemBuilder: (context, i) {
        final opp = opps[i];
        return _OppManagerCard(
          opp: opp,
          isRsvpd: feedProvider.isRsvpd(opp.id),
          onDelete: () => _confirmDelete(context, feedProvider, opp),
          typeColor: _typeColor(opp.type),
          formatDate: _formatDate,
        );
      },
    );
  }

  void _confirmDelete(
      BuildContext context, FeedProvider feedProvider, OpportunityModel opp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Opportunity',
          style: TextStyle(
            color: AppColors.navyBlue,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Remove "${opp.title}" from the feed? This cannot be undone.',
          style: const TextStyle(color: AppColors.gray, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.gray)),
          ),
          ElevatedButton(
            onPressed: () {
              feedProvider.deleteOpportunity(opp.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${opp.title}" removed from feed.'),
                  backgroundColor: AppColors.navyBlue,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // ── Tab 3: Broadcast ──────────────────────────────────────────────────────

  Widget _buildBroadcastTab(
    BuildContext context,
    dynamic user,
    EventProvider eventProvider,
  ) {
    final rsvpdEvents = eventProvider.rsvpdEvents;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF100774), Color(0xFF1A0F9E)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.campaign_rounded,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Broadcast Message',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Send announcements to all students who RSVPed to your events.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Select target event
        const Text(
          'Target Event',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navyBlue,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        if (rsvpdEvents.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'RSVP to events first to enable targeting',
              style: TextStyle(color: AppColors.gray, fontSize: 13),
            ),
          )
        else
          ...rsvpdEvents.map(
            (e) => _BroadcastTargetTile(event: e, accentColor: e.accentColor),
          ),

        const SizedBox(height: 20),

        // Message composer
        const Text(
          'Your Message',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.navyBlue,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _broadcastController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText:
                'e.g. "Reminder: bring your laptop tomorrow! Doors open at 9am sharp. Can\'t wait to see you all 🔥"',
            hintStyle: const TextStyle(color: AppColors.gray, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  const BorderSide(color: Color(0xFFE65100), width: 1.5),
            ),
            contentPadding: const EdgeInsets.all(14),
          ),
        ),
        const SizedBox(height: 16),

        // Quick templates
        const Text(
          'Quick Templates',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.gray,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _templateChip('📍 Location reminder', context),
            _templateChip('⏰ Time reminder', context),
            _templateChip('✅ Confirmed! See you there', context),
            _templateChip('🙏 Thank you for joining!', context),
          ],
        ),
        const SizedBox(height: 20),

        // Send button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _sendBroadcast(context),
            icon: const Icon(Icons.send_rounded, size: 18),
            label: const Text(
              'Send Broadcast',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE65100),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _templateChip(String text, BuildContext context) {
    return GestureDetector(
      onTap: () => _broadcastController.text = text,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFE65100).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: const Color(0xFFE65100).withValues(alpha: 0.25)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE65100),
          ),
        ),
      ),
    );
  }

  void _sendBroadcast(BuildContext context) {
    final msg = _broadcastController.text.trim();
    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please write a message first.'),
          backgroundColor: AppColors.navyBlue,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    _broadcastController.clear();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE65100).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_rounded,
                  color: Color(0xFFE65100), size: 44),
            ),
            const SizedBox(height: 16),
            const Text(
              'Broadcast Sent!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.navyBlue,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your message has been delivered to all RSVPed attendees.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE65100),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  elevation: 0,
                ),
                child: const Text('Done',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared empty state ─────────────────────────────────────────────────────

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFE65100).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: const Color(0xFFE65100)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.navyBlue,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.gray,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Event Organizer Card ───────────────────────────────────────────────────

class _EventOrganizerCard extends StatelessWidget {
  final EventModel event;
  final int rsvpCount;
  final VoidCallback onMarkAttendance;
  final String Function(DateTime) formatDate;
  final bool isRsvpd;

  const _EventOrganizerCard({
    required this.event,
    required this.rsvpCount,
    required this.onMarkAttendance,
    required this.formatDate,
    required this.isRsvpd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: event.accentColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [
            // Coloured top stripe
            Container(
              height: 5,
              color: event.accentColor,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + category
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.navyBlue,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: event.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.category,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: event.accentColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Date + location
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 12, color: AppColors.gray),
                      const SizedBox(width: 5),
                      Text(
                        '${formatDate(event.date)}  ·  ${event.time}',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.gray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: AppColors.gray),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          event.location,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.gray),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // RSVP count + mark attendance
                  Row(
                    children: [
                      // RSVP count badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: event.accentColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.people_rounded,
                                size: 14, color: event.accentColor),
                            const SizedBox(width: 6),
                            Text(
                              '$rsvpCount RSVPs',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: event.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Mark attendance button
                      GestureDetector(
                        onTap: onMarkAttendance,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF100774),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.fact_check_rounded,
                                  size: 14, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'Mark Attendance',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
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

// ── Opportunity Manager Card ───────────────────────────────────────────────

class _OppManagerCard extends StatelessWidget {
  final OpportunityModel opp;
  final bool isRsvpd;
  final VoidCallback onDelete;
  final Color typeColor;
  final String Function(DateTime) formatDate;

  const _OppManagerCard({
    required this.opp,
    required this.isRsvpd,
    required this.onDelete,
    required this.typeColor,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            Row(
              children: [
                // Type tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    opp.typeLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: typeColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (opp.isFeatured)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8F00).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '⭐ Featured',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFF8F00),
                      ),
                    ),
                  ),
                const Spacer(),
                // Delete button
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.errorBox,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline_rounded,
                        size: 16, color: AppColors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              opp.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.navyBlue,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.gray),
                const SizedBox(width: 5),
                Text(
                  '${formatDate(opp.date)}  ·  ${opp.time}',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.gray),
                ),
                const Spacer(),
                const Icon(Icons.people_outline_rounded,
                    size: 13, color: AppColors.gray),
                const SizedBox(width: 4),
                Text(
                  '${opp.rsvpCount} RSVPs',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 12, color: AppColors.gray),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    opp.location,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.gray),
                    overflow: TextOverflow.ellipsis,
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

// ── Broadcast Target Tile ─────────────────────────────────────────────────

class _BroadcastTargetTile extends StatelessWidget {
  final EventModel event;
  final Color accentColor;

  const _BroadcastTargetTile({
    required this.event,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 36,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navyBlue,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  event.organizer,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.gray),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.people_rounded, size: 11, color: accentColor),
                const SizedBox(width: 4),
                Text(
                  'RSVPed',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
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
