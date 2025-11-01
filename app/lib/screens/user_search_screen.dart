import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/strings_nl.dart' as strings;
import '../providers/game_stats_provider.dart';
import '../services/analytics_service.dart';

/// Screen for searching and following other users
class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnalyticsService _analyticsService;
  
  List<Map<String, dynamic>> _searchResults = [];
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
    _analyticsService.screen(context, 'UserSearchScreen');
    _analyticsService.trackFeatureUsage(context, 'user_search', 'screen_accessed');
  }

  /// Load the current following list
  Future<void> _loadFollowingList() async {
    final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
    final followingList = await gameStatsProvider.syncService.getFollowingList();
    
    if (mounted && followingList != null) {
      setState(() {
        _followingList = followingList;
      });
    }
  }

  /// Perform search for users
  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _error = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final results = await gameStatsProvider.syncService.searchUsers(query);
      
      if (mounted) {
        setState(() {
          _searchResults = results ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Error searching for users: ${e.toString()}';
          _isLoading = false;
          _searchResults = [];
        });
      }
    }
  }

  /// Handle follow/unfollow action
  Future<void> _toggleFollow(String targetDeviceId, String username) async {
    final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
    final isFollowing = _followingList.contains(targetDeviceId);
    
    _analyticsService.capture(
      context, 
      isFollowing ? 'unfollow_user' : 'follow_user',
      properties: {
        'target_device_id': targetDeviceId,
        'username': username,
      },
    );

    bool success;
    if (isFollowing) {
      success = await gameStatsProvider.syncService.unfollowUser(targetDeviceId);
      if (success) {
        setState(() {
          _followingList.remove(targetDeviceId);
        });
      }
    } else {
      success = await gameStatsProvider.syncService.followUser(targetDeviceId);
      if (success) {
        setState(() {
          _followingList.add(targetDeviceId);
        });
      }
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFollowing 
            ? 'Unfollowed $username' 
            : 'Started following $username'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFollowing 
            ? 'Failed to unfollow user' 
            : 'Failed to follow user'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.searchUsers),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search input
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: strings.AppStrings.searchByUsername,
                    hintText: strings.AppStrings.enterUsernameToSearch,
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                    ),
                  ),
                  onChanged: (value) {
                    // Add a small delay to avoid too many API calls
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (_searchController.text == value) {
                        _performSearch(value);
                      }
                    });
                  },
                  textInputAction: TextInputAction.search,
                ),
              ),
              
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
                ),
              
              // Results or empty state
              if (!_isLoading && _searchResults.isEmpty && _searchController.text.isNotEmpty)
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
                          strings.AppStrings.noUsersFound,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else if (!_isLoading)
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    itemCount: _searchResults.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      final username = user['username'] as String?;
                      final deviceId = user['device_id'] as String?;
                      
                      if (username == null || deviceId == null) {
                        return const SizedBox.shrink();
                      }
                      
                      final isFollowing = _followingList.contains(deviceId);
                      
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
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
                          deviceId.substring(0, _min(8, deviceId.length)), // Show partial device ID
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        trailing: deviceId != Provider.of<GameStatsProvider>(context, listen: false).syncService.getCurrentDeviceId() 
                          ? OutlinedButton(
                              onPressed: () => _toggleFollow(deviceId, username),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: isFollowing ? colorScheme.error : colorScheme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Text(
                                isFollowing ? strings.AppStrings.unfollow : strings.AppStrings.follow,
                                style: TextStyle(
                                  color: isFollowing ? colorScheme.error : colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : Text(
                              strings.AppStrings.yourself,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
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

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}