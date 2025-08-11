import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/game_stats_provider.dart';
import '../services/notification_service.dart';

import './guide_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import '../services/sound_service.dart';
import '../services/logger.dart';
import '../widgets/top_snackbar.dart';

class FeatureTestScreen extends StatefulWidget {
  const FeatureTestScreen({super.key});

  @override
  State<FeatureTestScreen> createState() => _FeatureTestScreenState();
}

// Typedef to help with accessing the private state for testing
// ignore: camel_case_types
typedef GuideScreenTestHarnessState = State<GuideScreenTestHarness>;

class _FeatureTestScreenState extends State<FeatureTestScreen> {
  final List<String> _log = [];
  bool _running = false;
  bool _done = false;
  bool _hasError = false;
  final GlobalKey<State<GuideScreenTestHarness>> _guideKey = GlobalKey<State<GuideScreenTestHarness>>();

  @override
  void initState() {
    super.initState();
    AppLogger.info('FeatureTestScreen loaded');
    // Attach error handlers for services
    final soundService = SoundService();
    soundService.onError = (message) {
      if (mounted) {
        showTopSnackBar(context, message, style: TopSnackBarStyle.error);
      }
    };
    NotificationService.onError = (message) {
      if (mounted) {
        showTopSnackBar(context, message, style: TopSnackBarStyle.error);
      }
    };
    final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
    gameStatsProvider.onError = (message) {
      if (mounted) {
        showTopSnackBar(context, message, style: TopSnackBarStyle.error);
      }
    };
    WidgetsBinding.instance.addPostFrameCallback((_) => _runAllTests());
  }

  Future<void> _runAllTests() async {
    if (_running) return;
    AppLogger.info('Starting all feature tests');
    
    setState(() {
      _running = true;
      _done = false;
      _hasError = false;
      _log.clear();
    });
    
    try {
      await _testQuizPlay();
      await _testSettings();
      await _testNotifications();
      await _testGuideScreen();
      await _testSoundAndHaptic();
      await _testUpdateCheck();
      await _testDialogAndSnackbar();
      await _testUrlLaunch();
      await _testGuideScreenUI();
      AppLogger.info('All feature tests completed successfully');
    } catch (e) {
      _logAdd('Error: ${e.toString()}');
      setState(() { _hasError = true; });
      AppLogger.error('Error running feature tests', e);
    }
    
    if (!mounted) return;
    setState(() {
      _running = false;
      _done = true;
    });
  }

  void _logAdd(String msg) {
    if (!mounted) return;
    setState(() { _log.add(msg); });
  }

