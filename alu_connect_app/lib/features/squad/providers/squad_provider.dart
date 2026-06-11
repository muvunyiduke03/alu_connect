import 'package:flutter/material.dart';
import '../models/squad_model.dart';
import '../data/mock_squads.dart';

class SquadProvider extends ChangeNotifier {
  final List<SquadPost> _posts = List.from(mockSquadPosts);
  String _selectedHackathonId = 'all';
  String _selectedSkillFilter = 'all';
  String _searchQuery = '';

  // ── Getters ──────────────────────────────────────────────────────────────

  List<SquadPost> get allPosts => List.unmodifiable(_posts);
  String get selectedHackathonId => _selectedHackathonId;
  String get selectedSkillFilter => _selectedSkillFilter;

  List<SquadPost> get filteredPosts {
    var result = _posts.toList();

    if (_selectedHackathonId != 'all') {
      result =
          result.where((p) => p.hackathonId == _selectedHackathonId).toList();
    }

    if (_selectedSkillFilter != 'all') {
      result = result
          .where((p) =>
              p.mySkills.contains(_selectedSkillFilter) ||
              p.seekingSkills.contains(_selectedSkillFilter))
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((p) =>
              p.posterName.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q) ||
              p.hackathonTitle.toLowerCase().contains(q) ||
              p.mySkills.any((s) => s.toLowerCase().contains(q)) ||
              p.seekingSkills.any((s) => s.toLowerCase().contains(q)))
          .toList();
    }

    // Sort by interested count then recency
    result.sort((a, b) {
      final byInterest = b.interestedCount.compareTo(a.interestedCount);
      if (byInterest != 0) return byInterest;
      return b.timestamp.compareTo(a.timestamp);
    });

    return result;
  }

  List<SquadPost> postsForHackathon(String hackathonId) =>
      _posts.where((p) => p.hackathonId == hackathonId).toList();

  // ── Filters ───────────────────────────────────────────────────────────────

  void setHackathonFilter(String hackathonId) {
    _selectedHackathonId = hackathonId;
    notifyListeners();
  }

  void setSkillFilter(String skill) {
    _selectedSkillFilter = skill;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearFilters() {
    _selectedHackathonId = 'all';
    _selectedSkillFilter = 'all';
    _searchQuery = '';
    notifyListeners();
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  void toggleInterest(String postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;
    final post = _posts[idx];
    post.isInterested = !post.isInterested;
    post.interestedCount += post.isInterested ? 1 : -1;
    notifyListeners();
  }

  void addPost(SquadPost post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  SquadPost? getById(String id) {
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Stats ─────────────────────────────────────────────────────────────────

  int get totalPosts => _posts.length;
  int get activePeopleCount => _posts.fold(0, (sum, p) => sum + p.interestedCount);
}
