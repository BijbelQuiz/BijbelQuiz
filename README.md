# BijbelQuiz

**Version 1.2.3+10**

BijbelQuiz is a cross-platform Bible quiz app designed to test and improve your knowledge of the Bible. Built with Flutter, it features multiple question types, performance optimizations for low-end devices, and comprehensive offline capabilities.

**Note: The app is only available in Dutch. All in-app content, questions, and UI are in Dutch.**

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

BijbelQuiz is a cross-platform Bible quiz app designed to test and improve your knowledge of the Bible. Built with Flutter, it features multiple question types, performance optimizations for low-end devices, and comprehensive offline capabilities.

**Note: The app is only available in Dutch. All in-app content, questions, and UI are in Dutch.**

## ✨ Features

### Core Functionality

- **Multiple Question Types**: Multiple choice, fill-in-the-blank, and true/false questions
- **Adaptive Difficulty**: Progressive Question Up-selection (PQU) algorithm adjusts difficulty based on performance
- **Comprehensive Scoring**: Tracks score, streaks, longest streaks, and incorrect answers
- **Lesson Mode**: Structured learning with unlockable content and progress tracking

### User Experience

- **Performance Optimized**: Special optimizations for low-end devices and poor connections
- **Offline First**: Complete offline functionality with question caching
- **Sound & Haptics**: Audio feedback and haptic responses (where supported)
- **Customizable Themes**: Multiple theme options including OLED-friendly dark theme
- **Responsive Design**: Optimized for phones, tablets, and desktop

### Advanced Features

- **Power-ups**: Score multipliers and time bonuses
- **Biblical References**: Unlockable scripture references for deeper study
- **Local Notifications**: Daily motivation reminders
- **Telemetry & Analytics**: Optional usage analytics with user consent
- **Data Export/Import**: Backup and restore user progress and settings

### Technical Features

- **Cross-Platform**: Android, iOS, Web, Linux, macOS, Windows
- **Provider Architecture**: Clean state management with ChangeNotifier
- **Service-Oriented Design**: Modular services for different app functions
- **Performance Monitoring**: Real-time frame rate and memory usage tracking
- **QuizSoundService**: Centralized sound management with mute support
- **QuestionLoadingService**: Advanced background question loading with predictive caching

## 🚀 Getting Started

### Prerequisites

- **Flutter**: Version 3.2.3 or higher (current: 3.35.4)
- **Dart**: Version 2.19 or higher (current: 3.9.2)
- **Flutter SDK**: >=3.2.3 <4.0.0 (current: 3.35.4)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)

### Installation

1. **Clone the repository**:

    ```bash
    git clone <repository-url>
    cd BijbelQuiz
    ```

2. **Install dependencies**:

    ```bash
    flutter pub get
    ```

3. **Set up development environment**:

    ```bash
    # For Android development
    flutter config --android-studio-dir /path/to/android/studio

    # For iOS development (macOS only)
    sudo gem install cocoapods
    ```

4. **Run the app**:

    ```bash
    # For Android
    flutter run

    # For iOS (macOS only)
    flutter run --device-id <iOS-device-id>

    # For Web
    flutter run -d chrome

    # For Desktop
    flutter run -d linux  # or macos, windows
    ```

### Development Commands

```bash
# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Build for production
flutter build apk --release
flutter build ios --release
flutter build web --release
```

## 🏗️ Architecture

### Project Structure

