import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/community_model.dart';
import '../providers/community_provider.dart';
import '../widgets/pinned_announcement_banner.dart';
import '../widgets/community_post_card.dart';
import '../widgets/member_tile.dart';
import '../widgets/chat_bubble.dart';
import '../../../providers/user_provider.dart';

class CommunityDetailScreen extends StatefulWidget {
  final String communityId;

  const CommunityDetailScreen({super.key, required this.communityId});

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _chatController = TextEditingController();
  final _chatScrollController = ScrollController();
  final _memberSearchController = TextEditingController();
  String _memberSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Scroll to bottom of chat when chat tab is selected
    _tabController.addListener(() {
      if (_tabController.index == 2) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });
    // Auto-scroll to bottom on first open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.index == 2) _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    _chatScrollController.dispose();
    _memberSearchController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_chatScrollController.hasClients) {
      _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CommunityProvider, UserProvider>(
      builder: (context, communityProvider, userProvider, _) {
        final community = communityProvider.getCommunityById(widget.communityId);
        if (community == null) {
          return const Scaffold(
            body: Center(child: Text('Community not found.')),
          );
        }
        return Scaffold(
          backgroundColor: const Color(0xFFF2F0EB),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverAppBar(context, community, communityProvider),
            ],
            body: Column(
              children: [
                // Tab bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: community.color,
                    unselectedLabelColor: const Color(0xFF8A8A8A),
                    indicatorColor: community.color,
                    indicatorWeight: 2.5,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(icon: Icon(Icons.article_outlined, size: 18), text: 'Feed'),
                      Tab(icon: Icon(Icons.people_outline_rounded, size: 18), text: 'Members'),
                      Tab(icon: Icon(Icons.chat_bubble_outline_rounded, size: 18), text: 'Chat'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFeedTab(community, communityProvider, userProvider),
                      _buildMembersTab(community),
                      _buildChatTab(context, community, communityProvider, userProvider),
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

  // ── SliverAppBar ──────────────────────────────────────────────────────────

  Widget _buildSliverAppBar(
    BuildContext context,
    Community community,
    CommunityProvider provider,
  ) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: community.color,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => provider.toggleJoin(community.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: community.isJoined
                    ? Colors.white.withValues(alpha: 0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                community.isJoined ? 'Joined ✓' : 'Join',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: community.isJoined ? Colors.white : community.color,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                community.color,
                community.color.withValues(alpha: 0.75),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.07),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              // Content
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(community.icon, color: Colors.white, size: 26),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  community.name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        community.category,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.people_alt_rounded, size: 12, color: Colors.white70),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${community.memberCount} members',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
      ),
    );
  }

  // ── Feed Tab ──────────────────────────────────────────────────────────────

  Widget _buildFeedTab(
    Community community,
    CommunityProvider provider,
    UserProvider userProvider,
  ) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 90),
          children: [
            // Pinned announcement
            PinnedAnnouncementBanner(
              announcement: community.pinnedAnnouncement,
              accentColor: community.color,
            ),
            const SizedBox(height: 6),
            // Posts
            ...community.posts.map(
              (post) => CommunityPostCard(
                post: post,
                communityColor: community.color,
                onLikeTap: () => provider.likePost(community.id, post.id),
              ),
            ),
            if (community.posts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.article_outlined,
                          size: 48, color: community.color.withValues(alpha: 0.3)),
                      const SizedBox(height: 12),
                      const Text(
                        'No posts yet.',
                        style: TextStyle(fontSize: 15, color: Color(0xFF8A8A8A)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Be the first to post something!',
                        style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        // FAB for creating a post
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            heroTag: 'post_fab_${community.id}',
            onPressed: () => _showCreatePostSheet(context, community, provider, userProvider),
            backgroundColor: community.color,
            icon: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
            label: const Text(
              'Post',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCreatePostSheet(
    BuildContext context,
    Community community,
    CommunityProvider provider,
    UserProvider userProvider,
  ) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                'Share with ${community.name}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF100774),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                maxLines: 4,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  hintStyle: const TextStyle(color: Color(0xFF8A8A8A)),
                  filled: true,
                  fillColor: const Color(0xFFF2F0EB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      provider.addPost(
                        community.id,
                        controller.text,
                        userProvider.user.name,
                        const Color(0xFFD92B2B),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: community.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Publish Post',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Members Tab ────────────────────────────────────────────────────────────

  Widget _buildMembersTab(Community community) {
    // Leader always first
    final sorted = [...community.members]..sort((a, b) {
        const order = {'Leader': 0, 'Moderator': 1, 'Member': 2};
        return (order[a.role] ?? 2).compareTo(order[b.role] ?? 2);
      });

    final filtered = _memberSearchQuery.isEmpty
        ? sorted
        : sorted
            .where((m) =>
                m.name.toLowerCase().contains(_memberSearchQuery.toLowerCase()))
            .toList();

    return Column(
      children: [
        // Member count + search bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _memberSearchController,
                  onChanged: (q) => setState(() => _memberSearchQuery = q),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF100774)),
                  decoration: InputDecoration(
                    hintText: 'Search members...',
                    hintStyle: const TextStyle(color: Color(0xFF8A8A8A), fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFF8A8A8A), size: 18),
                    filled: true,
                    fillColor: const Color(0xFFF2F0EB),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: community.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${community.memberCount}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: community.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(
                  child: Text(
                    'No members found.',
                    style: TextStyle(color: Color(0xFF8A8A8A), fontSize: 14),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(top: 10, bottom: 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) => MemberTile(
                    member: filtered[i],
                    communityColor: community.color,
                  ),
                ),
        ),
      ],
    );
  }

  // ── Chat Tab ────────────────────────────────────────────────────────────────

  Widget _buildChatTab(
    BuildContext context,
    Community community,
    CommunityProvider provider,
    UserProvider userProvider,
  ) {
    final messages = community.messages;

    return Column(
      children: [
        // Chat header bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              Icon(Icons.lock_rounded, size: 13, color: const Color(0xFF8A8A8A).withValues(alpha: 0.7)),
              const SizedBox(width: 6),
              Text(
                '${community.name} · ${community.memberCount} members',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8A8A8A),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Message list
        Expanded(
          child: messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          size: 48, color: community.color.withValues(alpha: 0.3)),
                      const SizedBox(height: 12),
                      const Text(
                        'No messages yet.',
                        style: TextStyle(fontSize: 15, color: Color(0xFF8A8A8A)),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Start the conversation!',
                        style: TextStyle(fontSize: 12, color: Color(0xFF8A8A8A)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: _chatScrollController,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final msg = messages[i];
                    // Show avatar only when sender changes
                    final showAvatar = i == 0 ||
                        messages[i - 1].senderId != msg.senderId;
                    return ChatBubble(message: msg, showAvatar: showAvatar);
                  },
                ),
        ),
        // Input bar
        _buildChatInputBar(context, community, provider, userProvider),
      ],
    );
  }

  Widget _buildChatInputBar(
    BuildContext context,
    Community community,
    CommunityProvider provider,
    UserProvider userProvider,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _chatController,
                style: const TextStyle(fontSize: 14, color: Color(0xFF100774)),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Message ${community.name}...',
                  hintStyle: const TextStyle(color: Color(0xFF8A8A8A), fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFFF2F0EB),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                final text = _chatController.text.trim();
                if (text.isNotEmpty) {
                  provider.sendMessage(
                    community.id,
                    text,
                    userProvider.user.name,
                    const Color(0xFFD92B2B),
                  );
                  _chatController.clear();
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _scrollToBottom(),
                  );
                }
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: community.color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
