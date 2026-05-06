import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../models/models.dart';
import '../models/constants.dart' show sounds, themes;

class SettingsPanel extends StatelessWidget {
  const SettingsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingTitle('Theme', appState),
              SizedBox(height: 12),
              _ThemeSelector(appState),
              SizedBox(height: 32),
              _SettingTitle('Ambient Sounds', appState),
              SizedBox(height: 12),
              _SoundSelector(appState),
              SizedBox(height: 32),
              _SettingTitle('Volume', appState),
              SizedBox(height: 12),
              _VolumeControl(appState),
              SizedBox(height: 32),
              _SettingTitle('Fade Out', appState),
              SizedBox(height: 12),
              _FadeControl(appState),
              SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

class _SettingTitle extends StatelessWidget {
  final String title;
  final AppState appState;

  const _SettingTitle(this.title, this.appState);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: appState.currentTheme.accentColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  final AppState appState;

  const _ThemeSelector(this.appState);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: themes.map((theme) {
        final isSelected = appState.currentTheme.id == theme.id;
        return GestureDetector(
          onTap: () => appState.setTheme(theme),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? appState.currentTheme.accentColor
                    : appState.currentTheme.textColor.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? appState.currentTheme.accentColor.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Text(
              theme.name,
              style: TextStyle(
                color: appState.currentTheme.textColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SoundSelector extends StatelessWidget {
  final AppState appState;

  const _SoundSelector(this.appState);

  @override
  Widget build(BuildContext context) {
    // Group sounds by category
    final ambientSounds =
        sounds.where((s) => s.category == 'Ambient').toList();
    final sleepSounds = sounds.where((s) => s.category == 'Sleep').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SoundCategory('Ambient', ambientSounds, appState),
        SizedBox(height: 16),
        _SoundCategory('Sleep', sleepSounds, appState),
        SizedBox(height: 16),
        // None option
        GestureDetector(
          onTap: () => appState.setSound(null),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: appState.currentSound == null
                    ? appState.currentTheme.accentColor
                    : appState.currentTheme.textColor.withValues(alpha: 0.3),
                width: appState.currentSound == null ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: appState.currentSound == null
                  ? appState.currentTheme.accentColor.withValues(alpha: 0.1)
                  : Colors.transparent,
            ),
            child: Text(
              'None',
              style: TextStyle(
                color: appState.currentTheme.textColor,
                fontWeight: appState.currentSound == null
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SoundCategory extends StatelessWidget {
  final String category;
  final List<Sound> soundList;
  final AppState appState;

  const _SoundCategory(this.category, this.soundList, this.appState);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            color: appState.currentTheme.textColor.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: soundList.map((sound) {
            final isSelected = appState.currentSound?.id == sound.id;
            return GestureDetector(
              onTap: () => appState.setSound(sound),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? appState.currentTheme.accentColor
                        : appState.currentTheme.textColor.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color: isSelected
                      ? appState.currentTheme.accentColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                ),
                child: Text(
                  sound.name,
                  style: TextStyle(
                    color: appState.currentTheme.textColor,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _VolumeControl extends StatelessWidget {
  final AppState appState;

  const _VolumeControl(this.appState);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              appState.isMuted ? Icons.volume_off : Icons.volume_up,
              color: appState.currentTheme.accentColor,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Slider(
                value: appState.isMuted ? 0 : appState.volume,
                onChanged: (v) => appState.setVolume(v),
                activeColor: appState.currentTheme.accentColor,
                inactiveColor:
                    appState.currentTheme.textColor.withValues(alpha: 0.2),
              ),
            ),
            SizedBox(width: 12),
            IconButton(
              icon: Icon(
                appState.isMuted ? Icons.volume_off : Icons.volume_up,
                color: appState.currentTheme.accentColor,
              ),
              onPressed: appState.toggleMute,
            ),
          ],
        ),
        if (appState.isMuted)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Muted',
              style: TextStyle(
                color: appState.currentTheme.textColor.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}

class _FadeControl extends StatelessWidget {
  final AppState appState;

  const _FadeControl(this.appState);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.remove_red_eye,
              color: appState.currentTheme.accentColor,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Slider(
                value: appState.fadeDuration.toDouble(),
                onChanged: (v) => appState.setFadeDuration(v.toInt()),
                min: 5,
                max: 120,
                divisions: 23,
                activeColor: appState.currentTheme.accentColor,
                inactiveColor:
                    appState.currentTheme.textColor.withValues(alpha: 0.2),
              ),
            ),
            SizedBox(width: 12),
            Text(
              '${appState.fadeDuration}m',
              style: TextStyle(
                color: appState.currentTheme.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text(
              'Fade Out Audio',
              style: TextStyle(
                color: appState.currentTheme.textColor,
              ),
            ),
            Spacer(),
            Switch(
              value: appState.isFadeActive,
              onChanged: (_) => appState.toggleFade(),
              activeThumbColor: appState.currentTheme.accentColor,
            ),
          ],
        ),
      ],
    );
  }
}
