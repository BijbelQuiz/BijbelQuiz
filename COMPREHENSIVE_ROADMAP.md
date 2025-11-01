# BijbelQuiz Comprehensive Roadmap

## Goal

To develop and continuously improve the BijbelQuiz application, providing an engaging, educational, and interactive experience for users to learn about the Bible.

## Todo List

- [ ] Multimedia Support: Explore adding images, audio, or video to questions/lessons

  - Status: Not Started (no explicit multimedia question attachments or handlers found)

- [ ] Practice Mode Improvements: Allow category-specific practice sessions

  - Status: Partially Done — practice/free-practice flows and labels exist in the app (see `app/lib/widgets/progress_header.dart`, `app/lib/screens/store_screen.dart`, analytics event `start_practice_quiz` in `ANALYTICS.md`). Category-specific UI may still be missing.

- [ ] Streak Rewards: Implement streak milestone celebrations

  - Status: Partially Done — streak tracking is present (current/longest streak used in web builds and services; see `app/lib/services/progressive_question_selector.dart`, built web `main.dart.js` references). Celebration UI not found.

- [ ] Streak Rewards: Add streak protection mechanisms

  - Status: Partially Done — streak values are tracked and used; explicit protection mechanisms not found.

- [ ] Optimization: Improve app responsiveness and reduce load times

  - Status: Not Started / Ongoing — builds and web artifacts present but explicit optimization tasks not tracked here.

- [ ] Cross-Platform Compatibility: Ensure smooth operation across supported platforms (Android, iOS, Web, Desktop)

  - Status: Partially Done — repo contains platform folders (android/ios/web/linux/macos/windows) and build scripts (`app/build_all.sh`).

- [ ] Accessibility: Ensure the app is usable by a wide range of users

  - Status: Partially Done — some accessibility-aware labels exist but full audit not present.

- [ ] Loading States: Implement skeleton screens for lesson grids

  - Status: Not Started

- [ ] Loading States: Add progress indicators for question loading

  - Status: Partially Done — some loading feedback exists in question loading services (`app/lib/services/question_loading_service.dart`).

- [ ] Loading States: Show loading feedback during answer processing

  - Status: Partially Done — answer processing hooks exist in UI tests and services; explicit spinners per-answer not located.

- [ ] Error Handling: Add retry mechanisms for failed question loads

  - Status: Not Started / Partial — some error handling in services but no general retry framework located.

- [ ] Error Handling: Add user-friendly error messages with actionable steps

  - Status: Partially Done — some user-facing messages exist across UI, but not comprehensive.

- [ ] Enhanced Accessibility: Add more semantic labels and screen reader support

  - Status: Partially Done

- [ ] Enhanced Accessibility: Improve keyboard navigation

  - Status: Partially Done

- [ ] Enhanced Accessibility: Add focus management for screen readers

  - Status: Not Started / Partial

- [ ] Enhanced Accessibility: Implement proper heading hierarchy

  - Status: Not Started / Partial

- [ ] User Registration/Login: Allow users to create accounts and log in

  - Status: Not Started / Partial — web index and website folders include login references, but in-app auth flows are not clearly implemented in the app mobile code.

- [ ] Basic User Profiles: Display username, profile picture (optional), and basic game statistics (e.g., total quizzes played, correct answers)

  - Status: Not Started / Partial — game stats are tracked (score, streak, incorrect) and shown in places; a full profile UI is not found.

- [ ] Global Leaderboard: Rank users based on overall score or number of correct answers

  - Status: Not Started — no leaderboard implementation located.

- [ ] Friends Leaderboard: Allow users to see rankings among their friends

  - Status: Not Started

- [ ] Category-Specific Leaderboards

  - Status: Not Started

- [ ] Historical Performance Charts

  - Status: Not Started / Partial — progress data exists in providers but charting UI not found.

- [ ] Quiz Result Sharing: Allow users to share their quiz results on social media platforms (e.g., Facebook, X, WhatsApp) or via direct link

  - Status: Not Started — `url_launcher` plugin appears in symlinked plugins, but no share implementation discovered.

- [ ] Customizable Share Content: Generate shareable images or text snippets with quiz performance

  - Status: Not Started

- [ ] Add/Remove Friends: Allow users to send, accept, and decline friend requests

  - Status: Not Started

