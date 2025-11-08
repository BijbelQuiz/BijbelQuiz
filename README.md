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
    git clone https://github.com/BijbelQuiz/BijbelQuiz
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
│   │   ├── config/            # App configuration
│   │   ├── constants/         # App constants and URLs
│   │   ├── l10n/              # Localization strings
│   │   ├── models/            # Data models
│   │   ├── providers/         # State management using Provider pattern
│   │   ├── services/          # Business logic and external integrations
│   │   ├── screens/           # UI screens
│   │   ├── widgets/           # Reusable UI components
│   │   ├── theme/             # Theme definitions
│   │   └── utils/             # Utility functions
│   ├── android/               # Android platform code
│   ├── ios/                   # iOS platform code
│   ├── linux/                 # Linux platform code
│   ├── macos/                 # macOS platform code
│   ├── web/                   # Web platform code
│   ├── windows/               # Windows platform code
│   ├── assets/                # App assets (questions, fonts, sounds)
│   ├── test/                  # Unit and integration tests
│   └── build_all.sh           # Build script for all platforms
├── docs/                      # Documentation (all .md files)
└── websites/                  # Web assets and backend
    ├── backend.bijbelquiz.app/ # Backend API and admin tools
    │   ├── api/               # REST API endpoints
    │   ├── question-editor/   # Web-based question management tool
    │   └── README.md          # Backend documentation
    ├── bijbelquiz.app/        # Main website
    │   ├── blog/              # Blog posts
    │   ├── downloads/         # Download links
    │   └── instructie/        # Instructions and guides
    └── play.bijbelquiz.app/   # Web app version (Flutter web build)
```

## Features

- **Multiple Question Types**: Multiple choice, fill-in-the-blank, and true/false questions
- **Performance Optimized**: Optimized for low-end devices with efficient data structures
- **Cross-Platform**: Works on Android, iOS, Web, and Desktop
- **Offline Capable**: All questions work offline
- **User-Friendly Interface**: Intuitive navigation and clean design
- **Centralized Error Reporting**: Built-in bug reporting system integrated with Supabase
- **Analytics**: Comprehensive usage tracking and analytics
- **Customizable Themes**: Multiple theme options including dark mode and AI-generated themes

## Security

See [SECURITY_DOCS.md](SECURITY_DOCS.md) for details on security measures implemented in this app.

## Asset Licenses

See [ASSETS_LICENSES.md](ASSETS_LICENSES.md) for details on the licenses of fonts, images, and sounds used in this app.

## Error Reporting

The app includes a centralized error reporting system that allows users to report bugs directly from the settings screen. The reported errors are stored in a Supabase database for debugging and monitoring purposes. See [README-questions.md](README-questions.md) for more technical details about the error reporting system.

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See [LICENSE.md](LICENSE.md) for details.

## Contact

For questions, suggestions, or security issues, contact: [thomasnowprod@proton.me](mailto:thomasnowprod@proton.me)
