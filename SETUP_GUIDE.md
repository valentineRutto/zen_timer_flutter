# ZenTimer Flutter - Setup & Deployment Guide

This guide will help you complete the setup and deployment of the Zen Focus Timer Flutter app.

## Prerequisites Installation

### 1. Flutter SDK Installation

If you haven't installed Flutter, download it from: https://flutter.dev/docs/get-started/install

```bash
# Verify Flutter installation
flutter --version
flutter doctor
```

### 2. Platform-Specific Setup

#### For iOS Development:
```bash
# Install Xcode (if not already installed)
# Then run:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# Install cocoapods
sudo gem install cocoapods
```

#### For Android Development:
```bash
# Install Android Studio
# Then configure:
flutter config --android-sdk=/path/to/android/sdk

# Create an Android emulator
flutter emulators create --name pixel5
flutter emulators launch pixel5
```

## Project Setup

### 1. Clone and Navigate
```bash
cd /Users/valentinerutto/Desktop/Timer
cd zen_timer_flutter
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Setup
```bash
flutter doctor
flutter analyze
```

## Running the App

### Development Mode

**Web Browser:**
```bash
flutter run -d chrome
```

**iOS Simulator:**
```bash
flutter run -d iphone
# or specific simulator
flutter run -d "iPhone 15 Pro"
```

**Android Emulator:**
```bash
flutter run -d android
```

**Physical Device:**
```bash
flutter run -d <device_id>
# List devices: flutter devices
```

### Hot Reload During Development
```bash
# After making code changes
r       # Hot reload
R       # Hot restart
q       # Quit
```

## Building for Release

### Web Release

```bash
flutter build web --release

# Output location: build/web/
# Deploy to:
# - Vercel: vercel deploy build/web
# - Firebase: firebase deploy --only hosting
# - GitHub Pages: Push build/web to gh-pages branch
```

### iOS Release

```bash
# Build for iOS
flutter build ios --release

# Open in Xcode
open ios/Runner.xcworkspace

# In Xcode:
# 1. Select "Runner" project
# 2. Select "Runner" target
# 3. Update version and build number
# 4. Product > Build For > Generic iOS Device
# 5. Validate and distribute through App Store Connect
```

**or use command line:**
```bash
flutter build ios --release
cd ios
xcodebuild -workspace Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -derivedDataPath build \
  -archivePath build/Runner.xcarchive \
  archive

cd build
xcodebuild -exportArchive \
  -archivePath Runner.xcarchive \
  -exportOptionsPlist ExportOptions.plist \
  -exportPath ./
```

### Android Release

**APK:**
```bash
flutter build apk --release

# Output: build/app/release/app-release.apk
# Install on device: flutter install --release
```

**App Bundle (for Play Store):**
```bash
flutter build appbundle --release

# Output: build/app/release/app-release.aab
```

**Manual signing:**
```bash
# Generate keystore (one time)
keytool -genkey -v -keystore ~/zen-timer-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias zen-timer-key

# Create android/key.properties
cat > android/key.properties << EOF
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=zen-timer-key
storeFile=../zen-timer-key.jks
EOF

# Build with signing
flutter build apk --release
```

### macOS Release

```bash
flutter build macos --release

# Output: build/macos/Build/Release/
```

### Windows Release

```bash
flutter build windows --release

# Output: build/windows/runner/Release/
```

### Linux Release

```bash
flutter build linux --release

# Output: build/linux/x64/release/bundle/
```

## Platform Configuration

### iOS App Store Configuration

1. Update `ios/Runner/Info.plist`:
```xml
<dict>
  <key>CFBundleName</key>
  <string>Zen Focus Timer</string>
  <key>CFBundleIdentifier</key>
  <string>com.zentimer.app</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0.0</string>
</dict>
```

2. Create App Store Connect account
3. Create app in App Store Connect
4. Configure signing certificates and provisioning profiles
5. Submit for review

### Android Play Store Configuration

1. Generate keystore (see above)
2. Create Google Play Console account
3. Create app in Play Console
4. Upload App Bundle
5. Configure store listing and content rating
6. Submit for review

### Web Deployment Options

**Firebase Hosting:**
```bash
firebase login
firebase init hosting
# Select build/web as public directory
flutter build web --release
firebase deploy
```

**Vercel:**
```bash
vercel login
cd build/web
vercel
```

**GitHub Pages:**
```bash
flutter build web --web-renderer html --release
# Push build/web to gh-pages branch
```

**Custom Server (Nginx):**
```bash
# Copy build/web to server
scp -r build/web user@host:/var/www/zen-timer/

# Nginx config
server {
  listen 80;
  server_name zen-timer.com;
  root /var/www/zen-timer;
  index index.html;
  
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

## Testing

### Unit Tests
```bash
flutter test
flutter test test/
```

### Integration Tests
```bash
flutter test integration_test/
```

### Performance Testing
```bash
flutter run --profile
```

## Debugging

### Debug Mode
```bash
flutter run
# Runs with all debug features enabled
```

### Flutter DevTools
```bash
flutter pub global activate devtools
flutter pub global run devtools

# or run from IDE
```

### Logging
```dart
import 'package:flutter/foundation.dart';

debugPrint('Debug message');
print('Standard output'); // Visible in logcat
```

## CI/CD Setup

### GitHub Actions

Create `.github/workflows/flutter.yml`:
```yaml
name: Flutter Build

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build web --release
```

## Common Issues & Solutions

### Issue: Pod install fails
```bash
# Solution:
cd ios
rm Podfile.lock
pod install
cd ..
flutter pub get
```

### Issue: Build cache issues
```bash
# Solution:
flutter clean
flutter pub get
flutter build <platform> --release
```

### Issue: Version conflicts
```bash
# Update dependencies
flutter pub upgrade
# Or to specific versions
flutter pub get
```

### Issue: Xcode build fails
```bash
# Solution:
cd ios
pod deintegrate
pod install
cd ..
```

## Performance Optimization

### Size Optimization
```bash
# Check app size
flutter build apk --split-per-abi --release

# Analyze what's included
flutter build web --release
# Check build/web/main.dart.js size
```

### Build Size Reduction
```bash
# Enable code shrinking (Android)
flutter build apk --target-platform android-arm64 --release

# Use tree shaking (Web)
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true
```

## Publishing Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Update `CHANGELOG.md`
- [ ] Run `flutter analyze`
- [ ] Run `flutter test`
- [ ] Test on all platforms
- [ ] Build release versions
- [ ] Sign applications
- [ ] Create app listings with screenshots
- [ ] Submit for review
- [ ] Monitor for approval

## Support & Help

- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Stack Overflow: Tag with `flutter`
- GitHub Issues: File issues in repository

---

For platform-specific documentation:
- [iOS Deployment](https://flutter.dev/docs/deployment/ios)
- [Android Deployment](https://flutter.dev/docs/deployment/android)
- [Web Deployment](https://flutter.dev/docs/deployment/web)
- [macOS Deployment](https://flutter.dev/docs/deployment/macos)
- [Windows Deployment](https://flutter.dev/docs/deployment/windows)
- [Linux Deployment](https://flutter.dev/docs/deployment/linux)
