import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../models/constants.dart';
import '../services/storage_service.dart';
import '../services/audio_service.dart';

class AppState extends ChangeNotifier {
  // Timer state
  TimerMode mode = TimerMode.down;
  int inputH = 0;
  int inputM = 25;
  int inputS = 0;
  int timeLeft = 25 * 60;
  bool isActive = false;
  bool isLocked = false;

  // Theme and sound
  AppTheme currentTheme = themes[0];
  Sound? currentSound;
  double volume = 0.5;
  bool isMuted = false;

  // UI state
  bool showSettings = false;
  ActiveTab activeTab = ActiveTab.goals;

  // Fade-out
  int fadeDuration = 30; // minutes
  bool isFadeActive = false;
  int fadeTimeLeft = 30 * 60; // seconds

  // Goals
  List<Goal> goals = [];
  String? activeGoalId;
  String newGoalTitle = '';
  bool showGoalInput = false;
  int sessionSeconds = 0;
  String? prevGoalId;

  // Services
  late AudioService _audioService;

  AppState() {
    _audioService = AudioService();
    _init();
  }

  Future<void> _init() async {
    goals = await StorageService.loadGoals();
    activeGoalId = await StorageService.loadActiveGoal();
    prevGoalId = activeGoalId;
    notifyListeners();
  }

  // Timer methods
  void startTimer() {
    isActive = true;
    notifyListeners();
  }

  void pauseTimer() {
    isActive = false;
    _commitSession();
    notifyListeners();
  }

  void resumeTimer() {
    isActive = true;
    notifyListeners();
  }

  void resetTimer() {
    isActive = false;
    timeLeft = (inputH * 3600) + (inputM * 60) + inputS;
    notifyListeners();
  }

  void stopTimer() {
    isActive = false;
    timeLeft = 0;
    _commitSession();
    notifyListeners();
  }

  void setTimerMode(TimerMode newMode) {
    mode = newMode;
    notifyListeners();
  }

  void setInputH(int value) {
    inputH = value;
    notifyListeners();
  }

  void setInputM(int value) {
    inputM = value;
    notifyListeners();
  }

  void setInputS(int value) {
    inputS = value;
    notifyListeners();
  }

  // Tick for timer
  void tick() {
    if (isFadeActive) {
      fadeTimeLeft--;
      if (fadeTimeLeft <= 0) {
        isFadeActive = false;
        fadeTimeLeft = 0;
      }
    }

    if (activeGoalId != null) {
      sessionSeconds++;
    }

    if (mode == TimerMode.up) {
      timeLeft++;
    } else {
      timeLeft--;
      if (timeLeft <= 0) {
        isActive = false;
        timeLeft = 0;
        _audioService.playCompletionSound(completionSoundUrl);
      }
    }

    _updateAmbientVolume();
    notifyListeners();
  }

  void _updateAmbientVolume() {
    if (isFadeActive && currentSound != null) {
      final fadeMultiplier = fadeTimeLeft / (fadeDuration * 60).toDouble();
      final adjustedVolume = isMuted ? 0.0 : volume * fadeMultiplier;
      _audioService.setAmbientVolume(adjustedVolume);
    } else if (currentSound != null) {
      _audioService.setAmbientVolume(isMuted ? 0.0 : volume);
    }
  }

  // Theme methods
  void setTheme(AppTheme theme) {
    currentTheme = theme;
    notifyListeners();
  }

  // Sound methods
  Future<void> setSound(Sound? sound) async {
    currentSound = sound;
    if (sound != null) {
      if (isActive) {
        await _audioService.playAmbientSound(sound.url);
      }
    } else {
      await _audioService.stopAmbientSound();
    }
    notifyListeners();
  }

  // Volume methods
  void setVolume(double newVolume) {
    volume = newVolume;
    _updateAmbientVolume();
    notifyListeners();
  }

  void toggleMute() {
    isMuted = !isMuted;
    _updateAmbientVolume();
    notifyListeners();
  }

  // Settings methods
  void toggleSettings() {
    showSettings = !showSettings;
    notifyListeners();
  }

  void setActiveTab(ActiveTab tab) {
    activeTab = tab;
    notifyListeners();
  }

  // Fade methods
  void setFadeDuration(int minutes) {
    fadeDuration = minutes;
    fadeTimeLeft = minutes * 60;
    notifyListeners();
  }

  void toggleFade() {
    isFadeActive = !isFadeActive;
    if (isFadeActive) {
      fadeTimeLeft = fadeDuration * 60;
    }
    notifyListeners();
  }

  // Lock methods
  void toggleLock() {
    isLocked = !isLocked;
    notifyListeners();
  }

  // Goal methods
  Future<void> addGoal(String title) async {
    final goal = Goal(id: const Uuid().v4(), title: title, secondsSpent: 0);
    goals.add(goal);
    await StorageService.saveGoals(goals);
    await setActiveGoal(goal.id);
    newGoalTitle = '';
    showGoalInput = false;
    notifyListeners();
  }

  Future<void> deleteGoal(String goalId) async {
    goals.removeWhere((g) => g.id == goalId);
    if (activeGoalId == goalId) {
      activeGoalId = goals.isNotEmpty ? goals.first.id : null;
      await StorageService.saveActiveGoal(activeGoalId ?? '');
    }
    await StorageService.saveGoals(goals);
    notifyListeners();
  }

  Future<void> setActiveGoal(String goalId) async {
    if (prevGoalId != null && prevGoalId != goalId && sessionSeconds > 0) {
      // Commit previous goal's session
      final prevIdx = goals.indexWhere((g) => g.id == prevGoalId);
      if (prevIdx >= 0) {
        goals[prevIdx] = goals[prevIdx].copyWith(
          secondsSpent: goals[prevIdx].secondsSpent + sessionSeconds,
        );
        await StorageService.saveGoals(goals);
      }
      sessionSeconds = 0;
    }

    activeGoalId = goalId;
    prevGoalId = goalId;
    await StorageService.saveActiveGoal(goalId);
    notifyListeners();
  }

  void setNewGoalTitle(String title) {
    newGoalTitle = title;
    notifyListeners();
  }

  void toggleGoalInput() {
    showGoalInput = !showGoalInput;
    if (!showGoalInput) {
      newGoalTitle = '';
    }
    notifyListeners();
  }

  Future<void> _commitSession() async {
    if (activeGoalId != null && sessionSeconds > 0) {
      final idx = goals.indexWhere((g) => g.id == activeGoalId);
      if (idx >= 0) {
        goals[idx] = goals[idx].copyWith(
          secondsSpent: goals[idx].secondsSpent + sessionSeconds,
        );
        await StorageService.saveGoals(goals);
      }
      sessionSeconds = 0;
    }
  }

  Future<void> handleActiveTimerStateChange(bool wasActive) async {
    if (wasActive && !isActive) {
      // Timer was paused
      await _audioService.pauseAmbientSound();
    } else if (!wasActive && isActive) {
      // Timer was resumed
      if (currentSound != null) {
        await _audioService.resumeAmbientSound();
      }
    }
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
