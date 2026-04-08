import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../providers/game_stats_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/top_snackbar.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';
import '../screens/quiz_screen.dart';
import '../screens/ai_theme_designer_screen.dart';
import '../screens/coupon_redeem_screen.dart';
import '../services/logger.dart';
import '../utils/automatic_error_reporter.dart';
import '../models/store_item.dart';
import '../services/connection_service.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

enum StoreErrorType {
  network,
  server,
  unknown,
}

class _StoreScreenState extends State<StoreScreen> {
  late ConnectionService _connectionService;

  @override
  void initState() {
    super.initState();
    _connectionService = ConnectionService();
    _connectionService.initialize();
    AppLogger.info('StoreScreen initialized');
    // Load store items from Supabase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storeProvider = Provider.of<StoreProvider>(context, listen: false);
      storeProvider.loadStoreItems();
    });
  }

  // Helper methods to get item prices by key
  int _getPriceByKey(BuildContext context, String key) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final item =
        storeProvider.storeItems.firstWhere((item) => item.itemKey == key,
            orElse: () => StoreItem(
                  itemKey: key,
                  itemName: key,
                  itemDescription: '',
                  itemType: 'theme',
                  basePrice: 50,
                  currentPrice: 50,
                  isDiscounted: false,
                  discountPercentage: 0,
                  isActive: true,
                  discountStart: null,
                  discountEnd: null,
                ));

    return item.currentPrice;
  }

  bool _isDiscountedByKey(BuildContext context, String key) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final item =
        storeProvider.storeItems.firstWhere((item) => item.itemKey == key,
            orElse: () => StoreItem(
                  itemKey: key,
                  itemName: key,
                  itemDescription: '',
                  itemType: 'theme',
                  basePrice: 50,
                  currentPrice: 50,
                  isDiscounted: false,
                  discountPercentage: 0,
                  isActive: true,
                  discountStart:
                      null, // Add these to ensure isCurrentlyDiscounted works properly
                  discountEnd: null,
                ));

    return item.isCurrentlyDiscounted;
  }

  int _getDiscountAmountByKey(BuildContext context, String key) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final item =
        storeProvider.storeItems.firstWhere((item) => item.itemKey == key,
            orElse: () => StoreItem(
                  itemKey: key,
                  itemName: key,
                  itemDescription: '',
                  itemType: 'theme',
                  basePrice: 50,
                  currentPrice: 50,
                  isDiscounted: false,
                  discountPercentage: 0,
                  isActive: true,
                  discountStart: null,
                  discountEnd: null,
                ));

    return item.basePrice - item.currentPrice;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final gameStats = Provider.of<GameStatsProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final storeProvider = Provider.of<StoreProvider>(context);
    final unlocked = settings.unlockedThemes;
    final isDev = kDebugMode;

    // Responsive design
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

    // Show offline error screen if not connected
    if (!_connectionService.isConnected) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
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
                  Icons.store_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.store,
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
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 600 : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 32 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Error icon with background
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 32 : 24),
                      decoration: BoxDecoration(
                        color: colorScheme.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colorScheme.error.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.wifi_off_rounded,
                        size:
                            getResponsiveFontSize(context, isDesktop ? 80 : 64),
                        color: colorScheme.error,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    Text(
                      AppLocalizations.of(context)!.connectionError,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.error,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isDesktop ? 16 : 12),
                    Text(
                      AppLocalizations.of(context)!.connectionErrorMsg,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isDesktop ? 40 : 32),
                    // Action buttons
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final storeProvider = Provider.of<StoreProvider>(
                                context,
                                listen: false);
                            await _connectionService.checkConnection();
                            if (_connectionService.isConnected) {
                              storeProvider.loadStoreItems();
                            }
                            setState(() {});
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(AppLocalizations.of(context)!.tryAgain),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 32 : 24,
                              vertical: isDesktop ? 16 : 12,
                            ),
                            textStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Show loading screen while fetching store items
    if (storeProvider.isLoading) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
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
                  Icons.store_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.store,
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
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Show error if loading failed
    if (storeProvider.error != null) {
      IconData errorIcon = Icons.error_outline_rounded;
      String errorTitle = AppLocalizations.of(context)!.errorLoadingStore;
      Color errorColor = colorScheme.error;

      return Scaffold(
        backgroundColor: colorScheme.surface,
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
                  Icons.store_rounded,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.store,
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
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 600 : double.infinity,
              ),
              child: Padding(
                padding: EdgeInsets.all(isDesktop ? 32 : 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Error icon with background
                    Container(
                      padding: EdgeInsets.all(isDesktop ? 32 : 24),
                      decoration: BoxDecoration(
                        color: errorColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: errorColor.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        errorIcon,
                        size:
                            getResponsiveFontSize(context, isDesktop ? 80 : 64),
                        color: errorColor,
                      ),
                    ),
                    SizedBox(height: isDesktop ? 32 : 24),
                    Text(
                      errorTitle,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: errorColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isDesktop ? 16 : 12),
                    Text(
                      storeProvider.error!,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isDesktop ? 40 : 32),
                    // Action buttons
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            final storeProvider = Provider.of<StoreProvider>(
                                context,
                                listen: false);
                            storeProvider.loadStoreItems();
                          },
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(AppLocalizations.of(context)!.tryAgain),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 32 : 24,
                              vertical: isDesktop ? 16 : 12,
                            ),
                            textStyle: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
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
                Icons.store_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.store,
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
      body: RefreshIndicator(
        onRefresh: () async {
          final storeProvider =
              Provider.of<StoreProvider>(context, listen: false);
          await storeProvider.loadStoreItems();
        },
        child: SafeArea(
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
                            colorScheme.primary.withValues(alpha: 0.1),
                            colorScheme.primary.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.1),
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
                                style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isDesktop ? 12 : 8),
                          Text(
                            AppLocalizations.of(context)!.availableStars,
                            style: textTheme.titleMedium?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isDesktop ? 32 : 24),

                    _buildCouponCard(
                      context,
                      isDesktop: isDesktop,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),

                    SizedBox(height: isDesktop ? 32 : 24),

                    // Power-ups section
                    _buildSectionHeader(
                      context,
                      AppLocalizations.of(context)!.powerUps,
                      Icons.flash_on_rounded,
                      colorScheme.primary,
                      isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildPowerupCard(
                      context,
                      title:
                          AppLocalizations.of(context)!.doubleStars5Questions,
                      description: AppLocalizations.of(context)!
                          .doubleStars5QuestionsDesc,
                      icon: Icons.flash_on_rounded,
                      iconColor: colorScheme.primary,
                      cost: _getPriceByKey(context, 'double_stars_5_questions'),
                      isDiscounted: _isDiscountedByKey(
                          context, 'double_stars_5_questions'),
                      discountAmount: _getDiscountAmountByKey(
                          context, 'double_stars_5_questions'),
                      isDev: isDev,
                      gameStats: gameStats,
                      isDesktop: isDesktop,
                      onPurchase: () {
                        gameStats.activatePowerup(multiplier: 2, questions: 5);
                        return AppLocalizations.of(context)!
                            .doubleStarsActivated;
                      },
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildPowerupCard(
                      context,
                      title:
                          AppLocalizations.of(context)!.tripleStars5Questions,
                      description: AppLocalizations.of(context)!
                          .tripleStars5QuestionsDesc,
                      icon: Icons.flash_on_rounded,
                      iconColor: Colors.deepOrange,
                      cost: _getPriceByKey(context, 'triple_stars_5_questions'),
                      isDiscounted: _isDiscountedByKey(
                          context, 'triple_stars_5_questions'),
                      discountAmount: _getDiscountAmountByKey(
                          context, 'triple_stars_5_questions'),
                      isDev: isDev,
                      gameStats: gameStats,
                      isDesktop: isDesktop,
                      onPurchase: () {
                        gameStats.activatePowerup(multiplier: 3, questions: 5);
                        return AppLocalizations.of(context)!
                            .tripleStarsActivated;
                      },
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildPowerupCard(
                      context,
                      title: AppLocalizations.of(context)!
                          .fiveTimesStars5Questions,
                      description: AppLocalizations.of(context)!
                          .fiveTimesStars5QuestionsDesc,
                      icon: Icons.flash_on_rounded,
                      iconColor: Colors.redAccent,
                      cost: _getPriceByKey(
                          context, 'five_times_stars_5_questions'),
                      isDiscounted: _isDiscountedByKey(
                          context, 'five_times_stars_5_questions'),
                      discountAmount: _getDiscountAmountByKey(
                          context, 'five_times_stars_5_questions'),
                      isDev: isDev,
                      gameStats: gameStats,
                      isDesktop: isDesktop,
                      onPurchase: () {
                        gameStats.activatePowerup(multiplier: 5, questions: 5);
                        return AppLocalizations.of(context)!
                            .fiveTimesStarsActivated;
                      },
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildPowerupCard(
                      context,
                      title: AppLocalizations.of(context)!.doubleStars60Seconds,
                      description: AppLocalizations.of(context)!
                          .doubleStars60SecondsDesc,
                      icon: Icons.timer_rounded,
                      iconColor: Colors.orangeAccent,
                      cost: _getPriceByKey(context, 'double_stars_60_seconds'),
                      isDiscounted: _isDiscountedByKey(
                          context, 'double_stars_60_seconds'),
                      discountAmount: _getDiscountAmountByKey(
                          context, 'double_stars_60_seconds'),
                      isDev: isDev,
                      gameStats: gameStats,
                      isDesktop: isDesktop,
                      onPurchase: () {
                        gameStats.activatePowerup(
                            multiplier: 2, time: Duration(seconds: 60));
                        return AppLocalizations.of(context)!
                            .doubleStars60SecondsActivated;
                      },
                    ),

                    SizedBox(height: isDesktop ? 32 : 24),

                    // Themes section
                    _buildSectionHeader(
                      context,
                      AppLocalizations.of(context)!.themes,
                      Icons.palette_rounded,
                      colorScheme.secondary,
                      isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildThemeCard(
                      context,
                      title: AppLocalizations.of(context)!.oledThemeName,
                      description: AppLocalizations.of(context)!.oledThemeDesc,
                      icon: Icons.nights_stay_rounded,
                      iconColor: Colors.black,
                      cost: _getPriceByKey(context, 'oled_theme'),
                      isDiscounted: _isDiscountedByKey(context, 'oled_theme'),
                      discountAmount:
                          _getDiscountAmountByKey(context, 'oled_theme'),
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
                      title: AppLocalizations.of(context)!.greenThemeName,
                      description: AppLocalizations.of(context)!.greenThemeDesc,
                      icon: Icons.eco_rounded,
                      iconColor: Colors.green[700]!,
                      cost: _getPriceByKey(context, 'green_theme'),
                      isDiscounted: _isDiscountedByKey(context, 'green_theme'),
                      discountAmount:
                          _getDiscountAmountByKey(context, 'green_theme'),
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
                      title: AppLocalizations.of(context)!.orangeThemeName,
                      description:
                          AppLocalizations.of(context)!.orangeThemeDesc,
                      icon: Icons.circle_rounded,
                      iconColor: Colors.orange[700]!,
                      cost: _getPriceByKey(context, 'orange_theme'),
                      isDiscounted: _isDiscountedByKey(context, 'orange_theme'),
                      discountAmount:
                          _getDiscountAmountByKey(context, 'orange_theme'),
                      isDev: isDev,
                      gameStats: gameStats,
                      settings: settings,
                      unlocked: unlocked,
                      themeKey: 'orange',
                      isDesktop: isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildThemeCard(
                      context,
                      title: AppLocalizations.of(context)!.christmasTheme,
                      description: AppLocalizations.of(context)!
                          .christmasThemeDescription,
                      icon: Icons.card_giftcard_rounded,
                      iconColor: Colors.red[700]!,
                      cost: _getPriceByKey(context, 'christmas_theme'),
                      isDiscounted:
                          _isDiscountedByKey(context, 'christmas_theme'),
                      discountAmount:
                          _getDiscountAmountByKey(context, 'christmas_theme'),
                      isDev: isDev,
                      gameStats: gameStats,
                      settings: settings,
                      unlocked: unlocked,
                      themeKey: 'christmas',
                      isDesktop: isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildThemeCard(
                      context,
                      title: AppLocalizations.of(context)!.terminalGreenTheme,
                      description: AppLocalizations.of(context)!
                          .terminalGreenThemeDescription,
                      icon: Icons.code_rounded,
                      iconColor: Colors.green[700]!,
                      cost: _getPriceByKey(context, 'terminal_green_theme'),
                      isDiscounted:
                          _isDiscountedByKey(context, 'terminal_green_theme'),
                      discountAmount: _getDiscountAmountByKey(
                          context, 'terminal_green_theme'),
                      isDev: isDev,
                      gameStats: gameStats,
                      settings: settings,
                      unlocked: unlocked,
                      themeKey: 'terminal_green',
                      isDesktop: isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildThemeCard(
                      context,
                      title: AppLocalizations.of(context)!.oceanBlueTheme,
                      description: AppLocalizations.of(context)!
                          .oceanBlueThemeDescription,
                      icon: Icons.waves_rounded,
                      iconColor: Colors.blue[400]!,
                      cost: _getPriceByKey(context, 'ocean_blue_theme'),
                      isDiscounted:
                          _isDiscountedByKey(context, 'ocean_blue_theme'),
                      discountAmount:
                          _getDiscountAmountByKey(context, 'ocean_blue_theme'),
                      isDev: isDev,
                      gameStats: gameStats,
                      settings: settings,
                      unlocked: unlocked,
                      themeKey: 'ocean_blue',
                      isDesktop: isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildThemeCard(
                      context,
                      title: AppLocalizations.of(context)!.roseWhiteTheme,
                      description: AppLocalizations.of(context)!
                          .roseWhiteThemeDescription,
                      icon: Icons.favorite_rounded,
                      iconColor: Colors.pink[400]!,
                      cost: _getPriceByKey(context, 'rose_white_theme'),
                      isDiscounted:
                          _isDiscountedByKey(context, 'rose_white_theme'),
                      discountAmount:
                          _getDiscountAmountByKey(context, 'rose_white_theme'),
                      isDev: isDev,
                      gameStats: gameStats,
                      settings: settings,
                      unlocked: unlocked,
                      themeKey: 'rose_white',
                      isDesktop: isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildThemeCard(
                      context,
                      title: AppLocalizations.of(context)!.darkWoodTheme,
                      description: AppLocalizations.of(context)!
                          .darkWoodThemeDescription,
                      icon: Icons.forest_rounded,
                      iconColor: Colors.brown[700]!,
                      cost: _getPriceByKey(context, 'dark_wood_theme'),
                      isDiscounted:
                          _isDiscountedByKey(context, 'dark_wood_theme'),
                      discountAmount:
                          _getDiscountAmountByKey(context, 'dark_wood_theme'),
                      isDev: isDev,
                      gameStats: gameStats,
                      settings: settings,
                      unlocked: unlocked,
                      themeKey: 'dark_wood',
                      isDesktop: isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildAIThemeCard(
                      context,
                      title: AppLocalizations.of(context)!.aiThemeGenerator,
                      description: AppLocalizations.of(context)!
                          .aiThemeGeneratorDescription,
                      icon: Icons.smart_toy_rounded,
                      iconColor: Colors.purple,
                      cost: _getPriceByKey(context, 'ai_theme_generator'),
                      isDiscounted:
                          _isDiscountedByKey(context, 'ai_theme_generator'),
                      discountAmount: _getDiscountAmountByKey(
                          context, 'ai_theme_generator'),
                      isDev: isDev,
                      gameStats: gameStats,
                      isDesktop: isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 32 : 24),

                    SizedBox(height: isDesktop ? 32 : 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon,
      Color color, bool isDesktop) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isDesktop ? 12 : 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
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
          style: textTheme.headlineSmall?.copyWith(
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
    required bool isDiscounted,
    required int discountAmount,
    required bool isDev,
    required GameStatsProvider gameStats,
    required bool isDesktop,
    required String Function() onPurchase,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
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
            AppLogger.info('Power-up purchase attempted: $title, cost: $cost');

            final localContext = context;
            final localGameStats = gameStats;
            final canAfford = isDev || localGameStats.score >= cost;
            if (canAfford) {
              AppLogger.info('Sufficient stars available for power-up: $title');
              try {
                final success = isDev
                    ? true
                    : await localGameStats.spendStarsWithTransaction(
                        amount: cost,
                        reason: 'Power-up aankoop: $title',
                        metadata: {
                          'powerup_name': title,
                          'feature': 'store',
                        },
                      );
                if (success) {
                  final message = onPurchase();

                  // Trigger sync after successful purchase
                  await localGameStats.triggerSync();

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
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: colorScheme.primary, size: 24),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .powerupActivated,
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
                            child: Text(AppLocalizations.of(context)!.goToQuiz,
                                style: TextStyle(color: colorScheme.primary)),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Auto-report transaction failure
                  await AutomaticErrorReporter.reportStorageError(
                    message: 'Failed to process power-up purchase transaction',
                    userMessage: 'Failed to purchase power-up',
                    operation: 'spend_stars',
                    additionalInfo: {
                      'powerup_name': title,
                      'cost': cost,
                      'expected_amount': cost,
                    },
                  );
                  if (localContext.mounted) {
                    showTopSnackBar(localContext,
                        AppLocalizations.of(context)!.purchaseFailed,
                        style: TopSnackBarStyle.error);
                  }
                }
              } catch (e) {
                // Auto-report the error
                await AutomaticErrorReporter.reportStorageError(
                  message:
                      'Error processing power-up purchase: ${e.toString()}',
                  userMessage: 'Error processing power-up purchase',
                  operation: 'spend_stars',
                  additionalInfo: {
                    'powerup_name': title,
                    'cost': cost,
                    'error': e.toString(),
                    'feature': 'store',
                  },
                );
                if (localContext.mounted) {
                  showTopSnackBar(
                      localContext,
                      AppLocalizations.of(context)!
                          .purchaseErrorString(e.toString()),
                      style: TopSnackBarStyle.error);
                }
              }
            } else {
              showTopSnackBar(
                  localContext, AppLocalizations.of(context)!.notEnoughStars,
                  style: TopSnackBarStyle.error);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20 : 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 16 : 12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (isDiscounted && discountAmount > 0) ...[
                            SizedBox(width: isDesktop ? 8 : 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 8 : 6,
                                vertical: isDesktop ? 2 : 1,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Colors.green[700]?.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      Colors.green[700]!.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_offer_rounded,
                                    color: Colors.green[700],
                                    size: getResponsiveFontSize(context, 10),
                                  ),
                                  SizedBox(width: isDesktop ? 2 : 1),
                                  Text(
                                    AppLocalizations.of(context)!.discount,
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: isDesktop ? 4 : 2),
                      Text(
                        description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Price display
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 16 : 12,
                        vertical: isDesktop ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
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
                            isDev
                                ? AppLocalizations.of(context)!.free
                                : '$cost',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
    required bool isDiscounted,
    required int discountAmount,
    required bool isDev,
    required GameStatsProvider gameStats,
    required SettingsProvider settings,
    required Set<String> unlocked,
    required String themeKey,
    required bool isDesktop,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isUnlocked = unlocked.contains(themeKey);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnlocked
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.1),
          width: isUnlocked ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
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
            AppLogger.info(
                'Theme purchase attempted: $title, theme: $themeKey, cost: $cost');
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
              try {
                final success = isDev
                    ? true
                    : await localGameStats.spendStarsWithTransaction(
                        amount: cost,
                        reason: 'Thema aankoop: $title',
                        metadata: {
                          'theme_name': title,
                          'theme_key': themeKey,
                          'feature': 'store',
                        },
                      );
                if (success) {
                  await localSettings.unlockTheme(themeKey);

                  // Apply the purchased theme immediately
                  await localSettings.setCustomTheme(themeKey);

                  // Trigger sync after successful purchase
                  await localGameStats.triggerSync();

                  if (!localContext.mounted) return;
                  final message =
                      '$title ${AppLocalizations.of(context)!.themeUnlockedWithSwitchOption}';
                  showTopSnackBar(localContext, message,
                      style: TopSnackBarStyle.success);
                } else {
                  // Auto-report transaction failure
                  await AutomaticErrorReporter.reportStorageError(
                    message: 'Failed to process theme purchase transaction',
                    userMessage: 'Failed to purchase theme',
                    operation: 'spend_stars',
                    additionalInfo: {
                      'theme_name': title,
                      'theme_key': themeKey,
                      'cost': cost,
                      'expected_amount': cost,
                      'feature': 'store',
                    },
                  );
                  if (localContext.mounted) {
                    showTopSnackBar(localContext,
                        AppLocalizations.of(context)!.purchaseFailed,
                        style: TopSnackBarStyle.error);
                  }
                }
              } catch (e) {
                // Auto-report the error
                await AutomaticErrorReporter.reportStorageError(
                  message: 'Error processing theme purchase: ${e.toString()}',
                  userMessage: 'Error processing theme purchase',
                  operation: 'spend_stars',
                  additionalInfo: {
                    'theme_name': title,
                    'theme_key': themeKey,
                    'cost': cost,
                    'error': e.toString(),
                    'feature': 'store',
                  },
                );
                if (localContext.mounted) {
                  showTopSnackBar(
                      localContext,
                      AppLocalizations.of(context)!
                          .purchaseErrorString(e.toString()),
                      style: TopSnackBarStyle.error);
                }
              }
            } else {
              showTopSnackBar(
                  localContext, AppLocalizations.of(context)!.notEnoughStars,
                  style: TopSnackBarStyle.error);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20 : 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 16 : 12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (isDiscounted && discountAmount > 0) ...[
                            SizedBox(width: isDesktop ? 8 : 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 8 : 6,
                                vertical: isDesktop ? 2 : 1,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Colors.green[700]?.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      Colors.green[700]!.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_offer_rounded,
                                    color: Colors.green[700],
                                    size: getResponsiveFontSize(context, 10),
                                  ),
                                  SizedBox(width: isDesktop ? 2 : 1),
                                  Text(
                                    AppLocalizations.of(context)!.discount,
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: isDesktop ? 4 : 2),
                      Text(
                        description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
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
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: colorScheme.primary,
                          size: getResponsiveFontSize(context, 20),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Price display
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 16 : 12,
                              vertical: isDesktop ? 8 : 6,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    colorScheme.primary.withValues(alpha: 0.2),
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
                                  isDev
                                      ? AppLocalizations.of(context)!.free
                                      : '$cost',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
    required bool isDiscounted,
    required int discountAmount,
    required bool isDev,
    required GameStatsProvider gameStats,
    required bool isDesktop,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
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
            final localContext = context;
            final localGameStats = gameStats;
            final canAfford = isDev || localGameStats.score >= cost;

            if (canAfford) {
              // Spend stars for AI theme generation
              bool transactionSuccess = false;
              try {
                transactionSuccess = isDev
                    ? true
                    : await localGameStats.spendStarsWithTransaction(
                        amount: cost,
                        reason: 'AI thema generator toegang',
                        metadata: {
                          'feature': 'ai_theme_generator_access',
                          'cost': cost,
                        },
                      );
                if (!transactionSuccess) {
                  await AutomaticErrorReporter.reportStorageError(
                    message:
                        'Failed to process AI theme generator access payment',
                    userMessage: 'Failed to process AI theme generator payment',
                    operation: 'spend_stars',
                    additionalInfo: {
                      'cost': cost,
                      'feature': 'ai_theme_generator',
                    },
                  );
                  if (localContext.mounted) {
                    showTopSnackBar(localContext,
                        AppLocalizations.of(context)!.purchaseFailed,
                        style: TopSnackBarStyle.error);
                  }
                  return;
                }
              } catch (e) {
                await AutomaticErrorReporter.reportStorageError(
                  message:
                      'Error processing AI theme generator access payment: ${e.toString()}',
                  userMessage: 'Error processing AI theme generator payment',
                  operation: 'spend_stars',
                  additionalInfo: {
                    'cost': cost,
                    'error': e.toString(),
                    'feature': 'ai_theme_generator',
                  },
                );
                if (localContext.mounted) {
                  showTopSnackBar(localContext,
                      AppLocalizations.of(context)!.paymentError(e.toString()),
                      style: TopSnackBarStyle.error);
                }
                return;
              }

              // Navigate to AI Theme Designer screen
              try {
                if (localContext.mounted) {
                  Navigator.of(localContext).push(
                    MaterialPageRoute(
                      builder: (_) => const AIThemeDesignerScreen(),
                    ),
                  );
                }
              } catch (navError) {
                // Auto-report navigation error
                await AutomaticErrorReporter.reportStorageError(
                  message:
                      'Failed to navigate to AI theme designer: ${navError.toString()}',
                  userMessage: 'Failed to open AI theme designer',
                  operation: 'navigation',
                  additionalInfo: {
                    'cost': cost,
                    'error': navError.toString(),
                    'feature': 'ai_theme_generator',
                  },
                );
                if (localContext.mounted) {
                  showTopSnackBar(
                      localContext,
                      AppLocalizations.of(context)!
                          .errorOpeningAiThemeGenerator,
                      style: TopSnackBarStyle.error);
                }
              }
            } else {
              showTopSnackBar(
                  localContext, AppLocalizations.of(context)!.notEnoughStars,
                  style: TopSnackBarStyle.error);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(isDesktop ? 20 : 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isDesktop ? 16 : 12),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          if (isDiscounted && discountAmount > 0) ...[
                            SizedBox(width: isDesktop ? 8 : 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 8 : 6,
                                vertical: isDesktop ? 2 : 1,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    Colors.green[700]?.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      Colors.green[700]!.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_offer_rounded,
                                    color: Colors.green[700],
                                    size: getResponsiveFontSize(context, 10),
                                  ),
                                  SizedBox(width: isDesktop ? 2 : 1),
                                  Text(
                                    AppLocalizations.of(context)!.discount,
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: isDesktop ? 4 : 2),
                      Text(
                        description,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isDesktop ? 16 : 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Price display
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 16 : 12,
                        vertical: isDesktop ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
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
                            isDev
                                ? AppLocalizations.of(context)!.free
                                : '$cost',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCouponCard(
    BuildContext context, {
    required bool isDesktop,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isDesktop ? 12 : 10),
          decoration: BoxDecoration(
            color: Colors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.confirmation_number_rounded,
            color: Colors.teal,
            size: getResponsiveFontSize(context, 20),
          ),
        ),
        SizedBox(width: isDesktop ? 16 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.couponTitle,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.couponDescription,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: isDesktop ? 16 : 12),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CouponRedeemScreen()),
          ),
          icon: const Icon(Icons.redeem_rounded, size: 20),
          label: Text(AppLocalizations.of(context)!.couponRedeem),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 24 : 20,
              vertical: isDesktop ? 14 : 12,
            ),
          ),
        ),
      ],
    );
  }
}
