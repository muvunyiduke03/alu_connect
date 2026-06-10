import 'package:flutter/material.dart';

enum OpportunityType { event, hackathon, startup }

class OrganizerInfo {
  final String name;
  final String id;
  final String avatar;

  const OrganizerInfo({
    required this.name,
    required this.id,
    required this.avatar,
  });
}

class OpportunityModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String location;
  final OpportunityType type;
  final String category;
  final OrganizerInfo organizer;
  final Color tagColor;
  final int rsvpCount;
  final bool isFeatured;

  const OpportunityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.type,
    required this.category,
    required this.organizer,
    required this.tagColor,
    this.rsvpCount = 0,
    this.isFeatured = false,
  });

  String get typeLabel {
    switch (type) {
      case OpportunityType.event:
        return 'Event';
      case OpportunityType.hackathon:
        return 'Hackathon';
      case OpportunityType.startup:
        return 'Startup';
    }
  }

  OpportunityModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    String? time,
    String? location,
    OpportunityType? type,
    String? category,
    OrganizerInfo? organizer,
    Color? tagColor,
    int? rsvpCount,
    bool? isFeatured,
  }) {
    return OpportunityModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      type: type ?? this.type,
      category: category ?? this.category,
      organizer: organizer ?? this.organizer,
      tagColor: tagColor ?? this.tagColor,
      rsvpCount: rsvpCount ?? this.rsvpCount,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }
}
