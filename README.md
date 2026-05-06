# Zen Focus Timer - Flutter Version

A beautiful cross-platform Pomodoro timer app with ambient sounds and customizable themes, converted from React to Flutter.

## Features

- ⏱️ **Countdown & Countup Timers** - Choose between traditional countdown or open-ended countup mode
- 🎵 **Ambient Sounds** - Relax with carefully selected sound options:
  - Soft Rain
  - Forest Birds
  - Ocean Waves
  - White Noise
  - Rainforest
  - Cosmic Hum
  - Chill Pop
- 🎨 **Customizable Themes** - Choose from 4 beautiful themes:
  - Aether (Gold)
  - Midnight Blue
  - Deep Emerald
  - Royal Purple
- 🎯 **Goal Tracking** - Track focus sessions across different goals
- 🔇 **Volume Control** - Adjust volume and mute options
- 🌅 **Fade Out Effect** - Gradually reduce audio volume over time
- 🔒 **Lock Feature** - Prevent accidental adjustments during sessions
- 💾 **Local Storage** - Goals and preferences are automatically saved

## Platforms Supported

✅ **iOS** (iPhone, iPad)
✅ **Android** (Phone, Tablet)
✅ **Web** (Browser)
✅ **macOS** (Coming soon)
✅ **Windows** (Coming soon)
✅ **Linux** (Coming soon)

## Requirements

- Flutter SDK 3.9.2 or higher
- Dart SDK (included with Flutter)
- For iOS: Xcode 14+
- For Android: Android Studio with SDK 21+

## Getting Started

### Installation

1. Navigate to the project directory:
```bash
cd zen_timer_flutter
```

2. Install dependencies:
```bash
flutter pub get
```

### Running the App

**Development (Chrome Web):**
```bash
flutter run -d chrome
```

**Development (iOS Simulator):**
```bash
flutter run -d iphone
```

**Development (Android Emulator):**
```bash
flutter run -d android
```

**Development (Physical Device):**
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   ├── models.dart             # Data models (AppTheme, Sound, Goal)
│   └── constants.dart          # Themes and sounds configuration
├── services/
│   ├── audio_service.dart      # Audio playback management
│   └── storage_service.dart    # Local storage (SharedPreferences)
├── state/
│   └── app_state.dart          # State management (ChangeNotifier)
├── screens/
│   └── home_screen.dart        # Main screen
├── utils/
│   └── time_utils.dart         # Time formatting utilities
└── widgets/
    ├── timer_display.dart      # Timer display widget
    ├── timer_controls.dart     # Play, pause, reset buttons
    ├── settings_panel.dart     # Settings UI
    └── bottom_navigation.dart  # Goals and Atmosphere tabs
```

## Building for Release

### iOS Release Build

```bash
flutter build ios --release
```

Then open in Xcode for signing and archiving:
```bash
open ios/Runner.xcworkspace
```

### Android Release Build

```bash
flutter build apk --release
```

Or for Google Play distribution:
```bash
flutter build appbundle --release
```

### Web Release Build

```bash
flutter build web --release
```

The optimized web app will be in `build/web/`

## Key Differences from React Version

| Aspect | React Version | Flutter Version |
|--------|---------------|-----------------|
| **State Management** | React Hooks | ChangeNotifier + Provider |
| **Styling** | Tailwind CSS | Material Design |
| **Audio** | Howler.js | just_audio |
| **Storage** | localStorage | SharedPreferences |
| **Platforms** | Web only | iOS, Android, Web, macOS* |

## Dependencies

### Runtime
- **just_audio** (0.9.36) - Audio playback with platform support
- **shared_preferences** (2.2.2) - Local data persistence
- **provider** (6.0.0) - State management
- **uuid** (4.0.0) - Unique ID generation

### Development
- **flutter_test** - Testing utilities
- **flutter_lints** - Linting rules

## Architecture

### State Management Pattern

The app uses Flutter's `ChangeNotifier` pattern with Provider for reactive UI:

```dart
class AppState extends ChangeNotifier {
  // State properties
  TimerMode mode = TimerMode.down;
  int timeLeft = 25 * 60;
  bool isActive = false;
  AppTheme currentTheme = themes[0];
  Sound? currentSound;
  List<Goal> goals = [];
  
  // Methods that modify state and notify listeners
  void tick() {
    timeLeft--;
    notifyListeners();
  }
}
```

### Data Persistence

Using `SharedPreferences` for automatic persistence:
- Goals are serialized to JSON
- Active goal ID is stored
- Data loads on app startup
- Changes are saved immediately

### Audio Management

The `AudioService` singleton:
- Plays ambient sounds in a loop
- Manages volume with fade-out support
- Plays completion sounds
- Handles play/pause/stop operations
- Works across all platforms

## Platform-Specific Setup

### iOS Configuration

Edit `ios/Podfile` if needed:
```ruby
# Minimum deployment target
platform :ios, '11.0'
```

Add audio permissions to `ios/Runner/Info.plist`:
```xml
<key>NSBluetooth PeripheralUsageDescription</key>
<string>This app uses Bluetooth to connect to audio devices</string>
```

### Android Configuration

Permissions are defined in `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### Web Configuration

No special configuration needed. The app uses HTML5 audio APIs.

## Testing

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/widget_test.dart
```

## Troubleshooting

### App won't build
- Run `flutter clean`
- Delete `pubspec.lock`
- Run `flutter pub get`

### Audio not working
- iOS: Check `Info.plist` permissions
- Android: Check app permissions in settings
- Web: Ensure autoplay permissions are granted

### State not updating
- Check that you're using `Consumer` or `watch` to listen to `AppState`
- Ensure `notifyListeners()` is called after state changes

## Performance Considerations

- Timer updates every second with `Timer.periodic()`
- Audio loops natively using platform APIs
- Goal tracking uses efficient JSON serialization
- Theme switching updates UI incrementally

## Future Enhancements

- [ ] Desktop support (macOS, Windows, Linux)
- [ ] Cloud sync for cross-device goals
- [ ] Sound library expansion
- [ ] Statistics and analytics
- [ ] Notifications
- [ ] Dark mode auto-detection
- [ ] Accessibility improvements

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improvement`)
3. Make your changes
4. Run `flutter analyze` and `flutter test`
5. Commit your changes
6. Push to the branch
7. Open a Pull Request

## License

Licensed under the Apache License 2.0. See [LICENSE](LICENSE) file for details.

## Original Web Version

The original React/Vite web application is available at:
[https://github.com/valentineRutto/ZenTimer](https://github.com/valentineRutto/ZenTimer)

## Support

For issues, bugs, or feature requests, please open an issue on GitHub.

---

Built with ❤️ using Flutter
