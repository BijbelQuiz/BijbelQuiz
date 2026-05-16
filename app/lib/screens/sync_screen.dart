import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:async';
import '../providers/game_stats_provider.dart';
import '../providers/lesson_progress_provider.dart';
import '../providers/settings_provider.dart';
import '../services/logger.dart';
import '../config/supabase_config.dart';
import '../utils/automatic_error_reporter.dart';
import '../screens/main_navigation_screen.dart';
import '../widgets/auth_view.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key, this.requiredForSocial = false});

  final bool requiredForSocial;

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Auth state management
  StreamSubscription<AuthState>? _authSubscription;
  bool _isLoadingProfile = false;

  String? _error;
  User? _currentUser;
  Map<String, dynamic>? _userProfile;
  List<String>? _blacklistedUsernames;

  // Account management states
  bool _isChangingPassword = false;
  bool _isChangingUsername = false;
  bool _isUpdatingProfile = false;

  // Sync status tracking
  final Map<String, DateTime> _lastSyncTimes = {};
  final List<String> _syncedDataTypes = [];
  bool _isManualSync = false;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    _setupAuthListener();
    _loadBlacklistedUsernames();
    _loadUserProfile();
  }

  void _checkAuthState() {
    final user = SupabaseConfig.maybeClient?.auth.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  void _setupAuthListener() {
    final client = SupabaseConfig.maybeClient;
    if (client == null) return;

    _authSubscription = client.auth.onAuthStateChange.listen((event) {
      AppLogger.debug(
          'Auth state changed: ${event.event} for user: ${event.session?.user.email ?? 'none'}');

      // Prevent race conditions by checking if we're already loading profile
      if (_isLoadingProfile) {
        AppLogger.debug('Skipping profile load - already in progress');
        return;
      }

      AppLogger.debug('Setting current user and calling _loadUserProfile');
      setState(() {
        _currentUser = event.session?.user;
      });
      AppLogger.debug('Calling _loadUserProfile after auth state change');
      _loadUserProfile();
    });
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser == null) {
      setState(() {
        _userProfile = null;
      });
      return;
    }

    // Prevent race conditions by tracking loading state
    if (_isLoadingProfile) {
      AppLogger.debug('Profile load already in progress, skipping');
      return;
    }

    _isLoadingProfile = true;

    try {
      final gameStatsProvider =
          Provider.of<GameStatsProvider>(context, listen: false);
      final profile =
          await gameStatsProvider.syncService.getCurrentUserProfile();

      if (mounted) {
        setState(() {
          _userProfile = profile;
          if (profile != null) {
            _displayNameController.text = profile['display_name'] ?? '';
            _bioController.text = profile['bio'] ?? '';
          }
        });
      }
      AppLogger.debug('User profile loaded successfully');
    } catch (e) {
      AppLogger.error('Failed to load user profile', e);
    } finally {
      _isLoadingProfile = false;
    }
  }

  /// Tracks sync status for different data types
  Future<void> _trackSyncStatus(String dataType) async {
    setState(() {
      _lastSyncTimes[dataType] = DateTime.now();
      if (!_syncedDataTypes.contains(dataType)) {
        _syncedDataTypes.add(dataType);
      }
    });
  }

  /// Triggers manual sync of all data
  Future<void> _manualSync() async {
    setState(() {
      _isManualSync = true;
    });

    try {
      final gameStatsProvider =
          Provider.of<GameStatsProvider>(context, listen: false);
      final lessonProgressProvider =
          Provider.of<LessonProgressProvider>(context, listen: false);
      final settingsProvider =
          Provider.of<SettingsProvider>(context, listen: false);

      // Force immediate sync bypassing debouncing
      await _trackSyncStatus('game_stats');
      await gameStatsProvider.syncService
          .syncDataImmediate('game_stats', gameStatsProvider.getExportData());

      await _trackSyncStatus('lesson_progress');
      await gameStatsProvider.syncService.syncDataImmediate(
          'lesson_progress', lessonProgressProvider.getExportData());

      await _trackSyncStatus('settings');
      await gameStatsProvider.syncService
          .syncDataImmediate('settings', settingsProvider.getExportData());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                AppLocalizations.of(context)!.dataSuccessfullySynchronized),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${AppLocalizations.of(context)!.synchronizationFailed}${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isManualSync = false;
      });
    }
  }

  /// Builds account menu items
  List<Widget> _buildAccountMenuItems() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return [
      _buildMenuItem(
        icon: Icons.person_rounded,
        title: AppLocalizations.of(context)!.editProfile,
        subtitle: AppLocalizations.of(context)!.adjustNameAndBio,
        onTap: () => _showProfileEditDialog(),
      ),
      const SizedBox(height: 16),
      _buildMenuItem(
        icon: Icons.alternate_email_rounded,
        title: AppLocalizations.of(context)!.changeUsername,
        subtitle: AppLocalizations.of(context)!.adjustYourUsername,
        onTap: () => _showUsernameChangeDialog(),
      ),
      const SizedBox(height: 16),
      _buildMenuItem(
        icon: Icons.lock_rounded,
        title: AppLocalizations.of(context)!.changePassword,
        subtitle: AppLocalizations.of(context)!.secureYourAccount,
        onTap: () => _showPasswordChangeDialog(),
      ),
      const SizedBox(height: 16),
      _buildDangerMenuItem(
        icon: Icons.logout_rounded,
        title: AppLocalizations.of(context)!.signOut,
        subtitle: AppLocalizations.of(context)!.signOutFromDevice,
        onTap: _signOut,
        color: colorScheme.error,
      ),
      const SizedBox(height: 16),
      _buildDangerMenuItem(
        icon: Icons.delete_rounded,
        title: AppLocalizations.of(context)!.deleteAccount,
        subtitle: AppLocalizations.of(context)!.permanentlyDeleteAccount,
        onTap: _deleteAccount,
        color: colorScheme.error,
      ),
    ];
  }

  /// Builds a menu item
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a danger menu item
  Widget _buildDangerMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows profile edit dialog
  void _showProfileEditDialog() {
    _displayNameController.text = _userProfile?['display_name'] ?? '';
    _bioController.text = _userProfile?['bio'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.editProfile),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.displayName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.bioOptional,
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: _isUpdatingProfile
                ? null
                : () async {
                    Navigator.of(context).pop();
                    await _updateProfile();
                  },
            child: _isUpdatingProfile
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(AppLocalizations.of(context)!.save),
          ),
        ],
      ),
    );
  }

  /// Shows username change dialog
  void _showUsernameChangeDialog() {
    _usernameController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.changeUsername),
        content: TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.newUsername,
            hintText: AppLocalizations.of(context)!.chooseUniqueName,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: _isChangingUsername
                ? null
                : () async {
                    Navigator.of(context).pop();
                    await _changeUsername();
                  },
            child: _isChangingUsername
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(AppLocalizations.of(context)!.change),
          ),
        ],
      ),
    );
  }

  /// Shows password change dialog
  void _showPasswordChangeDialog() {
    _passwordController.clear();
    _newPasswordController.clear();
    _confirmNewPasswordController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.changePassword),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.currentPassword,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.newPassword,
                hintText: AppLocalizations.of(context)!.atLeast6Characters,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmNewPasswordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.confirmNewPassword,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: _isChangingPassword
                ? null
                : () async {
                    Navigator.of(context).pop();
                    await _changePassword();
                  },
            child: _isChangingPassword
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Text(AppLocalizations.of(context)!.change),
          ),
        ],
      ),
    );
  }

  /// Checks if data is up to date (within last hour)
  bool _isDataUpToDate() {
    if (_lastSyncTimes.isEmpty) return false;

    final lastSync = _lastSyncTimes.values.isNotEmpty
        ? _lastSyncTimes.values.reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    if (lastSync == null) return false;

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    // Consider data up to date if synced within last hour
    return difference.inMinutes < 60;
  }

  /// Gets the last sync time as a formatted string
  String _getLastSyncTime() {
    if (_lastSyncTimes.isEmpty) {
      return AppLocalizations.of(context)!.never;
    }

    final lastSync = _lastSyncTimes.values.isNotEmpty
        ? _lastSyncTimes.values.reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    if (lastSync == null) {
      return AppLocalizations.of(context)!.never;
    }

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inMinutes < 1) {
      return AppLocalizations.of(context)!.justNow;
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}${AppLocalizations.of(context)!.minutesAgo}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}${AppLocalizations.of(context)!.hoursAgo}';
    } else {
      return '${difference.inDays}${AppLocalizations.of(context)!.daysAgo}';
    }
  }

  Future<void> _loadBlacklistedUsernames() async {
    try {
      // Load blacklisted usernames from assets
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/blacklisted_usernames.json');
      final List<dynamic> jsonData = json.decode(response);
      setState(() {
        _blacklistedUsernames =
            jsonData.map((item) => item.toString().toLowerCase()).toList();
      });
    } catch (e) {
      // Auto-report the error
      await AutomaticErrorReporter.reportStorageError(
        message: 'Error loading blacklisted usernames: ${e.toString()}',
        userMessage: 'Error loading blacklisted usernames',
        operation: 'load_asset',
        additionalInfo: {
          'file': 'assets/blacklisted_usernames.json',
          'error': e.toString(),
          'feature': 'auth',
        },
      );
      AppLogger.error('Error loading blacklisted usernames', e);
      // Set a default list if the file fails to load
      setState(() {
        _blacklistedUsernames = [
          'god',
          'jesus',
          'allah',
          'yahweh',
          'jehovah',
          'christ',
          'buddha',
          'muhammad',
          'holy',
          'sacred',
          'lord',
          'saint',
          'bible',
          'quran',
          'torah',
        ].map((item) => item.toLowerCase()).toList();
      });
    }
  }

  bool _isUsernameBlacklisted(String username) {
    if (_blacklistedUsernames == null || _blacklistedUsernames!.isEmpty) {
      return false;
    }
    final usernameLower = username.toLowerCase().trim();
    return _blacklistedUsernames!.contains(usernameLower);
  }

  Future<bool> _isUsernameTaken(String username) async {
    try {
      final client = SupabaseConfig.getClient();
      final response = await client
          .from('user_profiles')
          .select('username')
          .eq('username', username.toLowerCase().trim())
          .maybeSingle();

      return response != null;
    } catch (e) {
      AppLogger.error('Error checking if username is taken', e);
      return false; // Assume not taken on error
    }
  }

  Future<void> _signOut() async {
    setState(() {
      // _isLoading = true;
    });

    try {
      await SupabaseConfig.getClient().auth.signOut();
      AppLogger.info('Successfully signed out');

      // Navigate to main app screen after logout
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      AppLogger.error('Sign out failed', e);
      setState(() {
        _error =
            '${AppLocalizations.of(context)!.signOutFailed}${e.toString()}';
      });
    } finally {
      setState(() {
        // _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    final currentPassword = _passwordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmNewPassword = _confirmNewPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmNewPassword.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.fillAllPasswordFields;
      });
      return;
    }

    if (newPassword != confirmNewPassword) {
      setState(() {
        _error = AppLocalizations.of(context)!.newPasswordsDoNotMatch;
      });
      return;
    }

    if (newPassword.length < 6) {
      setState(() {
        _error = AppLocalizations.of(context)!.newPasswordMin6Chars;
      });
      return;
    }

    setState(() {
      _isChangingPassword = true;
      _error = null;
    });

    try {
      // Update password directly - Supabase handles current password verification internally
      final email = _currentUser!.email!;
      AppLogger.debug('Updating password for user: $email');

      await SupabaseConfig.getClient().auth.updateUser(
        UserAttributes(password: newPassword),
      );

      AppLogger.debug('Password update completed successfully');

      // Clear fields
      _passwordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.passwordSuccessfullyChanged),
            backgroundColor: Colors.green,
          ),
        );
      }
      AppLogger.info('Successfully changed password for user: $email');
    } catch (e) {
      setState(() {
        _error =
            '${AppLocalizations.of(context)!.failedToChangePassword}${e.toString()}';
      });
      AppLogger.error('Password change failed', e);
    } finally {
      setState(() {
        _isChangingPassword = false;
      });
    }
  }

  Future<void> _changeUsername() async {
    final newUsername = _usernameController.text.trim();

    if (newUsername.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.enterNewUsername;
      });
      return;
    }

    if (newUsername.length < 3) {
      setState(() {
        _error = AppLocalizations.of(context)!.usernameMin3Chars;
      });
      return;
    }

    if (newUsername.length > 20) {
      setState(() {
        _error = AppLocalizations.of(context)!.usernameMax20Chars;
      });
      return;
    }

    if (_isUsernameBlacklisted(newUsername)) {
      setState(() {
        _error = AppLocalizations.of(context)!.usernameNotAllowed;
      });
      return;
    }

    // Check if username is already taken by another user
    final usernameTaken = await _isUsernameTaken(newUsername);
    if (usernameTaken) {
      setState(() {
        _error = AppLocalizations.of(context)!.thisUsernameAlreadyTaken;
      });
      return;
    }

    setState(() {
      _isChangingUsername = true;
      _error = null;
    });

    try {
      await SupabaseConfig.getClient().from('user_profiles').update({
        'username': newUsername.toLowerCase().trim(),
        'display_name': newUsername.trim(),
      }).eq('user_id', _currentUser!.id);

      // Reload user profile
      await _loadUserProfile();

      // Clear field
      _usernameController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.usernameSuccessfullyChanged),
            backgroundColor: Colors.green,
          ),
        );
      }
      AppLogger.info(
          'Successfully changed username for user: ${_currentUser!.id} to: $newUsername');
    } catch (e) {
      setState(() {
        _error =
            '${AppLocalizations.of(context)!.failedToChangeUsername}${e.toString()}';
      });
      AppLogger.error('Username change failed', e);
    } finally {
      setState(() {
        _isChangingUsername = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    final displayName = _displayNameController.text.trim();
    final bio = _bioController.text.trim();

    if (displayName.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.displayNameRequired;
      });
      return;
    }

    setState(() {
      _isUpdatingProfile = true;
      _error = null;
    });

    try {
      await SupabaseConfig.getClient().from('user_profiles').update({
        'display_name': displayName,
        'bio': bio,
      }).eq('user_id', _currentUser!.id);

      // Reload user profile
      await _loadUserProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(context)!.profileSuccessfullyUpdated),
            backgroundColor: Colors.green,
          ),
        );
      }
      AppLogger.info(
          'Successfully updated profile for user: ${_currentUser!.id}');
    } catch (e) {
      setState(() {
        _error =
            '${AppLocalizations.of(context)!.failedToUpdateProfile}${e.toString()}';
      });
      AppLogger.error('Profile update failed', e);
    } finally {
      setState(() {
        _isUpdatingProfile = false;
      });
    }
  }

  Future<void> _deleteAccount() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteAccount),
        content: const Text(
            'Neem contact op met thomasnowprod@proton.me om je account te verwijderen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check auth state when dependencies change
    _checkAuthState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Error message
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.error),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: colorScheme.error,
                      ),
                      const SizedBox(width: 12),
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

              // Main content
              if (_currentUser == null)
                AuthView(
                  requiredForSocial: widget.requiredForSocial,
                  onLoginSuccess: () {
                    // Navigate to social screen after login if required
                    if (widget.requiredForSocial && mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) =>
                                const MainNavigationScreen(initialIndex: 2)),
                        (route) => false,
                      );
                    }
                  },
                )
              else
                // Account management view
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Unified Profile Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outline.withValues(alpha: 0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Picture
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: colorScheme.primary,
                              child: Text(
                                _userProfile?['display_name']
                                        ?.substring(0, 1)
                                        .toUpperCase() ??
                                    '?',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Profile Information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Display Name
                                  Text(
                                    _userProfile?['display_name'] ??
                                        AppLocalizations.of(context)!.user,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Username
                                  Text(
                                    '@${_userProfile?['username'] ?? 'username'}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),

                                  // Email
                                  Text(
                                    _currentUser!.email ??
                                        AppLocalizations.of(context)!.noEmail,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Simplified Sync Status
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _isDataUpToDate()
                                      ? Icons.cloud_done
                                      : Icons.cloud_sync,
                                  color: _isDataUpToDate()
                                      ? Colors.green
                                      : colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isDataUpToDate()
                                            ? AppLocalizations.of(context)!
                                                .updated
                                            : AppLocalizations.of(context)!
                                                .notUpdated,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: _isDataUpToDate()
                                              ? Colors.green
                                              : colorScheme.primary,
                                        ),
                                      ),
                                      Text(
                                        '${AppLocalizations.of(context)!.lastSync}: ${_getLastSyncTime()}',
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        _isManualSync ? null : _manualSync,
                                    icon: _isManualSync
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.sync_rounded,
                                            size: 16),
                                    label: Text(_isManualSync
                                        ? AppLocalizations.of(context)!.syncing
                                        : AppLocalizations.of(context)!.sync),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Account Management Menu - No header, just menu items
                      ..._buildAccountMenuItems(),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    _displayNameController.dispose();
    _bioController.dispose();

    // Cancel auth subscription to prevent memory leaks
    _authSubscription?.cancel();

    super.dispose();
  }
}
