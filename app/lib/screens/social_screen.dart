import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/strings_nl.dart' as strings;
import 'sync_screen.dart';
import 'user_search_screen.dart';
import 'following_list_screen.dart';
import 'followers_list_screen.dart';
import '../providers/game_stats_provider.dart';
import '../services/logger.dart';

/// Screen displaying social features of the app.
class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

/// Device size breakpoints for responsive design.
class _ResponsiveBreakpoints {
  static const double desktop = 800.0;
  static const double tablet = 600.0;
}

/// Spacing constants for consistent design.
class _SpacingConstants {
  static const double desktopPadding = 32.0;
  static const double tabletPadding = 24.0;
  static const double mobilePadding = 16.0;
  
  static const double desktopCardPadding = 16.0;
  static const double mobileCardPadding = 12.0;
  
  static const double desktopSpacing = 32.0;
  static const double mobileSpacing = 24.0;
  
  static const double desktopSmallSpacing = 16.0;
  static const double mobileSmallSpacing = 12.0;
  
  static const double iconDesktopSize = 120.0;
  static const double iconTabletSize = 100.0;
  static const double iconMobileSize = 80.0;
}

/// Represents device type based on screen size.
class _DeviceType {
  final bool isDesktop;
  final bool isTablet;
  final bool isMobile;

  const _DeviceType({
    required this.isDesktop,
    required this.isTablet,
    required this.isMobile,
  });
}

class _SocialScreenState extends State<SocialScreen> {
  bool _socialFeaturesEnabled = false;
  late AnalyticsService _analyticsService;

  @override
  void initState() {
    super.initState();
    _analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    _trackScreenAccess();
    // Social features enabled since feature flags removed
    _socialFeaturesEnabled = true;
  }

  /// Track screen access and feature availability.
  void _trackScreenAccess() {
    _analyticsService.screen(context, 'SocialScreen');
    _analyticsService.trackFeatureUsage(context, 'social_features', 'screen_accessed');
  }

  /// Get device type based on screen width.
  _DeviceType _getDeviceType(Size size) {
    final width = size.width;
    return _DeviceType(
      isDesktop: width > _ResponsiveBreakpoints.desktop,
      isTablet: width > _ResponsiveBreakpoints.tablet && width <= _ResponsiveBreakpoints.desktop,
      isMobile: width <= _ResponsiveBreakpoints.tablet,
    );
  }

  /// Get responsive padding based on device type.
  EdgeInsets _getResponsivePadding(_DeviceType deviceType) {
    final horizontalPadding = deviceType.isDesktop 
        ? _SpacingConstants.desktopPadding 
        : (deviceType.isTablet ? _SpacingConstants.tabletPadding : _SpacingConstants.mobilePadding);
    return EdgeInsets.symmetric(horizontal: horizontalPadding);
  }

  /// Get responsive size based on device type.
  double _getResponsiveSize(double desktop, double tablet, double mobile, _DeviceType deviceType) {
    return deviceType.isDesktop ? desktop : (deviceType.isTablet ? tablet : mobile);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final deviceType = _getDeviceType(size);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: _getResponsivePadding(deviceType),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: _getResponsiveSize(
                    _ResponsiveBreakpoints.desktop, 
                    _ResponsiveBreakpoints.tablet, 
                    double.infinity, 
                    deviceType,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBqidManagementCard(colorScheme, deviceType),
                    const SizedBox(height: 24), // Add some spacing below the BQID card
                    _buildSocialFeaturesContent(
                      colorScheme, 
                      deviceType, 
                      _socialFeaturesEnabled, // Pass the flag to determine content
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the app bar with consistent styling.
  AppBar _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.group_rounded,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            strings.AppStrings.social,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
    );
  }

  /// Builds the BQID management card.
  Widget _buildBqidManagementCard(ColorScheme colorScheme, _DeviceType deviceType) {
    final cardPadding = _getResponsiveSize(
      _SpacingConstants.desktopCardPadding,
      _SpacingConstants.desktopCardPadding,
      _SpacingConstants.mobileCardPadding,
      deviceType,
    );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleBqidCardTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: _getResponsiveSize(12, 12, 8, deviceType)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.AppStrings.manageYourBqid,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.AppStrings.manageYourBqidSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles tap on the BQID management card.
  void _handleBqidCardTap() {
    _analyticsService.capture(context, 'open_sync_screen');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SyncScreen(),
      ),
    );
  }