```bash
BijbelQuiz/
├── app/                       # Main Flutter application
│   ├── lib/                   # Dart source code
│   │   ├── main.dart          # App entry point and theme configuration
│   │   ├── settings_screen.dart # Settings screen
│   │   ├── config/            # App configuration
│   │   ├── constants/         # App constants and URLs
│   │   ├── l10n/              # Localization strings
│   │   ├── models/            # Data models
│   │   │   ├── quiz_question.dart   # Question data structure
│   │   │   ├── quiz_state.dart      # Quiz session state
│   │   │   ├── lesson.dart          # Lesson configuration
│   │   │   ├── bible_reference.dart # Bible reference model
│   │   │   └── ai_theme.dart         # AI theme model
│   │   ├── providers/         # State management using Provider pattern
│   │   │   ├── settings_provider.dart    # App settings and preferences
│   │   │   ├── game_stats_provider.dart  # Game statistics and scoring
│   │   │   └── lesson_progress_provider.dart # Lesson unlock progress
│   │   ├── services/          # Business logic and external integrations
│   │   │   ├── logger.dart            # Centralized logging
│   │   │   ├── performance_service.dart # Performance monitoring
│   │   │   ├── sound_service.dart     # Audio playback
│   │   │   ├── connection_service.dart # Network connectivity
│   │   │   ├── question_cache_service.dart # Question caching
│   │   │   ├── notification_service.dart # Local notifications
│   │   │   ├── progressive_question_selector.dart # Question difficulty algorithm
│   │   │   ├── quiz_animation_controller.dart # Animation management
│   │   │   ├── analytics_service.dart # Analytics and telemetry
│   │   │   ├── feature_flags_service.dart # Feature flag management
│   │   │   ├── gemini_service.dart    # AI/Gemini integration
│   │   │   ├── lesson_service.dart    # Lesson management
│   │   │   ├── platform_feedback_service.dart # Platform-specific feedback
│   │   │   ├── quiz_answer_handler.dart # Quiz answer processing
│   │   │   ├── quiz_sound_service.dart # Quiz sound management
│   │   │   └── quiz_timer_manager.dart # Quiz timer functionality
│   │   ├── screens/           # UI screens
│   │   │   ├── quiz_screen.dart         # Main quiz interface
│   │   │   ├── lesson_select_screen.dart # Lesson selection
│   │   │   ├── lesson_complete_screen.dart # Lesson completion
│   │   │   ├── guide_screen.dart        # User guide
│   │   │   ├── store_screen.dart        # In-app store
│   │   │   ├── main_navigation_screen.dart # Main navigation
│   │   │   └── social_screen.dart       # Social features
│   │   ├── widgets/           # Reusable UI components
│   │   ├── theme/             # Theme definitions
│   │   │   └── app_theme.dart          # App theming
│   │   └── utils/             # Utility functions
│   ├── android/               # Android platform code
│   ├── ios/                   # iOS platform code
│   ├── linux/                 # Linux platform code
│   ├── macos/                 # macOS platform code
│   ├── web/                   # Web platform code
│   ├── windows/               # Windows platform code
│   ├── assets/                # App assets (questions, fonts, sounds)
│   ├── test/                  # Unit and integration tests
│   ├── pubspec.yaml           # Flutter dependencies and configuration
│   └── build_all.sh           # Build script for all platforms
├── [Documentation files]      # Documentation (all .md files)
│   ├── README.md              # Main project documentation
│   ├── CONTRIBUTING.md        # Contribution guidelines
│   ├── LICENSE.md             # GPL-3.0 license
│   ├── SECURITY.md            # Security policy
│   ├── SECURITY_DOCS.md       # Security documentation
│   ├── LOCAL_DEVELOPMENT.md   # Local development setup
│   ├── README-questions.md    # Question format documentation
│   ├── CODE_OF_CONDUCT.md     # Code of conduct
│   ├── COMPREHENSIVE_ROADMAP.md # Project roadmap
│   ├── ANALYTICS.md           # Analytics documentation
│   ├── ASSETS_LICENSES.md     # Asset licenses
│   ├── SERVICES.md            # Services documentation
│   ├── EMERGENCY_SYSTEM.md    # Emergency messaging system
│   ├── MCP_SERVER_DOCS.md     # MCP server documentation
│   ├── RISK_MONITORING.md     # API security inventory
│   └── question_picking_algorithm.md # Question selection algorithm
└── websites/                  # Web assets and backend
    ├── backend.bijbelquiz.app/ # Backend API and admin tools
    │   ├── api/               # REST API endpoints
    │   ├── question-editor/   # Web-based question management tool
    │   └── README.md          # Backend documentation
    ├── bijbelquiz.app/        # Main website
    │   ├── index.html         # Homepage
    │   ├── download.html      # Download page
    │   ├── donate.html        # Donation page
    │   ├── blog/              # Blog posts
    │   ├── downloads/         # Download links
    │   └── instructie/        # Instructions and guides
    └── play.bijbelquiz.app/   # Web app version (Flutter web build)
```

