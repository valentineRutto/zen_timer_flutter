import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../utils/time_utils.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Column(
          children: [
            Text(
              formatTime(appState.timeLeft),
              style: TextStyle(
                color: appState.currentTheme.accentColor,
                fontSize: 80,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 24),
            if (appState.activeGoalId != null)
              Text(
                appState.goals
                    .firstWhere(
                      (g) => g.id == appState.activeGoalId,
                      orElse: () =>
                          Goal(id: '', title: 'No goal', secondsSpent: 0),
                    )
                    .title,
                style:
                    TextStyle(
                      color: appState.currentTheme.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      backgroundColor: Colors.transparent,
                    ).copyWith(
                      color: appState.currentTheme.textColor.withValues(
                        alpha: 0.8,
                      ),
                    ),
              ),
            if (appState.isFadeActive)
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'Fading in ${formatDuration(appState.fadeTimeLeft)}',
                  style: TextStyle(
                    color: appState.currentTheme.accentColor,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
