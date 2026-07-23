import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

import 'package:url_launcher/url_launcher.dart';
import '../services/logger.dart';
import '../config/supabase_config.dart';
import '../widgets/top_snackbar.dart';
import '../widgets/auth_view.dart';
import '../constants/urls.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';
import '../screens/main_navigation_screen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<GuidePage>? _pages;

  @override
  void initState() {
    super.initState();
    AppLogger.info('GuideScreen loaded');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_pages != null) return;

    final isLoggedIn = SupabaseConfig.maybeClient?.auth.currentUser != null;

    _pages = buildGuidePages(
      context: context,
      isLoggedIn: isLoggedIn,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // final textTheme = theme.textTheme; // Not used
    final pages = _pages!; // Get the current pages
    final isLastPage = _currentPage == pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: pages[_currentPage].isAuthPage
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return GuidePageView(
                    key: ValueKey(page),
                    page: page,
                    onConsentComplete: page.isAuthPage
                        ? () {
                            if (_currentPage < pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              _handleGuideCompletion(context);
                            }
                          }
                        : null,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    Semantics(
                      button: true,
                      label: AppLocalizations.of(context)!.previous,
                      child: TextButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.previous),
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                  Semantics(
                    label: AppLocalizations.of(context)!
                        .pageIndicator(_currentPage + 1, pages.length),
                    child: Row(
                      children: List.generate(
                        pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Semantics(
                    button: true,
                    label: isLastPage
                        ? AppLocalizations.of(context)!.getStarted
                        : AppLocalizations.of(context)!.next,
                    child: TextButton(
                      onPressed: () {
                          if (isLastPage) {
                            _handleGuideCompletion(context);
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      child: Text(
                        isLastPage
                            ? AppLocalizations.of(context)!.getStarted
                            : AppLocalizations.of(context)!.next,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGuideCompletion(BuildContext context) async {
    final localContext = context;
    final settings = Provider.of<SettingsProvider>(localContext, listen: false);
    try {
      // Mark guide as seen
      await settings.markGuideAsSeen();

      // Navigate to main app screen
      if (!mounted) return;
      if (localContext.mounted) {
        Navigator.of(localContext).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (!mounted) return;
      if (localContext.mounted) {
        final errorMessage = AppLocalizations.of(localContext)!.unknownError;
        showTopSnackBar(localContext, errorMessage,
            style: TopSnackBarStyle.error);
      }
    }
  }
}

class GuidePage {
  final String title;
  final String description;
  final IconData icon;
  final bool isDonationPage;
  final bool isAuthPage;
  final String? buttonText;
  final IconData? buttonIcon;

  GuidePage({
    required this.title,
    required this.description,
    required this.icon,
    this.isDonationPage = false,
    this.buttonText,
    this.buttonIcon,
    this.isAuthPage = false,
  });
}

List<GuidePage> buildGuidePages(
    {required BuildContext context, required bool isLoggedIn}) {
  final pages = <GuidePage>[];

  pages.addAll([
    GuidePage(
      title: AppLocalizations.of(context)!.welcomeTitle,
      description: AppLocalizations.of(context)!.welcomeDescription,
      icon: Icons.church,
    ),
    GuidePage(
      title: AppLocalizations.of(context)!.howToPlayTitle,
      description: AppLocalizations.of(context)!.howToPlayDescription,
      icon: Icons.quiz,
    ),
    GuidePage(
      title: AppLocalizations.of(context)!.trackProgressTitle,
      description: AppLocalizations.of(context)!.trackProgressDescription,
      icon: Icons.insights,
    ),
    GuidePage(
      title: AppLocalizations.of(context)!.customizeExperienceTitle,
      description: AppLocalizations.of(context)!.customizeExperienceDescription,
      icon: Icons.settings,
    ),
  ]);

  // Only add donation page if user hasn't donated yet
  final settings = Provider.of<SettingsProvider>(context, listen: false);
  if (!settings.hasDonated) {
    pages.add(
      GuidePage(
        title: AppLocalizations.of(context)!.supportUsTitle,
        description: AppLocalizations.of(context)!.supportUsDescription,
        icon: Icons.favorite,
        buttonText: AppLocalizations.of(context)!.donateNow,
        buttonIcon: Icons.volunteer_activism,
        isDonationPage: true,
      ),
    );
  }

  // Add account creation page last (if not logged in)
  if (!isLoggedIn) {
    pages.add(GuidePage(
      title: AppLocalizations.of(context)!.guideAccount,
      description: AppLocalizations.of(context)!.guideAccountDescription,
      icon: Icons.account_circle,
      isAuthPage: true,
    ));
  }

  return pages;
}

class GuidePageView extends StatefulWidget {
  final GuidePage page;
  final VoidCallback? onConsentComplete;

  const GuidePageView({
    super.key,
    required this.page,
    this.onConsentComplete,
  });

  @override
  State<GuidePageView> createState() => _GuidePageViewState();
}

class _GuidePageViewState extends State<GuidePageView> {
  bool _isLoading = false;

  Future<void> _handleDonation() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    BuildContext? safeContext;
    if (mounted) {
      safeContext = context;
    }

    try {
      final url = Uri.parse(AppUrls.donateUrl);
      if (await canLaunchUrl(url)) {
        // Mark as donated before launching the URL
        if (safeContext != null && safeContext.mounted) {
          final settings =
              Provider.of<SettingsProvider>(safeContext, listen: false);
          await settings.markAsDonated();
        }

        if (safeContext != null && safeContext.mounted) {
          await launchUrl(
            url,
            mode: LaunchMode.externalApplication,
          );
        }
      } else {
        if (safeContext != null && safeContext.mounted) {
          showTopSnackBar(
            safeContext,
            AppLocalizations.of(safeContext)!.couldNotOpenDonationPage,
            style: TopSnackBarStyle.error,
          );
        }
      }
    } catch (e) {
      if (safeContext != null && safeContext.mounted) {
        showTopSnackBar(
          safeContext,
          AppLocalizations.of(safeContext)!.donationError,
          style: TopSnackBarStyle.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildTermsAgreementText() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.4,
            ),
            children: [
              TextSpan(text: AppLocalizations.of(context)!.termsAgreementText),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: () async {
                    final url = AppUrls.termsUrl;
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(
                        Uri.parse(url),
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.termsOfService,
                    style: TextStyle(
                      color: colorScheme.primary,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (widget.page.isAuthPage) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  widget.page.icon,
                  size: 80,
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  widget.page.title,
                  style: textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.page.description,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                AuthView(
                  isEmbedded: true,
                  onLoginSuccess: widget.onConsentComplete,
                ),
                const SizedBox(height: 24),
                _buildTermsAgreementText(),
              ],
            ),
          ),
        ),
      );
    }

    // Check if this is the customization page
    final isCustomizationPage = widget.page.title ==
        AppLocalizations.of(context)!.customizeExperienceTitle;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.page.icon,
                      size: 100,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      widget.page.title,
                      style: textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.page.description,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isCustomizationPage) ...[
                      const SizedBox(height: 32),
                      Consumer<SettingsProvider>(
                          builder: (context, settings, child) {
                        return Column(
                          children: [
                            // Coupon Redeem (Text Only) - Now first option
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .couponTitle,
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .couponRedeemDescription,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.confirmation_number,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Language Selection
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
                                    AppLocalizations.of(context)!.language,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    initialValue: settings.language,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'nl',
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .languageNl),
                                      ),
                                      DropdownMenuItem(
                                        value: 'en',
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .languageEn),
                                      ),
                                    ],
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        settings.setLanguage(value);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: colorScheme.surface,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Game Speed Dropdown
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
                                    AppLocalizations.of(context)!.gameSpeed,
                                    style: textTheme.titleMedium?.copyWith(
                                      color: colorScheme.onSurface,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    initialValue: settings.gameSpeed,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'slow',
                                        child: Text(
                                            AppLocalizations.of(context)!.slow),
                                      ),
                                      DropdownMenuItem(
                                        value: 'medium',
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .medium),
                                      ),
                                      DropdownMenuItem(
                                        value: 'fast',
                                        child: Text(
                                            AppLocalizations.of(context)!.fast),
                                      ),
                                    ],
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        settings.setGameSpeed(value);
                                      }
                                    },
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: colorScheme.surface,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Sound Effects Toggle
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .muteSoundEffects,
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .soundEffectsDescription,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: settings.mute,
                                    onChanged: (bool value) {
                                      settings.setMute(value);
                                    },
                                    activeThumbColor: colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Analytics Toggle
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .analytics,
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .analyticsDescription,
                                          style: textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: settings.analyticsEnabled,
                                    onChanged: (bool value) {
                                      settings.setAnalyticsEnabled(value);
                                    },
                                    activeThumbColor: colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                    if (widget.page.buttonText != null) ...[
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        icon:
                            Icon(widget.page.buttonIcon ?? Icons.arrow_forward),
                        label: Text(widget.page.buttonText!),
                        onPressed:
                            widget.page.isDonationPage ? _handleDonation : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GuideScreenTestHarness extends StatefulWidget {
  final void Function(int page, int totalPages)? onPageShown;
  final VoidCallback? onComplete;

  const GuideScreenTestHarness({super.key, this.onPageShown, this.onComplete});

  @override
  State<GuideScreenTestHarness> createState() => _GuideScreenTestHarnessState();
}

class _GuideScreenTestHarnessState extends State<GuideScreenTestHarness> {
  late final PageController _pageController;
  int _currentPage = 0;
  late final List<GuidePage> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pages = buildGuidePages(
        context: context,
        isLoggedIn: false, // Default to false for test harness
      );
      setState(() {}); // Rebuild after initializing pages
      widget.onPageShown?.call(_currentPage, _pages.length);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // No longer initialize _pages here
  }

  void goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else {
      handleGuideCompletion();
    }
  }

  void goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    widget.onPageShown?.call(page, _pages.length);
  }

  Future<void> handleGuideCompletion() async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.markGuideAsSeen();

    widget.onComplete?.call();
    if (mounted) Navigator.of(context, rootNavigator: false).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isLastPage = _currentPage == _pages.length - 1;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => handleGuideCompletion(),
            child: Text(
              AppLocalizations.of(context)!.skip,
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return GuidePageView(
                    key: ValueKey(page),
                    page: page,
                    onConsentComplete: null,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: goToPreviousPage,
                      child: Text(AppLocalizations.of(context)!.previous),
                    )
                  else
                    const SizedBox(width: 80),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? colorScheme.primary
                              : colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: goToNextPage,
                    child: Text(isLastPage
                        ? AppLocalizations.of(context)!.getStarted
                        : AppLocalizations.of(context)!.next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
