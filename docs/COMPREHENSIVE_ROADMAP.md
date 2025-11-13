# BijbelQuiz Comprehensive Roadmap

## Goal

To develop and continuously improve the BijbelQuiz application, providing an engaging, educational, and interactive experience for users to learn about the Bible.

## Todo List

- [ ] Practice Mode Improvements: Allow category-specific practice sessions

  - Status: not implemented

- [ ] Streak Rewards: Implement streak milestone celebrations

  - Status: not implemented

- [ ] Streak Rewards: Add streak protection mechanisms

  - Status: partially implemented: already freezes streak on Sundays·

- [ ] Cross-Platform Compatibility: Add official support for Linux and Windows

  - Status: not implemented

- [ ] Accessibility: Ensure the app is usable by a wide range of users

  - Status: Partially Done — some accessibility-aware labels exist but full audit not present.

- [ ] Improve keyboard navigation

  - Status: Partially Done


- [ ] Basic User Profiles: Display username, profile picture (optional), and basic game statistics (e.g., total quizzes played, correct answers)

  - Status: partially implemented: already added a BQID

- [ ] Global Leaderboard: Rank users based on overall score or number of correct answers

  - Status: Not Started

- [ ] Customizable Share Content: Generate shareable images or text snippets with quiz performance

  - Status: Not Started

- [ ] Challenge Friends: Enable users to challenge friends to a specific quiz or set of questions

  - Status: Not Started

- [ ] Asynchronous Play: Allow challenges to be played at different times

  - Status: Not Started

- [ ] Challenge Notifications: Notify users of incoming challenges and results

  - Status: Not Started

- [ ] Define Achievements: Create a system for earning achievements (e.g., "First Quiz Complete", "100 Correct Answers", "Master of Genesis")

  - Status: Not Started

- [ ] Daily Streak Rewards

  - Status: Partially Done:streak tracking exists

- [ ] Question Categories: Allow filtering by biblical books or topics

  - Status: Partially Done — assets include `assets/categories.json` and category tooling (`assets/categories.py`) and UI references to categories; full filtering flows may exist.

- [ ] Progress Visualization: Provide better charts showing improvement over time

  - Status: Not Started

- [ ] Study Mode: Allow bookmarking difficult questions for review

  - Status: Not Started / Partial

- [ ] Multi-language Support: Expand beyond Dutch (English)

  - Status: Partially Done — `flutter_localizations` is enabled in `pubspec.yaml`, `app/lib/l10n/strings_nl.dart` exists, web manifest lang is `nl`, and question assets include `questions-nl-sv.json`. More languages need adding.


- [ ] Premium Content: Offer exclusive question sets or features

  - Status: Not Started / Partial — in-app store screen exists (`app/lib/screens/store_screen.dart`) but monetization flow not fully evident.
