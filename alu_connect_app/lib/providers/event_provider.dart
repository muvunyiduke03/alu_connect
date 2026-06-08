import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../models/badge_model.dart';
import '../constants/app_colors.dart';

class EventProvider extends ChangeNotifier {
  final Set<String> _rsvpdIds = {};

  final List<EventModel> _events = [
    EventModel(
      id: '1',
      title: 'Tech Innovation Summit',
      description:
          'Join us for an exciting summit on emerging technologies and innovation in Africa.',
      date: DateTime(2026, 6, 15),
      time: '10:00 AM',
      location: 'ALU Main Hall',
      category: 'Tech & Software',
      organizer: 'Tech Club',
      accentColor: AppColors.navyBlue,
    ),
    EventModel(
      id: '2',
      title: 'Entrepreneurship Bootcamp',
      description: 'A 2-day intensive program for aspiring entrepreneurs.',
      date: DateTime(2026, 6, 18),
      time: '9:00 AM',
      location: 'Innovation Hub',
      category: 'Entrepreneurship',
      organizer: 'E-Club',
      accentColor: AppColors.red,
    ),
    EventModel(
      id: '3',
      title: 'Leadership Workshop',
      description: 'Develop your leadership skills with industry experts.',
      date: DateTime(2026, 6, 20),
      time: '2:00 PM',
      location: 'Room 204',
      category: 'Leadership',
      organizer: 'Student Council',
      accentColor: const Color(0xFF7B2D8B),
    ),
    EventModel(
      id: '4',
      title: 'Design Sprint Challenge',
      description: 'A 48-hour design challenge to solve real-world problems.',
      date: DateTime(2026, 6, 22),
      time: '8:00 AM',
      location: 'Design Lab',
      category: 'Design',
      organizer: 'Design Guild',
      accentColor: const Color(0xFFE07B39),
    ),
    EventModel(
      id: '5',
      title: 'Social Impact Forum',
      description:
          'Discuss and develop solutions for social challenges in Africa.',
      date: DateTime(2026, 6, 25),
      time: '11:00 AM',
      location: 'Conference Room A',
      category: 'Social Impact',
      organizer: 'ALU Impact',
      accentColor: const Color(0xFF2E7D32),
    ),
    EventModel(
      id: '6',
      title: 'Finance & Investment Talk',
      description:
          'Learn about personal finance, investment, and wealth building.',
      date: DateTime(2026, 7, 2),
      time: '3:00 PM',
      location: 'Lecture Hall B',
      category: 'Finance',
      organizer: 'Finance Club',
      accentColor: const Color(0xFF1565C0),
    ),
    EventModel(
      id: '7',
      title: 'ALU Cultural Night',
      description: 'Celebrate the rich diversity of cultures at ALU.',
      date: DateTime(2026, 7, 5),
      time: '6:00 PM',
      location: 'Outdoor Amphitheater',
      category: 'Arts & Culture',
      organizer: 'Cultural Council',
      accentColor: const Color(0xFFAD1457),
    ),
    EventModel(
      id: '8',
      title: 'Health & Wellness Fair',
      description: 'Explore resources for physical and mental health.',
      date: DateTime(2026, 7, 8),
      time: '9:00 AM',
      location: 'Sports Complex',
      category: 'Health',
      organizer: 'Wellness Committee',
      accentColor: const Color(0xFF00695C),
    ),
  ];

  List<EventModel> get events => List.unmodifiable(_events);
  Set<String> get rsvpdIds => Set.unmodifiable(_rsvpdIds);
  bool isRsvpd(String eventId) => _rsvpdIds.contains(eventId);
  int get rsvpCount => _rsvpdIds.length;

  List<EventModel> get rsvpdEvents =>
      _events.where((e) => _rsvpdIds.contains(e.id)).toList();

  Set<String> get rsvpdCategories => _events
      .where((e) => _rsvpdIds.contains(e.id))
      .map((e) => e.category)
      .toSet();

  List<EventModel> eventsForDay(DateTime day) {
    return rsvpdEvents
        .where((e) =>
            e.date.year == day.year &&
            e.date.month == day.month &&
            e.date.day == day.day)
        .toList();
  }

  Map<DateTime, List<EventModel>> get rsvpdEventsByDay {
    final map = <DateTime, List<EventModel>>{};
    for (final event in rsvpdEvents) {
      final key = DateTime(event.date.year, event.date.month, event.date.day);
      map.putIfAbsent(key, () => []).add(event);
    }
    return map;
  }

  void toggleRsvp(String eventId) {
    if (_rsvpdIds.contains(eventId)) {
      _rsvpdIds.remove(eventId);
    } else {
      _rsvpdIds.add(eventId);
    }
    notifyListeners();
  }

  List<BadgeModel> get badges => [
        const BadgeModel(
          id: 'newcomer',
          name: 'Newcomer',
          description: 'Welcome to ALUConnect!',
          icon: Icons.star_rounded,
          color: Color(0xFF1565C0),
          isUnlocked: true,
        ),
        BadgeModel(
          id: 'event_goer',
          name: 'Event Goer',
          description: 'RSVP to your first event',
          icon: Icons.event_available_rounded,
          color: AppColors.red,
          isUnlocked: rsvpCount >= 1,
        ),
        BadgeModel(
          id: 'community_member',
          name: 'Community Member',
          description: 'RSVP to 3 events',
          icon: Icons.people_rounded,
          color: const Color(0xFF7B2D8B),
          isUnlocked: rsvpCount >= 3,
        ),
        BadgeModel(
          id: 'social_butterfly',
          name: 'Social Butterfly',
          description: 'RSVP to 5 events',
          icon: Icons.celebration_rounded,
          color: const Color(0xFFE07B39),
          isUnlocked: rsvpCount >= 5,
        ),
        BadgeModel(
          id: 'explorer',
          name: 'Explorer',
          description: 'RSVP across 3+ categories',
          icon: Icons.explore_rounded,
          color: const Color(0xFF2E7D32),
          isUnlocked: rsvpdCategories.length >= 3,
        ),
      ];
}
