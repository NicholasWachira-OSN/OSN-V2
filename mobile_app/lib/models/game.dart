import 'package:flutter/material.dart';

enum GameStatus { live, finaled, upcoming }

@immutable
class Team {
  final String name;
  final String logoUrl;
  const Team({required this.name, required this.logoUrl});
}

@immutable
class Game {
  final DateTime scheduledAt; // use DateTime for flexibility
  final Team teamA;
  final Team teamB;
  final String? score; // e.g., "98-92" or null
  final String thumbnailUrl;
  final GameStatus status;

  const Game({
    required this.scheduledAt,
    required this.teamA,
    required this.teamB,
    required this.score,
    required this.thumbnailUrl,
    required this.status,
  });

  String get formattedSchedule =>
      "${scheduledAt.year}-${scheduledAt.month.toString().padLeft(2, '0')}-${scheduledAt.day.toString().padLeft(2, '0')} ${scheduledAt.hour.toString().padLeft(2, '0')}:${scheduledAt.minute.toString().padLeft(2, '0')}";
}
