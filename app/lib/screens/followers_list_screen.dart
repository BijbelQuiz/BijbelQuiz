import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/strings_nl.dart' as strings;
import '../providers/game_stats_provider.dart';
import '../services/analytics_service.dart';
import '../services/logger.dart';

/// Screen displaying users that are following the current user
class FollowersListScreen extends StatefulWidget {
  const FollowersListScreen({super.key});

  @override
  State<FollowersListScreen> createState() => _FollowersListScreenState();
}

class _FollowersListScreenState extends State<FollowersListScreen> {
  late AnalyticsService _analyticsService;

  List<String> _followersList = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    _trackScreenAccess();
    _loadFollowersList();
  }

  /// Track screen access for analytics
  void _trackScreenAccess() {
    _analyticsService.screen(context, 'FollowersListScreen');
    _analyticsService.trackFeatureUsage(
        context, 'followers_list', 'screen_accessed');
  }

  /// Load the followers list
  Future<void> _loadFollowersList() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gameStatsProvider =
          Provider.of<GameStatsProvider>(context, listen: false);
      final followersList =
          await gameStatsProvider.syncService.getFollowersList();

      if (mounted) {
        setState(() {
          _followersList = followersList ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading followers list: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  /// Get user profiles for the follower users
  Future<List<Map<String, dynamic>>> _getUserProfilesForUsers(
      List<String> userIds) async {
    final gameStatsProvider =
        Provider.of<GameStatsProvider>(context, listen: false);
    final userProfiles = <Map<String, dynamic>>[];

    for (final userId in userIds) {
      try {
        final userProfile =
            await gameStatsProvider.syncService.getUserProfile(userId);
        if (userProfile != null) {
          userProfiles.add(userProfile);
        } else {
          userProfiles.add({
            'user_id': userId,
            'username': 'Unknown User',
            'display_name': 'Unknown User',
          });
        }
      } catch (e) {
        AppLogger.error('Error getting user profile for $userId', e);
        userProfiles.add({
          'user_id': userId,
          'username': 'Unknown User',
          'display_name': 'Unknown User',
        });
      }
    }

    return userProfiles;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.myFollowers),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Error message
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.error),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: colorScheme.onErrorContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Loading indicator
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_followersList.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          strings.AppStrings.noFollowers,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.AppStrings.shareBQIDFollowers,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                // Followers list
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _getUserProfilesForUsers(_followersList),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              'Error loading user profiles: ${snapshot.error}'),
                        );
                      }

                      final users = snapshot.data ?? [];

                      return ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final userId = user['user_id'] as String?;
                          final username = user['username'] as String?;
                          final displayName = user['display_name'] as String? ?? username;

                          if (userId == null || username == null) {
                            return const SizedBox.shrink();
                          }

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.person,
                                color: colorScheme.primary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              displayName ?? username,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              '@$username',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
