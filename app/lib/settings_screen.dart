import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:bijbelquiz/screens/local_api_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'providers/game_stats_provider.dart';
import 'providers/lesson_progress_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/guide_screen.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'widgets/top_snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
import 'services/question_cache_service.dart';
import 'services/connection_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/lesson_select_screen.dart';
import 'widgets/quiz_skeleton.dart';
import 'constants/urls.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openStatusPage() async {
    final Uri url = Uri.parse(AppUrls.statusPageUrl);
    if (!await launchUrl(url)) {
      if (mounted) {
        showTopSnackBar(
            context, AppLocalizations.of(context)!.couldNotOpenStatusPage,
            style: TopSnackBarStyle.error);
      }
    }
  }

  Future<void> _checkForUpdates(
      BuildContext context, SettingsProvider settings) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version;
      final platform = kIsWeb ? 'web' : Platform.operatingSystem.toLowerCase();
      final url =
          Uri.parse('${AppUrls.updateUrl}?version=$version&platform=$platform');

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          showTopSnackBar(
              context, AppLocalizations.of(context)!.couldNotOpenUpdatePage,
              style: TopSnackBarStyle.error);
        }
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(context,
            '${AppLocalizations.of(context)!.errorOpeningUpdatePage}${e.toString()}',
            style: TopSnackBarStyle.error);
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
              AppLocalizations.of(context)!.settings,
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
              : _buildMainContent(context, settings, colorScheme, isDesktop,
                  isTablet, isSmallScreen),
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
          Text(settings.error!,
              style: TextStyle(color: colorScheme.error),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              settings.reloadSettings();
            },
            icon: Icon(Icons.refresh, color: colorScheme.onPrimary),
            label: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context,
      SettingsProvider settings,
      ColorScheme colorScheme,
      bool isDesktop,
      bool isTablet,
      bool isSmallScreen) {
    return ResponsiveLayout(
      isDesktop: isDesktop,
      isTablet: isTablet,
      child: Column(
        children: [
          // Search Bar
          _buildSearchBar(context, colorScheme, isSmallScreen),

          // Settings Content
          Expanded(
            child: _buildSettingsList(
                context, settings, colorScheme, isSmallScreen),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
      BuildContext context, ColorScheme colorScheme, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchSettings,
          labelText: AppLocalizations.of(context)!.searchSettings,
          prefixIcon: Semantics(
            label: AppLocalizations.of(context)!.searchSettings,
            excludeSemantics: true,
            child: Icon(Icons.search,
                color: colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? Semantics(
                  button: true,
                  label: AppLocalizations.of(context)!.clearSearch,
                  child: IconButton(
                    icon: Icon(Icons.clear,
                        color: colorScheme.onSurface.withValues(alpha: 0.6)),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {});
                    },
                  ),
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

  Widget _buildSettingsList(BuildContext context, SettingsProvider settings,
      ColorScheme colorScheme, bool isSmallScreen) {
    final searchQuery = _searchController.text.toLowerCase().trim();

    // Note: Export functionality is always enabled for JSON export

    final allItems = <_SettingItem>[
      // Bug report
      _SettingItem(
        title: AppLocalizations.of(context)!.bugReport,
        subtitle: AppLocalizations.of(context)!.bugReportDesc,
        child: BugReportWidget(),
      ),
      // Appearance
      _SettingItem(
        title: AppLocalizations.of(context)!.language,
        subtitle: settings.language == 'nl' ? 'Nederlands' : 'English',
        child: _buildLanguageDropdown(settings, colorScheme, isSmallScreen),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.theme,
        subtitle: AppLocalizations.of(context)!.chooseTheme,
        child: _buildThemeDropdown(settings, colorScheme, isSmallScreen),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.showNavigationLabels,
        subtitle: AppLocalizations.of(context)!.showNavigationLabelsDesc,
        child: _buildSwitch(
          settings.showNavigationLabels,
          (value) => _updateSetting(settings, 'toggle_navigation_labels',
              () => settings.setShowNavigationLabels(value)),
          colorScheme,
        ),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.lessonLayoutSettings,
        subtitle: AppLocalizations.of(context)!.chooseLessonLayoutDesc,
        child: _buildLayoutDropdown(settings, colorScheme, isSmallScreen),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.colorfulMode,
        subtitle: AppLocalizations.of(context)!.colorfulModeDesc,
        child: _buildSwitch(
          settings.colorfulMode,
          (value) => _updateSetting(settings, 'toggle_colorful_mode',
              () => settings.setColorfulMode(value)),
          colorScheme,
        ),
      ),
      // Game
      _SettingItem(
        title: AppLocalizations.of(context)!.gameSpeed,
        subtitle: AppLocalizations.of(context)!.chooseGameSpeed,
        child: _buildGameSpeedDropdown(settings, colorScheme, isSmallScreen),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.muteSoundEffects,
        subtitle: AppLocalizations.of(context)!.muteSoundEffectsDesc,
        child: _buildSwitch(
          settings.mute,
          (value) => _updateSetting(
              settings, 'toggle_mute', () => settings.setMute(value)),
          colorScheme,
        ),
      ),
      // Privacy
      _SettingItem(
        title: AppLocalizations.of(context)!.analytics,
        subtitle: AppLocalizations.of(context)!.analyticsDescription,
        child: _buildSwitch(
          settings.analyticsEnabled,
          (value) => _updateAnalyticsSetting(settings, value),
          colorScheme,
        ),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.automaticBugReports,
        subtitle: AppLocalizations.of(context)!.automaticBugReportsDesc,
        child: _buildSwitch(
          settings.automaticBugReporting,
          (value) => _updateSetting(settings, 'toggle_automatic_bug_reporting',
              () => settings.setAutomaticBugReporting(value)),
          colorScheme,
        ),
      ),
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid))
        _SettingItem(
          title: AppLocalizations.of(context)!.motivationalNotifications,
          subtitle: AppLocalizations.of(context)!.motivationalNotificationsDesc,
          child: _buildSwitch(
            settings.motivationalNotificationsEnabled,
            (value) {
              _updateSetting(settings, 'toggle_motivational_notifications',
                  () => settings.setMotivationalNotificationsEnabled(value));
            },
            colorScheme,
          ),
        ),
      // Local API (not on web)
      if (!kIsWeb)
        _SettingItem(
          title: AppLocalizations.of(context)!.localApi,
          subtitle: AppLocalizations.of(context)!.localApiDesc,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LocalApiScreen()),
          ),
          child: _buildActionButton(
            context,
            icon: Icons.api,
          ),
        ),
      // Actions
      _SettingItem(
        title: AppLocalizations.of(context)!.donateButton,
        subtitle: AppLocalizations.of(context)!.supportUsTitle,
        onTap: () => _showDonateDialog(context),
        child: _buildActionButton(
          context,
          icon: Icons.favorite,
        ),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.showIntroduction,
        subtitle: AppLocalizations.of(context)!.showIntroductionDesc,
        onTap: () => _showIntroduction(context),
        child: _buildActionButton(
          context,
          icon: Icons.help_outline,
        ),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.importStats,
        subtitle: AppLocalizations.of(context)!.importStatsDesc,
        onTap: () => _importStats(context),
        child: _buildActionButton(
          context,
          icon: Icons.upload,
        ),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.exportAllDataJson,
        subtitle: AppLocalizations.of(context)!.exportAllDataJsonDesc,
        onTap: () => _exportAllDataJson(context),
        child: _buildActionButton(
          context,
          icon: Icons.download,
        ),
      ),

      _SettingItem(
        title: AppLocalizations.of(context)!.followOnSocialMedia,
        subtitle: AppLocalizations.of(context)!.followOnSocialMediaDesc,
        onTap: () => _showSocialMediaDialog(context),
        child: _buildActionButton(
          context,
          icon: Icons.share,
        ),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.inviteFriend,
        subtitle: AppLocalizations.of(context)!.inviteFriendDesc,
        onTap: () => _showInviteDialog(context),
        child: _buildActionButton(
          context,
          icon: Icons.person_add,
        ),
      ),
      _SettingItem(
        title: AppLocalizations.of(context)!.shareYourStats,
        subtitle: AppLocalizations.of(context)!.copyStatsLinkToClipboard,
        onTap: () => _shareStats(context),
        child: _buildActionButton(
          context,
          icon: Icons.bar_chart,
        ),
      ),
      if (BijbelQuizGenPeriod.isGenPeriod() || kDebugMode)
        _SettingItem(
          title: AppLocalizations.of(context)!.bijbelquizGenTitle,
          subtitle:
              '${AppLocalizations.of(context)!.bijbelquizGenSubtitle}${BijbelQuizGenPeriod.getStatsYear()}',
          onTap: () => _showBijbelQuizGen(context),
          child: _buildActionButton(
            context,
            icon: Icons.auto_awesome,
          ),
        ),
      _SettingItem(
        title: AppLocalizations.of(context)!.resetAndLogout,
        subtitle: AppLocalizations.of(context)!.resetAndLogoutDesc,
        onTap: () => _showResetAndLogoutDialog(context, settings),
        child: _buildActionButton(
          context,
          icon: Icons.logout,
        ),
      ),
      // About
      _SettingItem(
        title: AppLocalizations.of(context)!.serverStatus,
        subtitle: AppLocalizations.of(context)!.checkServiceStatus,
        child: IconButton(
          icon: Icon(Icons.open_in_new,
              color: Theme.of(context).colorScheme.primary),
          onPressed: _openStatusPage,
          tooltip: AppLocalizations.of(context)!.openStatusPage,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      if (!(kIsWeb || Platform.isAndroid))
        _SettingItem(
          title: AppLocalizations.of(context)!.checkForUpdates,
          subtitle: AppLocalizations.of(context)!.checkForUpdatesDescription,
          child: IconButton(
            icon: Icon(Icons.refresh,
                color: Theme.of(context).colorScheme.primary),
            onPressed: () => _checkForUpdates(context, settings),
            tooltip: AppLocalizations.of(context)!.checkForUpdatesTooltip,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      _SettingItem(
        title: AppLocalizations.of(context)!.privacyPolicy,
        subtitle: AppLocalizations.of(context)!.privacyPolicyDescription,
        child: IconButton(
          icon: Icon(Icons.open_in_new,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () => _openPrivacyPolicy(context),
          tooltip: AppLocalizations.of(context)!.openPrivacyPolicyTooltip,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ];

    final filteredItems = searchQuery.isEmpty
        ? allItems
        : allItems
            .where((item) =>
                item.title.toLowerCase().contains(searchQuery) ||
                (item.subtitle?.toLowerCase().contains(searchQuery) ?? false))
            .toList();

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 16.0 : 24.0),
      cacheExtent: 1000,
      physics: const BouncingScrollPhysics(),
      children: [
        Card(
          elevation: 0,
          color: colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: filteredItems
                .map((item) => _buildSettingRow(context, item, colorScheme))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
        _buildVersionInfo(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSettingRow(
      BuildContext context, _SettingItem item, ColorScheme colorScheme) {
    final VoidCallback? effectiveOnTap =
        item.onTap ?? _extractOnTapFromChild(item);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: effectiveOnTap != null
          ? InkWell(
              onTap: effectiveOnTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface,
                                    ),
                          ),
                          if (item.subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              item.subtitle!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.7),
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
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onSurface,
                                  ),
                        ),
                        if (item.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.subtitle!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.7),
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
            ),
    );
  }

  VoidCallback? _extractOnTapFromChild(_SettingItem item) {
    final child = item.child;
    if (child is IconButton) {
      return child.onPressed;
    }
    return null;
  }

  Widget _buildThemeDropdown(
      SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen) {
    final Map<String, String> themeDisplayNames = <String, String>{};

    themeDisplayNames[ThemeMode.light.name] =
        AppLocalizations.of(context)!.lightTheme;
    themeDisplayNames[ThemeMode.system.name] =
        AppLocalizations.of(context)!.systemTheme;
    themeDisplayNames[ThemeMode.dark.name] =
        AppLocalizations.of(context)!.darkTheme;

    final availableThemes = ThemeManager().getAvailableThemes();
    for (final entry in availableThemes.entries) {
      if (entry.key == 'grey' || settings.unlockedThemes.contains(entry.key)) {
        themeDisplayNames[entry.key] = entry.value.name;
      }
    }

    for (final themeId in settings.getAIThemeIds()) {
      final aiTheme = settings.getAITheme(themeId);
      themeDisplayNames[themeId] =
          aiTheme?.name ?? AppLocalizations.of(context)!.aiThemeFallback;
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
      underline: Container(),
    );
  }

  Widget _buildLanguageDropdown(
      SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen) {
    return DropdownButton<String>(
      value: settings.language,
      items: [
        DropdownMenuItem(
          value: 'nl',
          child: Text(AppLocalizations.of(context)!.languageNl),
        ),
        DropdownMenuItem(
          value: 'en',
          child: Text(AppLocalizations.of(context)!.languageEn),
        ),
      ],
      onChanged: (String? value) {
        if (value != null) {
          _updateSetting(
              settings, 'change_language', () => settings.setLanguage(value));
        }
      },
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: isSmallScreen ? 12 : 14,
      ),
      dropdownColor: colorScheme.surfaceContainerHighest,
      isExpanded: true,
      underline: Container(),
    );
  }

  Widget _buildLayoutDropdown(
      SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen) {
    return DropdownButton<String>(
      value: settings.layoutType,
      items: [
        DropdownMenuItem(
          value: SettingsProvider.layoutGrid,
          child: Text(AppLocalizations.of(context)!.grid,
              overflow: TextOverflow.ellipsis),
        ),
        DropdownMenuItem(
          value: SettingsProvider.layoutList,
          child: Text(AppLocalizations.of(context)!.list,
              overflow: TextOverflow.ellipsis),
        ),
        DropdownMenuItem(
          value: SettingsProvider.layoutCompactGrid,
          child: Text(AppLocalizations.of(context)!.compactGrid,
              overflow: TextOverflow.ellipsis),
        ),
      ],
      onChanged: (String? value) {
        if (value != null) {
          _updateSetting(settings, 'change_layout_type',
              () => settings.setLayoutType(value));
        }
      },
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: isSmallScreen ? 12 : 14,
      ),
      dropdownColor: colorScheme.surfaceContainerHighest,
      isExpanded: true,
      underline: Container(),
    );
  }

  Widget _buildGameSpeedDropdown(
      SettingsProvider settings, ColorScheme colorScheme, bool isSmallScreen) {
    return DropdownButton<String>(
      value: settings.gameSpeed,
      items: [
        DropdownMenuItem(
          value: 'slow',
          child: Text(AppLocalizations.of(context)!.slow,
              overflow: TextOverflow.ellipsis),
        ),
        DropdownMenuItem(
          value: 'medium',
          child: Text(AppLocalizations.of(context)!.medium,
              overflow: TextOverflow.ellipsis),
        ),
        DropdownMenuItem(
          value: 'fast',
          child: Text(AppLocalizations.of(context)!.fast,
              overflow: TextOverflow.ellipsis),
        ),
      ],
      onChanged: (String? value) {
        if (value != null) {
          _updateSetting(settings, 'change_game_speed',
              () => settings.setGameSpeed(value));
        }
      },
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: isSmallScreen ? 12 : 14,
      ),
      dropdownColor: colorScheme.surfaceContainerHighest,
      isExpanded: true,
      underline: Container(),
    );
  }

  Widget _buildSwitch(
      bool value, Function(bool) onChanged, ColorScheme colorScheme) {
    return Semantics(
      button: true,
      label: value
          ? AppLocalizations.of(context)!.enabled
          : AppLocalizations.of(context)!.disabled,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: colorScheme.primary,
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    VoidCallback? onTap,
    Color? color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: onTap == null
          ? 'Action unavailable'
          : AppLocalizations.of(context)!.submit,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: color ?? colorScheme.primary),
        color: color ?? colorScheme.primary,
        tooltip: null,
      ),
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
              AppLocalizations.of(context)!.copyright,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${AppLocalizations.of(context)!.version} $version',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.6),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper methods
  void _changeTheme(SettingsProvider settings, String value) {
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
          settings.setThemeMode(themeDef.type.toLowerCase() == 'dark'
              ? ThemeMode.dark
              : ThemeMode.light);
        } else {
          settings.setCustomTheme(value);
          settings.setThemeMode(ThemeMode.light);
        }
      }
    }
  }

  void _updateSetting(
      SettingsProvider settings, String action, VoidCallback updateFunction) {
    updateFunction();
  }

  void _updateAnalyticsSetting(SettingsProvider settings, bool value) {
    settings.setAnalyticsEnabled(value);
  }

  // Dialog and navigation methods (simplified implementations)
  void _showDonateDialog(BuildContext context) async {
    final Uri url = Uri.parse(AppUrls.donateUrl);
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    await settings.markAsDonated();

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        showTopSnackBar(
            context, AppLocalizations.of(context)!.couldNotOpenDonationPage,
            style: TopSnackBarStyle.error);
      }
    }
  }

  void _showIntroduction(BuildContext context) {
    if (widget.onOpenGuide != null) widget.onOpenGuide!();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GuideScreen(),
      ),
    );
  }

  void _exportAllDataJson(BuildContext context) async {
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    final lessonProgress =
        Provider.of<LessonProgressProvider>(context, listen: false);

    final allData = {
      'settings': settings.getExportData(),
      'gameStats': gameStats.getExportData(),
      'lessonProgress': lessonProgress.getExportData(),
      'exportTimestamp': DateTime.now().toIso8601String(),
      'appVersion': '1.0.0', // You might want to get this from package_info
    };

    // Encrypt the data before export
    final encryptedData = await _EncryptionService.encryptData(allData);

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ExportAllDataScreen(jsonData: json.encode(encryptedData)),
        ),
      );
    }
  }

  void _importStats(BuildContext context) async {
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
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.followUsOnSocialMedia),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSocialMediaButton(
                    context,
                    AppLocalizations.of(context)!.mastodon,
                    Icons.alternate_email,
                    AppUrls.mastodonUrl,
                    colorScheme),
                const SizedBox(height: 8),
                _buildSocialMediaButton(
                    context,
                    AppLocalizations.of(context)!.pixelfed,
                    Icons.camera_alt,
                    AppUrls.pixelfedUrl,
                    colorScheme),
                const SizedBox(height: 8),
                _buildSocialMediaButton(
                    context,
                    AppLocalizations.of(context)!.discord,
                    Icons.forum,
                    AppUrls.discordUrl,
                    colorScheme),
                const SizedBox(height: 8),
                _buildSocialMediaButton(
                    context,
                    AppLocalizations.of(context)!.signal,
                    Icons.message,
                    AppUrls.signalUrl,
                    colorScheme),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)!.close),
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
          title: Text(AppLocalizations.of(context)!.customizeInvite),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: yourNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterYourName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: friendNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.enterFriendName,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                final yourName = yourNameController.text.trim();
                final friendName = friendNameController.text.trim();

                String inviteUrl = 'https://bijbelquiz.app/invite.html';
                final Map<String, String> queryParams = {};
                if (yourName.isNotEmpty) queryParams['yourName'] = yourName;
                if (friendName.isNotEmpty) {
                  queryParams['friendName'] = friendName;
                }

                if (queryParams.isNotEmpty) {
                  inviteUrl = Uri.parse(inviteUrl)
                      .replace(queryParameters: queryParams)
                      .toString();
                }

                await Clipboard.setData(ClipboardData(text: inviteUrl));

                if (dialogContext.mounted) {
                  showTopSnackBar(dialogContext,
                      AppLocalizations.of(context)!.inviteLinkCopied,
                      style: TopSnackBarStyle.success);
                  Navigator.of(dialogContext).pop();
                }
              },
              child: Text(AppLocalizations.of(context)!.sendInvite),
            ),
          ],
        );
      },
    );
  }

  void _shareStats(BuildContext context) async {
    try {
      final gameStats = Provider.of<GameStatsProvider>(context, listen: false);

      // Calculate total questions and correct percentage

      final totalQuestions = gameStats.score + gameStats.incorrectAnswers;

      final correctPercentage = totalQuestions > 0
          ? ((gameStats.score / totalQuestions) * 100).round()
          : 0;

      // Create compact stats string: score:currentStreak:longestStreak:incorrectAnswers:totalQuestions:correctPercentage

      final statsString =
          '${gameStats.score}:${gameStats.currentStreak}:${gameStats.longestStreak}:${gameStats.incorrectAnswers}:$totalQuestions:$correctPercentage';

      // Generate hash (first 16 chars of SHA-256)

      final statsHash = await _generateStatsHash(statsString);

      // Create the full URL

      final statsUrl =
          'https://bijbelquiz.app/score.html?s=$statsString&h=$statsHash';

      await Clipboard.setData(ClipboardData(text: statsUrl));

      if (context.mounted) {
        showTopSnackBar(context, AppLocalizations.of(context)!.statsLinkCopied,
            style: TopSnackBarStyle.success);
      }
    } catch (e) {
      if (context.mounted) {
        showTopSnackBar(context, AppLocalizations.of(context)!.errorCopyingLink,
            style: TopSnackBarStyle.error);
      }
    }
  }

  /// Generate SHA-256 hash for stats verification (first 16 characters)
  Future<String> _generateStatsHash(String statsString) async {
    try {
      final bytes = utf8.encode(statsString);
      final digest = sha256.convert(bytes);
      return digest.toString().substring(0, 16);
    } catch (e) {
      // Fallback hash if crypto fails
      return statsString.hashCode
          .toRadixString(16)
          .padLeft(16, '0')
          .substring(0, 16);
    }
  }

  void _showBijbelQuizGen(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const BijbelQuizGenScreen(),
        ),
      );
    }
  }

  Future<void> _showResetAndLogoutDialog(
      BuildContext context, SettingsProvider settings) async {
    final gameStats = Provider.of<GameStatsProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.resetAndLogout),
          content:
              Text(AppLocalizations.of(context)!.resetAndLogoutConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                AppLogger.info('User initiated reset and logout');
                final nav = Navigator.of(dialogContext);
                try {
                  await gameStats.resetStats();
                  if (context.mounted) {
                    await Provider.of<LessonProgressProvider>(context,
                            listen: false)
                        .resetAll();
                  }
                  await QuestionCacheService(ConnectionService()).clearCache();
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
              child: Text(AppLocalizations.of(context)!.resetAndLogout),
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
        showTopSnackBar(
            context, AppLocalizations.of(context)!.couldNotOpenPrivacyPolicy,
            style: TopSnackBarStyle.error);
      }
    }
  }

  Widget _buildSocialMediaButton(BuildContext context, String platform,
      IconData icon, String url, ColorScheme colorScheme) {
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(platform),
      trailing: Icon(Icons.open_in_new, size: 16, color: colorScheme.primary),
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          if (context.mounted) {
            showTopSnackBar(context,
                AppLocalizations.of(context)!.couldNotOpenPlatform(platform),
                style: TopSnackBarStyle.error);
          }
        }
      },
    );
  }
}

