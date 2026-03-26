# BijbelQuiz

![Tablet image](https://bijbelquiz.app/assets/images/promo-tablet-lesson-select-screen.png)

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
![CodeRabbit Pull Request Reviews](https://img.shields.io/coderabbit/prs/github/thomasboom/BijbelQuiz?utm_source=oss&utm_medium=github&utm_campaign=thomasboom%2FBijbelQuiz&labelColor=171717&color=FF570A&link=https%3A%2F%2Fcoderabbit.ai&label=CodeRabbit+Reviews)
![GitHub release](https://img.shields.io/github/v/release/thomasboom/BijbelQuiz)


BijbelQuiz is a cross-platform Bible quiz app designed to test and improve your knowledge of the Bible. Built with Flutter, it features multiple question types, performance optimizations for low-end devices, and comprehensive offline capabilities.

## 📱 Install BijbelQuiz

- **Google Play Store**: [Install](https://bijbelquiz.app/playstore)
- **Website**: [Play](https://bijbelquiz.app/play)
- **APK**: [Codeberg Releases](https://codeberg.org/thomasboom/BijbelQuiz/releases)

## 🚀 Getting Started

### Prerequisites

- **Flutter**: Version 3.2.3 or higher (current: 3.35.7)
- **Dart**: Version 2.19 or higher (current: 3.9.2)
- **Flutter SDK**: >=3.2.3 <4.0.0 (current: 3.35.4)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)

### Installation

1. **Clone the repository**:

    ```bash
    git clone https://codeberg.org/thomasboom/BijbelQuiz
    cd BijbelQuiz
    ```

2. **Navigate to the app directory**:

    ```bash
    cd app
    ```

3. **Install dependencies**:

    ```bash
    flutter pub get
    ```

4. **Set up development environment**:

    ```bash
    # For Android development
    flutter config --android-studio-dir /path/to/android/studio

    # For iOS development (macOS only)
    sudo gem install cocoapods
    ```

5. **Run the app**:

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

See [docs/ASSETS_LICENSES.md](docs/ASSETS_LICENSES.md) for details on the licenses of fonts, images, and sounds used in this app.

## Error Reporting

The app includes a centralized error reporting system that allows users to report bugs directly from the settings screen. The reported errors are stored in a Supabase database for debugging and monitoring purposes. See [docs/README-questions.md](docs/README-questions.md) for more technical details about the error reporting system.

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See [docs/LICENSE.md](docs/LICENSE) for details.

## Contact

For questions, suggestions, or security issues, contact: [thomasnowprod@proton.me](mailto:thomasnowprod@proton.me)

## Star History

<a href="https://www.star-history.com/#thomasboom/BijbelQuiz&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=thomasboom/BijbelQuiz&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=thomasboom/BijbelQuiz&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=thomasboom/BijbelQuiz&type=date&legend=top-left" />
 </picture>
</a>
