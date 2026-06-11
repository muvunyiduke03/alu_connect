import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/badge_model.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../providers/event_provider.dart';
import 'settings_screen.dart';
import '../features/badges/screens/student_badges_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _editingBio = false;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final user = context.read<UserProvider>().user;
    _bioController = TextEditingController(text: user.bio);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Color _avatarColor(String name) {
    if (name.isEmpty) return AppColors.navyBlue;
    const colors = [
      Color(0xFFE53935),
      Color(0xFF8E24AA),
      Color(0xFF1E88E5),
      Color(0xFF43A047),
      Color(0xFFFF8F00),
      Color(0xFF00ACC1),
      Color(0xFFAD1457),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, EventProvider>(
      builder: (context, userProvider, eventProvider, _) {
        final user = userProvider.user;
        return Scaffold(
          backgroundColor: AppColors.offWhite,
          body: Column(
            children: [
              _buildProfileHeader(context, user),
              // TabBar
              Container(
                color: AppColors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: AppColors.red,
                  unselectedLabelColor: AppColors.gray,
                  indicatorColor: AppColors.red,
                  indicatorWeight: 2.5,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: 'About'),
                    Tab(text: 'My Events'),
                  ],
                ),
              ),
              // Tab views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAboutTab(context, user, eventProvider),
                    _buildMyEventsTab(context, eventProvider),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserModel user) {
    return Container(
      color: AppColors.navyBlue,
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 24),
      child: Column(
        children: [
          // Top row: spacer + settings icon
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white70,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _avatarColor(user.name),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                user.initials,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          // Role + intake chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _headerChip(user.role, AppColors.red),
              const SizedBox(width: 8),
              _headerChip(user.intake, Colors.white.withValues(alpha: 0.15)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerChip(String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildAboutTab(
    BuildContext context,
    UserModel user,
    EventProvider eventProvider,
  ) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Bio section
        _sectionHeader('Bio', trailing: GestureDetector(
          onTap: () {
            if (_editingBio) {
              context.read<UserProvider>().updateBio(_bioController.text.trim());
            }
            setState(() => _editingBio = !_editingBio);
          },
          child: Text(
            _editingBio ? 'Save' : 'Edit',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.red,
            ),
          ),
        )),
        const SizedBox(height: 8),
        _editingBio
            ? TextField(
                controller: _bioController,
                maxLines: 3,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Tell people about yourself...',
                  hintStyle: const TextStyle(color: AppColors.gray),
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.lightGray),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.red, width: 1.5),
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user.bio.isEmpty
                      ? 'No bio yet. Tap Edit to add one.'
                      : user.bio,
                  style: TextStyle(
                    fontSize: 14,
                    color: user.bio.isEmpty ? AppColors.gray : AppColors.navyBlue,
                    height: 1.5,
                    fontStyle: user.bio.isEmpty
                        ? FontStyle.italic
                        : FontStyle.normal,
                  ),
                ),
              ),
        const SizedBox(height: 24),

        // Interests section
        _sectionHeader('Interests'),
        const SizedBox(height: 10),
        user.interests.isEmpty
            ? _emptyState(
                'No interests set yet.',
                'Go to Settings → Edit Interests.',
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: user.interests.map((interest) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.navyBlue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.navyBlue.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Text(
                      interest,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navyBlue,
                      ),
                    ),
                  );
                }).toList(),
              ),
        const SizedBox(height: 24),

        // Gamification Badges section
        _sectionHeader(
          'Badges',
          trailing: TextButton.icon(
            onPressed: () {
              final user = context.read<UserProvider>().user;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StudentBadgesScreen(
                    studentId: user.id,
                    studentName: user.name,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.workspace_premium_rounded,
              size: 14,
              color: AppColors.red,
            ),
            label: const Text(
              'Engagement',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.red,
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildBadgesGrid(eventProvider.badges),
      ],
    );
  }

  Widget _buildBadgesGrid(List<BadgeModel> badges) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _BadgeTile(badge: badge);
      },
    );
  }

  Widget _buildMyEventsTab(BuildContext context, EventProvider eventProvider) {
    final rsvpdEvents = eventProvider.rsvpdEvents;

    if (rsvpdEvents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_note_rounded,
              color: AppColors.lightGray,
              size: 56,
            ),
            const SizedBox(height: 14),
            const Text(
              'No events yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.navyBlue,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'RSVP to events in the Feed to\nsee them here.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          '${rsvpdEvents.length} event${rsvpdEvents.length == 1 ? '' : 's'} coming up',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
          ),
        ),
        const SizedBox(height: 12),
        ...rsvpdEvents.map(
          (event) => _MyEventCard(event: event),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.navyBlue,
            letterSpacing: -0.3,
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _emptyState(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.gray,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: AppColors.gray),
          ),
        ],
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  final BadgeModel badge;

  const _BadgeTile({required this.badge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: badge.isUnlocked
            ? badge.color.withValues(alpha: 0.1)
            : AppColors.lightGray.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: badge.isUnlocked
              ? badge.color.withValues(alpha: 0.3)
              : AppColors.lightGray,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                badge.icon,
                size: 32,
                color: badge.isUnlocked ? badge.color : AppColors.gray,
              ),
              if (!badge.isUnlocked)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.gray,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      size: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: badge.isUnlocked ? badge.color : AppColors.gray,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MyEventCard extends StatelessWidget {
  final EventModel event;

  const _MyEventCard({required this.event});

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Row(
          children: [
            Container(width: 5, height: 90, color: event.accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navyBlue,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: AppColors.gray,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${_formatDate(event.date)}  ·  ${event.time}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 12,
                                color: AppColors.gray,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  event.location,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.gray,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Un-RSVP button
                    GestureDetector(
                      onTap: () => context
                          .read<EventProvider>()
                          .toggleRsvp(event.id),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.errorBox,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
