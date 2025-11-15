# Local Development Setup

This document explains how to set up and use the local development environment for BijbelQuiz.

## Prerequisites

- **Flutter SDK**: Version 3.2.3 or higher (current: 3.35.4)
- **Dart SDK**: Version 2.19 or higher (current: 3.9.2)

## Environment Setup

1. **Install Flutter**: Follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install)
2. **Verify Installation**:
   ```bash
   flutter doctor
   flutter --version
   ```

## Development Workflow

### Running the App

The app is located in the `app/` directory:

1. **Debug Mode**:
   ```bash
   flutter run
   ```

2. **Profile Mode** (performance testing):
   ```bash
   flutter run --profile
   ```

3. **Release Mode** (production testing):
   ```bash
   flutter run --release
   ```

4. **Platform-specific**:
   ```bash
   # Android
   flutter run -d android

   # iOS (macOS only)
   flutter run -d ios

   # Web
   flutter run -d chrome

   # Desktop
   flutter run -d linux  # or macos, windows
   ```

### Code Quality

```bash
# Analyze code for issues
flutter analyze

# Check for outdated dependencies
flutter pub outdated

# Upgrade dependencies
flutter pub upgrade
```

## Development Tools

### Build Scripts

Use the provided build script for multi-platform builds:

```bash
# Build for all platforms
cd scripts && ./build_all.sh

# Build specific platform
flutter build apk --release
flutter build ios --release
flutter build web --release
flutter build linux --release
```

### Debugging

1. **Flutter DevTools**:
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

2. **Performance Monitoring**: The app includes built-in performance monitoring via `PerformanceService`

3. **Logging**: Comprehensive logging system with configurable levels via `Logger` service

### Dependencies

Install platform-specific dependencies:
- **Linux**: Run `./install_dependencies.sh` for CMake and build tools
- **macOS**: Install Xcode command line tools: `xcode-select --install`
- **Android**: Install Android Studio and configure `ANDROID_HOME`
