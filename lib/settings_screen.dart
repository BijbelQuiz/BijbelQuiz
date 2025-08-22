import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'providers/game_stats_provider.dart';
import 'providers/lesson_progress_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/guide_screen.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'services/notification_service.dart';
import 'widgets/top_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'screens/feature_test_screen.dart';
import 'services/question_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/lesson_select_screen.dart';
import 'widgets/quiz_skeleton.dart';
import 'l10n/strings_nl.dart' as strings;
import 'services/update_service.dart';
import 'widgets/update_dialog.dart';

/// The settings screen that allows users to customize app preferences
class SettingsScreen extends StatefulWidget {
  final VoidCallback? onOpenGuide;
  const SettingsScreen({super.key, this.onOpenGuide});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Attach error handler for notification service
    NotificationService.onError = (message) {
      if (mounted) {
        showTopSnackBar(context, message, style: TopSnackBarStyle.error);
      }
    };
  }

  void _openStatusPage() async {
    final Uri url = Uri.parse('https://oneuptime.com/status-page/df067f1b-2beb-42d2-9ddd-719e9ce51238');
    if (!await launchUrl(url)) {
      if (mounted) {
        showTopSnackBar(context, strings.AppStrings.couldNotOpenStatusPage, style: TopSnackBarStyle.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;
    final isSmallScreen = size.width < 360;

    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.settings_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strings.AppStrings.settings,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 800 : (isTablet ? 600 : double.infinity),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : (isSmallScreen ? 16.0 : 24.0)),
                vertical: 24.0,
              ),
              child: _buildContent(context, settings, colorScheme, isSmallScreen, isDesktop),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen, bool isDesktop) {
    if (settings.isLoading) {
      final size = MediaQuery.of(context).size;
      final isDesktop = size.width > 800;
      final isTablet = size.width > 600 && size.width <= 800;
      final isSmallPhone = size.width < 350;
      return Center(
        child: QuizSkeleton(
          isDesktop: isDesktop,
          isTablet: isTablet,
          isSmallPhone: isSmallPhone,
        ),
      );
    }
    if (settings.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(settings.error!, style: TextStyle(color: colorScheme.error), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () { settings.reloadSettings(); },
              icon: const Icon(Icons.refresh),
              label: Text(strings.AppStrings.retry),
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Donation Section - Only show if user hasn't donated yet
        if (!settings.hasDonated) 
          Card(
            elevation: isDesktop ? 2 : 1,
            color: colorScheme.surfaceContainerHighest,
            margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8, horizontal: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 18),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 8 : 12,
                horizontal: isDesktop ? 16 : (isSmallScreen ? 8 : 12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    strings.AppStrings.supportUsTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings.AppStrings.donateExplanation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.tonalIcon(
                    onPressed: () async {
                      final Uri url = Uri.parse('https://backendbijbelquiz.vercel.app/donate.ts');
                      // Mark as donated before launching the URL
                      await settings.markAsDonated();
                      
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        if (mounted && context.mounted) {
                          showTopSnackBar(
                            context,
                            strings.AppStrings.couldNotOpenDonationPage,
                            style: TopSnackBarStyle.error,
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.favorite, size: 18),
                    label: Text(
                      strings.AppStrings.donateButton,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
        _buildSettingsGroup(
          context,
          settings,
          colorScheme,
          isSmallScreen,
          isDesktop,
          title: strings.AppStrings.display,
          children: [
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.theme,
              subtitle: strings.AppStrings.chooseTheme,
              icon: Icons.palette,
              child: (() {
                // Compute available values
                final List<String> availableValues = [
                  ThemeMode.light.name,
                  ThemeMode.system.name,
                  ThemeMode.dark.name,
                  ...settings.unlockedThemes.where((t) => t == 'oled' || t == 'green' || t == 'orange'),
                ];
                String value = _getThemeDropdownValue(settings);
                // Always default to the first available value if not present
                if (!availableValues.contains(value) || value.isEmpty) {
                  value = availableValues.first;
                }
                return DropdownButton<String>(
                  value: value,
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.light.name,
                      child: Text(strings.AppStrings.lightTheme),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.system.name,
                      child: Text(strings.AppStrings.systemTheme),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark.name,
                      child: Text(strings.AppStrings.darkTheme),
                    ),
                    if (settings.unlockedThemes.contains('oled'))
                      DropdownMenuItem(
                        value: 'oled',
                        child: Text(strings.AppStrings.oledTheme),
                      ),
                    if (settings.unlockedThemes.contains('green'))
                      DropdownMenuItem(
                        value: 'green',
                        child: Text(strings.AppStrings.greenTheme),
                      ),
                    if (settings.unlockedThemes.contains('orange'))
                      DropdownMenuItem(
                        value: 'orange',
                        child: Text(strings.AppStrings.orangeTheme),
                      ),
                  ],
                  onChanged: (String? value) {
                    if (value == ThemeMode.light.name) {
                      settings.setCustomTheme(null);
                      settings.setThemeMode(ThemeMode.light);
                    } else if (value == ThemeMode.dark.name) {
                      settings.setCustomTheme(null);
                      settings.setThemeMode(ThemeMode.dark);
                    } else if (value == ThemeMode.system.name) {
                      settings.setCustomTheme(null);
                      settings.setThemeMode(ThemeMode.system);
                    } else {
                      settings.setCustomTheme(value);
                      settings.setThemeMode(ThemeMode.light);
                    }
                  },
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                  dropdownColor: colorScheme.surfaceContainerHighest,
                );
              })(),
            ),

          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          context,
          settings,
          colorScheme,
          isSmallScreen,
          isDesktop,
          title: strings.AppStrings.gameSettings,
          children: [
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.gameSpeed,
              subtitle: strings.AppStrings.chooseGameSpeed,
              icon: Icons.speed,
              child: DropdownButton<String>(
                value: settings.gameSpeed,
                items: [
                  DropdownMenuItem(
                    value: 'slow',
                    child: Text(strings.AppStrings.slow),
                  ),
                  DropdownMenuItem(
                    value: 'medium',
                    child: Text(strings.AppStrings.medium),
                  ),
                  DropdownMenuItem(
                    value: 'fast',
                    child: Text(strings.AppStrings.fast),
                  ),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    settings.setGameSpeed(value);
                  }
                },
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
                dropdownColor: colorScheme.surfaceContainerHighest,
              ),
            ),
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.muteSoundEffects,
              subtitle: strings.AppStrings.muteSoundEffectsDesc,
              icon: Icons.volume_off,
              child: Switch(
                value: settings.mute,
                onChanged: (bool value) {
                  settings.setMute(value);
                },
                activeColor: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          context,
          settings,
          colorScheme,
          isSmallScreen,
          isDesktop,
          title: strings.AppStrings.about,
          children: [
            // Only show update option on non-web platforms
            if (!kIsWeb)
              _buildSettingItem(
                context,
                settings,
                colorScheme,
                isSmallScreen,
                isDesktop,
                title: strings.AppStrings.updateApp,
                subtitle: strings.AppStrings.checkForUpdates,
                icon: Icons.update,
                child: IconButton(
                  icon: const Icon(Icons.update),
                  onPressed: () => _checkForUpdate(context),
                  tooltip: strings.AppStrings.checkForUpdatesTooltip,
                ),
              ),
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.serverStatus,
              subtitle: strings.AppStrings.checkServiceStatus,
              icon: Icons.cloud_done_outlined,
              child: IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: _openStatusPage,
                tooltip: strings.AppStrings.openStatusPage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Notifications group: only show if supported
        if (!(kIsWeb || Platform.isLinux))
          _buildSettingsGroup(
            context,
            settings,
            colorScheme,
            isSmallScreen,
            isDesktop,
            title: strings.AppStrings.notifications,
            children: [
              _buildSettingItem(
                context,
                settings,
                colorScheme,
                isSmallScreen,
                isDesktop,
                title: strings.AppStrings.motivationNotifications,
                subtitle: strings.AppStrings.motivationNotificationsDesc,
                icon: Icons.notifications,
                child: Switch(
                  value: settings.notificationEnabled,
                  onChanged: (bool value) async {
                    await settings.setNotificationEnabled(value);
                    if (value) {
                      final granted = await NotificationService.requestNotificationPermission();
                      if (granted) {
                        await NotificationService().scheduleDailyMotivationNotifications();
                      }
                    } else {
                      await NotificationService().cancelAllNotifications();
                    }
                  },
                ),
              ),
            ],
          ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          context,
          settings,
          colorScheme,
          isSmallScreen,
          isDesktop,
          title: strings.AppStrings.actions,
          children: [
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () => _showResetAndLogoutDialog(context, settings),
              label: strings.AppStrings.resetAndLogout,
              icon: Icons.logout,
              isDestructive: true,
              subtitle: strings.AppStrings.resetAndLogoutDesc,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () {
                final nav = Navigator.of(context);
                if (widget.onOpenGuide != null) widget.onOpenGuide!();
                nav.push(
                  MaterialPageRoute(
                    builder: (context) => const GuideScreen(),
                  ),
                );
              },
              label: strings.AppStrings.showIntroduction,
              icon: Icons.help_outline,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () => _launchBugReportEmail(context),
              label: strings.AppStrings.reportIssue,
              icon: Icons.bug_report,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () async {
                await QuestionCacheService().clearCache();
                if (context.mounted) {
                  showTopSnackBar(context, strings.AppStrings.cacheCleared, style: TopSnackBarStyle.success);
                }
              },
              label: strings.AppStrings.clearQuestionCache,
              icon: Icons.delete_sweep,
              isDestructive: true,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () async {
                final Uri emailLaunchUri = Uri(
                  scheme: 'mailto',
                  path: 'thomasnowprod@proton.me',
                );
                if (await canLaunchUrl(emailLaunchUri)) {
                  await launchUrl(emailLaunchUri);
                } else {
                  if (context.mounted) {
                    showTopSnackBar(context, strings.AppStrings.emailNotAvailable, style: TopSnackBarStyle.error);
                  }
                }
              },
              label: strings.AppStrings.contactUs,
              icon: Icons.email,
            ),
          ],
        ),
        const SizedBox(height: 32),
        if (kDebugMode)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.bug_report),
              label: Text(strings.AppStrings.testAllFeatures),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FeatureTestScreen(),
                  ),
                );
              },
            ),
          ),
        Text(
          strings.AppStrings.copyright,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: colorScheme.onSurface.withValues(alpha: (0.7 * 255)),
          ),
        ),
        const SizedBox(height: 4),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final version = snapshot.data?.version ?? '';
            return Text(
              '${strings.AppStrings.version} $version',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: colorScheme.onSurface.withValues(alpha: (0.7 * 255)),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(
    BuildContext context,
    SettingsProvider settings,
    ColorScheme colorScheme,
    bool isSmallScreen,
    bool isDesktop, {
    required String title,
    required List<Widget> children,
  }) {
    // Use Card for Material 3 look, with more airy spacing and subtle elevation
    return Card(
      elevation: isDesktop ? 2 : 1,
      color: colorScheme.surfaceContainerHighest,
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 18),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: isSmallScreen ? 8 : 12,
          horizontal: isDesktop ? 16 : (isSmallScreen ? 8 : 12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.08 * 255).round()),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getGroupIcon(title),
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            ..._addDividersBetween(children, isSmallScreen),
          ],
        ),
      ),
    );
  }

  // Helper to add dividers between children for more airy look
  List<Widget> _addDividersBetween(List<Widget> children, bool isSmallScreen) {
    final List<Widget> spaced = [];
    for (int i = 0; i < children.length; i++) {
      spaced.add(children[i]);
      if (i < children.length - 1) {
        spaced.add(Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 3 : 6),
          child: Divider(height: 1, thickness: 0.7),
        ));
      }
    }
    return spaced;
  }

  Widget _buildSettingItem(
    BuildContext context,
    SettingsProvider settings,
    ColorScheme colorScheme,
    bool isSmallScreen,
    bool isDesktop, {
    required String title,
    String? subtitle,
    required IconData icon,
    required Widget child,
  }) {
    final size = MediaQuery.of(context).size;
    final isVerySmallScreen = size.width < 300;

    final double iconSize = isSmallScreen ? 16 : 18;
    final double fontSize = isSmallScreen ? 13 : 15;
    final double subtitleFontSize = isSmallScreen ? 11 : 13;
    final double verticalPad = isSmallScreen ? 6 : 8;
    final double horizontalPad = isSmallScreen ? 5 : 8;
    final double borderRadius = isSmallScreen ? 8 : 10;

    if (isVerySmallScreen) {
      // For very small screens, stack the title and control vertically
      return Container(
        padding: EdgeInsets.symmetric(vertical: verticalPad, horizontal: horizontalPad),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.08 * 255).round()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: iconSize,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: (0.7 * 255)),
                    fontSize: subtitleFontSize,
                  ),
                ),
              ),
            ],
            SizedBox(height: verticalPad),
            child,
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: verticalPad, horizontal: horizontalPad),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha((0.08 * 255).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(width: isSmallScreen ? 6 : 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    fontSize: fontSize,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: (0.7 * 255)),
                      fontSize: subtitleFontSize,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 6 : 10),
          child,
        ],
      ),
    );
  }

  IconData _getGroupIcon(String title) {
    switch (title.toLowerCase()) {
      case 'appearance':
      case 'weergave':
        return Icons.palette_rounded;
      case 'game settings':
      case 'spelinstellingen':
        return Icons.games_rounded;
      case 'performance':
      case 'prestaties':
        return Icons.speed_rounded;
      case 'notifications':
      case 'meldingen':
        return Icons.notifications_rounded;
      case 'privacy & analytics':
        return Icons.privacy_tip_rounded;
      case 'about':
      case 'over':
        return Icons.info_rounded;
      default:
        return Icons.settings_rounded;
    }
  }

  Widget _buildActionButton(
    BuildContext context,
    SettingsProvider settings,
    ColorScheme colorScheme,
    bool isSmallScreen,
    bool isDesktop, {
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    bool isDestructive = false,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.04 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 14 : 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                SizedBox(width: isDesktop ? 12 : 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: (0.7 * 255)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colorScheme.onSurface.withValues(alpha: (0.5 * 255)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showResetAndLogoutDialog(BuildContext context, SettingsProvider settings) async {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final localContext = context;
    return showDialog(
      context: localContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resetten en uitloggen'),
          content: const Text('Dit verwijdert alle scores, voortgang, cache, instellingen en activatie. De app wordt gedeactiveerd en vereist een nieuwe activatiecode. Deze actie kan niet ongedaan worden gemaakt.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuleren'),
            ),
            TextButton(
              onPressed: () async {
                final nav = Navigator.of(context);
                final settings = Provider.of<SettingsProvider>(context, listen: false);
                try {
                  // Reset in-memory providers first
                  await gameStats.resetStats();
                  if (context.mounted) {
                    await Provider.of<LessonProgressProvider>(context, listen: false).resetAll();
                  }

                  // Clear caches and notifications
                  await QuestionCacheService().clearCache();
                  await NotificationService().cancelAllNotifications();

                  // Clear all persisted data
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  // Reset the settings provider to initial state
                  await settings.reloadSettings();
                  
                  // Explicitly set hasSeenGuide to false
                  await settings.resetGuideStatus();
                  
                  // Reset check for update status
                  await settings.resetCheckForUpdateStatus();
                } catch (_) {
                  // ignore errors silently here; we'll proceed to restart flow
                }

                if (!context.mounted) return;
                nav.pop(); // Close dialog
                
                // Navigate to LessonSelectScreen
                nav.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LessonSelectScreen(),
                  ),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Resetten en uitloggen'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchBugReportEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'thomasnowprod@proton.me',
      queryParameters: {
        'subject': 'BijbelQuiz error report',
      },
    );
    final localContext = context;

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        // Fallback: Show a dialog with the email address
        if (localContext.mounted) {
          _showBugReportDialog(localContext);
        }
      }
    } catch (e) {
      // If there's any error, show the fallback dialog
      if (localContext.mounted) {
        _showBugReportDialog(localContext);
      }
    }
  }

  void _showBugReportDialog(BuildContext context) {
    final localContext = context;
    showDialog(
      context: localContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Address'),
          content: const Text('thomasnowprod@proton.me'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _checkForUpdate(BuildContext context) async {
    final localContext = context;
    try {
      final updateService = UpdateService();
      final updateInfo = await updateService.checkForUpdate();
      
      if (localContext.mounted) {
        if (updateInfo != null) {
          // Show update dialog
          showDialog(
            context: localContext,
            builder: (BuildContext context) {
              return UpdateDialog(updateInfo: updateInfo);
            },
          );
        } else {
          // No update available
          showTopSnackBar(
            localContext, 
            'Je gebruikt de nieuwste versie van BijbelQuiz!', 
            style: TopSnackBarStyle.success
          );
        }
      }
    } catch (e) {
      // Use a post-frame callback to ensure the context is still valid
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (localContext.mounted) {
          showTopSnackBar(
            localContext, 
            'Kon niet controleren op updates. Probeer het later opnieuw.', 
            style: TopSnackBarStyle.error
          );
        }
      });
    }
  }

}

String _getThemeDropdownValue(SettingsProvider settings) {
  final custom = settings.selectedCustomThemeKey;
  if (custom != null && settings.unlockedThemes.contains(custom)) {
    return custom;
  }
  // fallback to themeMode
  final mode = settings.themeMode;
  if (mode == ThemeMode.light || mode == ThemeMode.dark || mode == ThemeMode.system) {
    return mode.name;
  }
  // fallback to light if something is wrong
  return ThemeMode.light.name;
} 