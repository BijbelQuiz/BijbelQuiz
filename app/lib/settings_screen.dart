import 'package:bijbelquiz/services/analytics_service.dart';
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
import 'services/api_service.dart';
import 'widgets/top_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
import 'services/question_cache_service.dart';
import 'services/connection_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/lesson_select_screen.dart';
import 'widgets/quiz_skeleton.dart';
import 'constants/urls.dart';
import 'l10n/strings_nl.dart' as strings;
import 'services/logger.dart';
import 'utils/bijbelquiz_gen_utils.dart';
import 'screens/bijbelquiz_gen_screen.dart';
import 'theme/theme_manager.dart';
import 'widgets/bug_report_widget.dart';

/// Clean, simple, and responsive settings screen
class SettingsScreen extends StatefulWidget {
  final VoidCallback? onOpenGuide;
  const SettingsScreen({super.key, this.onOpenGuide});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    AppLogger.info('SettingsScreen initialized');
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.screen(context, 'SettingsScreen');
    analyticsService.trackFeatureStart(context, AnalyticsService.featureSettings);
    
    NotificationService.onError = (message) {
      AppLogger.error('Notification service error: $message');
      if (mounted) {
        showTopSnackBar(context, message, style: TopSnackBarStyle.error);
      }
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        if (context.mounted) {
          showTopSnackBar(context, strings.AppStrings.couldNotOpenUpdatePage, style: TopSnackBarStyle.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(context, '${strings.AppStrings.errorOpeningUpdatePage}${e.toString()}', style: TopSnackBarStyle.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;
    final isTablet = screenWidth > 600 && screenWidth <= 800;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.settings_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strings.AppStrings.settings,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: settings.isLoading
          ? _buildLoadingState(isDesktop, isTablet, isSmallScreen)
          : settings.error != null
              ? _buildErrorState(settings, colorScheme)
              : _buildMainContent(context, settings, colorScheme, isDesktop, isTablet, isSmallScreen),
    );
  }

  Widget _buildLoadingState(bool isDesktop, bool isTablet, bool isSmallPhone) {
    return Center(
      child: QuizSkeleton(
        isDesktop: isDesktop,
        isTablet: isTablet,
        isSmallPhone: isSmallPhone,
      ),
    );
  }

  Widget _buildErrorState(SettingsProvider settings, ColorScheme colorScheme) {
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

  Widget _buildMainContent(BuildContext context, SettingsProvider settings, ColorScheme colorScheme, bool isDesktop, bool isTablet, bool isSmallScreen) {
    return ResponsiveLayout(
      isDesktop: isDesktop,
      isTablet: isTablet,
      child: Column(
        children: [
          // Search Bar
          _buildSearchBar(context, colorScheme, isSmallScreen),
          
          // Settings Content
          Expanded(
            child: _buildSettingsList(context, settings, colorScheme, isSmallScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ColorScheme colorScheme, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: strings.AppStrings.searchSettings,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
            : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest,
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen) {
    final searchQuery = _searchController.text.toLowerCase().trim();
    
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 24.0),
      children: [
        // Appearance Section
        _buildSection(
          context,
          colorScheme,
          isSmallScreen,
          title: strings.AppStrings.display,
          icon: Icons.palette_rounded,
          items: [
            _SettingItem(
              title: strings.AppStrings.theme,
              subtitle: strings.AppStrings.chooseTheme,
              child: _buildThemeDropdown(settings, colorScheme, isSmallScreen),
            ),
            _SettingItem(
              title: strings.AppStrings.showNavigationLabels,
              subtitle: strings.AppStrings.showNavigationLabelsDesc,
              child: _buildSwitch(
                settings.showNavigationLabels,
                (value) => _updateSetting(settings, 'toggle_navigation_labels', () => settings.setShowNavigationLabels(value)),
                colorScheme,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.lessonLayoutSettings,
              subtitle: strings.AppStrings.chooseLessonLayoutDesc,
              child: _buildLayoutDropdown(settings, colorScheme, isSmallScreen),
            ),
            _SettingItem(
              title: strings.AppStrings.colorfulMode,
              subtitle: strings.AppStrings.colorfulModeDesc,
              child: _buildSwitch(
                settings.colorfulMode,
                (value) => _updateSetting(settings, 'toggle_colorful_mode', () => settings.setColorfulMode(value)),
                colorScheme,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.hidePopup,
              subtitle: strings.AppStrings.hidePopupDesc,
              child: _buildSwitch(
                settings.hidePromoCard,
                (value) => _updateSetting(settings, 'toggle_hide_promo_card', () => settings.setHidePromoCard(value)),
                colorScheme,
              ),
            ),
          ],
          searchQuery: searchQuery,
        ),

        // Game Section
        _buildSection(
          context,
          colorScheme,
          isSmallScreen,
          title: strings.AppStrings.gameSettings,
          icon: Icons.games_rounded,
          items: [
            _SettingItem(
              title: strings.AppStrings.gameSpeed,
              subtitle: strings.AppStrings.chooseGameSpeed,
              child: _buildGameSpeedDropdown(settings, colorScheme, isSmallScreen),
            ),
            _SettingItem(
              title: strings.AppStrings.muteSoundEffects,
              subtitle: strings.AppStrings.muteSoundEffectsDesc,
              child: _buildSwitch(
                settings.mute,
                (value) => _updateSetting(settings, 'toggle_mute', () => settings.setMute(value)),
                colorScheme,
              ),
            ),
            if (!(kIsWeb || Platform.isLinux))
              _SettingItem(
                title: strings.AppStrings.motivationNotifications,
                subtitle: strings.AppStrings.motivationNotificationsDesc,
                child: _buildSwitch(
                  settings.notificationEnabled,
                  (value) => _toggleNotifications(context, settings, value),
                  colorScheme,
                ),
              ),
          ],
          searchQuery: searchQuery,
        ),

        // Privacy Section
        _buildSection(
          context,
          colorScheme,
          isSmallScreen,
          title: strings.AppStrings.privacyAndAnalytics,
          icon: Icons.privacy_tip_rounded,
          items: [
            _SettingItem(
              title: strings.AppStrings.analytics,
              subtitle: strings.AppStrings.analyticsDescription,
              child: _buildSwitch(
                settings.analyticsEnabled,
                (value) => _updateAnalyticsSetting(settings, value),
                colorScheme,
              ),
            ),
            if (settings.apiEnabled) ...[
              _SettingItem(
                title: strings.AppStrings.apiKey,
                subtitle: settings.apiKey.isEmpty ? strings.AppStrings.generateApiKey : _formatApiKey(settings.apiKey),
                child: _buildApiKeyControls(context, settings, colorScheme),
              ),
              _SettingItem(
                title: strings.AppStrings.apiPort,
                subtitle: '${strings.AppStrings.apiPortDesc} (${settings.apiPort})',
                child: _buildApiPortControl(settings),
              ),
              _SettingItem(
                title: strings.AppStrings.apiStatus,
                subtitle: strings.AppStrings.apiStatusDesc,
                child: _buildApiStatusIndicator(settings),
              ),
            ],
          ],
          searchQuery: searchQuery,
        ),

        // Actions Section
        _buildSection(
          context,
          colorScheme,
          isSmallScreen,
          title: strings.AppStrings.actions,
          icon: Icons.build_rounded,
          items: [
            _SettingItem(
              title: strings.AppStrings.donateButton,
              subtitle: strings.AppStrings.supportUsTitle,
              onTap: () => _showDonateDialog(context),
              child: _buildActionButton(
                context,
                icon: Icons.favorite,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.showIntroduction,
              subtitle: strings.AppStrings.showIntroductionDesc,
              onTap: () => _showIntroduction(context),
              child: _buildActionButton(
                context,
                icon: Icons.help_outline,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.exportStats,
              subtitle: strings.AppStrings.exportStatsDesc,
              onTap: () => _exportStats(context),
              child: _buildActionButton(
                context,
                icon: Icons.download,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.importStats,
              subtitle: strings.AppStrings.importStatsDesc,
              onTap: () => _importStats(context),
              child: _buildActionButton(
                context,
                icon: Icons.upload,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.clearQuestionCache,
              subtitle: strings.AppStrings.clearQuestionCacheDesc,
              onTap: () => _clearCache(context),
              child: _buildActionButton(
                context,
                icon: Icons.delete_sweep,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.followOnSocialMedia,
              subtitle: strings.AppStrings.followOnSocialMediaDesc,
              onTap: () => _showSocialMediaDialog(context),
              child: _buildActionButton(
                context,
                icon: Icons.share,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.inviteFriend,
              subtitle: strings.AppStrings.inviteFriendDesc,
              onTap: () => _showInviteDialog(context),
              child: _buildActionButton(
                context,
                icon: Icons.person_add,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.shareYourStats,
              subtitle: strings.AppStrings.copyStatsLinkToClipboard,
              onTap: () => _shareStats(context),
              child: _buildActionButton(
                context,
                icon: Icons.bar_chart,
              ),
            ),
            if (BijbelQuizGenPeriod.isGenPeriod() || kDebugMode)
              _SettingItem(
                title: strings.AppStrings.bijbelquizGenTitle,
                subtitle: '${strings.AppStrings.bijbelquizGenSubtitle}${BijbelQuizGenPeriod.getStatsYear()}',
                onTap: () => _showBijbelQuizGen(context),
                child: _buildActionButton(
                  context,
                  icon: Icons.auto_awesome,
                ),
              ),
            _SettingItem(
              title: strings.AppStrings.resetAndLogout,
              subtitle: strings.AppStrings.resetAndLogoutDesc,
              onTap: () => _showResetAndLogoutDialog(context, settings),
              child: _buildActionButton(
                context,
                icon: Icons.logout,
              ),
            ),
          ],
          searchQuery: searchQuery,
        ),

        // About Section
        _buildSection(
          context,
          colorScheme,
          isSmallScreen,
          title: strings.AppStrings.about,
          icon: Icons.info_rounded,
          items: [
            _SettingItem(
              title: strings.AppStrings.serverStatus,
              subtitle: strings.AppStrings.checkServiceStatus,
              child: IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: _openStatusPage,
                tooltip: strings.AppStrings.openStatusPage,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (!(kIsWeb || Platform.isAndroid))
              _SettingItem(
                title: strings.AppStrings.checkForUpdates,
                subtitle: strings.AppStrings.checkForUpdatesDescription,
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _checkForUpdates(context, settings),
                  tooltip: strings.AppStrings.checkForUpdatesTooltip,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            _SettingItem(
              title: strings.AppStrings.privacyPolicy,
              subtitle: strings.AppStrings.privacyPolicyDescription,
              child: IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () => _openPrivacyPolicy(context),
                tooltip: strings.AppStrings.openPrivacyPolicyTooltip,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            _SettingItem(
              title: strings.AppStrings.bugReport,
              subtitle: strings.AppStrings.bugReportDesc,
              child: BugReportWidget(),
            ),
          ],
          searchQuery: searchQuery,
        ),

        // Version Info
        const SizedBox(height: 24),
        _buildVersionInfo(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSection(BuildContext context, ColorScheme colorScheme, bool isSmallScreen, {
    required String title,
    required IconData icon,
    required List<_SettingItem> items,
    String? searchQuery,
  }) {
    final filteredItems = searchQuery == null || searchQuery.isEmpty 
        ? items 
        : items.where((item) => 
            item.title.toLowerCase().contains(searchQuery) ||
            (item.subtitle?.toLowerCase().contains(searchQuery) ?? false)
          ).toList();

    if (filteredItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: isSmallScreen ? 4 : 8,
            top: 24,
            bottom: 12,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: filteredItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == filteredItems.length - 1;
              
              return Column(
                children: [
                  _buildSettingRow(context, item, colorScheme),
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outline.withValues(alpha: 0.12),
                      indent: 56,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow(BuildContext context, _SettingItem item, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: item.onTap != null
          ? InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: item.child,
                    ),
                  ),
                ],
              ),
            )
          : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.subtitle!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: item.child,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildThemeDropdown(SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen) {
    final Map<String, String> themeDisplayNames = <String, String>{};
    
    themeDisplayNames[ThemeMode.light.name] = strings.AppStrings.lightTheme;
    themeDisplayNames[ThemeMode.system.name] = strings.AppStrings.systemTheme;
    themeDisplayNames[ThemeMode.dark.name] = strings.AppStrings.darkTheme;
    
    final availableThemes = ThemeManager().getAvailableThemes();
    for (final entry in availableThemes.entries) {
      if (entry.key == 'grey' || settings.unlockedThemes.contains(entry.key)) {
        themeDisplayNames[entry.key] = entry.value.name;
      }
    }

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
          child: Text(entry.value, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (String? value) {
        if (value != null) {
          _changeTheme(settings, value);
        }
      },
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: isSmallScreen ? 12 : 14,
      ),
      dropdownColor: colorScheme.surfaceContainerHighest,
      isExpanded: true,
    );
  }

  Widget _buildLayoutDropdown(SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen) {
    return DropdownButton<String>(
      value: settings.layoutType,
      items: [
        DropdownMenuItem(
          value: SettingsProvider.layoutGrid,
          child: Text(strings.AppStrings.grid, overflow: TextOverflow.ellipsis),
        ),
        DropdownMenuItem(
          value: SettingsProvider.layoutList,
          child: Text(strings.AppStrings.list, overflow: TextOverflow.ellipsis),
        ),
        DropdownMenuItem(
          value: SettingsProvider.layoutCompactGrid,
          child: Text(strings.AppStrings.compactGrid, overflow: TextOverflow.ellipsis),
        ),
      ],
      onChanged: (String? value) {
        if (value != null) {
          _updateSetting(settings, 'change_layout_type', () => settings.setLayoutType(value));
        }
      },
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: isSmallScreen ? 12 : 14,
      ),
      dropdownColor: colorScheme.surfaceContainerHighest,
      isExpanded: true,
    );
  }

  Widget _buildGameSpeedDropdown(SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen) {
    return DropdownButton<String>(
      value: settings.gameSpeed,
      items: [
        DropdownMenuItem(
          value: 'slow',
          child: Text(strings.AppStrings.slow, overflow: TextOverflow.ellipsis),
        ),
        DropdownMenuItem(
          value: 'medium',
          child: Text(strings.AppStrings.medium, overflow: TextOverflow.ellipsis),
        ),
        DropdownMenuItem(
          value: 'fast',
          child: Text(strings.AppStrings.fast, overflow: TextOverflow.ellipsis),
        ),
      ],
      onChanged: (String? value) {
        if (value != null) {
          _updateSetting(settings, 'change_game_speed', () => settings.setGameSpeed(value));
        }
      },
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: isSmallScreen ? 12 : 14,
      ),
      dropdownColor: colorScheme.surfaceContainerHighest,
      isExpanded: true,
    );
  }

  Widget _buildSwitch(bool value, Function(bool) onChanged, ColorScheme colorScheme) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colorScheme.primary,
    );
  }

  Widget _buildActionButton(BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      color: color ?? colorScheme.primary,
      tooltip: null,
    );
  }

  Widget _buildApiKeyControls(BuildContext context, SettingsProvider settings, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (settings.apiKey.isNotEmpty) ...[
          IconButton(
            onPressed: () => _copyApiKeyToClipboard(context, settings.apiKey),
            icon: const Icon(Icons.copy, size: 20),
            tooltip: strings.AppStrings.copyApiKey,
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              foregroundColor: colorScheme.primary,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: () async {
              if (settings.apiKey.isEmpty) {
                await settings.generateNewApiKey();
              } else {
                _showApiKeyDialog(context, settings);
              }
            },
            icon: const Icon(Icons.refresh, size: 20),
            tooltip: strings.AppStrings.regenerateApiKey,
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              foregroundColor: colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildApiPortControl(SettingsProvider settings) {
    return SizedBox(
      width: 80,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
        controller: TextEditingController(text: settings.apiPort.toString()),
        onSubmitted: (value) {
          final port = int.tryParse(value);
          if (port != null && port >= 1024 && port <= 65535) {
            settings.setApiPort(port);
          }
        },
      ),
    );
  }

  Widget _buildApiStatusIndicator(SettingsProvider settings) {
    return Consumer<ApiService?>(
      builder: (context, apiService, child) {
        final isApiEnabled = settings.apiEnabled;
        final isRunning = apiService?.isRunning ?? false;

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
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
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
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVersionInfo() {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version ?? '';
        return Column(
          children: [
            Text(
              strings.AppStrings.copyright,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${strings.AppStrings.version} $version',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper methods
  void _changeTheme(SettingsProvider settings, String value) {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'change_theme', properties: {'theme': value});
    analytics.trackFeatureSuccess(context, AnalyticsService.featureThemeSelection, additionalProperties: {
      'theme': value,
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
      if (settings.hasAITheme(value)) {
        settings.setCustomTheme(value);
        settings.setThemeMode(ThemeMode.light);
      } else {
        final themeDef = ThemeManager().getThemeDefinition(value);
        if (themeDef != null) {
          settings.setCustomTheme(value);
          settings.setThemeMode(themeDef.type.toLowerCase() == 'dark' ? ThemeMode.dark : ThemeMode.light);
        } else {
          settings.setCustomTheme(value);
          settings.setThemeMode(ThemeMode.light);
        }
      }
    }
  }

  void _updateSetting(SettingsProvider settings, String action, VoidCallback updateFunction) {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, action);
    analytics.trackFeatureSuccess(context, AnalyticsService.featureSettings);
    updateFunction();
  }

  void _updateAnalyticsSetting(SettingsProvider settings, bool value) {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.trackFeatureSuccess(context, AnalyticsService.featureAnalyticsSettings, additionalProperties: {
      'enabled': value,
    });
    settings.setAnalyticsEnabled(value);
  }

  Future<void> _toggleNotifications(BuildContext context, SettingsProvider settings, bool value) async {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'toggle_notifications', properties: {'enabled': value});
    analytics.trackFeatureSuccess(context, AnalyticsService.featureSettings, additionalProperties: {
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
  }

  // Dialog and navigation methods (simplified implementations)
  void _showDonateDialog(BuildContext context) async {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.trackFeatureSuccess(context, AnalyticsService.featureDonationSystem);
    analytics.capture(context, 'donate');
    
    final Uri url = Uri.parse(AppUrls.donateUrl);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.markAsDonated();
    
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showTopSnackBar(context, strings.AppStrings.couldNotOpenDonationPage, style: TopSnackBarStyle.error);
      }
    }
  }

  void _showIntroduction(BuildContext context) {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'show_introduction');
    
    if (widget.onOpenGuide != null) widget.onOpenGuide!();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GuideScreen(),
      ),
    );
  }

  void _exportStats(BuildContext context) async {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'export_stats');
    // Simplified - navigate to export screen
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ExportStatsScreen(exportString: 'mock_export'),
        ),
      );
    }
  }

  void _importStats(BuildContext context) async {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'import_stats');
    
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ImportStatsScreen(),
        ),
      );
    }
  }

  void _clearCache(BuildContext context) async {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'clear_question_cache');
    await QuestionCacheService(ConnectionService()).clearCache();
    if (context.mounted) {
      showTopSnackBar(context, strings.AppStrings.cacheCleared, style: TopSnackBarStyle.success);
    }
  }

  void _showSocialMediaDialog(BuildContext context) {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'show_social_media_dialog');
    
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(strings.AppStrings.followUsOnSocialMedia),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSocialMediaButton(context, strings.AppStrings.mastodon, Icons.alternate_email, AppUrls.mastodonUrl, colorScheme),
                const SizedBox(height: 8),
                _buildSocialMediaButton(context, strings.AppStrings.pixelfed, Icons.camera_alt, AppUrls.pixelfedUrl, colorScheme),
                const SizedBox(height: 8),
                _buildSocialMediaButton(context, strings.AppStrings.discord, Icons.forum, AppUrls.discordUrl, colorScheme),
                const SizedBox(height: 8),
                _buildSocialMediaButton(context, strings.AppStrings.signal, Icons.message, AppUrls.signalUrl, colorScheme),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.AppStrings.close),
            ),
          ],
        );
      },
    );
  }

  void _showInviteDialog(BuildContext context) {
    final TextEditingController yourNameController = TextEditingController();
    final TextEditingController friendNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                final yourName = yourNameController.text.trim();
                final friendName = friendNameController.text.trim();
                
                String inviteUrl = 'https://bijbelquiz.app/invite.html';
                final Map<String, String> queryParams = {};
                if (yourName.isNotEmpty) queryParams['yourName'] = yourName;
                if (friendName.isNotEmpty) queryParams['friendName'] = friendName;
                
                if (queryParams.isNotEmpty) {
                  inviteUrl = Uri.parse(inviteUrl).replace(queryParameters: queryParams).toString();
                }

                await Clipboard.setData(ClipboardData(text: inviteUrl));
                
                if (dialogContext.mounted) {
                  showTopSnackBar(dialogContext, strings.AppStrings.inviteLinkCopied, style: TopSnackBarStyle.success);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(strings.AppStrings.sendInvite),
            ),
          ],
        );
      },
    );
  }

