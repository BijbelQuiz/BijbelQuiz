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
import '../utils/automatic_error_reporter.dart';
import '../services/store_service.dart';
import '../services/connection_service.dart';
import '../models/store_item.dart';

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
  List<StoreItem> _storeItems = [];
  bool _isLoadingItems = true;
  StoreErrorType? _errorType;
  String? _errorMessage;
  late ConnectionService _connectionService;

  @override
  void initState() {
    super.initState();
    AppLogger.info('StoreScreen initialized');
    _connectionService = ConnectionService();
    final analyticsService =
        Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.screen(context, 'StoreScreen');

    // Track store access
    analyticsService.trackFeatureStart(
        context, AnalyticsService.featureThemePurchases);

    // Load store items from Supabase
    _loadStoreItems();
  }

  Future<void> _loadStoreItems() async {
    try {
      setState(() {
        _isLoadingItems = true;
        _errorType = null;
        _errorMessage = null;
      });

      final storeService = StoreService();
      final items = await storeService.getStoreItems();

      setState(() {
        _storeItems = items;
        _isLoadingItems = false;
      });

      AppLogger.info('Loaded ${items.length} store items from database');
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      StoreErrorType errorType;
      String userMessage;

      // First check actual connectivity status
      await _connectionService.checkConnection();

      if (!_connectionService.isConnected) {
        errorType = StoreErrorType.network;
        userMessage =
            'Geen internetverbinding beschikbaar. Controleer je Wi-Fi of mobiele data en probeer het opnieuw.';
      } else if (errorString.contains('network') ||
          errorString.contains('connection') ||
          errorString.contains('timeout') ||
          errorString.contains('socket') ||
          errorString.contains('dns')) {
        errorType = StoreErrorType.network;
        userMessage =
            'Geen internetverbinding beschikbaar. Controleer je netwerk en probeer het opnieuw.';
      } else if (errorString.contains('server') ||
          errorString.contains('500') ||
          errorString.contains('502') ||
          errorString.contains('503') ||
          errorString.contains('504')) {
        errorType = StoreErrorType.server;
        userMessage =
            'De server is tijdelijk niet beschikbaar. Probeer het later opnieuw.';
      } else {
        errorType = StoreErrorType.unknown;
        userMessage =
            'Er is een fout opgetreden bij het laden van de winkel. Probeer het opnieuw.';
      }

      setState(() {
        _isLoadingItems = false;
        _errorType = errorType;
        _errorMessage = userMessage;
      });

      AppLogger.error('Error loading store items: $e');
    }
  }

  // Helper methods to get item prices by key
  int _getPriceByKey(String key) {
    final item = _storeItems.firstWhere((item) => item.itemKey == key,
        orElse: () => StoreItem(
              itemKey: key,
              itemName: '',
              itemDescription: '',
              itemType: '',
              basePrice: 0,
              currentPrice: 0,
              isDiscounted: false,
              discountPercentage: 0,
              isActive: true,
              discountStart: null,
              discountEnd: null,
            ));

    return item.currentPrice;
  }

  bool _isDiscountedByKey(String key) {
    final item = _storeItems.firstWhere((item) => item.itemKey == key,
        orElse: () => StoreItem(
              itemKey: key,
              itemName: '',
              itemDescription: '',
              itemType: '',
              basePrice: 0,
              currentPrice: 0,
              isDiscounted: false,
              discountPercentage: 0,
              isActive: true,
              discountStart:
                  null, // Add these to ensure isCurrentlyDiscounted works properly
              discountEnd: null,
            ));

    return item.isCurrentlyDiscounted;
  }

  int _getDiscountAmountByKey(String key) {
    final item = _storeItems.firstWhere((item) => item.itemKey == key,
        orElse: () => StoreItem(
              itemKey: key,
              itemName: '',
              itemDescription: '',
              itemType: '',
              basePrice: 0,
              currentPrice: 0,
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
    final unlocked = settings.unlockedThemes;
    final isDev = kDebugMode;

    // Responsive design
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

    // Show loading screen while fetching store items
    if (_isLoadingItems) {
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
                strings.AppStrings.store,
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
    if (_errorType != null) {
      IconData errorIcon;
      String errorTitle;
      Color errorColor;

      switch (_errorType!) {
        case StoreErrorType.network:
          errorIcon = Icons.wifi_off_rounded;
          errorTitle = 'Geen internetverbinding';
          errorColor = Colors.orange[700]!;
          break;
        case StoreErrorType.server:
          errorIcon = Icons.cloud_off_rounded;
          errorTitle = 'Server niet beschikbaar';
          errorColor = Colors.red[700]!;
          break;
        case StoreErrorType.unknown:
          errorIcon = Icons.error_outline_rounded;
          errorTitle = 'Fout bij laden winkel';
          errorColor = colorScheme.error;
          break;
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
                strings.AppStrings.store,
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
                      _errorMessage!,
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
                          onPressed: _loadStoreItems,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Opnieuw proberen'),
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
                        if (_errorType == StoreErrorType.network) ...[
                          SizedBox(height: isDesktop ? 16 : 12),
                          TextButton.icon(
                            onPressed: () async {
                              // Check connection again and show status
                              await _connectionService.checkConnection();
                              final isNowConnected =
                                  _connectionService.isConnected;

                              String message;
                              if (isNowConnected) {
                                message =
                                    'Verbinding hersteld! Probeer de winkel te laden.';
                              } else {
                                message =
                                    'Nog steeds geen verbinding. Controleer je Wi-Fi of mobiele data.';
                              }

                              if (!context.mounted) return;
                              showTopSnackBar(
                                context,
                                message,
                                style: isNowConnected
                                    ? TopSnackBarStyle.success
                                    : TopSnackBarStyle.info,
                              );
                            },
                            icon: const Icon(Icons.wifi_find_rounded),
                            label: const Text('Controleer verbinding'),
                            style: TextButton.styleFrom(
                              foregroundColor: colorScheme.primary,
                            ),
                          ),
                        ],
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
              strings.AppStrings.store,
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
        onRefresh: _loadStoreItems,
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
                            strings.AppStrings.availableStars,
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
                      cost: _getPriceByKey('double_stars_5_questions'),
                      isDiscounted:
                          _isDiscountedByKey('double_stars_5_questions'),
                      discountAmount:
                          _getDiscountAmountByKey('double_stars_5_questions'),
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
                      cost: _getPriceByKey('triple_stars_5_questions'),
                      isDiscounted:
                          _isDiscountedByKey('triple_stars_5_questions'),
                      discountAmount:
                          _getDiscountAmountByKey('triple_stars_5_questions'),
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
                      description:
                          strings.AppStrings.fiveTimesStars5QuestionsDesc,
                      icon: Icons.flash_on_rounded,
                      iconColor: Colors.redAccent,
                      cost: _getPriceByKey('five_times_stars_5_questions'),
                      isDiscounted:
                          _isDiscountedByKey('five_times_stars_5_questions'),
                      discountAmount: _getDiscountAmountByKey(
                          'five_times_stars_5_questions'),
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
                      cost: _getPriceByKey('double_stars_60_seconds'),
                      isDiscounted:
                          _isDiscountedByKey('double_stars_60_seconds'),
                      discountAmount:
                          _getDiscountAmountByKey('double_stars_60_seconds'),
                      isDev: isDev,
                      gameStats: gameStats,
                      isDesktop: isDesktop,
                      onPurchase: () {
                        gameStats.activatePowerup(
                            multiplier: 2, time: Duration(seconds: 60));
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
                      cost: _getPriceByKey('oled_theme'),
                      isDiscounted: _isDiscountedByKey('oled_theme'),
                      discountAmount: _getDiscountAmountByKey('oled_theme'),
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
                      cost: _getPriceByKey('green_theme'),
                      isDiscounted: _isDiscountedByKey('green_theme'),
                      discountAmount: _getDiscountAmountByKey('green_theme'),
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
                      cost: _getPriceByKey('orange_theme'),
                      isDiscounted: _isDiscountedByKey('orange_theme'),
                      discountAmount: _getDiscountAmountByKey('orange_theme'),
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
                      title: 'Kerst Thema',
                      description:
                          'Een feestelijk kerstthema met rode en groene kleuren',
                      icon: Icons.card_giftcard_rounded,
                      iconColor: Colors.red[700]!,
                      cost: _getPriceByKey('christmas_theme'),
                      isDiscounted: _isDiscountedByKey('christmas_theme'),
                      discountAmount:
                          _getDiscountAmountByKey('christmas_theme'),
                      isDev: isDev,
                      gameStats: gameStats,
                      settings: settings,
                      unlocked: unlocked,
                      themeKey: 'christmas',
                      isDesktop: isDesktop,
                    ),

                    SizedBox(height: isDesktop ? 16 : 12),

                    _buildAIThemeCard(
                      context,
                      title: strings.AppStrings.aiThemeGenerator,
                      description:
                          strings.AppStrings.aiThemeGeneratorDescription,
                      icon: Icons.smart_toy_rounded,
                      iconColor: Colors.purple,
                      cost: _getPriceByKey('ai_theme_generator'),
                      isDiscounted: _isDiscountedByKey('ai_theme_generator'),
                      discountAmount:
                          _getDiscountAmountByKey('ai_theme_generator'),
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

            final analytics =
                Provider.of<AnalyticsService>(context, listen: false);
            analytics.capture(context, 'purchase_powerup',
                properties: {'title': title, 'cost': cost});
            analytics.trackFeaturePurchase(
                context, AnalyticsService.featurePowerUps,
                additionalProperties: {
                  'powerup_type': title,
                  'cost': cost,
                  'current_score': gameStats.score,
                });
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
                            child: Text('Naar de quiz',
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
                    showTopSnackBar(
                        localContext, 'Aankoop mislukt, probeer het opnieuw',
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
                      localContext, 'Fout bij aankoop: ${e.toString()}',
                      style: TopSnackBarStyle.error);
                }
              }
            } else {
              showTopSnackBar(localContext, 'Niet genoeg sterren!',
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
                                    'Korting!',
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
                            isDev ? 'Gratis' : '$cost',
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
            final analytics =
                Provider.of<AnalyticsService>(context, listen: false);
            analytics.capture(context, 'purchase_theme',
                properties: {'theme': themeKey, 'cost': cost});
            analytics.trackFeaturePurchase(
                context, AnalyticsService.featureThemePurchases,
                additionalProperties: {
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
                  if (!localContext.mounted) return;
                  final message = '$title ontgrendeld!';
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
                    showTopSnackBar(
                        localContext, 'Aankoop mislukt, probeer het opnieuw',
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
                      localContext, 'Fout bij aankoop: ${e.toString()}',
                      style: TopSnackBarStyle.error);
                }
              }
            } else {
              showTopSnackBar(localContext, 'Niet genoeg sterren!',
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
                                    'Korting!',
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
                                  isDev ? 'Gratis' : '$cost',
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
            final analytics =
                Provider.of<AnalyticsService>(context, listen: false);
            analytics.capture(context, 'ai_theme_generator_tapped',
                properties: {'cost': cost});
            analytics.trackFeatureAttempt(
                context, AnalyticsService.featureAiThemeGenerator,
                additionalProperties: {
                  'cost': cost,
                  'current_score': gameStats.score,
                });
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
                    showTopSnackBar(
                        localContext, 'Aankoop mislukt, probeer het opnieuw',
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
                  showTopSnackBar(
                      localContext, 'Fout bij betaling: ${e.toString()}',
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
                      localContext, 'Fout bij openen van AI thema generator',
                      style: TopSnackBarStyle.error);
                }
              }
            } else {
              showTopSnackBar(localContext, 'Niet genoeg sterren!',
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
                                    'Korting!',
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
                            isDev ? 'Gratis' : '$cost',
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
}
