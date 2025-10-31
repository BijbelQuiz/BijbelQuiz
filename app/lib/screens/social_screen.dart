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

  /// Track screen access and feature usage.
  void _trackScreenAccess() {
    _analyticsService.screen(context, 'SocialScreen');
    _analyticsService.trackFeatureUsage(context, 'social_features', 'screen_accessed');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate responsive values based on available width
            final isLargeScreen = constraints.maxWidth > 600;
            final horizontalPadding = isLargeScreen ? 24.0 : 16.0;
            final maxContainerWidth = isLargeScreen ? 600.0 : constraints.maxWidth;
            
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: maxContainerWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBqidManagementCard(colorScheme),
                      const SizedBox(height: 24),
                      _buildSocialFeaturesContent(
                        colorScheme, 
                        isLargeScreen, 
                        _socialFeaturesEnabled,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
  Widget _buildBqidManagementCard(ColorScheme colorScheme) {
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
            padding: const EdgeInsets.all(16.0),
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
                const SizedBox(width: 12),
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

  /// Builds the social features content section.
  Widget _buildSocialFeaturesContent(
    ColorScheme colorScheme, 
    bool isLargeScreen, 
    bool featuresEnabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSocialFeatureButtons(colorScheme, isLargeScreen),
        _buildFollowedUsersScores(colorScheme, isLargeScreen),
      ],
    );
  }

  /// Builds responsive buttons for social features
  Widget _buildSocialFeatureButtons(ColorScheme colorScheme, bool isLargeScreen) {
    // Use a responsive grid based on screen size
    if (isLargeScreen) {
      // For large screens, arrange buttons in a grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.0,
        ),
        itemCount: 3,
        itemBuilder: (context, index) {
          final features = [
            {'icon': Icons.search, 'label': strings.AppStrings.search, 'onPressed': _navigateToUserSearchScreen},
            {'icon': Icons.people_alt_rounded, 'label': strings.AppStrings.myFollowing, 'onPressed': _navigateToFollowingList},
            {'icon': Icons.person_add_rounded, 'label': strings.AppStrings.myFollowers, 'onPressed': _navigateToFollowersList},
          ];
          
          final feature = features[index];
          return _buildFeatureButton(
            colorScheme: colorScheme,
            icon: feature['icon'] as IconData,
            label: feature['label'] as String,
            onPressed: feature['onPressed'] as VoidCallback,
            isLargeScreen: isLargeScreen,
          );
        },
      );
    } else {
      // For smaller screens, arrange all buttons as smaller, full-width buttons
      return Column(
        children: [
          _buildSmallerFullWidthButton(
            colorScheme: colorScheme,
            icon: Icons.search,
            label: strings.AppStrings.search,
            onPressed: _navigateToUserSearchScreen,
          ),
          const SizedBox(height: 16),
          _buildSmallerFullWidthButton(
            colorScheme: colorScheme,
            icon: Icons.people_alt_rounded,
            label: strings.AppStrings.myFollowing,
            onPressed: _navigateToFollowingList,
          ),
          const SizedBox(height: 16),
          _buildSmallerFullWidthButton(
            colorScheme: colorScheme,
            icon: Icons.person_add_rounded,
            label: strings.AppStrings.myFollowers,
            onPressed: _navigateToFollowersList,
          ),
        ],
      );
    }
  }

  /// Builds the followed users scores section
  Widget _buildFollowedUsersScores(ColorScheme colorScheme, bool isLargeScreen) {
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
          return Container();
        }
        
        final followedUsers = snapshot.data!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                strings.AppStrings.followedUsersScores,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            ...followedUsers.map((user) => 
              Card(
                color: colorScheme.surface,
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['username'] ?? strings.AppStrings.unknownUser,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${strings.AppStrings.lastScore} ${user['score'] ?? strings.AppStrings.notAvailable}',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
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
                          '${user['streak'] ?? 0}${strings.AppStrings.streakLabel}',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
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
      
      final followingList = await syncService.getFollowingList();
      if (followingList == null || followingList.isEmpty) {
        return [];
      }
      
      final usersWithScores = <Map<String, dynamic>>[];
      
      for (final deviceId in followingList) {
        final username = await syncService.getUsernameByDeviceId(deviceId);
        if (username != null) {
          usersWithScores.add({
            'username': username,
            'deviceId': deviceId,
            'score': strings.AppStrings.notAvailable,
            'streak': 0,
          });
        }
      }
      
      return usersWithScores;
    } catch (e) {
      AppLogger.error('Error getting followed users scores', e);
      return [];
    }
  }

  /// Builds a single feature button with responsive sizing
  Widget _buildFeatureButton({
    required ColorScheme colorScheme,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isLargeScreen,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(isLargeScreen ? 16.0 : 12.0),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: colorScheme.surface,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isLargeScreen ? 28.0 : 24.0,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a smaller, full-width button for following/followers
  Widget _buildSmallerFullWidthButton({
    required ColorScheme colorScheme,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity, // Full width
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Increased padding
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: colorScheme.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.0, // Increased icon size
              color: colorScheme.primary,
            ),
            const SizedBox(width: 12), // Increased spacing
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
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