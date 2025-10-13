# Analytics Documentation

This document explains the simplified analytics setup in the BijbelQuiz application, which uses PostHog for feature usage tracking.

## Overview

We use the `posthog_flutter` package to send events to PostHog. This allows us to understand which features users interact with, helping us prioritize development and improve user experience.

Users can opt out of analytics collection through a setting in the app's settings screen. All analytics methods respect this preference.

## AnalyticsService

The `AnalyticsService` is a focused wrapper around the `posthog_flutter` package that provides feature usage tracking capabilities. It is located in `bijbelquiz/lib/services/analytics_service.dart`.

### Core Methods

-   `init()`: Initializes the PostHog SDK with configuration and API keys
-   `getObserver()`: Returns a `PosthogObserver` for automatic screen view tracking
-   `screen(BuildContext context, String screenName)`: Tracks screen views with user preference checks
-   `capture(BuildContext context, String eventName, {Map<String, Object>? properties})`: Tracks custom events with optional properties

### Feature Usage Tracking

#### Primary Method
-   `trackFeatureUsage(BuildContext context, String feature, String action)`: Tracks which features users interact with and how they use them

This method allows us to track:
- Which features are most popular
- How users interact with specific features
- Feature adoption and usage patterns

## Tracked Events

The application now focuses on tracking feature usage to understand which features are most valuable to users.

### Feature Usage Events

All feature usage is tracked using the `trackFeatureUsage()` method with the following pattern:

```dart
analyticsService.trackFeatureUsage(context, 'feature_name', 'action_performed');
```

### Current Feature Usage Tracking

The following features are currently tracked across the application:

- **Onboarding**: `onboarding` - guide_opened, guide_finished
- **Social Features**: `social_features` - screen_accessed, available, unavailable
- **Donation**: `donation` - button_clicked
- **Biblical Reference**: `biblical_reference` - unlock_attempted

## How to Add Feature Usage Tracking

To track feature usage, use the `trackFeatureUsage()` method:

### Basic Feature Usage Tracking

1.  Get an instance of the `AnalyticsService` using `Provider.of<AnalyticsService>(context, listen: false)`.
2.  Call `trackFeatureUsage()` with the feature name and action.

### Usage Example

```dart
final analytics = Provider.of<AnalyticsService>(context, listen: false);

// Track feature usage
await analytics.trackFeatureUsage(context, 'new_feature', 'button_clicked');

// Track with additional properties
await analytics.trackFeatureUsage(
  context,
  'quiz_feature',
  'question_answered',
  additionalProperties: {
    'question_type': 'multiple_choice',
    'difficulty': 'easy',
  }
);
```

### Best Practices

1. **Use descriptive feature names**: Choose clear, consistent names for features
2. **Use descriptive actions**: Actions should clearly describe what the user did
3. **Include relevant context**: Add properties that help understand how features are used
4. **Respect user preferences**: The method automatically checks analytics settings
5. **Keep it focused**: Only track feature usage, not detailed user behavior or technical events

Note that the tracking method requires a `BuildContext` parameter to check the user's analytics preference setting and will automatically skip tracking if analytics are disabled.
