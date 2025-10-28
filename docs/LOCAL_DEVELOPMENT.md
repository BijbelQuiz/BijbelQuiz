# Local Development Setup

This document explains how to set up and use the local development environment for BijbelQuiz v1.2.1+3.

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

The backend is located in the `websites/backend.bijbelquiz.app/` directory. For local development:

1. **Debug Mode** (uses production backend):
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

### Testing the Update Flow

To test the update flow:

1. Modify the version in `pubspec.yaml` to be lower than the production version (e.g., `1.1.1+2`)
2. Run the app in debug mode: `flutter run`
3. The app should detect the update and show the update dialog

### Running Tests

Execute the comprehensive test suite:

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/quiz_question_test.dart

# Run tests with debugging
flutter test --verbose
```

### Code Quality

```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format lib/

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
./build_all.sh

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

## Backend Development

For local backend development:
1. See documentation in `websites/backend.bijbelquiz.app/README.md`
2. The app defaults to production backend (`https://bijbelquiz.app/api`) in debug mode
3. Configure local backend URL in `lib/config/app_config.dart` if needed

## Troubleshooting

### Common Issues

1. **Build Failures**: Run `flutter clean` then `flutter pub get`
2. **Platform Issues**: Use `flutter doctor` to diagnose environment problems
3. **Performance Issues**: Check `PerformanceService` logs for optimization opportunities

### Dependencies

Install platform-specific dependencies:
- **Linux**: Run `./install_dependencies.sh` for CMake and build tools
- **macOS**: Install Xcode command line tools: `xcode-select --install`
- **Android**: Install Android Studio and configure `ANDROID_HOME`

## Version Management

- **Current Version**: 1.1.2+3
- **Flutter SDK Range**: >=3.2.3 <4.0.0
- **Dart SDK Range**: >=2.19 <4.0.0

For version updates:
1. Update version in `pubspec.yaml`
2. Update documentation version references
3. Test update flow as described above