  void _shareStats(BuildContext context) async {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'share_stats');
    
    try {
      await Clipboard.setData(ClipboardData(text: 'https://bijbelquiz.app/score.html'));
      if (context.mounted) {
        showTopSnackBar(context, strings.AppStrings.statsLinkCopied, style: TopSnackBarStyle.success);
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(context, 'Error copying link: $e', style: TopSnackBarStyle.error);
      }
    }
  }

  void _showBijbelQuizGen(BuildContext context) {
    final analytics = Provider.of<AnalyticsService>(context, listen: false);
    analytics.capture(context, 'replay_bijbelquiz_gen');
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const BijbelQuizGenScreen(),
        ),
      );
    }
  }

  Future<void> _showResetAndLogoutDialog(BuildContext context, SettingsProvider settings) async {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(strings.AppStrings.resetAndLogout),
          content: Text(strings.AppStrings.resetAndLogoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                AppLogger.info('User initiated reset and logout');
                Provider.of<AnalyticsService>(context, listen: false).capture(context, 'reset_and_logout');
                final nav = Navigator.of(dialogContext);
                try {
                  await gameStats.resetStats();
                  if (context.mounted) {
                    await Provider.of<LessonProgressProvider>(context, listen: false).resetAll();
                  }
                  await QuestionCacheService(ConnectionService()).clearCache();
                  await NotificationService().cancelAllNotifications();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  await settings.reloadSettings();
                  await settings.resetGuideStatus();
                  await settings.resetCheckForUpdateStatus();
                } catch (_) {
                  // ignore errors
                }

                if (!dialogContext.mounted) return;
                nav.pop();
                nav.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const LessonSelectScreen(),
                  ),
                  (route) => false,
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              child: Text(strings.AppStrings.resetAndLogout),
            ),
          ],
        );
      },
    );
  }

  void _openPrivacyPolicy(BuildContext context) async {
    final Uri url = Uri.parse(AppUrls.privacyUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showTopSnackBar(context, strings.AppStrings.couldNotOpenPrivacyPolicy, style: TopSnackBarStyle.error);
      }
    }
  }

  String _formatApiKey(String apiKey) {
    if (apiKey.length <= 10) return apiKey;
    return '${apiKey.substring(0, 6)}...${apiKey.substring(apiKey.length - 4)}';
  }

  Future<void> _copyApiKeyToClipboard(BuildContext context, String apiKey) async {
    try {
      await Clipboard.setData(ClipboardData(text: apiKey));
      if (context.mounted) {
        showTopSnackBar(context, strings.AppStrings.apiKeyCopied, style: TopSnackBarStyle.success);
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(context, strings.AppStrings.apiKeyCopyFailed, style: TopSnackBarStyle.error);
      }
    }
  }

  void _showApiKeyDialog(BuildContext context, SettingsProvider settings) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(strings.AppStrings.regenerateApiKeyTitle),
          content: Text(strings.AppStrings.regenerateApiKeyMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(strings.AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                await settings.generateNewApiKey();
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                  showTopSnackBar(dialogContext, strings.AppStrings.apiKeyGenerated, style: TopSnackBarStyle.success);
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              child: Text(strings.AppStrings.regenerateApiKey),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialMediaButton(BuildContext context, String platform, IconData icon, String url, ColorScheme colorScheme) {
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(platform),
      trailing: const Icon(Icons.open_in_new, size: 16),
      onTap: () async {
        final analytics = Provider.of<AnalyticsService>(context, listen: false);
        analytics.capture(context, 'follow_social_media', properties: {'platform': platform});
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          if (context.mounted) {
            showTopSnackBar(context, strings.AppStrings.couldNotOpenPlatform.replaceAll('{platform}', platform), style: TopSnackBarStyle.error);
          }
        }
      },
    );
  }
}

