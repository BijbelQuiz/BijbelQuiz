# Analytics Documentation

This document explains the analytics setup in the BijbelQuiz application, which uses PostHog for event tracking and product analytics.

## Overview

We use the `posthog_flutter` package to send events to PostHog. This allows us to understand how users interact with the app, identify areas for improvement, and make data-driven decisions.

Users can opt out of analytics collection through a setting in the app's settings screen.

## AnalyticsService

The `AnalyticsService` is a wrapper around the `posthog_flutter` package that provides a simple interface for tracking events. It is located in `app/lib/services/analytics_service.dart`.

### Methods

-   `init()`: Initializes the PostHog SDK. This should be called once when the app starts.
-   `getObserver()`: Returns a `PosthogObserver` that can be used to automatically track screen views.
-   `screen(BuildContext context, String screenName)`: Tracks a screen view. Respects the user's analytics preference setting.
-   `capture(BuildContext context, String eventName, {Map<String, Object>? properties})`: Tracks an event. Respects the user's analytics preference setting.

## Tracked Events

The following is a list of all the events that are currently being tracked in the app.

### `lesson_select_screen.dart`

-   **Screen View**: `LessonSelectScreen`
-   **Load Lessons**: `load_lessons`
-   **Load Lessons Error**: `load_lessons_error`
-   **Show Promo Card**: `show_promo_card`
-   **Tap Settings**: `tap_settings`
-   **Tap Store**: `tap_store`
-   **Dismiss Promo Card**: `dismiss_promo_card`
-   **Tap Donation Promo**: `tap_donation_promo`
-   **Tap Satisfaction Promo**: `tap_satisfaction_promo`
-   **Tap Follow Promo**: `tap_follow_promo`
-   **Tap Locked Lesson**: `tap_locked_lesson`
-   **Tap Unplayable Lesson**: `tap_unplayable_lesson`
-   **Tap Lesson**: `tap_lesson`
-   **Start Quiz**: `start_quiz`
-   **Start Practice Quiz**: `start_practice_quiz`

### `quiz_screen.dart`

-   **Screen View**: `QuizScreen`
-   **Show Time Up Dialog**: `show_time_up_dialog`
-   **Retry With Points**: `retry_with_points`
-   **Next Question From Time Up**: `next_question_from_time_up`
-   **Language Changed**: `language_changed`
-   **Lesson Completed**: `lesson_completed`
-   **Skip Question**: `skip_question`
-   **Unlock Biblical Reference**: `unlock_biblical_reference`

### `settings_screen.dart`

-   **Screen View**: `SettingsScreen`
-   **Open Status Page**: `open_status_page`
-   **Check For Updates**: `check_for_updates`
-   **Change Theme**: `change_theme`
-   **Change Game Speed**: `change_game_speed`
-   **Toggle Mute**: `toggle_mute`
-   **Toggle Notifications**: `toggle_notifications`
-   **Donate**: `donate`
-   **Show Reset and Logout Dialog**: `show_reset_and_logout_dialog`
-   **Reset and Logout**: `reset_and_logout`
-   **Show Introduction**: `show_introduction`
-   **Report Issue**: `report_issue`
-   **Export Stats**: `export_stats`
-   **Import Stats**: `import_stats`
-   **Clear Question Cache**: `clear_question_cache`
-   **Contact Us**: `contact_us`
-   **Show Social Media Dialog**: `show_social_media_dialog`
-   **Follow Social Media**: `follow_social_media`

### `guide_screen.dart`

-   **Screen View**: `GuideScreen`
-   **Guide Page Viewed**: `guide_page_viewed`
-   **Guide Completed**: `guide_completed`
-   **Guide Donation Button Clicked**: `guide_donation_button_clicked`
-   **Guide Notification Permission Requested**: `guide_notification_permission_requested`

### `lesson_complete_screen.dart`

-   **Screen View**: `LessonCompleteScreen`
-   **Retry Lesson From Complete**: `retry_lesson_from_complete`
-   **Start Next Lesson From Complete**: `start_next_lesson_from_complete`

### `store_screen.dart`

-   **Screen View**: `StoreScreen`
-   **Purchase Power-up**: `purchase_powerup`
-   **Purchase Theme**: `purchase_theme`

## How to Add New Tracking Events

To add a new tracking event, you can use the `AnalyticsService`.

1.  Get an instance of the `AnalyticsService` using `Provider.of<AnalyticsService>(context, listen: false)`.
2.  Call the `capture` method with the event name and any properties.

```dart
Provider.of<AnalyticsService>(context, listen: false).capture(context, 'my_event', properties: {'my_property': 'my_value'});
```

Note that both the `screen` and `capture` methods now require a `BuildContext` parameter to check the user's analytics preference setting.
