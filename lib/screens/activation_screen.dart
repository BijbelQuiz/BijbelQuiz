import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/activation_service.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import './guide_screen.dart';
import '../l10n/strings_nl.dart' as strings;

/// Wrap your main screen with this gate to enforce activation before using the app.
/// Example:
/// home: ActivationGate(child: const LessonSelectScreen())
class ActivationGate extends StatefulWidget {
  final Widget child;
  const ActivationGate({super.key, required this.child});

  @override
  State<ActivationGate> createState() => _ActivationGateState();
}

class _ActivationGateState extends State<ActivationGate> {
  final ActivationService _service = ActivationService();
  bool _loading = true;
  bool _activated = false;

  @override
  void initState() {
    super.initState();
    _checkActivation();
  }

  Future<void> _checkActivation() async {
    setState(() {
      _loading = true;
    });
    final ok = await _service.isActivated();
    if (!mounted) return;
    setState(() {
      _activated = ok;
      _loading = false;
    });
  }

  void _onActivated() {
    setState(() {
      _activated = true;
    });
    // After activation, immediately show the guide on first run if not seen yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      if (!settings.hasSeenGuide) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const GuideScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      final cs = Theme.of(context).colorScheme;
      return Scaffold(
        backgroundColor: cs.surface,
        body: Center(
          child: SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
            ),
          ),
        ),
      );
    }
    if (_activated) return widget.child;
    return ActivationScreen(onActivated: _onActivated);
  }
}

/// A minimal activation UI that fits with current app styling.
class ActivationScreen extends StatefulWidget {
  final VoidCallback onActivated;
  const ActivationScreen({super.key, required this.onActivated});

  @override
  State<ActivationScreen> createState() => _ActivationScreenState();
}

class _ActivationScreenState extends State<ActivationScreen> {
  final TextEditingController _controller = TextEditingController();
  final ActivationService _service = ActivationService();
  bool _verifying = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final raw = _controller.text;
    final code = raw.trim().toUpperCase();
    if (code.isEmpty) {
      setState(() => _error = 'Voer een activatiecode in');
      return;
    }
    setState(() {
      _verifying = true;
      _error = null;
    });
    try {
      final ok = await _service.verifyCode(code);
      if (!mounted) return;
      if (ok) {
        widget.onActivated();
      } else {
        setState(() => _error = 'Ongeldige code. Probeer het opnieuw.');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Kan geen verbinding maken. Controleer je internetverbinding en probeer opnieuw.');
    } finally {
      if (mounted) {
        setState(() => _verifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outlineVariant),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.verified_user_rounded, color: cs.primary, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.AppStrings.activationTitle,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.AppStrings.activationSubtitle,
                      style: textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.8)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-]')),
                        UpperCaseTextFormatter(),
                      ],
                      onSubmitted: (_) => _verify(),
                      decoration: InputDecoration(
                        hintText: strings.AppStrings.activationCodeHint,
                        filled: true,
                        fillColor: cs.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: cs.outlineVariant),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: cs.outlineVariant),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: cs.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_error != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _error!,
                          style: textTheme.bodySmall?.copyWith(color: cs.error, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _verifying ? null : _verify,
                        style: FilledButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        icon: _verifying
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(cs.onPrimary),
                                ),
                              )
                            : const Icon(Icons.lock_open_rounded),
                        label: Text(_verifying ? strings.AppStrings.verifying : strings.AppStrings.verifyButton),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.AppStrings.activationTip,
                      style: textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Formatter to force uppercase input.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}