// Supporting classes
class _SettingItem {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget child;

  const _SettingItem({
    required this.title,
    this.subtitle,
    this.onTap,
    required this.child,
  });
}

class ResponsiveLayout extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  final Widget child;

  const ResponsiveLayout({
    super.key,
    required this.isDesktop,
    required this.isTablet,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: child,
        ),
      );
    } else if (isTablet) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: child,
        ),
      );
    }
    return child;
  }
}

String _getThemeDropdownValue(SettingsProvider settings) {
  final custom = settings.selectedCustomThemeKey;
  if (custom != null) {
    if (settings.hasAITheme(custom)) {
      return custom;
    }
    final themeDef = ThemeManager().getThemeDefinition(custom);
    if (themeDef != null) {
      return custom;
    }
    if (settings.unlockedThemes.contains(custom) || custom == 'grey' || custom == 'christmas') {
      return custom;
    }
  }
  final mode = settings.themeMode;
  if (mode == ThemeMode.light || mode == ThemeMode.dark || mode == ThemeMode.system) {
    return mode.name;
  }
  return ThemeMode.light.name;
}

// Simplified export/import screens
class ExportStatsScreen extends StatelessWidget {
  final String exportString;

  const ExportStatsScreen({super.key, required this.exportString});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(strings.AppStrings.exportStatsTitle)),
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
                  child: SelectableText(exportString),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      appBar: AppBar(title: Text(strings.AppStrings.importStatsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                    onPressed: () {
                      if (context.mounted) {
                        Navigator.pop(context);
                        showTopSnackBar(context, strings.AppStrings.statsImportedSuccessfully, style: TopSnackBarStyle.success);
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