### Design Patterns

- **Provider Pattern**: State management for reactive UI updates
- **Service Layer**: Separation of business logic from UI
- **Repository Pattern**: Data access abstraction
- **Factory Pattern**: Object creation for models
- **Observer Pattern**: Event handling and notifications

### Key Components

#### Progressive Question Up-selection (PQU)

The app uses an intelligent difficulty adjustment algorithm that:

- Analyzes user performance across multiple metrics
- Adjusts question difficulty dynamically
- Prevents getting stuck at the same difficulty level
- Balances challenge with achievability

#### Performance Optimization

- **Frame Rate Monitoring**: Real-time performance tracking
- **Memory Management**: Automatic cache optimization
- **Adaptive Animations**: Duration adjustment based on device capabilities
- **Lazy Loading**: Progressive question loading to reduce startup time

#### Offline-First Design

- **Question Caching**: Local storage of question data
- **Background Sync**: Automatic data updates when online
- **Graceful Degradation**: Full functionality without network

## 🔧 Troubleshooting

### Notifications Not Working

If you're not receiving daily motivation notifications:

**Android:**

1. **App Settings**: Ensure notifications are enabled in app settings
2. **System Permissions**: Check notification permissions in device settings
3. **Android 12+**: Enable "Schedule exact alarms" permission
4. **Battery Optimization**: Disable battery optimization for the app
5. **Background Execution**: Allow background execution in battery settings

**iOS:**

1. **System Settings**: Enable notifications for the app
2. **Focus Modes**: Check if notifications are blocked by Focus/DND modes
3. **Background Refresh**: Ensure background app refresh is enabled

**General:**

1. **Restart App**: Force stop and restart the application
2. **Check Time Zone**: Verify device time zone is correct
3. **Network**: Ensure device has internet for initial setup

### Performance Issues

**Low Frame Rate:**

- The app automatically detects low-end devices and adjusts animations
- Try restarting the app to reset performance monitoring
- Check for background apps consuming resources

**Slow Loading:**

- Clear app cache in device settings
- Ensure stable internet connection for initial data load
- Try restarting the app

**Memory Issues:**

- The app includes automatic memory optimization
- Restart the app if memory usage seems high
- Check available device storage

### Audio Problems

**No Sound Effects:**

- Check if sound is muted in app settings
- Verify device volume is not muted
- For Linux: Install audio players (mpg123, ffplay)

**Audio Playback Errors:**

- Try restarting the app
- Check system audio configuration
- For Linux: Verify audio drivers are working

## 📚 API Reference

### Core Classes

#### QuizQuestion

```dart
class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final String difficulty;
  final QuestionType type;
  final List<String> categories;
  final String? biblicalReference;

  // Factory constructor for JSON parsing
  factory QuizQuestion.fromJson(Map<String, dynamic> json)

  // Convert to JSON for caching
  Map<String, dynamic> toJson()
}
```

#### GameStatsProvider

```dart
class GameStatsProvider extends ChangeNotifier {
  int get score;
  int get currentStreak;
  int get longestStreak;

  Future<void> updateStats({required bool isCorrect});
  Future<bool> spendPointsForRetry();
  Future<bool> spendStars(int amount);
}
```

#### SettingsProvider

```dart
class SettingsProvider extends ChangeNotifier {
  ThemeMode get themeMode;
  String get gameSpeed;
  bool get mute;
  bool get notificationEnabled;

  Future<void> setThemeMode(ThemeMode mode);
  Future<void> setGameSpeed(String speed);
  Future<void> setMute(bool enabled);
}
```

### Services