/// Encryption service for secure data export/import operations
class _EncryptionService {
  static final _algorithm = AesGcm.with256bits();
  static SecretKey? _secretKey;

  /// Initialize encryption with a new secret key
  static Future<void> _initializeEncryption() async {
    _secretKey = await _algorithm.newSecretKey();
  }

  /// Get the current secret key, initializing if needed
  static Future<SecretKey> _getSecretKey() async {
    if (_secretKey == null) {
      await _initializeEncryption();
    }
    return _secretKey!;
  }

  /// Encrypt data using AES-GCM
  static Future<Map<String, dynamic>> encryptData(
      Map<String, dynamic> data) async {
    try {
      final secretKey = await _getSecretKey();
      final jsonString = json.encode(data);

      final secretBox = await _algorithm.encryptString(
        jsonString,
        secretKey: secretKey,
      );

      return {
        'encryptedData': base64.encode(secretBox.concatenation()),
        'encryptionInfo': {
          'algorithm': 'AES-GCM-256',
          'timestamp': DateTime.now().toIso8601String(),
          'dataType': 'encryptedSettingsExport',
        }
      };
    } catch (e) {
      AppLogger.error('Encryption failed: $e');
      // Fallback to unencrypted data if encryption fails
      return {
        'encryptedData': base64.encode(utf8.encode(json.encode(data))),
        'encryptionInfo': {
          'algorithm': 'none',
          'timestamp': DateTime.now().toIso8601String(),
          'error': 'Encryption failed: ${e.toString()}',
        }
      };
    }
  }

