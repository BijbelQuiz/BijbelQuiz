import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bijbelquiz/services/connection_service.dart';
import 'package:bijbelquiz/providers/settings_provider.dart';
import 'package:bijbelquiz/providers/messages_provider.dart';
import 'package:bijbelquiz/providers/store_provider.dart';
import 'package:bijbelquiz/config/supabase_config.dart';

import '../screens/lesson_select_screen.dart';
import '../screens/store_screen.dart';
import '../screens/social_screen.dart';
import '../settings_screen.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  late ConnectionService _connectionService;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _connectionService = ConnectionService();
    _connectionService.initialize();
    _connectionService
        .setConnectionStatusCallback((isConnected, connectionType) {
      if (mounted) {
        setState(() {
          _isOnline = isConnected;
        });
      }
    });
    _checkConnectionOnScreenLoad();
  }

  Future<void> _checkConnectionOnScreenLoad() async {
    await _connectionService.checkConnection();
  }

  List<Widget> _getScreens() {
    if (_isOnline) {
      return [
        const LessonSelectScreen(),
        const StoreScreen(),
        const SocialScreen(),
        const SettingsScreen(),
      ];
    } else {
      return [
        const LessonSelectScreen(),
        const SettingsScreen(),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Builds the social destination with activity indicator for unread messages or login required
  NavigationDestination _buildSocialDestination() {
    final messagesProvider = Provider.of<MessagesProvider>(context);
    final hasUnreadMessages = messagesProvider.hasUnreadMessages;
    final isLoggedIn = SupabaseConfig.maybeClient?.auth.currentUser != null;
    final showAlertDot = !isLoggedIn || hasUnreadMessages;

    return NavigationDestination(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            label: AppLocalizations.of(context)!.social,
            button: true,
            child: const Icon(Icons.groups_outlined),
          ),
          if (showAlertDot)
            Positioned(
              right: -2,
              top: -2,
              child: Semantics(
                label: AppLocalizations.of(context)!.newMessagesOrLoginRequired,
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
            ),
        ],
      ),
      selectedIcon: Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            label: 'Selected - ${AppLocalizations.of(context)!.social}',
            button: true,
            child: const Icon(Icons.groups),
          ),
          if (showAlertDot)
            Positioned(
              right: -2,
              top: -2,
              child: Semantics(
                label: AppLocalizations.of(context)!.newMessagesOrLoginRequired,
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
            ),
        ],
      ),
      label: AppLocalizations.of(context)!.social,
    );
  }

  /// Builds the store destination with activity indicator for active discounts
  NavigationDestination _buildStoreDestination() {
    final storeProvider = Provider.of<StoreProvider>(context);
    final hasActiveDiscount = storeProvider.hasActiveDiscount;

    return NavigationDestination(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            label: AppLocalizations.of(context)!.store,
            button: true,
            child: const Icon(Icons.store_outlined),
          ),
          if (hasActiveDiscount)
            Positioned(
              right: -2,
              top: -2,
              child: Semantics(
                label: AppLocalizations.of(context)!.activeDiscountsAvailable,
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
            ),
        ],
      ),
      selectedIcon: Stack(
        clipBehavior: Clip.none,
        children: [
          Semantics(
            label: 'Selected - ${AppLocalizations.of(context)!.store}',
            button: true,
            child: const Icon(Icons.store),
          ),
          if (hasActiveDiscount)
            Positioned(
              right: -2,
              top: -2,
              child: Semantics(
                label: AppLocalizations.of(context)!.activeDiscountsAvailable,
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
            ),
        ],
      ),
      label: AppLocalizations.of(context)!.store,
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
        height: settings.showNavigationLabels ? 80 : 60,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.1),
        labelBehavior: settings.showNavigationLabels
            ? NavigationDestinationLabelBehavior.alwaysShow
            : NavigationDestinationLabelBehavior.alwaysHide,
        destinations: _buildDestinations(),
      ),
    );
  }

  List<NavigationDestination> _buildDestinations() {
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: Semantics(
          label: AppLocalizations.of(context)!.lessons,
          button: true,
          child: const Icon(Icons.menu_book_outlined),
        ),
        selectedIcon: Semantics(
          label:
              '${AppLocalizations.of(context)!.selected} - ${AppLocalizations.of(context)!.lessons}',
          button: true,
          child: const Icon(Icons.menu_book),
        ),
        label: AppLocalizations.of(context)!.lessons,
      ),
    ];

    if (_isOnline) {
      destinations.add(_buildStoreDestination());
      destinations.add(_buildSocialDestination());
    }

    destinations.add(
      NavigationDestination(
        icon: Semantics(
          label: AppLocalizations.of(context)!.settings,
          button: true,
          child: const Icon(Icons.settings_outlined),
        ),
        selectedIcon: Semantics(
          label: 'Selected - ${AppLocalizations.of(context)!.settings}',
          button: true,
          child: const Icon(Icons.settings),
        ),
        label: AppLocalizations.of(context)!.settings,
      ),
    );

    return destinations;
  }
}
