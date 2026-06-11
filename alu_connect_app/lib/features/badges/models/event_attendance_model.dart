// Represents an attendee entry on the organizer's checklist
class EventAttendee {
  final String studentId;
  final String studentName;
  final String cohort; // e.g. "Kigali 2025", "Mauritius 2024"
  bool isMarkedPresent;
  bool badgeAwarded;

  EventAttendee({
    required this.studentId,
    required this.studentName,
    required this.cohort,
    this.isMarkedPresent = false,
    this.badgeAwarded = false,
  });
}
