import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bijbelquiz/providers/profile_provider.dart';
import 'package:bijbelquiz/models/user_profile.dart';
import 'providers/settings_provider.dart';
import 'providers/game_stats_provider.dart';
import 'providers/lesson_progress_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/guide_screen.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'services/notification_service.dart';
import 'services/api_service.dart';
import 'widgets/top_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
import 'services/question_cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/lesson_select_screen.dart';
import 'widgets/quiz_skeleton.dart';
import 'constants/urls.dart';
import 'l10n/strings_nl.dart' as strings;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'services/logger.dart';
import 'package:archive/archive.dart';
import 'utils/bijbelquiz_gen_utils.dart';
import 'screens/bijbelquiz_gen_screen.dart';
import 'theme/theme_manager.dart';

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
    AppLogger.info('SettingsScreen initialized');
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.screen(context, 'SettingsScreen');

    // Track settings access
    analyticsService.trackFeatureStart(context, AnalyticsService.FEATURE_SETTINGS);
    // Attach error handler for notification service
    NotificationService.onError = (message) {
      AppLogger.error('Notification service error: $message');
      if (mounted) {
        showTopSnackBar(context, message, style: TopSnackBarStyle.error);
      }
    };
  }

  void _openStatusPage() async {
    Provider.of<AnalyticsService>(context, listen: false).capture(context, 'open_status_page');
    final Uri url = Uri.parse(AppUrls.statusPageUrl);
    if (!await launchUrl(url)) {
      if (mounted) {
        showTopSnackBar(context, strings.AppStrings.couldNotOpenStatusPage, style: TopSnackBarStyle.error);
      }
    }
  }

  Future<void> _checkForUpdates(BuildContext context, SettingsProvider settings) async {
    Provider.of<AnalyticsService>(context, listen: false).capture(context, 'check_for_updates');
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version;
      final platform = kIsWeb ? 'web' : Platform.operatingSystem.toLowerCase();
      final url = Uri.parse('${AppUrls.updateUrl}?version=$version&platform=$platform');

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showTopSnackBar(context, strings.AppStrings.couldNotOpenUpdatePage, style: TopSnackBarStyle.error);
          }
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showTopSnackBar(context, '${strings.AppStrings.errorOpeningUpdatePage}${e.toString()}', style: TopSnackBarStyle.error);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
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
                color: colorScheme.primary.withOpacity(0.1),
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
              style: textTheme.titleLarge?.copyWith(
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
        _buildProfileManagementGroup(context, settings, colorScheme, isSmallScreen, isDesktop),
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
                // Get available themes from the centralized theme manager
                final Map<String, String> themeDisplayNames = <String, String>{};
                
                // Add system themes
                themeDisplayNames[ThemeMode.light.name] = strings.AppStrings.lightTheme;
                themeDisplayNames[ThemeMode.system.name] = strings.AppStrings.systemTheme;
                themeDisplayNames[ThemeMode.dark.name] = strings.AppStrings.darkTheme;
                
                // Add themes from centralized theme manager
                final availableThemes = ThemeManager().getAvailableThemes();
                for (final entry in availableThemes.entries) {
                  themeDisplayNames[entry.key] = entry.value.name;
                }

                // Add AI themes
                for (final themeId in settings.getAIThemeIds()) {
                  final aiTheme = settings.getAITheme(themeId);
                  themeDisplayNames[themeId] = aiTheme?.name ?? strings.AppStrings.aiThemeFallback;
                }

                String value = _getThemeDropdownValue(settings);
                
                return DropdownButton<String>(
                  value: value,
                  items: themeDisplayNames.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
                      final previousTheme = _getThemeDropdownValue(settings);
  
                      final analytics = Provider.of<AnalyticsService>(context, listen: false);
                      analytics.capture(context, 'change_theme', properties: {'theme': value});
                      analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_THEME_SELECTION, additionalProperties: {
                        'theme': value,
                        'previous_theme': previousTheme,
                      });
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
                        // Check if it's an AI theme
                        if (settings.hasAITheme(value)) {
                          settings.setCustomTheme(value);
                          settings.setThemeMode(ThemeMode.light);
                        } else {
                          // For other custom themes, determine if it's light or dark from the theme definition
                          final themeDef = ThemeManager().getThemeDefinition(value);
                          if (themeDef != null) {
                            settings.setCustomTheme(value);
                            // Set theme mode based on the theme's type
                            settings.setThemeMode(themeDef.type.toLowerCase() == 'dark' ? ThemeMode.dark : ThemeMode.light);
                          } else {
                            // Fallback for themes that don't exist in the centralized system
                            settings.setCustomTheme(value);
                            // Default to light mode for unknown themes
                            settings.setThemeMode(ThemeMode.light);
                          }
                        }
                      }
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
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.showNavigationLabels,
              subtitle: strings.AppStrings.showNavigationLabelsDesc,
              icon: Icons.label,
              child: Switch(
                value: settings.showNavigationLabels,
                onChanged: (bool value) {
                  final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                  final analytics = Provider.of<AnalyticsService>(context, listen: false);
                  analytics.capture(context, 'toggle_navigation_labels', properties: {'show_labels': value});
                  analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_SETTINGS, additionalProperties: {
                    'setting': 'show_navigation_labels',
                    'value': value,
                  });
                  settings.setShowNavigationLabels(value);
                },
                activeThumbColor: colorScheme.primary,
              ),
            ),
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: 'Leslay-out',
              subtitle: 'Kies hoe lessen worden weergegeven',
              icon: Icons.view_module,
              child: DropdownButton<String>(
                value: settings.layoutType,
                items: [
                  DropdownMenuItem(
                    value: SettingsProvider.layoutGrid,
                    child: Text('Grid'),
                  ),
                  DropdownMenuItem(
                    value: SettingsProvider.layoutList,
                    child: Text('Lijst'),
                  ),
                  DropdownMenuItem(
                    value: SettingsProvider.layoutCompactGrid,
                    child: Text('Compacte grid'),
                  ),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                    final analytics = Provider.of<AnalyticsService>(context, listen: false);
                    analytics.capture(context, 'change_layout_type', properties: {'layout': value});
                    analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_SETTINGS, additionalProperties: {
                      'setting': 'layout_type',
                      'value': value,
                    });
                    settings.setLayoutType(value);
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
              title: strings.AppStrings.colorfulMode,
              subtitle: strings.AppStrings.colorfulModeDesc,
              icon: Icons.color_lens,
              child: Switch(
                value: settings.colorfulMode,
                onChanged: (bool value) {
                  final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                  final analytics = Provider.of<AnalyticsService>(context, listen: false);
                  analytics.capture(context, 'toggle_colorful_mode', properties: {'enabled': value});
                  analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_SETTINGS, additionalProperties: {
                    'setting': 'colorful_mode',
                    'value': value,
                  });
                  settings.setColorfulMode(value);
                },
                activeThumbColor: colorScheme.primary,
              ),
            ),
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.hidePopup,
              subtitle: strings.AppStrings.hidePopupDesc,
              icon: Icons.visibility_off,
              child: Switch(
                value: settings.hidePromoCard,
                onChanged: (bool value) {
                  final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                  final analytics = Provider.of<AnalyticsService>(context, listen: false);
                  analytics.capture(context, 'toggle_hide_promo_card', properties: {'hide': value});
                  analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_SETTINGS, additionalProperties: {
                    'setting': 'hide_promo_card',
                    'value': value,
                  });
                  settings.setHidePromoCard(value);
                },
                activeThumbColor: colorScheme.primary,
              ),
            ),
          ],
        ),

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
                    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                    final analytics = Provider.of<AnalyticsService>(context, listen: false);
                    analytics.capture(context, 'change_game_speed', properties: {'speed': value});
                    analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_SETTINGS, additionalProperties: {
                      'setting': 'game_speed',
                      'value': value,
                    });
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
                  final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                  final analytics = Provider.of<AnalyticsService>(context, listen: false);
                  analytics.capture(context, 'toggle_mute', properties: {'muted': value});
                  analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_SETTINGS, additionalProperties: {
                    'setting': 'mute',
                    'value': value,
                  });
                  settings.setMute(value);
                },
                activeThumbColor: colorScheme.primary,
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
            if (!(kIsWeb || Platform.isAndroid))
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.checkForUpdates,
              subtitle: strings.AppStrings.checkForUpdatesDescription,
              icon: Icons.system_update,
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _checkForUpdates(context, settings),
                tooltip: strings.AppStrings.checkForUpdatesTooltip,
              ),
            ),
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.privacyPolicy,
              subtitle: strings.AppStrings.privacyPolicyDescription,
              icon: Icons.privacy_tip,
              child: IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () async {
                  final Uri url = Uri.parse(AppUrls.privacyUrl);
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    if (mounted) {
                      showTopSnackBar(context, strings.AppStrings.couldNotOpenPrivacyPolicy, style: TopSnackBarStyle.error);
                    }
                  }
                },
                tooltip: strings.AppStrings.openPrivacyPolicyTooltip,
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
          title: strings.AppStrings.localApi,
          children: [
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.enableLocalApi,
              subtitle: strings.AppStrings.enableLocalApiDesc,
              icon: Icons.api,
              child: Switch(
                value: settings.apiEnabled,
                onChanged: (bool value) {
                  settings.setApiEnabled(value);
                },
                activeThumbColor: colorScheme.primary,
              ),
            ),
            if (settings.apiEnabled) ...[
              _buildSettingItem(
                context,
                settings,
                colorScheme,
                isSmallScreen,
                isDesktop,
                title: strings.AppStrings.apiKey,
                subtitle: settings.apiKey.isEmpty ? strings.AppStrings.generateApiKey : _formatApiKey(settings.apiKey),
                icon: Icons.key,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (settings.apiKey.isNotEmpty) ...[
                      IconButton(
                        onPressed: () => _copyApiKeyToClipboard(context, settings.apiKey),
                        icon: Icon(Icons.copy, size: 20),
                        tooltip: strings.AppStrings.copyApiKey,
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.primary.withOpacity(0.1),
                          foregroundColor: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: TextButton(
                        onPressed: () async {
                          if (settings.apiKey.isEmpty) {
                            await settings.generateNewApiKey();
                          } else {
                            // Show dialog to regenerate key
                            _showApiKeyDialog(context, settings);
                          }
                        },
                        child: Text(settings.apiKey.isEmpty ? strings.AppStrings.generateKey : strings.AppStrings.regenerateApiKey),
                      ),
                    ),
                  ],
                ),
              ),
              _buildSettingItem(
                context,
                settings,
                colorScheme,
                isSmallScreen,
                isDesktop,
                title: strings.AppStrings.apiPort,
                subtitle: '${strings.AppStrings.apiPortDesc} (${settings.apiPort})',
                icon: Icons.settings_ethernet,
                child: SizedBox(
                  width: 100,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    ),
                    controller: TextEditingController(text: settings.apiPort.toString()),
                    onSubmitted: (value) {
                      final port = int.tryParse(value);
                      if (port != null && port >= 1024 && port <= 65535) {
                        settings.setApiPort(port);
                      }
                    },
                  ),
                ),
              ),
              _buildSettingItem(
                context,
                settings,
                colorScheme,
                isSmallScreen,
                isDesktop,
                title: strings.AppStrings.apiStatus,
                subtitle: strings.AppStrings.apiStatusDesc,
                icon: Icons.info_outline,
                child: Consumer<ApiService?>(
                  builder: (context, apiService, child) {
                    // Also check if API is enabled in settings
                    final settings = Provider.of<SettingsProvider>(context);
                    final isApiEnabled = settings.apiEnabled;
                    final isRunning = apiService?.isRunning ?? false;

                    // Show different states based on API enabled status and server running status
                    Color statusColor;
                    String statusText;
                    if (!isApiEnabled) {
                      statusColor = Colors.grey;
                      statusText = strings.AppStrings.apiDisabled;
                    } else if (isRunning) {
                      statusColor = Colors.green;
                      statusText = strings.AppStrings.apiRunning;
                    } else {
                      statusColor = Colors.orange;
                      statusText = strings.AppStrings.apiStarting;
                    }

                    return Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 24),
        _buildSettingsGroup(
          context,
          settings,
          colorScheme,
          isSmallScreen,
          isDesktop,
          title: strings.AppStrings.privacyAndAnalytics,
          children: [
            _buildSettingItem(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              title: strings.AppStrings.analytics,
              subtitle: strings.AppStrings.analyticsDescription,
              icon: Icons.analytics,
              child: Switch(
                value: settings.analyticsEnabled,
                onChanged: (bool value) {
                  // Track analytics setting change
                  final analytics = Provider.of<AnalyticsService>(context, listen: false);
                  analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_ANALYTICS_SETTINGS, additionalProperties: {
                    'enabled': value,
                  });
                  settings.setAnalyticsEnabled(value);
                },
                activeThumbColor: colorScheme.primary,
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
                    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                    final analytics = Provider.of<AnalyticsService>(context, listen: false);
                    analytics.capture(context, 'toggle_notifications', properties: {'enabled': value});
                    analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_SETTINGS, additionalProperties: {
                      'setting': 'notifications',
                      'value': value,
                    });
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
                  activeThumbColor: colorScheme.primary,
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
              onPressed: () async {
                final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

                // Track donation attempt
                final analytics = Provider.of<AnalyticsService>(context, listen: false);
                analytics.trackFeatureSuccess(context, AnalyticsService.FEATURE_DONATION_SYSTEM);

                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'donate');
                final Uri url = Uri.parse(AppUrls.donateUrl);
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
              label: strings.AppStrings.donateButton,
              icon: Icons.favorite,
              subtitle: strings.AppStrings.supportUsTitle,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () {
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'show_reset_and_logout_dialog');
                _showResetAndLogoutDialog(context, settings);
              },
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
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'show_introduction');
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
              onPressed: () {
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'report_issue');
                _launchBugReportEmail(context);
              },
              label: strings.AppStrings.reportIssue,
              icon: Icons.bug_report,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () {
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'export_stats');
                _exportStats(context);
              },
              label: strings.AppStrings.exportStats,
              subtitle: strings.AppStrings.exportStatsDesc,
              icon: Icons.download,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () {
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'import_stats');
                _importStats(context);
              },
              label: strings.AppStrings.importStats,
              subtitle: strings.AppStrings.importStatsDesc,
              icon: Icons.upload,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () async {
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'clear_question_cache');
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
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'contact_us');
                final Uri url = Uri.parse(AppUrls.contactEmailUrl);
                if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  if (context.mounted) {
                    showTopSnackBar(context, strings.AppStrings.emailNotAvailable, style: TopSnackBarStyle.error);
                  }
                }
              },
              label: strings.AppStrings.contactUs,
              icon: Icons.email,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () {
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'show_social_media_dialog');
                _showSocialMediaDialog(context);
              },
              label: strings.AppStrings.followOnSocialMedia,
              icon: Icons.share,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () => _showInviteDialog(context),
              label: strings.AppStrings.inviteFriend,
              icon: Icons.person_add,
            ),
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () => _shareStats(context),
              label: strings.AppStrings.shareYourStats,
              subtitle: strings.AppStrings.copyStatsLinkToClipboard,
              icon: Icons.bar_chart,
            ),
            // Show BijbelQuiz Gen replay button only during gen period or in debug mode
            if (BijbelQuizGenPeriod.isGenPeriod() || kDebugMode)
            _buildActionButton(
              context,
              settings,
              colorScheme,
              isSmallScreen,
              isDesktop,
              onPressed: () {
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'replay_bijbelquiz_gen');
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const BijbelQuizGenScreen(),
                  ),
                );
              },
              label: strings.AppStrings.bijbelquizGenTitle,
              subtitle: strings.AppStrings.bijbelquizGenSubtitle + '${BijbelQuizGenPeriod.getStatsYear()}',
              icon: Icons.auto_awesome,
            ),

          ],
        ),
        const SizedBox(height: 32),
        Text(
          strings.AppStrings.copyright,
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: colorScheme.onSurface.withOpacity(0.7),
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
                color: colorScheme.onSurface.withOpacity(0.7),
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
                    color: colorScheme.primary.withOpacity(0.08),
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
                    color: colorScheme.primary.withOpacity(0.08),
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
                    color: colorScheme.onSurface.withOpacity(0.7),
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
              color: colorScheme.primary.withOpacity(0.08),
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
                      color: colorScheme.onSurface.withOpacity(0.7),
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
            color: colorScheme.shadow.withOpacity(0.04),
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
                    color: colorScheme.primary.withOpacity(0.1),
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
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.5),
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
          title: Text(strings.AppStrings.resetAndLogout),
          content: Text(strings.AppStrings.resetAndLogoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                AppLogger.info('User initiated reset and logout');
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'reset_and_logout');
                final nav = Navigator.of(context);
                final settings = Provider.of<SettingsProvider>(context, listen: false);
                try {
                  AppLogger.info('Starting app reset process...');
                  // Reset in-memory providers first
                  await gameStats.resetStats();
                  AppLogger.info('Game stats reset successfully');
                  if (context.mounted) {
                    await Provider.of<LessonProgressProvider>(context, listen: false).resetAll();
                    AppLogger.info('Lesson progress reset successfully');
                  }

                  // Clear caches and notifications
                  AppLogger.info('Clearing question cache...');
                  await QuestionCacheService().clearCache();
                  AppLogger.info('Question cache cleared');
                  await NotificationService().cancelAllNotifications();
                  AppLogger.info('Notifications cancelled');

                  // Clear all persisted data
                  AppLogger.info('Clearing all persisted data...');
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  AppLogger.info('All persisted data cleared');

                  // Reset the settings provider to initial state
                  await settings.reloadSettings();
                  AppLogger.info('Settings reloaded after reset');
                  
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
              child: Text(strings.AppStrings.resetAndLogout),
            ),
          ],
        );
      },
    );
  }

  Future<void> _launchBugReportEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppUrls.contactEmail,
      queryParameters: {
        'subject': '${strings.AppStrings.appName} error report',
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
          title: Text(strings.AppStrings.emailAddress),
          content: Text(AppUrls.contactEmail),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.AppStrings.ok),
            ),
          ],
        );
      },
    );
  }

  Future<void> _exportStats(BuildContext context) async {
    try {
      final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
      final lessonProgress = Provider.of<LessonProgressProvider>(context, listen: false);
      final settings = Provider.of<SettingsProvider>(context, listen: false);

      // Collect all data
      final data = {
        'gameStats': gameStats.getExportData(),
        'lessonProgress': lessonProgress.getExportData(),
        'settings': settings.getExportData(),
        'version': '1.0', // For future compatibility
      };

      // Serialize to JSON
      final jsonString = json.encode(data);

      // Create hash for tamper-proofing (based on original JSON) - use SHA-1 for shorter hash
      final hash = sha1.convert(utf8.encode(jsonString)).toString();

      // Compress the JSON string
      final compressedBytes = GZipEncoder().encode(utf8.encode(jsonString));

      // Combine hash and compressed data (no version field to save space)
      final exportData = {
        'hash': hash,
        'data': base64Url.encode(compressedBytes!),
      };

      final exportString = base64.encode(utf8.encode(json.encode(exportData)));

      // Navigate to full-screen export screen
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExportStatsScreen(exportString: exportString),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(context, '${strings.AppStrings.failedToExportStats} $e', style: TopSnackBarStyle.error);
      }
    }
  }

  Future<void> _importStats(BuildContext context) async {
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ImportStatsScreen(),
        ),
      );
    }
  }

  void _showSocialMediaDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(strings.AppStrings.followUsOnSocialMedia),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSocialMediaButton(
                context,
                strings.AppStrings.mastodon,
                Icons.alternate_email,
                AppUrls.mastodonUrl,
                colorScheme,
              ),
              const SizedBox(height: 12),
              _buildSocialMediaButton(
                context,
                strings.AppStrings.pixelfed,
                Icons.camera_alt,
                AppUrls.pixelfedUrl,
                colorScheme,
              ),
              const SizedBox(height: 12),
              _buildSocialMediaButton(
                context,
                strings.AppStrings.kwebler,
                Icons.public,
                AppUrls.kweblerUrl,
                colorScheme,
              ),
              const SizedBox(height: 12),
              _buildSocialMediaButton(
                context,
                strings.AppStrings.discord,
                Icons.forum,
                AppUrls.discordUrl,
                colorScheme,
              ),
              const SizedBox(height: 12),
              _buildSocialMediaButton(
                context,
                strings.AppStrings.signal,
                Icons.message,
                AppUrls.signalUrl,
                colorScheme,
              ),
              const SizedBox(height: 12),
              _buildSocialMediaButton(
                context,
                strings.AppStrings.bluesky,
                Icons.cloud,
                AppUrls.blueskyUrl,
                colorScheme,
              ),
              const SizedBox(height: 12),
              _buildSocialMediaButton(
                context,
                strings.AppStrings.nooki,
                Icons.group,
                AppUrls.nookiUrl,
                colorScheme,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.AppStrings.close),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showInviteDialog(BuildContext context) async {
    final TextEditingController yourNameController = TextEditingController();
    final TextEditingController friendNameController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(strings.AppStrings.customizeInvite),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: yourNameController,
                decoration: InputDecoration(
                  labelText: strings.AppStrings.enterYourName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: friendNameController,
                decoration: InputDecoration(
                  labelText: strings.AppStrings.enterFriendName,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                final yourName = yourNameController.text.trim();
                final friendName = friendNameController.text.trim();
                
                // Construct a personalized invite URL with query parameters
                String inviteUrl = 'https://bijbelquiz.app/invite.html';
                
                // Add query parameters for personalization if names were provided
                final Map<String, String> queryParams = {};
                if (yourName.isNotEmpty) {
                  queryParams['yourName'] = yourName;
                }
                if (friendName.isNotEmpty) {
                  queryParams['friendName'] = friendName;
                }
                
                if (queryParams.isNotEmpty) {
                  inviteUrl = Uri.parse(inviteUrl).replace(queryParameters: queryParams).toString();
                }

                // Copy the personalized link to clipboard
                await Clipboard.setData(ClipboardData(text: inviteUrl));
                
                if (context.mounted) {
                  showTopSnackBar(
                    context,
                    strings.AppStrings.inviteLinkCopied,
                    style: TopSnackBarStyle.success,
                  );
                }
                
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(strings.AppStrings.sendInvite),
            ),
          ],
        );
      },
    );
  }

  Future<void> _shareApp(BuildContext context) async {
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.capture(context, 'share_app');
    
    final String inviteUrl = 'https://bijbelquiz.app/i';
    
    try {
      await Clipboard.setData(ClipboardData(text: inviteUrl));
      if (context.mounted) {
        showTopSnackBar(
          context,
          strings.AppStrings.inviteLinkCopied,
          style: TopSnackBarStyle.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(
          context,
          '${strings.AppStrings.errorCopyingLink}${e.toString()}',
          style: TopSnackBarStyle.error,
        );
      }
    }
  }

  Future<void> _shareStats(BuildContext context) async {
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.capture(context, 'share_stats');

    try {
      // Get stats from provider
      final gameStats = Provider.of<GameStatsProvider>(context, listen: false);

      // Calculate total questions and correct percentage
      final totalQuestions = gameStats.score + gameStats.incorrectAnswers;
      final correctPercentage = totalQuestions > 0 ? (gameStats.score / totalQuestions * 100).round() : 0;

      // Create compact stats string (format: score:currentStreak:longestStreak:incorrectAnswers:totalQuestions:correctPercentage)
      final statsString = '${gameStats.score}:${gameStats.currentStreak}:${gameStats.longestStreak}:${gameStats.incorrectAnswers}:${totalQuestions}:${correctPercentage}';

      // Create hash for tamper-proofing (just based on stats data)
      final hash = sha256.convert(utf8.encode(statsString)).toString().substring(0, 16); // Use first 16 chars for shorter URL

      // Create shareable link with compact format
      final baseUrl = 'https://bijbelquiz.app/score.html';
      final Uri shareUrl = Uri.parse(baseUrl).replace(queryParameters: {
        's': statsString, // 's' for stats
        'h': hash,        // 'h' for hash
      });

      // Copy link to clipboard
      await Clipboard.setData(ClipboardData(text: shareUrl.toString()));

      if (context.mounted) {
        showTopSnackBar(
          context,
          strings.AppStrings.statsLinkCopied,
          style: TopSnackBarStyle.success,
        );
      }

    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(
          context,
          '${strings.AppStrings.errorCopyingLink}${e.toString()}',
          style: TopSnackBarStyle.error,
        );
      }
    }
  }



  void _showApiKeyDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(strings.AppStrings.regenerateApiKeyTitle),
          content: Text(strings.AppStrings.regenerateApiKeyMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(strings.AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                await settings.generateNewApiKey();
                Navigator.of(context).pop();
                if (context.mounted) {
                  showTopSnackBar(context, strings.AppStrings.apiKeyGenerated, style: TopSnackBarStyle.success);
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(strings.AppStrings.regenerateApiKey),
            ),
          ],
        );
      },
    );
  }


  /// Format API key for display (show first 6 and last 4 characters)
  String _formatApiKey(String apiKey) {
    if (apiKey.length <= 10) return apiKey;
    return '${apiKey.substring(0, 6)}...${apiKey.substring(apiKey.length - 4)}';
  }

  /// Copy API key to clipboard and show feedback
  Future<void> _copyApiKeyToClipboard(BuildContext context, String apiKey) async {
    try {
      await Clipboard.setData(ClipboardData(text: apiKey));
      if (context.mounted) {
        showTopSnackBar(
          context,
          strings.AppStrings.apiKeyCopied,
          style: TopSnackBarStyle.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(
          context,
          strings.AppStrings.apiKeyCopyFailed,
          style: TopSnackBarStyle.error,
        );
      }
    }
  }

  Widget _buildProfileManagementGroup(BuildContext context, SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen, bool isDesktop) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profiles = profileProvider.profiles;
    final activeProfile = profileProvider.activeProfile;

    return _buildSettingsGroup(
      context,
      settings,
      colorScheme,
      isSmallScreen,
      isDesktop,
      title: 'Profiles',
      children: [
        _buildSettingItem(
          context,
          settings,
          colorScheme,
          isSmallScreen,
          isDesktop,
          title: 'Current Profile',
          subtitle: 'Switch between profiles',
          icon: Icons.person,
          child: DropdownButton<String>(
            value: activeProfile?.id,
            items: profiles.map((profile) {
              return DropdownMenuItem(
                value: profile.id,
                child: Text(profile.name),
              );
            }).toList(),
            onChanged: (String? profileId) {
              if (profileId != null) {
                profileProvider.setActiveProfile(profileId);
              }
            },
          ),
        ),
        _buildActionButton(
          context,
          settings,
          colorScheme,
          isSmallScreen,
          isDesktop,
          onPressed: () => _showAddProfileDialog(context),
          label: 'Add Profile',
          icon: Icons.add,
        ),
        _buildActionButton(
          context,
          settings,
          colorScheme,
          isSmallScreen,
          isDesktop,
          onPressed: () => _showEditProfileDialog(context, activeProfile),
          label: 'Edit Profile',
          icon: Icons.edit,
        ),
      ],
    );
  }

  void _showAddProfileDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Profile'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Profile Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  final profile = UserProfile(name: name);
                  Provider.of<ProfileProvider>(context, listen: false)
                      .addProfile(profile);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProfileDialog(BuildContext context, UserProfile? profile) {
    if (profile == null) return;

    final TextEditingController nameController =
        TextEditingController(text: profile.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Profile Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text;
                if (name.isNotEmpty) {
                  profile.name = name;
                  Provider.of<ProfileProvider>(context, listen: false)
                      .updateProfile(profile);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialMediaButton(BuildContext context, String platform, IconData icon, String url, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () async {
            final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

            Provider.of<AnalyticsService>(context, listen: false).capture(context, 'follow_social_media', properties: {'platform': platform});
            final Uri uri = Uri.parse(url);
            if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  showTopSnackBar(context, strings.AppStrings.couldNotOpenPlatform.replaceAll('{platform}', platform), style: TopSnackBarStyle.error);
                }
              });
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    platform,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_new,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

String _getThemeDropdownValue(SettingsProvider settings) {
  final custom = settings.selectedCustomThemeKey;
  if (custom != null) {
    // Check if it's an AI theme
    if (settings.hasAITheme(custom)) {
      return custom;
    }
    // Check if the theme exists in the centralized theme manager
    final themeDef = ThemeManager().getThemeDefinition(custom);
    if (themeDef != null) {
      return custom;
    }
    // For backward compatibility, still check for unlocked themes
    if (settings.unlockedThemes.contains(custom) || 
        custom == 'grey') { // Grey theme is always available
      return custom;
    }
  }
  // fallback to themeMode
  final mode = settings.themeMode;
  if (mode == ThemeMode.light || mode == ThemeMode.dark || mode == ThemeMode.system) {
    return mode.name;
  }
  // fallback to light if something is wrong
  return ThemeMode.light.name;
}

/// Full-screen screen for exporting stats
class ExportStatsScreen extends StatelessWidget {
  final String exportString;

  const ExportStatsScreen({super.key, required this.exportString});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.exportStatsTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(strings.AppStrings.exportStatsMessage),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    exportString,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: exportString));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(strings.AppStrings.codeCopied)),
                    );
                  },
                  child: Text(strings.AppStrings.copyCode),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(strings.AppStrings.close),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen screen for importing stats
