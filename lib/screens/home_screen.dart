import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../state/app_state.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/settings_panel.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) {
        final appState = context.read<AppState>();
        if (appState.isActive) {
          appState.tick();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Scaffold(
          backgroundColor: appState.currentTheme.backgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                // Header with settings button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Zen Focus Timer',
                        style: TextStyle(
                          color: appState.currentTheme.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          // Lock button
                          IconButton(
                            icon: Icon(
                              appState.isLocked ? Icons.lock : Icons.lock_open,
                              color: appState.isLocked
                                  ? appState.currentTheme.accentColor
                                  : appState.currentTheme.textColor,
                            ),
                            onPressed: appState.toggleLock,
                          ),
                          // Settings button
                          IconButton(
                            icon: Icon(
                              Icons.settings,
                              color: appState.showSettings
                                  ? appState.currentTheme.accentColor
                                  : appState.currentTheme.textColor,
                            ),
                            onPressed: appState.toggleSettings,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Main content
                Expanded(
                  child: appState.showSettings
                      ? SettingsPanel()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TimerDisplay(),
                                    SizedBox(height: 40),
                                    TimerControls(),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                // Bottom navigation
                BottomNavigation(),
              ],
            ),
          ),
        );
      },
    );
  }
}