- **PerformanceService**: Monitors and optimizes app performance
- **SoundService**: Handles audio playback across platforms
- **QuizSoundService**: Centralized quiz sound management with mute support
- **QuestionLoadingService**: Advanced background question loading with predictive caching
- **ConnectionService**: Manages network connectivity
- **QuestionCacheService**: Caches questions for offline use
- **NotificationService**: Local notification management for daily motivation reminders
- **ProgressiveQuestionSelector**: Intelligent difficulty adjustment algorithm
- **QuizAnimationController**: Animation management
- **AnalyticsService**: Analytics and telemetry service
- **FeatureFlagsService**: Feature flag management
- **GeminiService**: AI/Gemini integration service
- **LessonService**: Lesson management service
- **PlatformFeedbackService**: Platform-specific feedback service
- **QuizAnswerHandler**: Quiz answer processing service
- **QuizTimerManager**: Quiz timer functionality
- **Logger**: Centralized logging with configurable levels

## 📚 Additional Documentation

- **[ANALYTICS.md](ANALYTICS.md)**: Detailed documentation of the analytics setup
- **[SERVICES.md](SERVICES.md)**: Detailed documentation of all application services
- **[EMERGENCY_SYSTEM.md](EMERGENCY_SYSTEM.md)**: Emergency messaging system documentation
- **[LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md)**: Local development setup guide
- **[README-questions.md](README-questions.md)**: Question format documentation
- **[COMPREHENSIVE_ROADMAP.md](COMPREHENSIVE_ROADMAP.md)**: Project roadmap and feature planning
- **[ASSETS_LICENSES.md](ASSETS_LICENSES.md)**: Licenses for third-party assets
- **[MCP_SERVER_DOCS.md](MCP_SERVER_DOCS.md)**: Model Context Protocol server documentation
- **[RISK_MONITORING.md](RISK_MONITORING.md)**: API security inventory and risk assessment
- **[question_picking_algorithm.md](question_picking_algorithm.md)**: Detailed algorithm documentation

## 🤝 Contributing

We welcome contributions! Here's how you can help:

### Development Workflow

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/your-feature-name`
3. **Make** your changes with proper documentation
4. **Test** thoroughly on multiple platforms
5. **Commit** with clear messages: `git commit -m "Add: feature description"`
6. **Push** to your branch: `git push origin feature/your-feature-name`
7. **Create** a Pull Request

### Code Guidelines

- **Dart/Flutter Best Practices**: Follow official style guides
- **Documentation**: Add doc comments for public APIs
- **Testing**: Include unit tests for new features
- **Performance**: Consider performance impact of changes
- **Cross-Platform**: Test on Android, iOS, and Web

### Areas for Contribution

- **Question Content**: Add new Bible questions
- **UI/UX Improvements**: Enhance user interface
- **Performance**: Optimize for low-end devices
- **Accessibility**: Improve screen reader support
- **Internationalization**: Add support for other languages
- **Testing**: Increase test coverage

### Issue Reporting

When reporting bugs, please include:

- Device/platform information
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/logs if applicable

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## Build & Test

To build for your platform:

- **Web:**

  ```sh
  flutter build web
  ```

- **Android:**

  ```sh
  flutter build apk --release
  ```

- **iOS:**

  ```sh
  flutter build ios --release
  ```

- **Linux:**

  ```sh
  flutter build linux --release
  ```

- **macOS:**

  ```sh
  flutter build macos --release
  ```

- **Windows:**

  ```sh
  flutter build windows --release
  ```

To run tests:

```sh
flutter test
```

## Security

See [SECURITY_DOCS.md](SECURITY_DOCS.md) for details on security measures implemented in this app.

## Asset Licenses

See [ASSETS_LICENSES.md](ASSETS_LICENSES.md) for details on the licenses of fonts, images, and sounds used in this app.

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See [LICENSE.md](LICENSE.md) for details.

## Contact

For questions, suggestions, or security issues, contact: [thomasnowprod@proton.me](mailto:thomasnowprod@proton.me)
