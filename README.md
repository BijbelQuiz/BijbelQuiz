# BijbelQuiz

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

BijbelQuiz is a cross-platform Bible quiz app designed to test and improve your knowledge of the Bible. Built with Flutter, it features multiple question types, performance optimizations for low-end devices, and comprehensive offline capabilities.

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

## Security

See [SECURITY_DOCS.md](SECURITY_DOCS.md) for details on security measures implemented in this app.

## Asset Licenses

See [ASSETS_LICENSES.md](ASSETS_LICENSES.md) for details on the licenses of fonts, images, and sounds used in this app.

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See [LICENSE.md](LICENSE.md) for details.

## Contact

For questions, suggestions, or security issues, contact: [thomasnowprod@proton.me](mailto:thomasnowprod@proton.me)
