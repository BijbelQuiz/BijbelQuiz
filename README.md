# BijbelQuiz

BijbelQuiz is a Flutter-based mobile application designed for Bible quizzes, featuring interactive lessons, questions, and progress tracking.

## Project Structure

### Root Directory

- `.gitignore`: Git ignore rules
- `app/`: Main Flutter application
- `docs/`: Documentation files
- `websites/`: Web applications and services

### app/ Directory

The core Flutter application with the following structure:

- `android/`: Android-specific configuration and code
  - `app/src/main/`: Main Android source code
  - `gradle/`: Gradle build files
- `ios/`: iOS-specific configuration and code
  - `Runner/`: iOS runner app
- `lib/`: Dart source code
  - `config/`: Application configuration
  - `constants/`: Constant values and URLs
  - `l10n/`: Localization strings
  - `models/`: Data models (Lesson, QuizQuestion, QuizState)
  - `providers/`: State management providers
  - `screens/`: UI screens (Quiz, Lesson Select, etc.)
  - `services/`: Business logic services (Sound, Notifications, etc.)
  - `theme/`: Application theming
  - `utils/`: Utility functions
  - `widgets/`: Reusable UI widgets
- `assets/`: Static assets
  - `categories.json`: Quiz categories
  - `questions-nl-sv.json`: Questions in Dutch and Swedish
  - `fonts/`: Custom fonts (Quicksand)
  - `icon/`: App icons
  - `sounds/`: Audio files for feedback
- `linux/`, `macos/`, `web/`, `windows/`: Platform-specific code
- `test/`: Unit tests

### docs/ Directory

Documentation for the project.

### websites/ Directory

Web applications:

- `backend.bijbelquiz.app/`: Backend API and services
  - `api/`: API endpoints
  - `question-editor/`: Question editing interface
- `bijbelquiz.app/`: Main website
  - `blog/`: Blog content
  - `downloads/`: Downloadable resources
  - `instructie/`: Download instructions
- `play.bijbelquiz.app/`: Web version of the app

## Getting Started

1. Ensure Flutter is installed: [Flutter Installation](https://flutter.dev/docs/get-started/install)
2. Clone the repository
3. Navigate to `app/` directory
4. Run `flutter pub get` to install dependencies
5. Run `flutter run` to start the app

## Features

- Interactive Bible quizzes
- Multiple languages (Dutch, Swedish)
- Progress tracking
- Sound effects
- Offline support
- Cross-platform (Android, iOS, Web, Desktop, some aren't finished yet)

## Git repositories

- [Codeberg](https://codeberg.org/ThomasNowProductions/BijbelQuiz) (primary)
- [GitHub](https://github.com/ThomasNowProductions/BijbelQuiz) (secondary)
- [GitLab](https://gitlab.com/ThomasNow/bijbelquiz) (tertiary)

Please open as much as possible issues and pull requests on Codeberg.
