import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/strings_nl.dart' as strings;
import 'sync_screen.dart';
import 'user_search_screen.dart';
import 'following_list_screen.dart';
import 'followers_list_screen.dart';
import 'messages_screen.dart';
import '../providers/game_stats_provider.dart';
import '../providers/messages_provider.dart';
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
  Map<String, Map<String, dynamic>>? _cachedUserScores;

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
    _analyticsService.trackFeatureUsage(
        context, 'social_features', 'screen_accessed');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme, textTheme),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate responsive values based on available width
            final isLargeScreen = constraints.maxWidth > 600;
            final horizontalPadding = isLargeScreen ? 24.0 : 16.0;
            final maxContainerWidth =
                isLargeScreen ? 600.0 : constraints.maxWidth;

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
                      _buildBqidManagementCard(colorScheme, textTheme),
                      const SizedBox(height: 24),
                      _buildSocialFeaturesContent(
                        colorScheme,
                        textTheme,
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

  /// Clears the cached user scores - call this when stats are updated
  void _clearCachedUserScores() {
    _cachedUserScores = null;
  }

  /// Builds the app bar with consistent styling.
  AppBar _buildAppBar(ColorScheme colorScheme, TextTheme textTheme) {
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
            child: Icon(
              Icons.group_rounded,
              size: 20,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            strings.AppStrings.social,
            style: textTheme.titleLarge?.copyWith(
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
  Widget _buildBqidManagementCard(
      ColorScheme colorScheme, TextTheme textTheme) {
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
                  child: Icon(
                    Icons.person_add,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.AppStrings.manageYourBqid,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.AppStrings.manageYourBqidSubtitle,
                        style: textTheme.bodyMedium?.copyWith(
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
    TextTheme textTheme,
    bool isLargeScreen,
    bool featuresEnabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSocialFeatureButtons(colorScheme, textTheme, isLargeScreen),
        _buildFollowedUsersScores(colorScheme, textTheme, isLargeScreen),
      ],
    );
  }

  /// Builds responsive buttons for social features
  Widget _buildSocialFeatureButtons(
      ColorScheme colorScheme, TextTheme textTheme, bool isLargeScreen) {
    if (isLargeScreen) {
      // Arrange all buttons in a single row for large screens
      return Row(
        children: [
          Expanded(
            child: _buildFeatureButton(
              colorScheme: colorScheme,
              textTheme: textTheme,
              icon: Icons.search,
              label: strings.AppStrings.search,
              onPressed: _navigateToUserSearchScreen,
              isLargeScreen: isLargeScreen,
              isMessages: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFeatureButton(
              colorScheme: colorScheme,
              textTheme: textTheme,
              icon: Icons.people_alt_rounded,
              label: strings.AppStrings.myFollowing,
              onPressed: _navigateToFollowingList,
              isLargeScreen: isLargeScreen,
              isMessages: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFeatureButton(
              colorScheme: colorScheme,
              textTheme: textTheme,
              icon: Icons.person_add_rounded,
              label: strings.AppStrings.myFollowers,
              onPressed: _navigateToFollowersList,
              isLargeScreen: isLargeScreen,
              isMessages: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFeatureButton(
              colorScheme: colorScheme,
              textTheme: textTheme,
              icon: Icons.message_rounded,
              label: strings.AppStrings.messages,
              onPressed: _navigateToMessagesScreen,
              isLargeScreen: isLargeScreen,
              isMessages: true,
            ),
          ),
        ],
      );
    } else {
      // Stack buttons vertically for small screens, full width
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: _buildFeatureButton(
              colorScheme: colorScheme,
              textTheme: textTheme,
              icon: Icons.search,
              label: strings.AppStrings.search,
              onPressed: _navigateToUserSearchScreen,
              isLargeScreen: isLargeScreen,
              isMessages: false,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildFeatureButton(
              colorScheme: colorScheme,
              textTheme: textTheme,
              icon: Icons.people_alt_rounded,
              label: strings.AppStrings.myFollowing,
              onPressed: _navigateToFollowingList,
              isLargeScreen: isLargeScreen,
              isMessages: false,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildFeatureButton(
              colorScheme: colorScheme,
              textTheme: textTheme,
              icon: Icons.person_add_rounded,
              label: strings.AppStrings.myFollowers,
              onPressed: _navigateToFollowersList,
              isLargeScreen: isLargeScreen,
              isMessages: false,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: _buildFeatureButton(
              colorScheme: colorScheme,
              textTheme: textTheme,
              icon: Icons.message_rounded,
              label: strings.AppStrings.messages,
              onPressed: _navigateToMessagesScreen,
              isLargeScreen: isLargeScreen,
              isMessages: true,
            ),
          ),
        ],
      );
    }
  }

  /// Builds the followed users scores section
  Widget _buildFollowedUsersScores(
      ColorScheme colorScheme, TextTheme textTheme, bool isLargeScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Text(
                        strings.AppStrings.followedUsersScores,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        strings.AppStrings.beta,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Clear the cache to force a refresh
                  _clearCachedUserScores();
                  setState(() {}); // Trigger a rebuild
                },
              ),
            ],
          ),
        ),
        FutureBuilder<List<Map<String, dynamic>>>(
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

            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.data!.isEmpty) {
              return Container();
            }

            final followedUsers = snapshot.data!;

            return Column(
              children: [
                ...followedUsers.map(
                  (user) => Card(
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
                                  user['displayName'] ?? user['username'] ??
                                      strings.AppStrings.unknownUser,
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${strings.AppStrings.lastScore} ${user['score'] ?? strings.AppStrings.notAvailable}',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${user['stars'] ?? 0}',
                                  style: TextStyle(
                                    color: colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Gets followed users and their scores
  Future<List<Map<String, dynamic>>> _getFollowedUsersScores() async {
    try {
      final gameStatsProvider =
          Provider.of<GameStatsProvider>(context, listen: false);
      final syncService = gameStatsProvider.syncService;

      final followingList = await syncService.getFollowingList();
      if (followingList == null || followingList.isEmpty) {
        return [];
      }

      // Use cached scores if available, otherwise fetch fresh data
      Map<String, Map<String, dynamic>> userScores;
      if (_cachedUserScores != null) {
        userScores = _cachedUserScores!;
      } else {
        userScores = <String, Map<String, dynamic>>{};
      }

      final usersWithScores = <Map<String, dynamic>>[];

      for (final userId in followingList) {
        // Get user profile
        Map<String, dynamic>? userProfile;
        try {
          userProfile = await syncService.getUserProfile(userId);
        } catch (e) {
          AppLogger.error('Error getting user profile for $userId', e);
          userProfile = null;
        }

        if (userProfile == null) {
          continue; // Skip users without profiles
        }

        final username = userProfile['username'] as String?;
        final displayName = userProfile['display_name'] as String? ?? username;

        if (username == null) {
          continue; // Skip users without usernames
        }

        // Check if we have cached data for this user
        Map<String, dynamic>? stats;
        if (userScores.containsKey(userId)) {
          stats = userScores[userId];
        } else {
          // Fetch fresh stats from the database
          try {
            stats = await syncService.getGameStatsForUser(userId);
            // Cache the result
            userScores[userId] = stats ?? <String, dynamic>{};
          } catch (e) {
            AppLogger.error(
                'Error fetching game stats for user $userId', e);
            // Use empty stats on error
            stats = <String, dynamic>{};
          }
        }

        // Extract score and stars from fetched stats
        final score = stats?['score'] ?? 0;

        usersWithScores.add({
          'username': username,
          'displayName': displayName,
          'userId': userId,
          'score': score,
          'stars': score, // Stars are represented by the score field
        });
      }

      // Update cache with the latest fetched data
      _cachedUserScores = userScores;

      return usersWithScores;
    } catch (e) {
      AppLogger.error('Error getting followed users scores', e);
      return [];
    }
  }


  /// Builds a single feature button with responsive sizing
  Widget _buildFeatureButton({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isLargeScreen,
    bool isMessages = false,
  }) {
    final messagesProvider = Provider.of<MessagesProvider>(context);
    final unreadCount = messagesProvider.unreadCount;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.all(isLargeScreen ? 16.0 : 12.0),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: colorScheme.surface,
        fixedSize: Size.fromHeight(isLargeScreen ? 112.0 : 100.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: isLargeScreen ? 28.0 : 24.0,
                color: colorScheme.primary,
              ),
              if (isMessages && unreadCount > 0)
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                        style: TextStyle(
                          color: colorScheme.onError,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (!isMessages) // Don't show beta badge for messages
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                strings.AppStrings.beta,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
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

  /// Navigate to messages screen
  Future<void> _navigateToMessagesScreen() async {
    _analyticsService.capture(context, 'messages_screen_opened');

    // Mark messages as viewed when navigating to messages screen
    final messagesProvider =
        Provider.of<MessagesProvider>(context, listen: false);
    await messagesProvider.markAllMessagesAsViewed();

    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MessagesScreen(),
        ),
      );
    }
  }
}
