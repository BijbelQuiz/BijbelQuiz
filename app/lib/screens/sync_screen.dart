import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import '../providers/game_stats_provider.dart';
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

  bool _isLoading = false;
  String? _error;
  bool _isLoginMode = true; // true for login, false for signup
  User? _currentUser;
  Map<String, dynamic>? _userProfile;
  List<String>? _blacklistedUsernames;

  // Account management states
  bool _showAccountSettings = false;
  bool _isChangingPassword = false;
  bool _isChangingUsername = false;
  bool _isUpdatingProfile = false;

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
    Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      setState(() {
        _currentUser = event.session?.user;
      });
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
    } catch (e) {
      AppLogger.error('Failed to load user profile', e);
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
        if (mounted) {
          Navigator.of(context).pop(true); // Return success
        }
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
      if (mounted) {
        Navigator.of(context).pop(false); // Return signed out
      }
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
      // First verify current password by attempting to sign in
      final email = _currentUser!.email!;
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: currentPassword,
      );

      // If successful, update password
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );

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
              // Header section
              Container(
                margin: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_circle_rounded,
                      size: 64,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Account',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentUser != null
                          ? 'Je bent ingelogd met ${_currentUser!.email}'
                          : 'Log in of maak een account aan om je gegevens te synchroniseren',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

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
                      const SizedBox(height: 24),

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

                      const SizedBox(height: 24),
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
                      // Account info header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                            const SizedBox(height: 16),
                            Text(
                              _userProfile?['display_name'] ?? 'Gebruiker',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '@${_userProfile?['username'] ?? 'username'}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _currentUser!.email ?? 'Geen email',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Account management options
                      if (!_showAccountSettings) ...[
                        // Profile info
                        if (_userProfile?['bio']?.isNotEmpty == true) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bio',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _userProfile!['bio'],
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Sync status
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.sync_rounded,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Je gegevens worden automatisch gesynchroniseerd tussen al je apparaten.',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Account management buttons
                        Text(
                          'Account beheren',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Settings button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() => _showAccountSettings = true),
                            icon: const Icon(Icons.settings_rounded),
                            label: const Text('Account instellingen'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Sign out button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _signOut,
                            icon: const Icon(Icons.logout_rounded),
                            label: const Text('Uitloggen'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(color: colorScheme.error),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // Account settings view
                        Text(
                          'Account instellingen',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Profile settings
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Profiel bewerken',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: _displayNameController,
                                decoration: InputDecoration(
                                  labelText: 'Weergavenaam',
                                  hintText: 'Hoe anderen je zien',
                                  prefixIcon: const Icon(Icons.person_rounded),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                enabled: !_isUpdatingProfile,
                              ),
                              const SizedBox(height: 12),

                              TextField(
                                controller: _bioController,
                                decoration: InputDecoration(
                                  labelText: 'Bio (optioneel)',
                                  hintText: 'Vertel iets over jezelf',
                                  prefixIcon: const Icon(Icons.description_rounded),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                maxLines: 3,
                                enabled: !_isUpdatingProfile,
                              ),
                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _isUpdatingProfile ? null : _updateProfile,
                                  child: _isUpdatingProfile
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('Profiel bijwerken'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Username change
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gebruikersnaam wijzigen',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  labelText: 'Nieuwe gebruikersnaam',
                                  hintText: 'Kies een unieke naam',
                                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                enabled: !_isChangingUsername,
                              ),
                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _isChangingUsername ? null : _changeUsername,
                                  child: _isChangingUsername
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('Gebruikersnaam wijzigen'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Password change
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Wachtwoord wijzigen',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 16),

                              TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Huidig wachtwoord',
                                  prefixIcon: const Icon(Icons.lock_rounded),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                enabled: !_isChangingPassword,
                              ),
                              const SizedBox(height: 12),

                              TextField(
                                controller: _newPasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Nieuw wachtwoord',
                                  hintText: 'Minimaal 6 karakters',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                enabled: !_isChangingPassword,
                              ),
                              const SizedBox(height: 12),

                              TextField(
                                controller: _confirmNewPasswordController,
                                decoration: InputDecoration(
                                  labelText: 'Bevestig nieuw wachtwoord',
                                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                enabled: !_isChangingPassword,
                              ),
                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _isChangingPassword ? null : _changePassword,
                                  child: _isChangingPassword
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('Wachtwoord wijzigen'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Danger zone
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.error),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Gevaarlijke zone',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Deze acties kunnen niet ongedaan worden gemaakt.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onErrorContainer.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _deleteAccount,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorScheme.error,
                                    foregroundColor: colorScheme.onError,
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text('Account verwijderen'),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Back button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() => _showAccountSettings = false),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Terug'),
                          ),
                        ),
                      ],
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
    super.dispose();
  }
}