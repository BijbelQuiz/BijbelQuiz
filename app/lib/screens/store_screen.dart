import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../providers/game_stats_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;
import '../screens/quiz_screen.dart';
import '../services/logger.dart';
import '../services/gemini_service.dart';
import '../services/feature_flags_service.dart';
import '../models/ai_theme.dart';

// Extension for capitalizing strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  @override
  void initState() {
    super.initState();
    AppLogger.info('StoreScreen initialized');
    Provider.of<AnalyticsService>(context, listen: false).screen(context, 'StoreScreen');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gameStats = Provider.of<GameStatsProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final unlocked = settings.unlockedThemes;
    final isDev = kDebugMode;

    
    // Responsive design
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

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
                Icons.store_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strings.AppStrings.store,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
              ),
            ),
          ],
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 800 : (isTablet ? 600 : double.infinity),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section with stars display
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isDesktop ? 24 : 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary.withAlpha((0.1 * 255).round()),
                          colorScheme.primary.withAlpha((0.05 * 255).round()),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: colorScheme.outline.withAlpha((0.1 * 255).round()),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: colorScheme.primary,
                              size: getResponsiveFontSize(context, 24),
                            ),
                            SizedBox(width: isDesktop ? 12 : 8),
                            Text(
                              '${gameStats.score}',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isDesktop ? 12 : 8),
                        Text(
                          strings.AppStrings.availableStars,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isDesktop ? 32 : 24),
                  
                  // Power-ups section
                  _buildSectionHeader(
                    context,
                    strings.AppStrings.powerUps,
                    Icons.flash_on_rounded,
                    colorScheme.primary,
                    isDesktop,
                  ),
                  
                  SizedBox(height: isDesktop ? 16 : 12),
                  
                  _buildPowerupCard(
                    context,
                    title: strings.AppStrings.doubleStars5Questions,
                    description: strings.AppStrings.doubleStars5QuestionsDesc,
                    icon: Icons.flash_on_rounded,
                    iconColor: colorScheme.primary,
                    cost: 100,
                    isDev: isDev,
                    gameStats: gameStats,
                    isDesktop: isDesktop,
                    onPurchase: () {
                      gameStats.activatePowerup(multiplier: 2, questions: 5);
                      return 'Dubbele Sterren geactiveerd voor 5 vragen!';
                    },
                  ),
                  
                  SizedBox(height: isDesktop ? 16 : 12),
                  
                  _buildPowerupCard(
                    context,
                    title: strings.AppStrings.tripleStars5Questions,
                    description: strings.AppStrings.tripleStars5QuestionsDesc,
                    icon: Icons.flash_on_rounded,
                    iconColor: Colors.deepOrange,
                    cost: 180,
                    isDev: isDev,
                    gameStats: gameStats,
                    isDesktop: isDesktop,
                    onPurchase: () {
                      gameStats.activatePowerup(multiplier: 3, questions: 5);
                      return 'Driedubbele Sterren geactiveerd voor 5 vragen!';
                    },
                  ),
                  
                  SizedBox(height: isDesktop ? 16 : 12),
                  
                  _buildPowerupCard(
                    context,
                    title: strings.AppStrings.fiveTimesStars5Questions,
                    description: strings.AppStrings.fiveTimesStars5QuestionsDesc,
                    icon: Icons.flash_on_rounded,
                    iconColor: Colors.redAccent,
                    cost: 350,
                    isDev: isDev,
                    gameStats: gameStats,
                    isDesktop: isDesktop,
                    onPurchase: () {
                      gameStats.activatePowerup(multiplier: 5, questions: 5);
                      return '5x Sterren geactiveerd voor 5 vragen!';
                    },
                  ),
                  
                  SizedBox(height: isDesktop ? 16 : 12),
                  
                  _buildPowerupCard(
                    context,
                    title: strings.AppStrings.doubleStars60Seconds,
                    description: strings.AppStrings.doubleStars60SecondsDesc,
                    icon: Icons.timer_rounded,
                    iconColor: Colors.orangeAccent,
                    cost: 120,
                    isDev: isDev,
                    gameStats: gameStats,
                    isDesktop: isDesktop,
                    onPurchase: () {
                      gameStats.activatePowerup(multiplier: 2, time: Duration(seconds: 60));
                      return 'Dubbele Sterren geactiveerd voor 60 seconden!';
                    },
                  ),
                  
                  SizedBox(height: isDesktop ? 32 : 24),
                  
                  // Themes section
                  _buildSectionHeader(
                    context,
                    strings.AppStrings.themes,
                    Icons.palette_rounded,
                    colorScheme.secondary,
                    isDesktop,
                  ),
                  
                  SizedBox(height: isDesktop ? 16 : 12),
                  
                  _buildThemeCard(
                    context,
                    title: strings.AppStrings.oledThemeName,
                    description: strings.AppStrings.oledThemeDesc,
                    icon: Icons.nights_stay_rounded,
                    iconColor: Colors.black,
                    cost: 150,
                    isDev: isDev,
                    gameStats: gameStats,
                    settings: settings,
                    unlocked: unlocked,
                    themeKey: 'oled',
                    isDesktop: isDesktop,
                  ),
                  
                  SizedBox(height: isDesktop ? 16 : 12),
                  
                  _buildThemeCard(
                    context,
                    title: strings.AppStrings.greenThemeName,
                    description: strings.AppStrings.greenThemeDesc,
                    icon: Icons.eco_rounded,
                    iconColor: Colors.green[700]!,
                    cost: 120,
                    isDev: isDev,
                    gameStats: gameStats,
                    settings: settings,
                    unlocked: unlocked,
                    themeKey: 'green',
                    isDesktop: isDesktop,
                  ),
                  
                  SizedBox(height: isDesktop ? 16 : 12),
                  
                  _buildThemeCard(
                    context,
                    title: strings.AppStrings.orangeThemeName,
                    description: strings.AppStrings.orangeThemeDesc,
                    icon: Icons.circle_rounded,
                    iconColor: Colors.orange[700]!,
                    cost: 120,
                    isDev: isDev,
                    gameStats: gameStats,
                    settings: settings,
                    unlocked: unlocked,
                    themeKey: 'orange',
                    isDesktop: isDesktop,
                  ),

                  SizedBox(height: isDesktop ? 16 : 12),

                  _buildAIThemeCard(
                    context,
                    title: strings.AppStrings.aiThemeGenerator,
                    description: strings.AppStrings.aiThemeGeneratorDescription,
                    icon: Icons.smart_toy_rounded,
                    iconColor: Colors.purple,
                    cost: 200,
                    isDev: isDev,
                    gameStats: gameStats,
                    isDesktop: isDesktop,
                  ),

                  SizedBox(height: isDesktop ? 32 : 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color, bool isDesktop) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isDesktop ? 12 : 10),
          decoration: BoxDecoration(
            color: color.withAlpha((0.1 * 255).round()),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: getResponsiveFontSize(context, 20),
          ),
        ),
        SizedBox(width: isDesktop ? 16 : 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildPowerupCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required int cost,
    required bool isDev,
    required GameStatsProvider gameStats,
    required bool isDesktop,
    required String Function() onPurchase,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withAlpha((0.1 * 255).round()),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.04 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

            AppLogger.info('Power-up purchase attempted: $title, cost: $cost');

            Provider.of<AnalyticsService>(context, listen: false).capture(context, 'purchase_powerup', properties: {'title': title, 'cost': cost});
            final localContext = context;
            final localGameStats = gameStats;
            final canAfford = isDev || localGameStats.score >= cost;
            if (canAfford) {
              AppLogger.info('Sufficient stars available for power-up: $title');
              final success = isDev ? true : await localGameStats.spendStars(cost);
              if (success) {

                final message = onPurchase();
                if (!localContext.mounted) return;
                
                // Show confirmation dialog
                await showDialog(
                  context: localContext,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded, color: colorScheme.primary, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Power-up Geactiveerd!',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Start free play (random practice) regardless of how Store is shown
                            Navigator.of(localContext).push(
                              MaterialPageRoute(
                                builder: (_) => const QuizScreen(),
                              ),
                            );
                          },
                          child: Text('Naar de quiz', style: TextStyle(color: colorScheme.primary)),
                        ),
                      ],
                    );
                  },
                );
              }
            } else {
              showTopSnackBar(localContext, 'Niet genoeg sterren!', style: TopSnackBarStyle.error);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20 : 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 16 : 12),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: getResponsiveFontSize(context, 24),
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 4 : 2),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 16 : 12,
                    vertical: isDesktop ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withAlpha((0.2 * 255).round()),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: colorScheme.primary,
                        size: getResponsiveFontSize(context, 16),
                      ),
                      SizedBox(width: isDesktop ? 6 : 4),
                      Text(
                        isDev ? 'Gratis' : '$cost',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required int cost,
    required bool isDev,
    required GameStatsProvider gameStats,
    required SettingsProvider settings,
    required Set<String> unlocked,
    required String themeKey,
    required bool isDesktop,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isUnlocked = unlocked.contains(themeKey);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked 
            ? colorScheme.primary.withAlpha((0.3 * 255).round())
            : colorScheme.outline.withAlpha((0.1 * 255).round()),
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.04 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            AppLogger.info('Theme purchase attempted: $title, theme: $themeKey, cost: $cost');
            Provider.of<AnalyticsService>(context, listen: false).capture(context, 'purchase_theme', properties: {'theme': themeKey, 'cost': cost});
            final localContext = context;
            final localGameStats = gameStats;
            final localSettings = settings;
            final canAfford = isDev || localGameStats.score >= cost;
            if (isUnlocked) {
              AppLogger.info('Theme already unlocked: $themeKey');
              return;
            }
            if (canAfford) {
              AppLogger.info('Sufficient stars available for theme: $themeKey');
              final success = isDev ? true : await localGameStats.spendStars(cost);
              if (success) {
                await localSettings.unlockTheme(themeKey);
                if (!localContext.mounted) return;
                final message = '$title ontgrendeld!';
                showTopSnackBar(localContext, message, style: TopSnackBarStyle.success);
              }
            } else {
              showTopSnackBar(localContext, 'Niet genoeg sterren!', style: TopSnackBarStyle.error);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20 : 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 16 : 12),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: getResponsiveFontSize(context, 24),
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 4 : 2),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                isUnlocked
                    ? Container(
                        padding: EdgeInsets.all(isDesktop ? 12 : 10),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: colorScheme.primary,
                          size: getResponsiveFontSize(context, 20),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 16 : 12,
                          vertical: isDesktop ? 8 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withAlpha((0.2 * 255).round()),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: colorScheme.primary,
                              size: getResponsiveFontSize(context, 16),
                            ),
                            SizedBox(width: isDesktop ? 6 : 4),
                            Text(
                              isDev ? 'Gratis' : '$cost',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAIThemeCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
    required int cost,
    required bool isDev,
    required GameStatsProvider gameStats,
    required bool isDesktop,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withAlpha((0.1 * 255).round()),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.04 * 255).round()),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () async {
            AppLogger.info('AI Theme Generator tapped, cost: $cost');
            Provider.of<AnalyticsService>(context, listen: false).capture(context, 'ai_theme_generator_tapped', properties: {'cost': cost});
            final localContext = context;
            final localGameStats = gameStats;
            final canAfford = isDev || localGameStats.score >= cost;

            if (canAfford) {
              await _showAIThemeDialog(localContext, localGameStats, cost, isDev);
            } else {
              showTopSnackBar(localContext, 'Niet genoeg sterren!', style: TopSnackBarStyle.error);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20 : 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 16 : 12),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: getResponsiveFontSize(context, 24),
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 4 : 2),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 16 : 12,
                    vertical: isDesktop ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withAlpha((0.2 * 255).round()),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: colorScheme.primary,
                        size: getResponsiveFontSize(context, 16),
                      ),
                      SizedBox(width: isDesktop ? 6 : 4),
                      Text(
                        isDev ? 'Gratis' : '$cost',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showAIThemeDialog(BuildContext context, GameStatsProvider gameStats, int cost, bool isDev) async {
    final colorScheme = Theme.of(context).colorScheme;
    final TextEditingController themeController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: colorScheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.smart_toy_rounded, color: Colors.purple, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'AI Thema Generator',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Beschrijf het thema dat je wilt laten maken door AI:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: themeController,
                    maxLines: 3,
                    enabled: !_isGenerating,
                    decoration: InputDecoration(
                      hintText: 'Bijvoorbeeld: "Een blauw thema met gouden accenten, geïnspireerd op de oceaan..."',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.purple, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isGenerating) ...[
                    LinearProgressIndicator(
                      backgroundColor: colorScheme.primary.withAlpha((0.1 * 255).round()),
                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _generationStatus,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else
                    Text(
                      'Dit kost $cost sterren. Het AI-thema wordt direct gegenereerd en toegevoegd aan je collectie.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                ],
              ),
              actions: _isGenerating
                ? [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isGenerating = false;
                          _generationStatus = '';
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Annuleren',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  ]
                : [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Annuleren',
                        style: TextStyle(color: colorScheme.onSurface.withAlpha((0.7 * 255).round())),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _generateAITheme(context, themeController, gameStats, cost, isDev, setState);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Genereer Thema'),
                    ),
                  ],
            );
          },
        );
      },
    );
  }

  bool _isGenerating = false;
  String _generationStatus = '';

  Future<void> _generateAITheme(
    BuildContext context,
    TextEditingController themeController,
    GameStatsProvider gameStats,
    int cost,
    bool isDev,
    StateSetter setState,
  ) async {
    final description = themeController.text.trim();
    if (description.isEmpty) {
      showTopSnackBar(context, 'Beschrijf eerst je gewenste thema!', style: TopSnackBarStyle.error);
      return;
    }

    AppLogger.info('AI Theme generation requested: $description');
    Provider.of<AnalyticsService>(context, listen: false).capture(
      context,
      'ai_theme_generated',
      properties: {'description': description}
    );

    // Spend stars first
    final success = isDev ? true : await gameStats.spendStars(cost);
    if (!success) {
      showTopSnackBar(context, 'Niet genoeg sterren!', style: TopSnackBarStyle.error);
      return;
    }

    // Start generation process
    setState(() {
      _isGenerating = true;
      _generationStatus = 'AI aan het werk...';
    });

    try {
       // Check if Gemini color generation is enabled
       FeatureFlagsService? featureFlags;
       try {
         featureFlags = Provider.of<FeatureFlagsService>(context, listen: false);
       } catch (e) {
         // Feature flags service not available in provider yet, create new instance
         featureFlags = FeatureFlagsService();
       }
       final isGeminiEnabled = await featureFlags.isGeminiColorGenerationEnabled();

       if (!isGeminiEnabled) {
         showTopSnackBar(context, 'AI thema generatie is momenteel uitgeschakeld.', style: TopSnackBarStyle.error);
         // Refund stars since feature is disabled
         if (!isDev) {
           await gameStats.spendStars(cost);
         }
         return;
       }

       // Update status
       setState(() {
         _generationStatus = 'Kleuren aan het genereren...';
       });

       // Call Gemini API
       final geminiService = GeminiService.instance;
       final colorPalette = await geminiService.generateColorsFromText(description);

      // Update status
      setState(() {
        _generationStatus = 'Thema aan het samenstellen...';
      });

      // Create theme from color palette
      final themeId = AIThemeBuilder.generateThemeId();
      final themeName = _generateThemeName(description);
      final themeDescription = 'AI-gegenereerd thema gebaseerd op: $description';

      final lightTheme = AIThemeBuilder.createLightThemeFromPalette(colorPalette.toJson());

      final aiTheme = AITheme(
        id: themeId,
        name: themeName,
        description: themeDescription,
        createdAt: DateTime.now(),
        lightTheme: lightTheme,
        colorPalette: colorPalette.toJson(),
        prompt: description,
      );

      // Update status
      setState(() {
        _generationStatus = 'Thema aan het opslaan...';
      });

      // Save theme to settings provider
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      await settings.saveAITheme(aiTheme);

      // Update status
      setState(() {
        _generationStatus = 'Klaar!';
      });

      // Close dialog and show success
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
        Navigator.of(context).pop();
        showTopSnackBar(
          context,
          'AI thema "$themeName" succesvol aangemaakt!',
          style: TopSnackBarStyle.success
        );

        // Show theme preview dialog
        await _showThemePreviewDialog(context, aiTheme);
      }

    } catch (e) {
      AppLogger.error('AI theme generation failed', e);

      if (context.mounted) {
        String errorMessage = 'Er ging iets fout bij het genereren van het thema.';
        if (e is GeminiError) {
          errorMessage = 'AI fout: ${e.message}';
        }

        showTopSnackBar(context, errorMessage, style: TopSnackBarStyle.error);

        // Refund stars on error
        if (!isDev) {
          await gameStats.addStars(cost);
        }
      }
    } finally {
      setState(() {
        _isGenerating = false;
        _generationStatus = '';
      });
    }
  }

  String _generateThemeName(String description) {
    // Extract key words from description for theme name
    final words = description.toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(' ')
        .where((word) => word.length > 3)
        .take(2)
        .toList();

    if (words.isEmpty) {
      return 'AI Thema ${DateTime.now().millisecondsSinceEpoch % 1000}';
    }

    return '${words[0].capitalize()} ${words.length > 1 ? words[1].capitalize() : 'Thema'}';
  }

  Future<void> _showThemePreviewDialog(BuildContext context, AITheme theme) async {
    final colorScheme = Theme.of(context).colorScheme;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.palette_rounded, color: theme.lightTheme.colorScheme.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  theme.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                theme.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Kleurenschema:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildColorPreview(theme.lightTheme.colorScheme.primary, 'Primair'),
                  const SizedBox(width: 8),
                  _buildColorPreview(theme.lightTheme.colorScheme.secondary, 'Secundair'),
                  const SizedBox(width: 8),
                  _buildColorPreview(theme.lightTheme.colorScheme.tertiary, 'Tertiair'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Sluiten',
                style: TextStyle(color: colorScheme.onSurface.withAlpha((0.7 * 255).round())),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Apply the theme
                final settings = Provider.of<SettingsProvider>(context, listen: false);
                await settings.setCustomTheme(theme.id);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  showTopSnackBar(
                    context,
                    'Thema "${theme.name}" is nu actief!',
                    style: TopSnackBarStyle.success
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.lightTheme.colorScheme.primary,
                foregroundColor: theme.lightTheme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Gebruik Thema'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildColorPreview(Color color, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.withAlpha((0.3 * 255).round()),
                width: 1,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}