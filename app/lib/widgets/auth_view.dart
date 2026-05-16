import 'package:flutter/material.dart';
import 'dart:convert';
import '../config/supabase_config.dart';
import '../services/logger.dart';
import '../utils/automatic_error_reporter.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';

class AuthView extends StatefulWidget {
  final bool requiredForSocial;
  final VoidCallback? onLoginSuccess;
  final bool isEmbedded; // To adjust padding/styling if needed

  const AuthView({
    super.key,
    this.requiredForSocial = false,
    this.onLoginSuccess,
    this.isEmbedded = false,
  });

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  bool _isLoginMode = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  List<String>? _blacklistedUsernames;

  /// Converts technical error messages to user-friendly messages
  String _getUserFriendlyErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Network/connection errors
    if (errorString.contains('failed to fetch') ||
        errorString.contains('network error') ||
        errorString.contains('connection')) {
      return '${AppLocalizations.of(context)!.connectionError}. ${AppLocalizations.of(context)!.connectionErrorMsg}';
    }

    // Authentication errors
    if (errorString.contains('invalid login credentials') ||
        errorString.contains('email not confirmed') ||
        errorString.contains('invalid email or password')) {
      return AppLocalizations.of(context)!.invalidEmailOrPassword;
    }

    if (errorString.contains('email not confirmed')) {
      return AppLocalizations.of(context)!.emailNotConfirmed;
    }

    if (errorString.contains('too many requests')) {
      return AppLocalizations.of(context)!.tooManyRequests;
    }

    if (errorString.contains('password should be at least')) {
      return AppLocalizations.of(context)!.passwordTooShortGeneric;
    }

    if (errorString.contains('unable to validate email address')) {
      return AppLocalizations.of(context)!.invalidEmailAddress;
    }

    if (errorString.contains('user already registered')) {
      return AppLocalizations.of(context)!.userAlreadyRegistered;
    }

    if (errorString.contains('signup is disabled')) {
      return AppLocalizations.of(context)!.signupDisabled;
    }

    if (errorString.contains('weak password')) {
      return AppLocalizations.of(context)!.weakPassword;
    }

    // Generic error fallback
    return AppLocalizations.of(context)!.genericError;
  }

  @override
  void initState() {
    super.initState();
    _loadBlacklistedUsernames();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _loadBlacklistedUsernames() async {
    try {
      // Load blacklisted usernames from assets
      final String response = await DefaultAssetBundle.of(context)
          .loadString('assets/blacklisted_usernames.json');
      final List<dynamic> jsonData = json.decode(response);
      if (mounted) {
        setState(() {
          _blacklistedUsernames =
              jsonData.map((item) => item.toString().toLowerCase()).toList();
        });
      }
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
      if (mounted) {
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

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.fillEmailAndPassword;
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _error = AppLocalizations.of(context)!.enterValidEmail;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await SupabaseConfig.getClient().auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        AppLogger.info('Successfully signed in user: ${response.user!.email}');
        widget.onLoginSuccess?.call();
      }
    } catch (e) {
      setState(() {
        _error = _getUserFriendlyErrorMessage(e);
      });
      AppLogger.error('Sign in failed', e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final username = _usernameController.text.trim();

    // Enhanced field validation with specific messages
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        username.isEmpty) {
      setState(() {
        _error = AppLocalizations.of(context)!.fillAllFields;
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _error = AppLocalizations.of(context)!.enterValidEmail;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _error = AppLocalizations.of(context)!.passwordsDoNotMatch;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _error = AppLocalizations.of(context)!.passwordTooShort;
      });
      return;
    }

    if (username.length < 3) {
      setState(() {
        _error = AppLocalizations.of(context)!.usernameTooShort;
      });
      return;
    }

    if (username.length > 20) {
      setState(() {
        _error = AppLocalizations.of(context)!.usernameSignupTooLong;
      });
      return;
    }

    // Check for valid username characters
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      setState(() {
        _error = AppLocalizations.of(context)!.usernameInvalidChars;
      });
      return;
    }

    if (_isUsernameBlacklisted(username)) {
      setState(() {
        _error = AppLocalizations.of(context)!.usernameNotAllowed;
      });
      return;
    }

    // Check if username is already taken
    setState(() {
      _error = AppLocalizations.of(context)!.checkingUsername;
    });

    final usernameTaken = await _isUsernameTaken(username);
    if (usernameTaken) {
      setState(() {
        _error = AppLocalizations.of(context)!.thisUsernameAlreadyTaken;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final client = SupabaseConfig.getClient();
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        try {
          // Create user profile with username
          await client.from('user_profiles').insert({
            'user_id': response.user!.id,
            'username': username.toLowerCase().trim(),
            'display_name': username.trim(),
            'bio': null,
            'avatar_url': null,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          });

          AppLogger.info(
              'Successfully signed up user: ${response.user!.email} with username: $username');
        } catch (profileError) {
          // If profile creation fails, log it but don't fail the signup
          AppLogger.error(
              'Failed to create user profile during signup', profileError);
          // Try to create a basic profile as fallback
          try {
            await client.from('user_profiles').insert({
              'user_id': response.user!.id,
              'username': username.toLowerCase().trim(),
              'display_name': username.trim(),
            });
            AppLogger.info('Created basic user profile as fallback');
          } catch (fallbackError) {
            AppLogger.error(
                'Failed to create fallback user profile', fallbackError);
          }
        }

        if (mounted) {
          setState(() {
            _isLoginMode = true; // Switch to login mode after signup
            _usernameController.clear(); // Clear username field
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.accountCreatedMessage),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _error = _getUserFriendlyErrorMessage(e);
      });
      AppLogger.error('Sign up failed', e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(widget.isEmbedded ? 0 : 20),
      decoration: widget.isEmbedded
          ? null
          : BoxDecoration(
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
        mainAxisSize: MainAxisSize.min,
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

          // Social features requirement message
          if (widget.requiredForSocial) ...[
            // Large header
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                AppLocalizations.of(context)!.loginWithBqid,
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.group_rounded,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.socialFeaturesMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
                      AppLocalizations.of(context)!.login,
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
                      AppLocalizations.of(context)!.signup,
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
              labelText: AppLocalizations.of(context)!.email,
              hintText: AppLocalizations.of(context)!.emailHint,
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
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
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
                labelText: AppLocalizations.of(context)!.username,
                hintText: AppLocalizations.of(context)!.usernameSignupHint,
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
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
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
              labelText: AppLocalizations.of(context)!.password,
              hintText: AppLocalizations.of(context)!.passwordHint,
              prefixIcon: const Icon(Icons.lock_rounded),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
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
            obscureText: _obscurePassword,
            textInputAction:
                _isLoginMode ? TextInputAction.done : TextInputAction.next,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),

          // Confirm password field (only for signup)
          if (!_isLoginMode) ...[
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.confirmPassword,
                hintText: AppLocalizations.of(context)!.confirmPasswordHint,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
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
              obscureText: _obscureConfirmPassword,
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
              onPressed: _isLoading ? null : (_isLoginMode ? _signIn : _signUp),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _isLoginMode
                          ? AppLocalizations.of(context)!.login
                          : AppLocalizations.of(context)!.createAccount,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
