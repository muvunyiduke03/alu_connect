/// EngagementBadgeModel — SQLite-persisted badge awarded by organizers
/// to verified event attendees.
///
/// NOTE: This is separate from the simple BadgeModel in models/badge_model.dart
/// which represents the profile gamification badges.
class EngagementBadgeModel {
  final String id;
  final String studentId;
  final String studentName;
  final String eventId;
  final String eventName;
  final String eventType; // 'workshop', 'hackathon', 'leadership', 'community', 'startup'
  final DateTime awardedAt;
  final String awardedBy; // organizer's name
  bool isVerified;

  EngagementBadgeModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.eventId,
    required this.eventName,
    required this.eventType,
    required this.awardedAt,
    required this.awardedBy,
    this.isVerified = false,
  });

  // Badge visual config based on event type
  static Map<String, Map<String, dynamic>> typeConfig = {
    'workshop': {
      'label': 'Workshop',
      'emoji': '🛠️',
      'color': 0xFF4A90D9, // blue
    },
    'hackathon': {
      'label': 'Hackathon',
      'emoji': '⚡',
      'color': 0xFFF5A623, // amber
    },
    'leadership': {
      'label': 'Leadership',
      'emoji': '🎯',
      'color': 0xFF7B68EE, // purple
    },
    'community': {
      'label': 'Community',
      'emoji': '🤝',
      'color': 0xFF50C878, // green
    },
    'startup': {
      'label': 'Startup',
      'emoji': '🚀',
      'color': 0xFFFF6B6B, // coral
    },
  };

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentId': studentId,
        'studentName': studentName,
        'eventId': eventId,
        'eventName': eventName,
        'eventType': eventType,
        'awardedAt': awardedAt.toIso8601String(),
        'awardedBy': awardedBy,
        'isVerified': isVerified ? 1 : 0,
      };

  factory EngagementBadgeModel.fromMap(Map<String, dynamic> map) =>
      EngagementBadgeModel(
        id: map['id'],
        studentId: map['studentId'],
        studentName: map['studentName'],
        eventId: map['eventId'],
        eventName: map['eventName'],
        eventType: map['eventType'],
        awardedAt: DateTime.parse(map['awardedAt']),
        awardedBy: map['awardedBy'],
        isVerified: map['isVerified'] == 1,
      );
}
