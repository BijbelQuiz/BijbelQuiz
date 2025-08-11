import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

import '../services/notification_service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../services/logger.dart';
import '../widgets/quiz_skeleton.dart';
import '../widgets/top_snackbar.dart';

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
    return buildGuidePages(showNotificationPage: showNotificationPage);
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
                      child: Text('Vorige'),
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
                      isLastPage ? 'Beginnen' : 'Volgende',
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
      Navigator.of(localContext).pop();
    } catch (e) {
      if (!mounted) return;
      final errorMessage = 'Setup voltooien mislukt. Probeer het opnieuw.';
      showTopSnackBar(localContext, errorMessage, style: TopSnackBarStyle.error);
    }
  }
}

class GuidePage {
  final String title;
  final String description;
  final IconData icon;
  final bool isNotificationPage;

  GuidePage({
    required this.title,
    required this.description,
    required this.icon,
    this.isNotificationPage = false,
  });
}

List<GuidePage> buildGuidePages({required bool showNotificationPage}) {
  final pages = <GuidePage>[
    GuidePage(
      title: 'Welkom bij BijbelQuiz!',
      description: 'Test je bijbelkennis',
      icon: Icons.church,
    ),
    GuidePage(
      title: 'Ontdek en Leer',
      description: 'Beantwoord vragen uit alle Bijbelboeken en Bijbelse geschiedenissen om je kennis te vergroten.',
      icon: Icons.quiz,
    ),
    GuidePage(
      title: 'Volg Je Voortgang',
      description: 'Houd je scores bij en verbeter jezelf in de loop van de tijd.',
      icon: Icons.insights,
    ),
    GuidePage(
      title: 'Pas Je Ervaring Aan',
      description: 'Pas je thema, speelsnelheid en de geluidseffecten aan in de instellingen. Heeft u nog vragen? Neem gerust contact met ons op.',
      icon: Icons.settings,
    ),
  ];

  if (showNotificationPage) {
    pages.add(
      GuidePage(
        title: 'Blijf Gemotiveerd!',
        description: 'Schakel meldingen in om dagelijkse motivatie en herinneringen te ontvangen voor BijbelQuiz.',
        icon: Icons.notifications_active_outlined,
        isNotificationPage: true,
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
  State<GuidePageView> createState() => GuidePageViewState();
}

class GuidePageViewState extends State<GuidePageView> {
  bool _isLoading = false;
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
    _pages = buildGuidePages(showNotificationPage: showNotificationPage);
    WidgetsBinding.instance.addPostFrameCallback((_) {
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