  /// Decrypt data using AES-GCM
  static Future<Map<String, dynamic>> decryptData(
      Map<String, dynamic> encryptedData) async {
    try {
      final secretKey = await _getSecretKey();

      // Extract and decode the encrypted data
      final encryptedBytes =
          base64.decode(encryptedData['encryptedData'] as String);
      final secretBox = SecretBox.fromConcatenation(
        encryptedBytes,
        nonceLength: _algorithm.nonceLength,
        macLength: _algorithm.macAlgorithm.macLength,
      );

      final decryptedString = await _algorithm.decryptString(
        secretBox,
        secretKey: secretKey,
      );

      return json.decode(decryptedString) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Decryption failed: $e');
      // Try to handle unencrypted fallback data
      try {
        final fallbackData =
            base64.decode(encryptedData['encryptedData'] as String);
        final fallbackString = utf8.decode(fallbackData);
        return json.decode(fallbackString) as Map<String, dynamic>;
      } catch (fallbackError) {
        AppLogger.error('Fallback decryption also failed: $fallbackError');
        throw Exception(
            'Failed to decrypt data: ${e.toString()}. Fallback also failed: ${fallbackError.toString()}');
      }
    }
  }

  /// Handle import data with decryption
  static Future<Map<String, dynamic>> handleImportData(
      Map<String, dynamic> parsedData) async {
    try {
      // Check if this is encrypted data
      if (parsedData.containsKey('encryptedData') &&
          parsedData.containsKey('encryptionInfo')) {
        // This is encrypted data, decrypt it
        return await decryptData(parsedData);
      } else {
        // This is unencrypted data, return as-is
        return parsedData;
      }
    } catch (e) {
      AppLogger.error('Error handling import data: $e');
      // If decryption fails, try to handle as unencrypted data
      if (parsedData.containsKey('settings') &&
          parsedData.containsKey('gameStats') &&
          parsedData.containsKey('lessonProgress')) {
        return parsedData;
      }
      throw Exception('Invalid import data format: ${e.toString()}');
    }
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
    // Migrate old theme keys to new ones
    String migratedCustom = custom;
    if (custom == 'terminal') migratedCustom = 'terminal_green';
    if (custom == 'light_blue') migratedCustom = 'ocean_blue';
    if (custom == 'pink_white') migratedCustom = 'rose_white';
    // dark_wood remains the same

    if (settings.hasAITheme(migratedCustom)) {
      return migratedCustom;
    }
    final themeDef = ThemeManager().getThemeDefinition(migratedCustom);
    if (themeDef != null) {
      return migratedCustom;
    }
    if (settings.unlockedThemes.contains(migratedCustom) ||
        migratedCustom == 'grey' ||
        migratedCustom == 'christmas') {
      return migratedCustom;
    }
  }
  final mode = settings.themeMode;
  if (mode == ThemeMode.light ||
      mode == ThemeMode.dark ||
      mode == ThemeMode.system) {
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
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.exportStatsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.exportStatsMessage),
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
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.importStatsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.importStatsMessage),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: AppLocalizations.of(context)!.importStatsHint,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final input = _controller.text.trim();
                      if (input.isEmpty) {
                        showTopSnackBar(
                            context,
                            AppLocalizations.of(context)!
                                .pleaseEnterDataToImport,
                            style: TopSnackBarStyle.error);
                        return;
                      }
                      try {
                        // Handle import data with decryption
                        final decryptedData =
                            await _EncryptionService.handleImportData(
                                json.decode(input));

                        // Import JSON data
                        if (!context.mounted) return;
                        final settings = Provider.of<SettingsProvider>(context,
                            listen: false);
                        final gameStats = Provider.of<GameStatsProvider>(
                            context,
                            listen: false);
                        final lessonProgress =
                            Provider.of<LessonProgressProvider>(context,
                                listen: false);

                        await settings
                            .loadImportData(decryptedData['settings']);
                        await gameStats
                            .loadImportData(decryptedData['gameStats']);
                        await lessonProgress
                            .loadImportData(decryptedData['lessonProgress']);

                        if (context.mounted) {
                          Navigator.pop(context);
                          showTopSnackBar(
                              context,
                              AppLocalizations.of(context)!
                                  .statsImportedSuccessfully,
                              style: TopSnackBarStyle.success);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          showTopSnackBar(
                              context,
                              AppLocalizations.of(context)!.importFailed +
                                  e.toString(),
                              style: TopSnackBarStyle.error);
                        }
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.importButton),
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

class ExportAllDataScreen extends StatelessWidget {
  final String jsonData;

  const ExportAllDataScreen({super.key, required this.jsonData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.exportAllDataJsonTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.exportAllDataJsonMessage,
              style: const TextStyle(fontSize: 16),
            ),
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
                    jsonData,
                    style:
                        const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: jsonData));
                      if (context.mounted) {
                        showTopSnackBar(context,
                            AppLocalizations.of(context)!.jsonDataCopied,
                            style: TopSnackBarStyle.success);
                      }
                    },
                    icon: const Icon(Icons.copy),
                    label: Text(AppLocalizations.of(context)!.copyToClipboard),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(AppLocalizations.of(context)!.close),
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