  /// Builds the social features content section, which now includes active features.
  Widget _buildSocialFeaturesContent(
    ColorScheme colorScheme, 
    _DeviceType deviceType, 
    bool featuresEnabled,
  ) {
    final iconSize = _getResponsiveSize(
      _SpacingConstants.iconDesktopSize,
      _SpacingConstants.iconTabletSize,
      _SpacingConstants.iconMobileSize,
      deviceType,
    );
    
    final iconColor = featuresEnabled 
        ? colorScheme.primary 
        : colorScheme.primary.withValues(alpha: 0.5);
    
    final titleColor = featuresEnabled 
        ? colorScheme.onSurface 
        : colorScheme.onSurface.withValues(alpha: 0.7);
    
    final subtitleColor = featuresEnabled 
        ? colorScheme.onSurface.withValues(alpha: 0.7) 
        : colorScheme.onSurface.withValues(alpha: 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.groups_rounded,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(height: _getResponsiveSize(
          _SpacingConstants.desktopSpacing,
          _SpacingConstants.desktopSpacing,
          _SpacingConstants.mobileSpacing,
          deviceType,
        )),
        Text(
          strings.AppStrings.socialFeatures,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: _getResponsiveSize(
          _SpacingConstants.desktopSmallSpacing,
          _SpacingConstants.desktopSmallSpacing,
          _SpacingConstants.mobileSmallSpacing,
          deviceType,
        )),
        Text(
          strings.AppStrings.connectWithOtherUsers,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: subtitleColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        // Add social feature buttons
        SizedBox(height: _getResponsiveSize(
          _SpacingConstants.desktopSmallSpacing,
          _SpacingConstants.desktopSmallSpacing,
          _SpacingConstants.mobileSmallSpacing,
          deviceType,
        )),
        _buildSocialFeatureButtons(colorScheme, deviceType),
        // Add followed users scores section
        _buildFollowedUsersScores(colorScheme, deviceType),
      ],
    );
  }

  /// Builds buttons for social features
  Widget _buildSocialFeatureButtons(ColorScheme colorScheme, _DeviceType deviceType) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        _buildFeatureButton(
          colorScheme: colorScheme,
          icon: Icons.search,
          label: strings.AppStrings.search,
          onPressed: () => _navigateToUserSearchScreen(),
          deviceType: deviceType,
        ),
        _buildFeatureButton(
          colorScheme: colorScheme,
          icon: Icons.people_alt_rounded,
          label: strings.AppStrings.myFollowing,
          onPressed: () => _navigateToFollowingList(),
          deviceType: deviceType,
        ),
        _buildFeatureButton(
          colorScheme: colorScheme,
          icon: Icons.person_add_rounded,
          label: strings.AppStrings.myFollowers,
          onPressed: () => _navigateToFollowersList(),
          deviceType: deviceType,
        ),
      ],
    );
  }

  /// Builds the followed users scores section
  Widget _buildFollowedUsersScores(ColorScheme colorScheme, _DeviceType deviceType) {
    // This would typically fetch and display scores from followed users
    // For now, I'll implement a placeholder structure
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getFollowedUsersScores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(); // Hide section if no followed users or error
        }
        
        final followedUsers = snapshot.data!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Scores van Gevolgde Gebruikers',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            ...followedUsers.map((user) => 
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['username'] ?? 'Unknown User',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Laatste score: ${user['score'] ?? 'N/A'}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${user['streak'] ?? 0} reeks',
                        style: TextStyle(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ],
        );
      },
    );
  }

  /// Gets followed users and their scores
  Future<List<Map<String, dynamic>>> _getFollowedUsersScores() async {
    try {
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final syncService = gameStatsProvider.syncService;
      
      // Get list of followed users
      final followingList = await syncService.getFollowingList();
      if (followingList == null || followingList.isEmpty) {
        return []; // Return empty list if no one is followed
      }
      
      final usersWithScores = <Map<String, dynamic>>[];
      
      // For each followed user, get their username and scores
      for (final deviceId in followingList) {
        final username = await syncService.getUsernameByDeviceId(deviceId);
        if (username != null) {
          // For now, we'll add placeholder data as we don't have the full score structure
          // In a real implementation, you would fetch actual scores from the sync system
          usersWithScores.add({
            'username': username,
            'deviceId': deviceId,
            'score': 'N/A', // Placeholder - would fetch actual score
            'streak': 0,    // Placeholder - would fetch actual streak
          });
        }
      }
      
      return usersWithScores;
    } catch (e) {
      AppLogger.error('Error getting followed users scores', e);
      return [];
    }
  }

  /// Builds a single feature button
  Widget _buildFeatureButton({
    required ColorScheme colorScheme,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required _DeviceType deviceType,
  }) {
    final buttonSize = _getResponsiveSize(120.0, 110.0, 100.0, deviceType);
    
    return SizedBox(
      width: buttonSize,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Navigate to user search screen
  void _navigateToUserSearchScreen() {
    _analyticsService.capture(context, 'user_search_screen_opened');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UserSearchScreen(),
      ),
    );
  }

  /// Navigate to following list screen
  void _navigateToFollowingList() {
    _analyticsService.capture(context, 'following_list_opened');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FollowingListScreen(),
      ),
    );
  }

  /// Navigate to followers list screen
  void _navigateToFollowersList() {
    _analyticsService.capture(context, 'followers_list_opened');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FollowersListScreen(),
      ),
    );
  }
}