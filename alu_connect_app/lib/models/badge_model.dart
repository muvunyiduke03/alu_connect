import 'package:flutter/material.dart';

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final bool isUnlocked;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.isUnlocked,
  });
}
