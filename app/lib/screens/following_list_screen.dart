import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/strings_nl.dart' as strings;
import '../providers/game_stats_provider.dart';
import '../services/analytics_service.dart';
import '../services/logger.dart';

/// Screen displaying users that the current user is following
class FollowingListScreen extends StatefulWidget {
  const FollowingListScreen({super.key});

  @override
  State<FollowingListScreen> createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen> {
  late AnalyticsService _analyticsService;

  List<String> _followingList = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    _trackScreenAccess();
    _loadFollowingList();
  }

  /// Track screen access for analytics
  void _trackScreenAccess() {
    _analyticsService.screen(context, 'FollowingListScreen');
    _analyticsService.trackFeatureUsage(
        context, 'following_list', 'screen_accessed');
  }

  /// Load the following list
  Future<void> _loadFollowingList() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gameStatsProvider =
          Provider.of<GameStatsProvider>(context, listen: false);
      final followingList =
          await gameStatsProvider.syncService.getFollowingList();

      if (mounted) {
        setState(() {
          _followingList = followingList ?? [];
          _isLoading = false;

          // Show warning if not in a room since followers/following requires being in a room
          if (!gameStatsProvider.syncService.isInRoom) {
            _error = strings.AppStrings.joinRoomToViewFollowing;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error loading following list: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  /// Get usernames for the followed devices
  Future<List<Map<String, String>>> _getUsernamesForDevices(
      List<String> deviceIds) async {
    final gameStatsProvider =
        Provider.of<GameStatsProvider>(context, listen: false);
    final usernames = <Map<String, String>>[];

    for (final deviceId in deviceIds) {
      try {
        final username =
            await gameStatsProvider.syncService.getUsernameByDeviceId(deviceId);
        if (username != null) {
          usernames.add({'deviceId': deviceId, 'username': username});
        } else {
          usernames.add({
            'deviceId': deviceId,
            'username': 'Unknown User ($deviceId.substring(0, 8))...'
          });
        }
      } catch (e) {
        AppLogger.error('Error getting username for device $deviceId', e);
        usernames.add({
          'deviceId': deviceId,
          'username': 'Unknown User ($deviceId.substring(0, 8))...'
        });
      }
    }

    return usernames;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.myFollowing),
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
              else if (_followingList.isEmpty)
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
                          strings.AppStrings.notFollowing,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          strings.AppStrings.searchUsersToFollow,
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
                // Following list
                Expanded(
                  child: FutureBuilder<List<Map<String, String>>>(
                    future: _getUsernamesForDevices(_followingList),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              'Error loading usernames: ${snapshot.error}'),
                        );
                      }

                      final users = snapshot.data ?? [];

                      return ListView.separated(
                        itemCount: users.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final user = users[index];
                          final deviceId = user['deviceId']!;
                          final username = user['username']!;

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
                              username,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              deviceId.substring(
                                  0,
                                  _min(
                                      8,
                                      deviceId
                                          .length)), // Show partial device ID
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

  /// Helper to limit string length
  int _min(int a, int b) => a < b ? a : b;
}
