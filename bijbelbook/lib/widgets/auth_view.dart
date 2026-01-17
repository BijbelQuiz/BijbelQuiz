import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/logger.dart';
import '../l10n/strings_nl.dart' as strings;

class AuthView extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const AuthView({
    super.key,
    this.onLoginSuccess,
  });

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _error;
  bool _isLoginMode = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _getUserFriendlyErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('invalid login credentials') ||
        errorString.contains('email not confirmed') ||
        errorString.contains('invalid email or password')) {
      return strings.AppStrings.invalidEmailOrPassword;
    }

    if (errorString.contains('user already registered')) {
      return strings.AppStrings.userAlreadyRegistered;
    }

    if (errorString.contains('password should be at least')) {
      return strings.AppStrings.passwordTooShort;
    }

    if (errorString.contains('weak password')) {
      return strings.AppStrings.weakPassword;
    }

    return strings.AppStrings.genericError;
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = strings.AppStrings.fillAllFields;
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

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _error = strings.AppStrings.fillAllFields;
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _error = strings.AppStrings.passwordsDoNotMatch;
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        _error = strings.AppStrings.passwordTooShort;
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
        AppLogger.info('Successfully signed up user: ${response.user!.email}');
        if (mounted) {
          setState(() {
            _isLoginMode = true;
            _confirmPasswordController.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(strings.AppStrings.accountCreatedMessage),
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
        mainAxisSize: MainAxisSize.min,
        children: [
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
                      strings.AppStrings.login,
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
                      strings.AppStrings.signup,
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
          const SizedBox(height: 16),

          TextField(
                      strings.AppStrings.signup,
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
            ],
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: strings.AppStrings.email,
              hintText: 'email@example.com',
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

          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: strings.AppStrings.password,
              hintText: '••••••••',
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
                borderSide: BorderSide(color: colorScheme.primary, width: 2),
              ),
            ),
            obscureText: true,
            textInputAction: _isLoginMode
                ? TextInputAction.done
                : TextInputAction.next,
            enabled: !_isLoading,
          ),
          const SizedBox(height: 16),

          if (!_isLoginMode) {
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: strings.AppStrings.confirmPassword,
                hintText: '••••••••',
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
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              enabled: !_isLoading,
            )
          },

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
                      _isLoginMode ? strings.AppStrings.login : strings.AppStrings.createAccount,
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
  }
}
