import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/community_provider.dart';
import '../widgets/community_card.dart';
import 'community_detail_screen.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      body: Consumer<CommunityProvider>(
        builder: (context, provider, _) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverHeader(context, provider, innerBoxIsScrolled),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildAllTab(provider),
                _buildMyTab(provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverHeader(
    BuildContext context,
    CommunityProvider provider,
    bool innerBoxIsScrolled,
  ) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: _showSearch ? 130 : 110,
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
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Communities',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      // Joined count badge
                      if (provider.joinedCount > 0)
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${provider.joinedCount} joined',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      // Search icon
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showSearch = !_showSearch;
                            if (!_showSearch) {
                              _searchController.clear();
                              provider.clearSearch();
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
                            _showSearch ? Icons.close_rounded : Icons.search_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showSearch) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: provider.setSearch,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF100774)),
                      decoration: InputDecoration(
                        hintText: 'Search clubs, categories, tags...',
                        hintStyle: const TextStyle(color: Color(0xFF8A8A8A), fontSize: 13),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: Color(0xFF8A8A8A), size: 18),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
      bottom: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFFD92B2B),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white54,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.apps_rounded, size: 16),
                const SizedBox(width: 6),
                Text('All Clubs (${provider.allCommunities.length})'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bookmark_rounded, size: 16),
                const SizedBox(width: 6),
                const Text('My Clubs'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllTab(CommunityProvider provider) {
    final communities = provider.filteredCommunities;
    if (communities.isEmpty) {
      return _emptySearch();
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      itemCount: communities.length,
      itemBuilder: (context, i) {
        final c = communities[i];
        return CommunityCard(
          community: c,
          onTap: () => _openDetail(context, c.id),
          onJoinTap: () => provider.toggleJoin(c.id),
        );
      },
    );
  }

  Widget _buildMyTab(CommunityProvider provider) {
    final communities = provider.filteredMyCommunities;
    if (communities.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF100774).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group_add_rounded,
                  size: 48,
                  color: Color(0xFF100774),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'No clubs joined yet',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF100774),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Explore All Clubs and hit Join on any community that interests you.',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8A8A8A),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => _tabController.animateTo(0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF100774),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'Explore All Clubs',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      itemCount: communities.length,
      itemBuilder: (context, i) {
        final c = communities[i];
        return CommunityCard(
          community: c,
          onTap: () => _openDetail(context, c.id),
          onJoinTap: () => provider.toggleJoin(c.id),
        );
      },
    );
  }

  Widget _emptySearch() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Color(0xFFE8E6E1)),
          SizedBox(height: 14),
          Text(
            'No clubs found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF100774),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Try a different search term.',
            style: TextStyle(fontSize: 13, color: Color(0xFF8A8A8A)),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, String communityId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommunityDetailScreen(communityId: communityId),
      ),
    );
  }
}
