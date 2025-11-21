import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:bijbelquiz/providers/settings_provider.dart';
import 'package:bijbelquiz/providers/messages_provider.dart';

import '../screens/lesson_select_screen.dart';
import '../screens/store_screen.dart';
import '../screens/social_screen.dart';
import '../settings_screen.dart';
import '../l10n/strings_nl.dart' as strings;

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  List<Widget> _getScreens() {
    return [
      const LessonSelectScreen(),
      const StoreScreen(),
      const SocialScreen(),
      const SettingsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;

      // Track screen view in analytics
      final screenNames = [
        'LessonSelectScreen',
        'StoreScreen',
        'SocialScreen',
        'SettingsScreen'
      ];
      final analyticsService =
          Provider.of<AnalyticsService>(context, listen: false);
      analyticsService.screen(context, screenNames[index]);

      // Track feature usage for main navigation
      final featureNames = [
        AnalyticsService.featureLessonSystem,
        AnalyticsService.featureThemePurchases,
        AnalyticsService.featureSocialFeatures,
        AnalyticsService.featureSettings
      ];
      analyticsService.trackFeatureStart(context, featureNames[index]);
    });
  }

  /// Builds the social destination with activity indicator for unread messages
  NavigationDestination _buildSocialDestination() {
    final messagesProvider = Provider.of<MessagesProvider>(context);
    final hasUnreadMessages = messagesProvider.hasUnreadMessages;

    return NavigationDestination(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.groups_outlined),
          if (hasUnreadMessages)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
      selectedIcon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.groups),
          if (hasUnreadMessages)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
      label: strings.AppStrings.social,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screens = _getScreens();
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onItemTapped,
        elevation: 10,
        height: settings.showNavigationLabels
            ? 80
            : 60, // Reduce height when labels are hidden
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.1),
        labelBehavior: settings.showNavigationLabels
            ? NavigationDestinationLabelBehavior.alwaysShow
            : NavigationDestinationLabelBehavior
                .alwaysHide, // Properly hide labels
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: strings.AppStrings.lessons,
          ),
          NavigationDestination(
            icon: const Icon(Icons.store_outlined),
            selectedIcon: const Icon(Icons.store),
            label: strings.AppStrings.store,
          ),
          _buildSocialDestination(),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: strings.AppStrings.settings,
          ),
        ],
      ),
    );
  }
}
