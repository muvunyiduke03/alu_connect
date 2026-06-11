import 'package:flutter/foundation.dart';
import '../data/badges_db_helper.dart';
import '../models/badge_model.dart';
import '../models/event_attendance_model.dart';

class BadgesProvider extends ChangeNotifier {
  final BadgesDbHelper _db = BadgesDbHelper.instance;

  List<BadgeModel> _studentBadges = [];
  Map<String, int> _badgeCounts = {};
  bool _isLoading = false;
  bool _isAwarding = false;
  String? _error;

  List<BadgeModel> get studentBadges => _studentBadges;
  Map<String, int> get badgeCounts => _badgeCounts;
  bool get isLoading => _isLoading;
  bool get isAwarding => _isAwarding;
  String? get error => _error;

  int get totalBadges => _studentBadges.length;

  // Load badges for the current student's profile
  Future<void> loadBadgesForStudent(String studentId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _studentBadges = await _db.getBadgesForStudent(studentId);
      _badgeCounts = await _db.getBadgeCountsByType(studentId);
    } catch (e) {
      _error = 'Could not load badges. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Called by organizer after selecting verified attendees
  Future<bool> awardBadges({
    required List<EventAttendee> attendees,
    required String eventId,
    required String eventName,
    required String eventType,
    required String organizerName,
  }) async {
    final verified = attendees.where((a) => a.isMarkedPresent).toList();
    if (verified.isEmpty) return false;

    _isAwarding = true;
    _error = null;
    notifyListeners();

    try {
      await _db.awardBadgesToAttendees(
        studentIds: verified.map((a) => a.studentId).toList(),
        studentNames: verified.map((a) => a.studentName).toList(),
        eventId: eventId,
        eventName: eventName,
        eventType: eventType,
        awardedBy: organizerName,
      );
      return true;
    } catch (e) {
      _error = 'Failed to award badges. Please try again.';
      return false;
    } finally {
      _isAwarding = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}