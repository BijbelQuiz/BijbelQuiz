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
import '../screens/ai_theme_designer_screen.dart';
import '../services/logger.dart';



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
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.screen(context, 'StoreScreen');

    // Track store access
    analyticsService.trackFeatureStart(context, AnalyticsService.FEATURE_THEME_PURCHASES);
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

            final analytics = Provider.of<AnalyticsService>(context, listen: false);
            analytics.capture(context, 'purchase_powerup', properties: {'title': title, 'cost': cost});
            analytics.trackFeaturePurchase(context, AnalyticsService.FEATURE_POWER_UPS, additionalProperties: {
              'powerup_type': title,
              'cost': cost,
              'current_score': gameStats.score,
            });
            final localContext = context;
            final localGameStats = gameStats;
            final canAfford = isDev || localGameStats.score >= cost;
            if (canAfford) {
              AppLogger.info('Sufficient stars available for power-up: $title');
              final success = isDev ? true : await localGameStats.spendStarsWithTransaction(
                amount: cost,
                reason: 'Thema aankoop: $title',
                metadata: {
                  'theme_name': title,
                },
              );
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
            final analytics = Provider.of<AnalyticsService>(context, listen: false);
            analytics.capture(context, 'purchase_theme', properties: {'theme': themeKey, 'cost': cost});
            analytics.trackFeaturePurchase(context, AnalyticsService.FEATURE_THEME_PURCHASES, additionalProperties: {
              'theme_key': themeKey,
              'theme_name': title,
              'cost': cost,
              'current_score': gameStats.score,
            });
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
              final success = isDev ? true : await localGameStats.spendStarsWithTransaction(
                amount: cost,
                reason: 'Power-up aankoop: $title',
                metadata: {
                  'powerup_type': title,
                  'duration_questions': title.contains('vragen') ? 5 : null,
                  'duration_seconds': title.contains('seconden') ? 60 : null,
                },
              );
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
            final analytics = Provider.of<AnalyticsService>(context, listen: false);
            analytics.capture(context, 'ai_theme_generator_tapped', properties: {'cost': cost});
            analytics.trackFeatureAttempt(context, AnalyticsService.FEATURE_AI_THEME_GENERATOR, additionalProperties: {
              'cost': cost,
              'current_score': gameStats.score,
            });
            final localContext = context;
            final localGameStats = gameStats;
            final canAfford = isDev || localGameStats.score >= cost;

            if (canAfford) {
              // Navigate to AI Theme Designer screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AIThemeDesignerScreen(),
                ),
              );
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
}