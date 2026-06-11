import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/opportunity_model.dart';
import '../providers/feed_provider.dart';
import '../providers/user_provider.dart';
import '../screens/opportunity_details_screen.dart';
import '../features/squad/screens/squad_board_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String? _activeCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Category definitions ──────────────────────────────────────────────────

  static const _categories = [
    {'label': 'Tech & Dev', 'icon': Icons.code_rounded, 'color': Color(0xFF1565C0), 'tag': 'Tech & Software'},
    {'label': 'Hackathons', 'icon': Icons.bolt_rounded, 'color': Color(0xFFE65100), 'tag': 'Hackathon'},
    {'label': 'Leadership', 'icon': Icons.workspace_premium_rounded, 'color': Color(0xFF6A1B9A), 'tag': 'Leadership'},
    {'label': 'Startups', 'icon': Icons.rocket_launch_rounded, 'color': Color(0xFF2E7D32), 'tag': 'Entrepreneurship'},
    {'label': 'Design', 'icon': Icons.palette_rounded, 'color': Color(0xFFAD1457), 'tag': 'Design'},
    {'label': 'Finance', 'icon': Icons.account_balance_rounded, 'color': Color(0xFF00695C), 'tag': 'Finance'},
    {'label': 'Social Impact', 'icon': Icons.favorite_rounded, 'color': Color(0xFFD92B2B), 'tag': 'Social Impact'},
    {'label': 'Culture', 'icon': Icons.theater_comedy_rounded, 'color': Color(0xFFFF8F00), 'tag': 'Arts & Culture'},
  ];

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<OpportunityModel> _filteredOpps(List<OpportunityModel> all) {
    var result = all;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((o) =>
              o.title.toLowerCase().contains(q) ||
              o.category.toLowerCase().contains(q) ||
              o.description.toLowerCase().contains(q) ||
              o.organizer.name.toLowerCase().contains(q))
          .toList();
    }
    if (_activeCategory != null) {
      result = result
          .where((o) =>
              o.category.toLowerCase().contains(_activeCategory!.toLowerCase()))
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F0EB),
      body: Consumer2<FeedProvider, UserProvider>(
        builder: (context, feedProvider, userProvider, _) {
          final allOpps = feedProvider.opportunities;
          final hackathons = allOpps
              .where((o) => o.type == OpportunityType.hackathon)
              .toList();
          final forYou = _forYouOpps(allOpps, userProvider);
          final filtered = _filteredOpps(allOpps);
          final isSearching =
              _searchQuery.isNotEmpty || _activeCategory != null;

          return CustomScrollView(
            slivers: [
              // ── App Bar ──────────────────────────────────────────────────
              SliverAppBar(
                pinned: true,
                expandedHeight: 130,
                backgroundColor: const Color(0xFF100774),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF100774), Color(0xFF1A0F9E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -30,
                          top: -30,
                          child: _circle(120, 0.06),
                        ),
                        Positioned(
                          left: -15,
                          bottom: 10,
                          child: _circle(80, 0.04),
                        ),
                        SafeArea(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20, 12, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Explore',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Hi ${userProvider.user.name.split(' ').first} 👋 — what\'s next for you?',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(56),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (q) => setState(() => _searchQuery = q),
                      style: const TextStyle(
                          fontSize: 14, color: Color(0xFF100774)),
                      decoration: InputDecoration(
                        hintText: 'Search events, skills, categories...',
                        hintStyle: const TextStyle(
                            color: Color(0xFF8A8A8A), fontSize: 13),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Color(0xFF8A8A8A), size: 18),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () => setState(() {
                                  _searchQuery = '';
                                  _searchController.clear();
                                }),
                                child: const Icon(Icons.close_rounded,
                                    color: Color(0xFF8A8A8A), size: 18),
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Search results ────────────────────────────────────────────
              if (isSearching) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
                    child: Row(
                      children: [
                        Text(
                          '${filtered.length} results',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF100774),
                          ),
                        ),
                        if (_activeCategory != null) ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _activeCategory = null),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF100774),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    _activeCategory!,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.close_rounded,
                                      size: 12, color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _CompactOppCard(
                      opp: filtered[i],
                      isRsvpd:
                          feedProvider.isRsvpd(filtered[i].id),
                      onTap: () => _openDetail(context, filtered[i].id),
                      onRsvp: () =>
                          feedProvider.toggleRsvp(filtered[i].id),
                    ),
                    childCount: filtered.length,
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 52, color: Color(0xFFE8E6E1)),
                            SizedBox(height: 14),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF100774),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Try a different keyword or category.',
                              style: TextStyle(
                                  fontSize: 13, color: Color(0xFF8A8A8A)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ] else ...[
                // ── Category grid ───────────────────────────────────────────
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                _SectionHeader(title: 'Browse by Category'),
                SliverToBoxAdapter(child: _buildCategoryGrid()),

                // ── For You ─────────────────────────────────────────────────
                if (forYou.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'For You',
                    subtitle:
                        'Based on your interests',
                  ),
                  SliverToBoxAdapter(
                    child: _buildHorizontalScroll(
                      context,
                      forYou,
                      feedProvider,
                    ),
                  ),
                ],

                // ── Squad Board CTA ─────────────────────────────────────────
                SliverToBoxAdapter(child: _buildSquadBoardCta(context)),

                // ── Hackathons ───────────────────────────────────────────────
                if (hackathons.isNotEmpty) ...[
                  _SectionHeader(
                    title: 'Hackathons',
                    subtitle: 'Compete, build, win',
                    actionLabel: 'See all',
                    onAction: () {},
                  ),
                  SliverToBoxAdapter(
                    child: _buildHorizontalScroll(
                      context,
                      hackathons,
                      feedProvider,
                      accent: const Color(0xFFE65100),
                    ),
                  ),
                ],

                // ── All opportunities ────────────────────────────────────────
                _SectionHeader(
                  title: 'All Opportunities',
                  subtitle:
                      '${allOpps.length} open right now',
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _CompactOppCard(
                      opp: allOpps[i],
                      isRsvpd: feedProvider.isRsvpd(allOpps[i].id),
                      onTap: () => _openDetail(context, allOpps[i].id),
                      onRsvp: () =>
                          feedProvider.toggleRsvp(allOpps[i].id),
                    ),
                    childCount: allOpps.length,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ],
          );
        },
      ),
    );
  }

  // ── For You filter ────────────────────────────────────────────────────────

  List<OpportunityModel> _forYouOpps(
      List<OpportunityModel> all, UserProvider userProvider) {
    final interests = userProvider.user.interests;
    if (interests.isEmpty) return all.take(4).toList();
    return all
        .where((o) => interests.any(
            (i) => o.category.toLowerCase().contains(i.toLowerCase())))
        .take(6)
        .toList();
  }

  // ── Category grid ─────────────────────────────────────────────────────────

  Widget _buildCategoryGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.85,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final isActive = _activeCategory == cat['tag'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _activeCategory =
                    isActive ? null : cat['tag'] as String;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isActive
                    ? (cat['color'] as Color)
                    : Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: isActive
                        ? (cat['color'] as Color).withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.04),
                    blurRadius: isActive ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    cat['icon'] as IconData,
                    size: 26,
                    color: isActive
                        ? Colors.white
                        : cat['color'] as Color,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isActive
                          ? Colors.white
                          : const Color(0xFF100774),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Horizontal scroll card row ────────────────────────────────────────────

  Widget _buildHorizontalScroll(
    BuildContext context,
    List<OpportunityModel> opps,
    FeedProvider feedProvider, {
    Color accent = const Color(0xFF100774),
  }) {
    return SizedBox(
      height: 188,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        itemCount: opps.length,
        itemBuilder: (context, i) {
          final opp = opps[i];
          final isRsvpd = feedProvider.isRsvpd(opp.id);
          return GestureDetector(
            onTap: () => _openDetail(context, opp.id),
            child: Container(
              width: 220,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: opp.tagColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Color band
                    Container(height: 4, color: opp.tagColor),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 3),
                                decoration: BoxDecoration(
                                  color: opp.tagColor
                                      .withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                                child: Text(
                                  opp.typeLabel,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: opp.tagColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () =>
                                    feedProvider.toggleRsvp(opp.id),
                                child: Icon(
                                  isRsvpd
                                      ? Icons.bookmark_rounded
                                      : Icons.bookmark_outline_rounded,
                                  size: 18,
                                  color: isRsvpd
                                      ? AppColors.red
                                      : const Color(0xFF8A8A8A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            opp.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF100774),
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today_outlined,
                                  size: 11,
                                  color: Color(0xFF8A8A8A)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${_mon(opp.date.month)} ${opp.date.day}  ·  ${opp.time}',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF8A8A8A)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 11,
                                  color: Color(0xFF8A8A8A)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  opp.location,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF8A8A8A)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                opp.organizer.avatar,
                                style:
                                    const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  opp.organizer.name,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF100774),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${opp.rsvpCount} RSVPs',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: opp.tagColor,
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
            ),
          );
        },
      ),
    );
  }

  // ── Squad Board CTA ────────────────────────────────────────────────────────

  Widget _buildSquadBoardCta(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SquadBoardScreen()),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFE65100), Color(0xFFFF8F00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFE65100).withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              top: -15,
              child: _circle(90, 0.1),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.group_add_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚡  Squad Board',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Find teammates for hackathons by skill',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OpportunityDetailsScreen(opportunityId: id),
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

  static String _mon(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[m - 1];
  }
}

