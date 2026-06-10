import 'package:flutter/material.dart';
import '../models/opportunity_model.dart';
import '../data/mock_opportunities.dart';

class FeedProvider extends ChangeNotifier {
  final List<OpportunityModel> _opportunities = List.from(mockOpportunities);
  final Set<String> _rsvpdIds = {};
  OpportunityType? _selectedFilter;

  List<OpportunityModel> get opportunities => List.unmodifiable(_opportunities);
  Set<String> get rsvpdIds => Set.unmodifiable(_rsvpdIds);
  OpportunityType? get selectedFilter => _selectedFilter;

  bool isRsvpd(String opportunityId) => _rsvpdIds.contains(opportunityId);
  int get rsvpCount => _rsvpdIds.length;

  List<OpportunityModel> get filteredOpportunities {
    if (_selectedFilter == null) {
      return List.unmodifiable(_opportunities);
    }
    return List.unmodifiable(
      _opportunities.where((opp) => opp.type == _selectedFilter).toList(),
    );
  }

  List<OpportunityModel> get rsvpdOpportunities =>
      _opportunities.where((opp) => _rsvpdIds.contains(opp.id)).toList();

  List<OpportunityModel> get featuredOpportunities =>
      _opportunities.where((opp) => opp.isFeatured).toList();

  OpportunityModel? getOpportunityById(String id) {
    try {
      return _opportunities.firstWhere((opp) => opp.id == id);
    } catch (e) {
      return null;
    }
  }

  void setFilter(OpportunityType? type) {
    _selectedFilter = type;
    notifyListeners();
  }

  void toggleRsvp(String opportunityId) {
    if (_rsvpdIds.contains(opportunityId)) {
      _rsvpdIds.remove(opportunityId);
      // Update rsvpCount in the opportunity
      final index = _opportunities.indexWhere((opp) => opp.id == opportunityId);
      if (index != -1) {
        final current = _opportunities[index];
        _opportunities[index] = current.copyWith(
          rsvpCount: current.rsvpCount - 1,
        );
      }
    } else {
      _rsvpdIds.add(opportunityId);
      // Update rsvpCount in the opportunity
      final index = _opportunities.indexWhere((opp) => opp.id == opportunityId);
      if (index != -1) {
        final current = _opportunities[index];
        _opportunities[index] = current.copyWith(
          rsvpCount: current.rsvpCount + 1,
        );
      }
    }
    notifyListeners();
  }

  void createOpportunity(OpportunityModel opportunity) {
    _opportunities.insert(0, opportunity);
    notifyListeners();
  }

  void updateOpportunity(String id, OpportunityModel updated) {
    final index = _opportunities.indexWhere((opp) => opp.id == id);
    if (index != -1) {
      _opportunities[index] = updated;
      notifyListeners();
    }
  }

  void deleteOpportunity(String id) {
    _opportunities.removeWhere((opp) => opp.id == id);
    _rsvpdIds.remove(id);
    notifyListeners();
  }

  // Search opportunities by title or category
  List<OpportunityModel> searchOpportunities(String query) {
    final lowerQuery = query.toLowerCase();
    return _opportunities
        .where(
          (opp) =>
              opp.title.toLowerCase().contains(lowerQuery) ||
              opp.category.toLowerCase().contains(lowerQuery) ||
              opp.description.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  // Get opportunities by category
  List<OpportunityModel> getByCategory(String category) {
    return _opportunities.where((opp) => opp.category == category).toList();
  }

  // Get all unique categories
  Set<String> get allCategories =>
      _opportunities.map((opp) => opp.category).toSet();
}
