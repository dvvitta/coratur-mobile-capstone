import 'package:flutter/material.dart';

enum BadgeStatus { owned, locked, comingSoon }

class BadgeItem {
  const BadgeItem({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.description,
    required this.status,
    required this.cardColor,
    required this.requirement,
    this.obtainedDate,
    this.progress,
  });

  final String id;
  final String name;
  final String assetPath;
  final String description;
  final BadgeStatus status;
  final Color cardColor;
  final String requirement;
  final String? obtainedDate;
  final double? progress;
}
