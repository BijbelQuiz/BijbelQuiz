import 'package:posthog_flutter/posthog_flutter.dart';

/// A service that provides an interface to the PostHog analytics service.
///
/// This service is a singleton and can be accessed using `Provider.of<AnalyticsService>(context)`.
class AnalyticsService {
  /// Initializes the PostHog SDK.
  ///
  /// This should be called once when the app starts.
  Future<void> init() async {
    final config = PostHogConfig(
      'phc_WWdBwDKbzwCJ2iRbnWFI8m6lgnVFQCmMouRIaNBV2WF',
    );
    config.host = 'https://us.i.posthog.com';
    await Posthog().setup(config);
  }

  /// Returns a [PosthogObserver] that can be used to automatically track screen views.
  PosthogObserver getObserver() => PosthogObserver();

  /// Tracks a screen view.
  ///
  /// This should be called when a screen is displayed.
  /// The [screenName] is the name of the screen.
  Future<void> screen(String screenName) async {
    await Posthog().screen(screenName: screenName);
  }

  /// Tracks an event.
  ///
  /// The [eventName] is the name of the event.
  /// The [properties] are any additional data to send with the event.
  Future<void> capture(String eventName, {Map<String, Object>? properties}) async {
    await Posthog().capture(eventName: eventName, properties: properties);
  }
}
