import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/squad_model.dart';
import '../providers/squad_provider.dart';
import '../data/mock_squads.dart';
import '../../../providers/user_provider.dart';

class SquadBoardScreen extends StatefulWidget {
  const SquadBoardScreen({super.key});

  @override
  State<SquadBoardScreen> createState() => _SquadBoardScreenState();
}

class _SquadBoardScreenState extends State<SquadBoardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: mockHackathons.length + 1, vsync: this);
    _tabController.addListener(() {
      final provider = context.read<SquadProvider>();
      if (_tabController.indexIsChanging) return;
      final idx = _tabController.index;
      if (idx == 0) {
        provider.setHackathonFilter('all');
      } else {
        provider.setHackathonFilter(
            mockHackathons[idx - 1]['id'] as String);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F0EB),
      body: Consumer<SquadProvider>(
        builder: (context, squadProvider, _) {
          return NestedScrollView(
            headerSliverBuilder: (context, _) => [
              _buildSliverHeader(context, squadProvider),
            ],
            body: Column(
              children: [
                // Tab bar
                Container(
                  color: const Color(0xFF100774),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: const Color(0xFFD92B2B),
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13),
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      const Tab(text: 'All Hacks'),
                      ...mockHackathons.map(
                        (h) => Tab(text: h['title'] as String),
                      ),
                    ],
                  ),
                ),
                // Skill filter chips
                _buildSkillFilterBar(squadProvider),
                // Posts list
                Expanded(
                  child: _buildPostsList(context, squadProvider),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'squad_fab',
        onPressed: () => _showCreatePostSheet(context),
        backgroundColor: const Color(0xFF100774),
        icon: const Icon(Icons.group_add_rounded, color: Colors.white, size: 18),
        label: const Text(
          'Find Teammates',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  // ── SliverAppBar ──────────────────────────────────────────────────────────

  Widget _buildSliverHeader(BuildContext context, SquadProvider provider) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: _showSearch ? 140 : 120,
      backgroundColor: const Color(0xFF100774),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF100774), Color(0xFF1A0F9E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Squad Board',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Find teammates for hackathons',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white60,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stat chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.people_rounded,
                                size: 13, color: Colors.white70),
                            const SizedBox(width: 5),
                            Text(
                              '${provider.totalPosts} posts',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Search toggle
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showSearch = !_showSearch;
                            if (!_showSearch) {
                              _searchController.clear();
                              provider.setSearch('');
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _showSearch
                                ? Icons.close_rounded
                                : Icons.search_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showSearch) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: provider.setSearch,
                      style: const TextStyle(
                          fontSize: 13, color: Color(0xFF100774)),
                      decoration: InputDecoration(
                        hintText: 'Search skills, names, hackathons...',
                        hintStyle: const TextStyle(
                            color: Color(0xFF8A8A8A), fontSize: 12),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Color(0xFF8A8A8A), size: 17),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Skill filter chips ────────────────────────────────────────────────────

  Widget _buildSkillFilterBar(SquadProvider provider) {
    final skills = ['all', ...kAllSkills.take(10)];
    return Container(
      height: 42,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: skills.length,
        itemBuilder: (context, i) {
          final skill = skills[i];
          final isSelected = provider.selectedSkillFilter == skill;
          return GestureDetector(
            onTap: () => provider.setSkillFilter(skill),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(right: 8),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF100774)
                    : const Color(0xFFF2F0EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                skill == 'all' ? '✦ All Skills' : skill,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color:
                      isSelected ? Colors.white : const Color(0xFF5A5A5A),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Posts list ────────────────────────────────────────────────────────────

  Widget _buildPostsList(BuildContext context, SquadProvider provider) {
    final posts = provider.filteredPosts;
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group_off_rounded,
                size: 52, color: const Color(0xFF100774).withValues(alpha: 0.2)),
            const SizedBox(height: 14),
            const Text(
              'No posts found',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF100774)),
            ),
            const SizedBox(height: 6),
            const Text(
              'Be the first to post!',
              style: TextStyle(fontSize: 13, color: Color(0xFF8A8A8A)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 100),
      itemCount: posts.length,
      itemBuilder: (context, i) {
        final post = posts[i];
        return _SquadPostCardWrapper(
          post: post,
          onInterestTap: () => provider.toggleInterest(post.id),
        );
      },
    );
  }

  // ── Create post sheet ──────────────────────────────────────────────────────

  void _showCreatePostSheet(BuildContext context) {
    final user = context.read<UserProvider>().user;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CreateSquadPostSheet(userName: user.name),
    );
  }
}

// ── Thin wrapper to read SquadProvider inline ─────────────────────────────

class _SquadPostCardWrapper extends StatelessWidget {
  final SquadPost post;
  final VoidCallback onInterestTap;

  const _SquadPostCardWrapper({
    required this.post,
    required this.onInterestTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF2F0EB),
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(18)),
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
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                _SkillsRow(
                  label: 'I bring',
                  skills: post.mySkills,
                  color: const Color(0xFF1565C0),
                  bgColor: const Color(0xFFE3F2FD),
                ),
                const SizedBox(height: 5),
                _SkillsRow(
                  label: 'Need',
                  skills: post.seekingSkills,
                  color: const Color(0xFFD92B2B),
                  bgColor: const Color(0xFFFFEBEE),
                ),
                const SizedBox(height: 10),
                const Divider(color: Color(0xFFE8E6E1), height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.alternate_email_rounded,
                        size: 13, color: Color(0xFF8A8A8A)),
                    const SizedBox(width: 4),
                    Text(
                      post.contactHandle,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF8A8A8A)),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onInterestTap,
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
                                  : "I'm in! (${post.interestedCount})",
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
    );
  }

  static String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class _SkillsRow extends StatelessWidget {
  final String label;
  final List<String> skills;
  final Color color;
  final Color bgColor;

  const _SkillsRow({
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

// ── Create Squad Post Bottom Sheet ────────────────────────────────────────

class _CreateSquadPostSheet extends StatefulWidget {
  final String userName;

  const _CreateSquadPostSheet({required this.userName});

  @override
  State<_CreateSquadPostSheet> createState() => _CreateSquadPostSheetState();
}

class _CreateSquadPostSheetState extends State<_CreateSquadPostSheet> {
  final _descController = TextEditingController();
  final _contactController = TextEditingController();
  String _selectedHackathon = mockHackathons[0]['id'] as String;
  final Set<String> _mySkills = {};
  final Set<String> _seekingSkills = {};

  @override
  void dispose() {
    _descController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_descController.text.trim().isEmpty ||
        _mySkills.isEmpty ||
        _seekingSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Fill in description, your skills, and what you need.'),
          backgroundColor: const Color(0xFF100774),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final hackathon = mockHackathons.firstWhere(
        (h) => h['id'] == _selectedHackathon);

    final post = SquadPost(
      id: 'sq_${DateTime.now().millisecondsSinceEpoch}',
      hackathonId: _selectedHackathon,
      hackathonTitle: hackathon['title'] as String,
      posterName: widget.userName,
      posterAvatarColor: const Color(0xFFD92B2B),
      cohort: 'Kigali 2025',
      mySkills: _mySkills.toList(),
      seekingSkills: _seekingSkills.toList(),
      description: _descController.text.trim(),
      contactHandle: _contactController.text.trim().isEmpty
          ? '@${widget.userName.replaceAll(' ', '.').toLowerCase()}'
          : _contactController.text.trim(),
      timestamp: DateTime.now(),
    );

    context.read<SquadProvider>().addPost(post);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.92,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scroll) => ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E6E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Post to Squad Board',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF100774),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tell the community what you\'re building and who you need.',
                style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
              ),
              const SizedBox(height: 20),

              // Hackathon selector
              const Text(
                'Hackathon',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF100774)),
              ),
              const SizedBox(height: 6),
              ...mockHackathons.map(
                (h) => GestureDetector(
                  onTap: () =>
                      setState(() => _selectedHackathon = h['id'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedHackathon == h['id']
                          ? const Color(0xFF100774)
                          : const Color(0xFFF2F0EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          h['icon'] as IconData,
                          size: 18,
                          color: _selectedHackathon == h['id']
                              ? Colors.white
                              : const Color(0xFF5A5A5A),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          h['title'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _selectedHackathon == h['id']
                                ? Colors.white
                                : const Color(0xFF100774),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'What are you building?',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF100774)),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _descController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Describe your idea and what you\'re looking for...',
                  hintStyle:
                      const TextStyle(color: Color(0xFF8A8A8A), fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFFF2F0EB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 16),

              // My skills
              const Text(
                'Skills I bring  (select all that apply)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1565C0)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kAllSkills.map((skill) {
                  final sel = _mySkills.contains(skill);
                  return GestureDetector(
                    onTap: () => setState(() =>
                        sel ? _mySkills.remove(skill) : _mySkills.add(skill)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFF1565C0)
                            : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: sel ? Colors.white : const Color(0xFF1565C0),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Seeking skills
              const Text(
                'Skills I need  (select all that apply)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD92B2B)),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kAllSkills.map((skill) {
                  final sel = _seekingSkills.contains(skill);
                  return GestureDetector(
                    onTap: () => setState(() => sel
                        ? _seekingSkills.remove(skill)
                        : _seekingSkills.add(skill)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel
                            ? const Color(0xFFD92B2B)
                            : const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        skill,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: sel ? Colors.white : const Color(0xFFD92B2B),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Contact handle
              const Text(
                'Contact handle  (optional)',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF100774)),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _contactController,
                decoration: InputDecoration(
                  hintText: '@your.handle',
                  hintStyle: const TextStyle(
                      color: Color(0xFF8A8A8A), fontSize: 13),
                  prefixIcon: const Icon(Icons.alternate_email_rounded,
                      size: 18, color: Color(0xFF8A8A8A)),
                  filled: true,
                  fillColor: const Color(0xFFF2F0EB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF100774),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Post to Squad Board',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
