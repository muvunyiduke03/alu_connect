import 'package:flutter/material.dart';

/// Skills that squad members can offer or seek
const kAllSkills = [
  'Flutter / Mobile', 'Frontend (Web)', 'Backend', 'UI/UX Design',
  'Data Science', 'Machine Learning', 'DevOps / Cloud', 'Cybersecurity',
  'Business Strategy', 'Finance / Pitch Deck', 'Marketing', 'Product Management',
  'Hardware / IoT', 'Research', 'Video / Content', 'Graphic Design',
];

class SquadPost {
  final String id;
  final String hackathonId;
  final String hackathonTitle;
  final String posterName;
  final Color posterAvatarColor;
  final String cohort;
  final List<String> mySkills;       // What I bring
  final List<String> seekingSkills;  // What I need
  final String description;
  final String contactHandle;        // e.g. @aline.umuhoza
  final DateTime timestamp;
  int interestedCount;
  bool isInterested; // set true for current user

  SquadPost({
    required this.id,
    required this.hackathonId,
    required this.hackathonTitle,
    required this.posterName,
    required this.posterAvatarColor,
    required this.cohort,
    required this.mySkills,
    required this.seekingSkills,
    required this.description,
    required this.contactHandle,
    required this.timestamp,
    this.interestedCount = 0,
    this.isInterested = false,
  });

  String get initials {
    final parts = posterName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return posterName.isNotEmpty ? posterName[0].toUpperCase() : '?';
  }
}