class ImportStatsScreen extends StatefulWidget {
  const ImportStatsScreen({super.key});

  @override
  State<ImportStatsScreen> createState() => _ImportStatsScreenState();
}

class _ImportStatsScreenState extends State<ImportStatsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.AppStrings.importStatsTitle),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(strings.AppStrings.importStatsMessage),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: strings.AppStrings.importStatsHint,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(strings.AppStrings.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final importString = _controller.text.trim();
                      if (importString.isEmpty) {
                        showTopSnackBar(context, strings.AppStrings.pleaseEnterValidString, style: TopSnackBarStyle.error);
                        return;
                      }

                      final safeContext = context;
                      
                      try {
                        // Decode and verify
                        final decoded = utf8.decode(base64.decode(importString));
                        final importData = json.decode(decoded) as Map<String, dynamic>;

                        final hash = importData['hash'] as String;
                        final dataString = importData['data'] as String;
                        String jsonString;

                        // Detect format based on hash length: SHA-1 (40 chars) for new, SHA-256 (64 chars) for old
                        if (hash.length == 40) {
                          // New compressed format with SHA-1
                          try {
                            final compressedData = base64Url.decode(dataString);
                            jsonString = utf8.decode(GZipDecoder().decodeBytes(compressedData));
                            // Verify with SHA-1
                            final computedHash = sha1.convert(utf8.encode(jsonString)).toString();
                            if (computedHash != hash) {
                              if (!safeContext.mounted) return;
                              showTopSnackBar(safeContext, strings.AppStrings.invalidOrTamperedData, style: TopSnackBarStyle.error);
                              return;
                            }
                          } catch (e) {
                            if (!safeContext.mounted) return;
                            showTopSnackBar(safeContext, strings.AppStrings.invalidOrTamperedData, style: TopSnackBarStyle.error);
                            return;
                          }
                        } else {
                          // Old uncompressed format with SHA-256
                          jsonString = dataString;
                          // Verify with SHA-256
                          final computedHash = sha256.convert(utf8.encode(jsonString)).toString();
                          if (computedHash != hash) {
                            if (!safeContext.mounted) return;
                            showTopSnackBar(safeContext, strings.AppStrings.invalidOrTamperedData, style: TopSnackBarStyle.error);
                            return;
                          }
                        }

                        // Parse data
                        final data = json.decode(jsonString) as Map<String, dynamic>;

                        // Load data into providers
                        final gameStats = Provider.of<GameStatsProvider>(safeContext, listen: false);
                        final lessonProgress = Provider.of<LessonProgressProvider>(safeContext, listen: false);
                        final settings = Provider.of<SettingsProvider>(safeContext, listen: false);

                        // Load game stats
                        final gameStatsData = data['gameStats'] as Map<String, dynamic>;
                        await gameStats.loadImportData(gameStatsData);

                        // Load lesson progress
                        final lessonData = data['lessonProgress'] as Map<String, dynamic>;
                        await lessonProgress.loadImportData(lessonData);

                        // Load settings
                        final settingsData = data['settings'] as Map<String, dynamic>;
                        await settings.loadImportData(settingsData);

                        // Use a global key or other mechanism to avoid context issues
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (safeContext.mounted) {
                            Navigator.of(safeContext).pop();
                            if (safeContext.mounted) {
                              showTopSnackBar(safeContext, strings.AppStrings.statsImportedSuccessfully, style: TopSnackBarStyle.success);
                            }
                          }
                        });
                      } catch (e) {
                        if (!mounted) return;
                        showTopSnackBar(safeContext, '${strings.AppStrings.failedToImportStats} $e', style: TopSnackBarStyle.error);
                      }
                    },
                    child: Text(strings.AppStrings.importButton),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
