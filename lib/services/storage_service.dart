import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class StorageService {
  static const String _goalsKey = 'zentime_goals';
  static const String _activeGoalKey = 'zentime_active_goal';

  static Future<List<Goal>> loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = prefs.getStringList(_goalsKey);
    
    if (goalsJson == null || goalsJson.isEmpty) {
      // Return default goals
      return [
        Goal(id: '1', title: 'Deep Work', secondsSpent: 0),
        Goal(id: '2', title: 'Learning', secondsSpent: 0),
      ];
    }

    return goalsJson
        .map((json) => Goal.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveGoals(List<Goal> goals) async {
    final prefs = await SharedPreferences.getInstance();
    final goalsJson = goals.map((g) => jsonEncode(g.toJson())).toList();
    await prefs.setStringList(_goalsKey, goalsJson);
  }

  static Future<String?> loadActiveGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeGoalKey) ?? '1';
  }

  static Future<void> saveActiveGoal(String goalId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeGoalKey, goalId);
  }
}
