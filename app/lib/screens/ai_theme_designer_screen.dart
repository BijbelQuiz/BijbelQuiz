import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import '../providers/game_stats_provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/top_snackbar.dart';
import '../l10n/strings_nl.dart' as strings;
import '../services/logger.dart';
import '../services/gemini_service.dart';
import '../models/ai_theme.dart';

class AIThemeDesignerScreen extends StatefulWidget {
  const AIThemeDesignerScreen({super.key});

  @override
  State<AIThemeDesignerScreen> createState() => _AIThemeDesignerScreenState();
}

class _AIThemeDesignerScreenState extends State<AIThemeDesignerScreen> {
  final TextEditingController _themeController = TextEditingController();
  bool _isGenerating = false;
  String _generationStatus = '';

  @override
  void initState() {
    super.initState();
    AppLogger.info('AIThemeDesignerScreen initialized');
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.screen(context, 'AIThemeDesignerScreen');
    
    // Track AI theme designer access
    analyticsService.trackFeatureStart(
      context, 
      AnalyticsService.FEATURE_AI_THEME_GENERATOR
    );
  }

  @override
  void dispose() {
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gameStats = Provider.of<GameStatsProvider>(context);
    final settings = Provider.of<SettingsProvider>(context);
    final isDev = kDebugMode; // Use kDebugMode to enable dev mode
    final cost = 200; // Standard cost for AI theme generation

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                color: Colors.purple,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strings.AppStrings.aiThemeGenerator,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header section with stars display
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
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
                                const SizedBox(width: 8),
                                Text(
                                  '${gameStats.score}',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
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
                      
                      const SizedBox(height: 24),
                      
                      // Cost information
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withAlpha((0.2 * 255).round()),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_rounded,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'AI thema generatie kost ${isDev ? '0' : cost} sterren',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Instruction text
                      Text(
                        'Beschrijf het thema dat je wilt laten maken door AI:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Bijvoorbeeld: "Een blauw thema met gouden accenten, geïnspireerd op de oceaan..."',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withAlpha((0.6 * 255).round()),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Text input field
                      TextField(
                        controller: _themeController,
                        maxLines: 5,
                        enabled: !_isGenerating,
                        decoration: InputDecoration(
                          hintText: 'Beschrijf hier jouw gewenste thema...',
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
                      
                      // Generation status
                      if (_isGenerating) ...[
                        LinearProgressIndicator(
                          backgroundColor: colorScheme.primary.withAlpha((0.1 * 255).round()),
                          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _generationStatus,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Generate button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: _isGenerating 
                    ? null 
                    : () async {
                        await _generateAITheme(
                          context, 
                          _themeController, 
                          gameStats, 
                          cost, 
                          isDev
                        );
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _isGenerating ? 'Aan het genereren...' : 'Genereer Thema', 
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _generateAITheme(
    BuildContext context,
    TextEditingController themeController,
    GameStatsProvider gameStats,
    int cost,
    bool isDev,
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
    final success = isDev ? true : await gameStats.spendStarsWithTransaction(
      amount: cost,
      reason: 'AI thema generatie',
      metadata: {
        'description': description,
        'feature': 'ai_theme_generator',
      },
    );
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
       // AI theme generation enabled since feature flags removed

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

      // Show success message and theme preview dialog after a short delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (context.mounted) {
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
          await gameStats.addStarsWithTransaction(
            amount: cost,
            reason: 'Terugbetaling AI thema (fout)',
            metadata: {
              'original_transaction': 'ai_theme_generation',
              'error': e.toString(),
            },
          );
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

// Extension for capitalizing strings
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}