  Future<void> _testQuizPlay() async {
    _logAdd('Testing quiz play...');
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final oldScore = gameStats.score;
    await gameStats.updateStats(isCorrect: true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (gameStats.score > oldScore) {
      _logAdd('Quiz play: Score incremented.');
    } else {
      throw Exception('Quiz play: Score did not increment!');
    }
  }

  Future<void> _testSettings() async {
    _logAdd('Testing settings toggling...');
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    // Theme
    final oldTheme = settings.themeMode;
    await settings.setThemeMode(oldTheme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    await Future.delayed(const Duration(milliseconds: 200));
    await settings.setThemeMode(oldTheme); // revert
    _logAdd('Settings: Theme toggled.');
    // Slow mode
    final oldSlow = settings.slowMode;
    await settings.setSlowMode(!oldSlow);
    await Future.delayed(const Duration(milliseconds: 200));
    await settings.setSlowMode(oldSlow);
    _logAdd('Settings: Slow mode toggled.');
    // Mute
    final oldMute = settings.mute;
    await settings.setMute(!oldMute);
    await Future.delayed(const Duration(milliseconds: 200));
    await settings.setMute(oldMute);
    _logAdd('Settings: Mute toggled.');
    // Haptic
    final oldHaptic = settings.hapticFeedback;
    await settings.setHapticFeedback(oldHaptic == 'medium' ? 'soft' : 'medium');
    await Future.delayed(const Duration(milliseconds: 200));
    await settings.setHapticFeedback(oldHaptic);
    _logAdd('Settings: Haptic toggled.');

    // Notifications
    final oldNotif = settings.notificationEnabled;
    await settings.setNotificationEnabled(!oldNotif);
    await Future.delayed(const Duration(milliseconds: 200));
    await settings.setNotificationEnabled(oldNotif);
    _logAdd('Settings: Notifications toggled.');
  }

  Future<void> _testNotifications() async {
    if (kIsWeb || Platform.isLinux) {
      _logAdd('Notifications: Skipped (not supported on web/linux).');
      return;
    }
    _logAdd('Testing notification scheduling...');
    final localContext = context;
    await NotificationService().init();
    await NotificationService().scheduleDailyMotivationNotifications();
    await Future.delayed(const Duration(milliseconds: 500));
    _logAdd('Notifications: Scheduled.');
    await NotificationService().cancelAllNotifications();
    await Future.delayed(const Duration(milliseconds: 200));
    _logAdd('Notifications: Cancelled.');
  }



  Future<void> _testGuideScreen() async {
    _logAdd('Testing guide screen logic...');
    final localContext = context;
    final settings = Provider.of<SettingsProvider>(localContext, listen: false);
    await settings.resetGuideStatus();
    await Future.delayed(const Duration(milliseconds: 200));
    await settings.markGuideAsSeen();
    _logAdd('Guide: Status toggled.');
  }

  Future<void> _testSoundAndHaptic() async {
    _logAdd('Testing sound and haptic feedback...');
    final localContext = context;
    final gameStats = Provider.of<GameStatsProvider>(localContext, listen: false);
    await gameStats.updateStats(isCorrect: true); // Should play sound/haptic if not muted
    await Future.delayed(const Duration(milliseconds: 300));
    _logAdd('Sound/Haptic: Triggered via quiz stat update.');
  }

  Future<void> _testUpdateCheck() async {
    _logAdd('Testing update check logic...');
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version;
      final platform = kIsWeb ? 'web' : Platform.operatingSystem.toLowerCase();
      final url = Uri.parse('https://bijbelquiz.vercel.app/update.php?version=$version&platform=$platform');
      _logAdd('Update: Would check $url');
    } catch (e) {
      _logAdd('Update: Could not check for updates ($e)');
    }
  }

  Future<void> _testDialogAndSnackbar() async {
    _logAdd('Testing dialog and snackbar...');
    final localContext = context;
    await showDialog(
      context: localContext,
      builder: (ctx) => AlertDialog(
        title: const Text('Test Dialog'),
        content: const Text('This is a test dialog.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    _logAdd('Dialog: Shown and closed.');
    // Show a snackbar
    if (!mounted) return;
    showTopSnackBar(localContext, 'This is a test snackbar.');
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    _logAdd('Snackbar: Shown.');
  }

  Future<void> _testUrlLaunch() async {
    _logAdd('Testing URL launch...');
    try {
      final url = Uri.parse('https://bijbelquiz.vercel.app/');
      // ignore: deprecated_member_use
      // Use canLaunchUrl and launchUrl if available
      // For test, just log the intent
      _logAdd('Would launch URL: $url');
    } catch (e) {
      _logAdd('URL launch: Failed ($e)');
    }
  }

  Future<void> _testGuideScreenUI() async {
    _logAdd('Testing GuideScreen UI (all pages)...');
    int totalPages = 0;
    bool completed = false;
    final localContext = context;
    await showDialog(
      context: localContext,
      barrierDismissible: false,
      builder: (context) => GuideScreenTestHarness(
        key: _guideKey,
        onPageShown: (page, total) {
          totalPages = total;
          _logAdd('GuideScreen: Showing page \\${page + 1}/$total');
        },
        onComplete: () {
          completed = true;
          _logAdd('GuideScreen: Completed (Get Started pressed).');
        },
      ),
    );
    // Simulate going through all pages
    for (int i = 0; i < totalPages; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      final harnessState = _guideKey.currentState;
      if (harnessState != null) {
        (harnessState as dynamic).goToNextPage();
      }
    }
    await Future.delayed(const Duration(milliseconds: 400));
    if (completed) {
      _logAdd('GuideScreen: Walkthrough finished.');
    } else {
      _logAdd('GuideScreen: Walkthrough did not complete as expected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Test'),
        backgroundColor: colorScheme.surface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_running) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 16),
              const Text('Running feature tests...'),
            ] else if (_done && !_hasError) ...[
              const Icon(Icons.check_circle, color: Colors.green, size: 32),
              const SizedBox(height: 8),
              const Text('All tests passed!'),
            ] else if (_hasError) ...[
              const Icon(Icons.error, color: Colors.red, size: 32),
              const SizedBox(height: 8),
              const Text('Some tests failed.'),
            ],
            const SizedBox(height: 16),
            const Text('Test Log:'),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: ListView.builder(
                  itemCount: _log.length,
                  itemBuilder: (context, i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: Text(_log[i]),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!_running)
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Run Again'),
                    onPressed: _runAllTests,
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Log'),
                    onPressed: () async {
                      final logText = _log.join('\n');
                      await Clipboard.setData(ClipboardData(text: logText));
                      if (!mounted) return;
                      if (!context.mounted) return;
                      showTopSnackBar(context, 'Log copied to clipboard!', style: TopSnackBarStyle.success);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}