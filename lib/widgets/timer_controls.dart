import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';

class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return Column(
          children: [
            // Mode selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModeButton(
                  label: 'Countdown',
                  isActive: appState.mode == TimerMode.down,
                  onPressed: appState.isLocked
                      ? null
                      : () => appState.setTimerMode(TimerMode.down),
                ),
                SizedBox(width: 16),
                _ModeButton(
                  label: 'Countup',
                  isActive: appState.mode == TimerMode.up,
                  onPressed: appState.isLocked
                      ? null
                      : () => appState.setTimerMode(TimerMode.up),
                ),
              ],
            ),
            SizedBox(height: 32),
            // Time input (only for countdown mode)
            if (appState.mode == TimerMode.down && !appState.isActive)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _TimeInputField(
                      label: 'H',
                      value: appState.inputH,
                      onChanged: appState.isLocked
                          ? null
                          : (v) => appState.setInputH(v),
                    ),
                    _TimeInputField(
                      label: 'M',
                      value: appState.inputM,
                      onChanged: appState.isLocked
                          ? null
                          : (v) => appState.setInputM(v),
                    ),
                    _TimeInputField(
                      label: 'S',
                      value: appState.inputS,
                      onChanged: appState.isLocked
                          ? null
                          : (v) => appState.setInputS(v),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 32),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Play/Pause
                _ControlButton(
                  icon: appState.isActive ? Icons.pause : Icons.play_arrow,
                  onPressed: appState.isLocked
                      ? null
                      : () {
                          if (appState.isActive) {
                            appState.pauseTimer();
                          } else if (appState.timeLeft > 0 &&
                              appState.mode == TimerMode.up) {
                            appState.resumeTimer();
                          } else if (!appState.isActive &&
                              appState.timeLeft == 0) {
                            // Start new timer
                            final totalSeconds = (appState.inputH * 3600) +
                                (appState.inputM * 60) +
                                appState.inputS;
                            if (totalSeconds > 0) {
                              appState.resetTimer();
                              appState.startTimer();
                            }
                          } else {
                            appState.startTimer();
                          }
                        },
                  size: 60,
                ),
                SizedBox(width: 24),
                // Stop
                _ControlButton(
                  icon: Icons.stop,
                  onPressed: appState.isLocked
                      ? null
                      : () => appState.stopTimer(),
                  size: 50,
                ),
                SizedBox(width: 24),
                // Reset
                _ControlButton(
                  icon: Icons.refresh,
                  onPressed: appState.isLocked
                      ? null
                      : () => appState.resetTimer(),
                  size: 50,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback? onPressed;

  const _ModeButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isActive
              ? appState.currentTheme.accentColor
              : appState.currentTheme.textColor.withValues(alpha: 0.5),
          width: isActive ? 2 : 1,
        ),
        backgroundColor: isActive
            ? appState.currentTheme.accentColor.withValues(alpha: 0.1)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: appState.currentTheme.textColor,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _TimeInputField extends StatelessWidget {
  final String label;
  final int value;
  final Function(int)? onChanged;

  const _TimeInputField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.expand_less,
              color: appState.currentTheme.accentColor),
          onPressed: onChanged == null ? null : () => onChanged!(value + 1),
        ),
        Text(
          value.toString().padLeft(2, '0'),
          style: TextStyle(
            color: appState.currentTheme.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: Icon(Icons.expand_more,
              color: appState.currentTheme.accentColor),
          onPressed: onChanged == null
              ? null
              : () => onChanged!(value > 0 ? value - 1 : 0),
        ),
        Text(
          label,
          style: TextStyle(
            color: appState.currentTheme.textColor.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;

  const _ControlButton({
    required this.icon,
    required this.onPressed,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return SizedBox(
      width: size,
      height: size,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: appState.currentTheme.accentColor,
        foregroundColor: appState.currentTheme.backgroundColor,
        disabledElevation: 2,
        elevation: 4,
        child: Icon(icon, size: size * 0.4),
      ),
    );
  }
}
