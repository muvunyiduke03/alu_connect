import 'package:flutter/material.dart';
import '../models/community_model.dart';
import '../data/mock_communities.dart';

class CommunityProvider extends ChangeNotifier {
  final List<Community> _communities = List.from(mockCommunities);
  String _searchQuery = '';

  // ── Getters ────────────────────────────────────────────────────────────────

  List<Community> get allCommunities => List.unmodifiable(_communities);

  List<Community> get myCommunities =>
      _communities.where((c) => c.isJoined).toList();

  List<Community> get filteredCommunities {
    if (_searchQuery.isEmpty) return allCommunities;
    final q = _searchQuery.toLowerCase();
    return _communities
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.description.toLowerCase().contains(q) ||
              c.category.toLowerCase().contains(q) ||
              c.tags.any((t) => t.toLowerCase().contains(q)),
        )
        .toList();
  }

  List<Community> get filteredMyCommunities {
    if (_searchQuery.isEmpty) return myCommunities;
    final q = _searchQuery.toLowerCase();
    return _communities
        .where(
          (c) =>
              c.isJoined &&
              (c.name.toLowerCase().contains(q) ||
                  c.category.toLowerCase().contains(q)),
        )
        .toList();
  }

  Community? getCommunityById(String id) {
    try {
      return _communities.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  int get joinedCount => _communities.where((c) => c.isJoined).length;

  // ── Search ─────────────────────────────────────────────────────────────────

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  // ── Join / Leave ───────────────────────────────────────────────────────────

  void toggleJoin(String communityId) {
    final index = _communities.indexWhere((c) => c.id == communityId);
    if (index == -1) return;
    final community = _communities[index];
    community.isJoined = !community.isJoined;
    community.memberCount += community.isJoined ? 1 : -1;
    notifyListeners();
  }

  // ── Post Actions ───────────────────────────────────────────────────────────

  void likePost(String communityId, String postId) {
    final community = getCommunityById(communityId);
    if (community == null) return;
    try {
      final post = community.posts.firstWhere((p) => p.id == postId);
      post.isLiked = !post.isLiked;
      post.likeCount += post.isLiked ? 1 : -1;
      notifyListeners();
    } catch (_) {}
  }

  void addPost(String communityId, String content, String authorName, Color authorAvatarColor) {
    final community = getCommunityById(communityId);
    if (community == null || content.trim().isEmpty) return;
    final newPost = CommunityPost(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorId: 'current_user',
      authorName: authorName,
      authorAvatarColor: authorAvatarColor,
      content: content.trim(),
      timestamp: DateTime.now(),
      likeCount: 0,
    );
    community.posts.insert(0, newPost);
    notifyListeners();
  }

  // ── Chat Actions ───────────────────────────────────────────────────────────

  void sendMessage(String communityId, String content, String senderName, Color senderAvatarColor) {
    final community = getCommunityById(communityId);
    if (community == null || content.trim().isEmpty) return;
    final message = CommunityMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: 'current_user',
      senderName: senderName,
      senderAvatarColor: senderAvatarColor,
      content: content.trim(),
      timestamp: DateTime.now(),
      isOwn: true,
    );
    community.messages.add(message);
    notifyListeners();
  }
}
