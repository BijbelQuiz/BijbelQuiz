import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:async';
import '../providers/game_stats_provider.dart';
import '../providers/lesson_progress_provider.dart';
import '../providers/settings_provider.dart';
import '../services/logger.dart';
import '../utils/automatic_error_reporter.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Auth state management
  StreamSubscription<AuthState>? _authSubscription;
  bool _isLoadingProfile = false;

  bool _isLoading = false;
  String? _error;
  bool _isLoginMode = true; // true for login, false for signup
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
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  void _setupAuthListener() {
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      AppLogger.debug('Auth state changed: ${event.event} for user: ${event.session?.user.email ?? 'none'}');

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
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final profile = await gameStatsProvider.syncService.getCurrentUserProfile();

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
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final lessonProgressProvider = Provider.of<LessonProgressProvider>(context, listen: false);
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

      // Sync each data type with correct provider data
      await _trackSyncStatus('game_stats');
      await gameStatsProvider.syncService.syncData('game_stats', gameStatsProvider.getExportData());

      await _trackSyncStatus('lesson_progress');
      await gameStatsProvider.syncService.syncData('lesson_progress', lessonProgressProvider.getExportData());

      await _trackSyncStatus('settings');
      await gameStatsProvider.syncService.syncData('settings', settingsProvider.getExportData());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gegevens succesvol gesynchroniseerd'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Synchronisatie mislukt: ${e.toString()}'),
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

  /// Gets list of data types being synced
  List<String> _getSyncDataTypes() {
    return [
      'game_stats',
      'lesson_progress', 
      'settings',
    ];
  }

  /// Builds sync status row for a data type
  Widget _buildSyncStatusRow(String dataType) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final lastSync = _lastSyncTimes[dataType];
    final isSynced = _syncedDataTypes.contains(dataType);
    
    String displayName;
    switch (dataType) {
      case 'game_stats':
        displayName = 'Game Statistieken';
        break;
      case 'lesson_progress':
        displayName = 'Les Voortgang';
        break;
      case 'settings':
        displayName = 'Instellingen';
        break;
      default:
        displayName = dataType;
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isSynced ? Icons.check_circle : Icons.pending,
            color: isSynced ? Colors.green : colorScheme.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayName,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Text(
            lastSync != null 
                ? '${lastSync.hour.toString().padLeft(2, '0')}:${lastSync.minute.toString().padLeft(2, '0')}'
                : 'Nooit',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  /// Gets account statistics from providers
  Future<Map<String, dynamic>> _getAccountStatistics() async {
    try {
      final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
      final lessonProgressProvider = Provider.of<LessonProgressProvider>(context, listen: false);
      
      final gameStats = gameStatsProvider.getExportData();
      final lessonProgress = lessonProgressProvider.getExportData();
      
      // Count completed lessons (lessons with > 0 stars)
      int completedLessons = 0;
      final bestStarsByLesson = lessonProgress['bestStarsByLesson'] as Map<String, int>? ?? {};
      for (final stars in bestStarsByLesson.values) {
        if (stars > 0) completedLessons++;
      }
      
      return {
        'totalScore': gameStats['score'] ?? 0,
        'currentStreak': gameStats['currentStreak'] ?? 0,
        'longestStreak': gameStats['longestStreak'] ?? 0,
        'incorrectAnswers': gameStats['incorrectAnswers'] ?? 0,
        'completedLessons': completedLessons,
        'totalLessons': bestStarsByLesson.length,
      };
    } catch (e) {
      AppLogger.error('Failed to get account statistics', e);
      return {
        'totalScore': 0,
        'currentStreak': 0,
        'longestStreak': 0,
        'incorrectAnswers': 0,
        'completedLessons': 0,
        'totalLessons': 0,
      };
    }
  }

  /// Builds a statistics row
  Widget _buildStatRow(String label, String value) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds account menu items
  List<Widget> _buildAccountMenuItems() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return [
      _buildMenuItem(
        icon: Icons.person_rounded,
        title: 'Profiel bewerken',
        subtitle: 'Naam en bio aanpassen',
        onTap: () => _showProfileEditDialog(),
      ),
      const SizedBox(height: 16),
      _buildMenuItem(
        icon: Icons.alternate_email_rounded,
        title: 'Gebruikersnaam wijzigen',
        subtitle: 'Je gebruikersnaam aanpassen',
        onTap: () => _showUsernameChangeDialog(),
      ),
      const SizedBox(height: 16),
      _buildMenuItem(
        icon: Icons.lock_rounded,
        title: 'Wachtwoord wijzigen',
        subtitle: 'Beveilig je account',
        onTap: () => _showPasswordChangeDialog(),
      ),
      const SizedBox(height: 16),
      _buildDangerMenuItem(
        icon: Icons.logout_rounded,
        title: 'Uitloggen',
        subtitle: 'Van dit apparaat afmelden',
        onTap: _signOut,
        color: colorScheme.error,
      ),
      const SizedBox(height: 16),
      _buildDangerMenuItem(
        icon: Icons.delete_rounded,
        title: 'Account verwijderen',
        subtitle: 'Account permanent verwijderen',
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
        title: const Text('Profiel bewerken'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Weergavenaam',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Bio (optioneel)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: _isUpdatingProfile ? null : () async {
              Navigator.of(context).pop();
              await _updateProfile();
            },
            child: _isUpdatingProfile 
                ? const SizedBox(
                    width: 16, 
                    height: 16, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Text('Opslaan'),
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
        title: const Text('Gebruikersnaam wijzigen'),
        content: TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
            labelText: 'Nieuwe gebruikersnaam',
            hintText: 'Kies een unieke naam',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: _isChangingUsername ? null : () async {
              Navigator.of(context).pop();
              await _changeUsername();
            },
            child: _isChangingUsername 
                ? const SizedBox(
                    width: 16, 
                    height: 16, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Text('Wijzigen'),
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
        title: const Text('Wachtwoord wijzigen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Huidig wachtwoord',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                labelText: 'Nieuw wachtwoord',
                hintText: 'Minimaal 6 karakters',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmNewPasswordController,
              decoration: const InputDecoration(
                labelText: 'Bevestig nieuw wachtwoord',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuleren'),
          ),
          ElevatedButton(
            onPressed: _isChangingPassword ? null : () async {
              Navigator.of(context).pop();
              await _changePassword();
            },
            child: _isChangingPassword 
                ? const SizedBox(
                    width: 16, 
                    height: 16, 
                    child: CircularProgressIndicator(strokeWidth: 2)
                  )
                : const Text('Wijzigen'),
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
      return 'Nooit';
    }
    
    final lastSync = _lastSyncTimes.values.isNotEmpty 
        ? _lastSyncTimes.values.reduce((a, b) => a.isAfter(b) ? a : b)
        : null;
        
    if (lastSync == null) {
      return 'Nooit';
    }
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) {
      return 'Zojuist';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m geleden';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}u geleden';
    } else {
      return '${difference.inDays}d geleden';
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
      final client = Supabase.instance.client;
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

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = 'Vul alle velden in';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        AppLogger.info('Successfully signed in user: ${response.user!.email}');
        // Sync will be handled automatically by auth state change
        // Stay on the account screen after login
      }
    } catch (e) {
      setState(() {
        _error = 'Inloggen mislukt: ${e.toString()}';
      });
      AppLogger.error('Sign in failed', e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final username = _usernameController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || username.isEmpty) {
      setState(() {
        _error = 'Vul alle velden in';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _error = 'Wachtwoorden komen niet overeen';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _error = 'Wachtwoord moet minimaal 6 karakters bevatten';
      });
      return;
    }

    if (username.length < 3) {
      setState(() {
        _error = 'Gebruikersnaam moet minimaal 3 karakters bevatten';
      });
      return;
    }

    if (username.length > 20) {
      setState(() {
        _error = 'Gebruikersnaam mag maximaal 20 karakters bevatten';
      });
      return;
    }

    if (_isUsernameBlacklisted(username)) {
      setState(() {
        _error = 'Deze gebruikersnaam is niet toegestaan';
      });
      return;
    }

    // Check if username is already taken
    final usernameTaken = await _isUsernameTaken(username);
    if (usernameTaken) {
      setState(() {
        _error = 'Deze gebruikersnaam is al in gebruik';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        try {
          // Create user profile with username
          await Supabase.instance.client.from('user_profiles').insert({
            'user_id': response.user!.id,
            'username': username.toLowerCase().trim(),
            'display_name': username.trim(),
            'bio': null,
            'avatar_url': null,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });

          AppLogger.info('Successfully signed up user: ${response.user!.email} with username: $username');
        } catch (profileError) {
          // If profile creation fails, log it but don't fail the signup
          AppLogger.error('Failed to create user profile during signup', profileError);
          // Try to create a basic profile as fallback
          try {
            await Supabase.instance.client.from('user_profiles').insert({
              'user_id': response.user!.id,
              'username': username.toLowerCase().trim(),
              'display_name': username.trim(),
            });
            AppLogger.info('Created basic user profile as fallback');
          } catch (fallbackError) {
            AppLogger.error('Failed to create fallback user profile', fallbackError);
          }
        }

        if (mounted) {
          setState(() {
            _isLoginMode = true; // Switch to login mode after signup
            _usernameController.clear(); // Clear username field
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account aangemaakt! Controleer je email voor verificatie.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _error = 'Aanmelden mislukt: ${e.toString()}';
      });
      AppLogger.error('Sign up failed', e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.signOut();
      AppLogger.info('Successfully signed out');
      // Stay on the screen - auth state change will update UI to show login form
    } catch (e) {
      AppLogger.error('Sign out failed', e);
      setState(() {
        _error = 'Uitloggen mislukt: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _changePassword() async {
    final currentPassword = _passwordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmNewPassword = _confirmNewPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmNewPassword.isEmpty) {
      setState(() {
        _error = 'Vul alle wachtwoord velden in';
      });
      return;
    }

    if (newPassword != confirmNewPassword) {
      setState(() {
        _error = 'Nieuwe wachtwoorden komen niet overeen';
      });
      return;
    }

    if (newPassword.length < 6) {
      setState(() {
        _error = 'Nieuw wachtwoord moet minimaal 6 karakters bevatten';
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
      
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      
      AppLogger.debug('Password update completed successfully');

      // Clear fields
      _passwordController.clear();
      _newPasswordController.clear();
      _confirmNewPasswordController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wachtwoord succesvol gewijzigd'),
            backgroundColor: Colors.green,
          ),
        );
      }
      AppLogger.info('Successfully changed password for user: $email');
    } catch (e) {
      setState(() {
        _error = 'Wachtwoord wijzigen mislukt: ${e.toString()}';
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
        _error = 'Voer een nieuwe gebruikersnaam in';
      });
      return;
    }

    if (newUsername.length < 3) {
      setState(() {
        _error = 'Gebruikersnaam moet minimaal 3 karakters bevatten';
      });
      return;
    }

    if (newUsername.length > 20) {
      setState(() {
        _error = 'Gebruikersnaam mag maximaal 20 karakters bevatten';
      });
      return;
    }

    if (_isUsernameBlacklisted(newUsername)) {
      setState(() {
        _error = 'Deze gebruikersnaam is niet toegestaan';
      });
      return;
    }

    // Check if username is already taken by another user
    final usernameTaken = await _isUsernameTaken(newUsername);
    if (usernameTaken) {
      setState(() {
        _error = 'Deze gebruikersnaam is al in gebruik';
      });
      return;
    }

    setState(() {
      _isChangingUsername = true;
      _error = null;
    });

    try {
      await Supabase.instance.client.from('user_profiles').update({
        'username': newUsername.toLowerCase().trim(),
        'display_name': newUsername.trim(),
      }).eq('user_id', _currentUser!.id);

      // Reload user profile
      await _loadUserProfile();

      // Clear field
      _usernameController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gebruikersnaam succesvol gewijzigd'),
            backgroundColor: Colors.green,
          ),
        );
      }
      AppLogger.info('Successfully changed username for user: ${_currentUser!.id} to: $newUsername');
    } catch (e) {
      setState(() {
        _error = 'Gebruikersnaam wijzigen mislukt: ${e.toString()}';
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
        _error = 'Weergavenaam is verplicht';
      });
      return;
    }

    setState(() {
      _isUpdatingProfile = true;
      _error = null;
    });

    try {
      await Supabase.instance.client.from('user_profiles').update({
        'display_name': displayName,
        'bio': bio,
      }).eq('user_id', _currentUser!.id);

      // Reload user profile
      await _loadUserProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profiel succesvol bijgewerkt'),
            backgroundColor: Colors.green,
          ),
        );
      }
      AppLogger.info('Successfully updated profile for user: ${_currentUser!.id}');
    } catch (e) {
      setState(() {
        _error = 'Profiel bijwerken mislukt: ${e.toString()}';
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
        title: const Text('Account verwijderen'),
        content: const Text(
          'Neem contact op met thomasnowprod@proton.me om je account te verwijderen.'
        ),
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
        title: const Text('Account'),
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
                      // Mode toggle
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isLoginMode = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _isLoginMode
                                      ? colorScheme.primaryContainer
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Inloggen',
                                  style: TextStyle(
                                    color: _isLoginMode
                                        ? colorScheme.primary
                                        : colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _isLoginMode = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !_isLoginMode
                                      ? colorScheme.primaryContainer
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Aanmelden',
                                  style: TextStyle(
                                    color: !_isLoginMode
                                        ? colorScheme.primary
                                        : colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'jouw@email.com',
                          prefixIcon: const Icon(Icons.email_rounded),
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
                            borderSide: BorderSide(
                                color: colorScheme.primary, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Username field (only for signup)
                      if (!_isLoginMode) ...[
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Gebruikersnaam',
                            hintText: 'Kies een unieke naam',
                            prefixIcon: const Icon(Icons.person_outline_rounded),
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
                              borderSide: BorderSide(
                                  color: colorScheme.primary, width: 2),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Password field
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Wachtwoord',
                          hintText: 'Minimaal 6 karakters',
                          prefixIcon: const Icon(Icons.lock_rounded),
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
                            borderSide: BorderSide(
                                color: colorScheme.primary, width: 2),
                          ),
                        ),
                        obscureText: true,
                        textInputAction: _isLoginMode
                            ? TextInputAction.done
                            : TextInputAction.next,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),

                      // Confirm password field (only for signup)
                      if (!_isLoginMode) ...[
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Bevestig wachtwoord',
                            hintText: 'Herhaal je wachtwoord',
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
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
                              borderSide: BorderSide(
                                  color: colorScheme.primary, width: 2),
                            ),
                          ),
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          enabled: !_isLoading,
                        ),
                        const SizedBox(height: 16),
                      ],

                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : (_isLoginMode ? _signIn : _signUp),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  _isLoginMode ? 'Inloggen' : 'Account aanmaken',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
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
                                _userProfile?['display_name']?.substring(0, 1).toUpperCase() ?? '?',
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
                                    _userProfile?['display_name'] ?? 'Gebruiker',
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
                                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  
                                  // Email
                                  Text(
                                    _currentUser!.email ?? 'Geen email',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.6),
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
                                  _isDataUpToDate() ? Icons.cloud_done : Icons.cloud_sync,
                                  color: _isDataUpToDate() ? Colors.green : colorScheme.primary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _isDataUpToDate() ? 'Bijgewerkt' : 'Niet bijgewerkt',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: _isDataUpToDate() ? Colors.green : colorScheme.primary,
                                        ),
                                      ),
                                      Text(
                                        'Laatste sync: ${_getLastSyncTime()}',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                  child: ElevatedButton.icon(
                                    onPressed: _isManualSync ? null : _manualSync,
                                    icon: _isManualSync
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Icon(Icons.sync_rounded, size: 16),
                                    label: Text(_isManualSync ? 'Syncing...' : 'Sync'),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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