// ── Shared Section Header ─────────────────────────────────────────────────

class _SectionHeader extends SliverToBoxAdapter {
  _SectionHeader({
    required String title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) : super(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF100774),
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFF8A8A8A)),
                        ),
                    ],
                  ),
                ),
                if (actionLabel != null && onAction != null)
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionLabel,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFD92B2B),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
}

// ── Compact Opportunity Card (list view) ──────────────────────────────────

class _CompactOppCard extends StatelessWidget {
  final OpportunityModel opp;
  final bool isRsvpd;
  final VoidCallback onTap;
  final VoidCallback onRsvp;

  const _CompactOppCard({
    required this.opp,
    required this.isRsvpd,
    required this.onTap,
    required this.onRsvp,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left color band
            Container(
              width: 4,
              height: 76,
              decoration: BoxDecoration(
                color: opp.tagColor,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(14)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color:
                                opp.tagColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            opp.typeLabel,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: opp.tagColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            opp.category,
                            style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF8A8A8A)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: onRsvp,
                          child: Icon(
                            isRsvpd
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            size: 18,
                            color: isRsvpd
                                ? AppColors.red
                                : const Color(0xFF8A8A8A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      opp.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF100774),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            size: 10, color: Color(0xFF8A8A8A)),
                        const SizedBox(width: 4),
                        Text(
                          '${_mon(opp.date.month)} ${opp.date.day}  ·  ${opp.location}',
                          style: const TextStyle(
                              fontSize: 11, color: Color(0xFF8A8A8A)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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

  static String _mon(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[m - 1];
  }
}