- [ ] Friend List: Display a list of connected friends

  - Status: Not Started

- [ ] Challenge Friends: Enable users to challenge friends to a specific quiz or set of questions

  - Status: Not Started

- [ ] Asynchronous Play: Allow challenges to be played at different times

  - Status: Not Started

- [ ] Challenge Notifications: Notify users of incoming challenges and results

  - Status: Not Started / Partial — notifications infra present but challenge-specific flow not found.

- [ ] Define Achievements: Create a system for earning achievements (e.g., "First Quiz Complete", "100 Correct Answers", "Master of Genesis")

  - Status: Not Started

- [ ] Display Achievements: Showcase earned achievements on user profiles

  - Status: Not Started

- [ ] Achievement Progress Tracking

  - Status: Not Started

- [ ] Achievement Showcase in Profile/Settings

  - Status: Not Started

- [ ] Time-Limited Special Question Sets

  - Status: Not Started

- [ ] Daily Streak Rewards

  - Status: Partially Done — streak tracking exists; reward mechanics not located.

- [ ] Challenge Completion Certificates

  - Status: Not Started

- [ ] Customizable Themes: Allow users to personalize the app's appearance

  - Status: Partially Done — theming exists under `app/lib/theme`.

- [ ] Progress Sync: Synchronize offline progress when online

  - Status: Partially Done — local progress and settings are stored using `shared_preferences` in multiple providers (`app/lib/providers/*_provider.dart`), but remote sync was not found.

- [ ] Question Categories: Allow filtering by biblical books or topics

  - Status: Partially Done — assets include `assets/categories.json` and category tooling (`assets/categories.py`) and UI references to categories; full filtering flows may exist.

- [ ] Question Categories: Category-based lesson creation

  - Status: Partially Done

- [ ] Progress Visualization: Provide better charts showing improvement over time

  - Status: Not Started

- [ ] Progress Visualization: Implement learning curve analytics

  - Status: Not Started

- [ ] Progress Visualization: Identify weak areas

  - Status: Not Started

- [ ] Study Mode: Non-timed mode for learning without pressure

  - Status: Partially Done — free/practice labels exist (`app/lib/l10n/strings_nl.dart` contains `freePractice`).

- [ ] Study Mode: Allow bookmarking difficult questions for review

  - Status: Not Started / Partial

- [ ] Multi-language Support: Expand beyond Dutch (English)

  - Status: Partially Done — `flutter_localizations` is enabled in `pubspec.yaml`, `app/lib/l10n/strings_nl.dart` exists, web manifest lang is `nl`, and question assets include `questions-nl-sv.json`. More languages need adding.

- [ ] Multi-language Support: Prepare for RTL language support

  - Status: Not Started / Partial

- [ ] Multi-language Support: Localize question content

  - Status: Partially Done — question assets are localized (Dutch/Swedish?) in `assets/questions-nl-sv.json`.

- [ ] Data Export/Import: Enable cross-device synchronization

  - Status: Not Started

- [ ] Data Export/Import: Facilitate data migration between app versions

  - Status: Not Started

- [ ] Premium Content: Offer exclusive question sets or features

  - Status: Not Started / Partial — in-app store screen exists (`app/lib/screens/store_screen.dart`) but monetization flow not fully evident.

- [ ] Ad Integration: (Carefully considered) Non-intrusive advertising

  - Status: Not Started

- [ ] Backend API: Develop a robust and scalable backend for all dynamic features

  - Status: Partially Done — `app/lib/config/app_config.dart` references `https://backend.bijbelquiz.app/api` and there is a `websites/backend.bijbelquiz.app/` folder; full backend implementation coverage unclear.

- [ ] Authentication: Implement secure and flexible authentication methods

  - Status: Not Started / Partial — web login references exist in website assets but in-app auth flows are not obvious.

- [ ] Real-time Communication: Utilize WebSockets for interactive features

  - Status: Not Started

- [ ] Notifications: Implement push notifications for various app events

  - Status: Partially Done — `flutter_local_notifications_plus` is in `pubspec.yaml` and notification settings are covered in tests (`app/test/settings_provider_test.dart`).

- [ ] Scalability & Security: Design the system for future growth and protect user data
  - Status: Ongoing / Not Fully Tracked — security docs exist (`SECURITY_DOCS.md`) and some best practices are documented.
