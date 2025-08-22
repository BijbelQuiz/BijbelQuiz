import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

import '../services/notification_service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import '../services/logger.dart';
import '../widgets/quiz_skeleton.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<GuidePage> get _pages {
    final showNotificationPage = !kIsWeb && !Platform.isLinux;
    return buildGuidePages(
      showNotificationPage: showNotificationPage,
      context: context,
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
  void initState() {
    super.initState();
    AppLogger.info('GuideScreen loaded');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pages = _pages; // Get the current pages
    final isLastPage = _currentPage == pages.length - 1;
    // Log screen view for analytics


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return GuidePageView(
                    key: ValueKey(page),
                    page: page,
                    colorScheme: colorScheme,
                    onConsentComplete: page.isNotificationPage
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
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(strings.AppStrings.previous),
                    )
                  else
                    const SizedBox(width: 80),
                  Row(
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
                  TextButton(
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
                      isLastPage ? strings.AppStrings.getStarted : strings.AppStrings.next,
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
      // Initialize telemetry service with default setting (disabled)

      // Request notification permission if enabled and on supported platform
      // if (settings.notificationEnabled && !kIsWeb && !Platform.isLinux) {
      //   await NotificationService.requestNotificationPermission();
      // }
      // Navigate back
      if (!mounted) return;
      if (localContext.mounted) {
        Navigator.of(localContext).pop();
      }
    } catch (e) {
      if (!mounted) return;
      final errorMessage = strings.AppStrings.unknownError;
      if (localContext.mounted) {
        showTopSnackBar(localContext, errorMessage, style: TopSnackBarStyle.error);
      }
    }
  }
}

class GuidePage {
  final String title;
  final String description;
  final IconData icon;
  final bool isNotificationPage;
  final bool isDonationPage;
  final String? buttonText;
  final IconData? buttonIcon;

  GuidePage({
    required this.title,
    required this.description,
    required this.icon,
    this.isNotificationPage = false,
    this.isDonationPage = false,
    this.buttonText,
    this.buttonIcon,
  });
}

List<GuidePage> buildGuidePages({required bool showNotificationPage, required BuildContext context}) {
  final pages = <GuidePage>[
    GuidePage(
      title: strings.AppStrings.welcomeTitle,
      description: strings.AppStrings.welcomeDescription,
      icon: Icons.church,
    ),
    GuidePage(
      title: strings.AppStrings.howToPlayTitle,
      description: strings.AppStrings.howToPlayDescription,
      icon: Icons.quiz,
    ),
    GuidePage(
      title: strings.AppStrings.trackProgressTitle,
      description: strings.AppStrings.trackProgressDescription,
      icon: Icons.insights,
    ),
    GuidePage(
      title: strings.AppStrings.customizeExperienceTitle,
      description: strings.AppStrings.customizeExperienceDescription,
      icon: Icons.settings,
    ),
  ];

  if (showNotificationPage) {
    pages.add(
      GuidePage(
        title: strings.AppStrings.notificationsTitle,
        description: strings.AppStrings.notificationsDescription,
        icon: Icons.notifications_active_outlined,
        isNotificationPage: true,
      ),
    );
  }

  // Only add donation page if user hasn't donated yet
  final settings = Provider.of<SettingsProvider>(context, listen: false);
  if (!settings.hasDonated) {
    pages.add(
      GuidePage(
        title: strings.AppStrings.supportUsTitle,
        description: strings.AppStrings.supportUsDescription,
        icon: Icons.favorite,
        buttonText: strings.AppStrings.donateNow,
        buttonIcon: Icons.volunteer_activism,
        isDonationPage: true,
      ),
    );
  }

  return pages;
}

class GuidePageView extends StatefulWidget {
  final GuidePage page;
  final ColorScheme colorScheme;
  final VoidCallback? onConsentComplete;

  const GuidePageView({
    super.key,
    required this.page,
    required this.colorScheme,
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
      final url = Uri.parse('https://backendbijbelquiz.vercel.app/donate.ts');
      if (await canLaunchUrl(url)) {
        // Mark as donated before launching the URL
        if (safeContext != null && safeContext.mounted) {
          final settings = Provider.of<SettingsProvider>(safeContext, listen: false);
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
            'Kon de donatiepagina niet openen',
            style: TopSnackBarStyle.error,
          );
        }
      }
    } catch (e) {
      if (safeContext != null && safeContext.mounted) {
        showTopSnackBar(
          safeContext,
          'Er is een fout opgetreden bij het openen van de donatiepagina',
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

  bool _permissionGranted = true;

  @override
  void initState() {
    super.initState();
    if (widget.page.isNotificationPage) {
      _checkPermission();
    }
  }

  Future<void> _checkPermission() async {
    if (!kIsWeb && !Platform.isLinux) {
      // Optionally, check permission status here if needed
      setState(() {
        _permissionGranted = true; // Assume granted for now
      });
    }
  }

  Future<void> _requestPermission() async {
    setState(() { _isLoading = true; });
    final granted = await NotificationService.requestNotificationPermission();
    setState(() {
      _isLoading = false;
      _permissionGranted = granted;
    });
    if (!granted && mounted) {
      showTopSnackBar(context, 'Meldingstoestemming geweigerd.', style: TopSnackBarStyle.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.page.isNotificationPage) {
      final settings = Provider.of<SettingsProvider>(context);
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.page.icon,
                size: 100,
                color: widget.colorScheme.primary,
              ),
              const SizedBox(height: 32),
              Text(
                widget.page.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: widget.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                widget.page.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: widget.colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.notifications_active_outlined),
                label: Text(_permissionGranted
                    ? (settings.language == 'en' ? 'Notifications Enabled' : 'Meldingen Ingeschakeld')
                    : (settings.language == 'en' ? 'Enable Notifications' : 'Meldingen Inschakelen')),
                onPressed: _permissionGranted || _isLoading ? null : _requestPermission,
              ),
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    height: 48,
                    child: QuizSkeleton(
                      isSmallPhone: false,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    
    // Check if this is the "Pas Je Ervaring Aan" page
    final isCustomizationPage = widget.page.title == 'Pas Je Ervaring Aan';
    
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
                      color: widget.colorScheme.primary,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      widget.page.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: widget.colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.page.description,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: widget.colorScheme.onSurface,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    if (isCustomizationPage) ...[
                      const SizedBox(height: 32),
                      Consumer<SettingsProvider>(
                        builder: (context, settings, child) {
                          return Column(
                            children: [
                              // Game Speed Dropdown
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: widget.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Spelsnelheid',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            color: widget.colorScheme.onSurface,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 12),
                                    DropdownButtonFormField<String>(
                                      value: settings.gameSpeed,
                                      items: [
                                        DropdownMenuItem(
                                          value: 'slow',
                                          child: Text('Langzaam'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'medium',
                                          child: Text('Gemiddeld'),
                                        ),
                                        DropdownMenuItem(
                                          value: 'fast',
                                          child: Text('Snel'),
                                        ),
                                      ],
                                      onChanged: (String? value) {
                                        if (value != null) {
                                          settings.setGameSpeed(value);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: widget.colorScheme.surface,
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
                                  color: widget.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Geluidseffecten',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: widget.colorScheme.onSurface,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Schakel alle spelgeluiden in of uit',
                                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                  color: widget.colorScheme.onSurface.withValues(alpha: 0.7),
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
                                      activeColor: widget.colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    ],
                    if (widget.page.buttonText != null) ...[
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        icon: Icon(widget.page.buttonIcon ?? Icons.arrow_forward),
                        label: Text(widget.page.buttonText!),
                        onPressed: widget.page.isDonationPage
                            ? _handleDonation
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    final showNotificationPage = !kIsWeb && !Platform.isLinux;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pages = buildGuidePages(
        showNotificationPage: showNotificationPage,
        context: context,
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
      _pageController.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else {
      handleGuideCompletion();
    }
  }

  void goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 100), curve: Curves.linear);
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
    
    if (settings.notificationEnabled && !kIsWeb && !Platform.isLinux) {
      await NotificationService.requestNotificationPermission();
    }
    widget.onComplete?.call();
    if (mounted) Navigator.of(context, rootNavigator: false).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLastPage = _currentPage == _pages.length - 1;
    return Scaffold(
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
                    colorScheme: colorScheme,
                    onConsentComplete: page.isNotificationPage
                        ? () {
                            if (_currentPage < _pages.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              handleGuideCompletion();
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
                    TextButton(
                      onPressed: goToPreviousPage,
                      child: Text('Vorige'),
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
                    child: Text(isLastPage ? 'Beginnen' : 'Volgende'),
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