import 'package:flutter/material.dart';

// Theme Model (renamed to AppTheme to avoid conflict with Flutter's Theme)
class AppTheme {
  final String id;
  final String name;
  final Color backgroundColor;
  final Color accentColor;
  final Color textColor;

  AppTheme({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.accentColor,
    required this.textColor,
  });
}

// Sound Model
class Sound {
  final String id;
  final String name;
  final String url;
  final String category; // 'Ambient' or 'Sleep'

  Sound({
    required this.id,
    required this.name,
    required this.url,
    required this.category,
  });
}

// Goal Model
class Goal {
  final String id;
  final String title;
  final int secondsSpent;

  Goal({
    required this.id,
    required this.title,
    required this.secondsSpent,
  });

  Goal copyWith({
    String? id,
    String? title,
    int? secondsSpent,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      secondsSpent: secondsSpent ?? this.secondsSpent,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'secondsSpent': secondsSpent,
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'] as String,
    title: json['title'] as String,
    secondsSpent: json['secondsSpent'] as int,
  );
}

enum TimerMode { down, up }

enum ActiveTab { goals, atmosphere }
