import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/analytics_service.dart';
import '../providers/multiplayer_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/game_stats_provider.dart';
import 'multiplayer_waiting_room_screen.dart';
import 'sync_screen.dart';

/// Screen for setting up a multiplayer game
class MultiplayerGameSetupScreen extends StatefulWidget {
  const MultiplayerGameSetupScreen({super.key});

  @override
  State<MultiplayerGameSetupScreen> createState() =>
      _MultiplayerGameSetupScreenState();
}

class _MultiplayerGameSetupScreenState
    extends State<MultiplayerGameSetupScreen> {
  final TextEditingController _gameCodeController = TextEditingController();
  bool _isCreatingGame = false;
  bool _isJoiningGame = false;
  String? _errorMessage;
  final int _selectedQuestionTime = 20; // Default 20 seconds
  int _selectedNumQuestions = 10; // Default 10 questions
  bool _useQuestionLimit = true; // true = limit by questions, false = limit by time
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    final analyticsService =
        Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.screen(context, 'MultiplayerGameSetupScreen');
    analyticsService.trackFeatureStart(
        context, AnalyticsService.featureMultiplayerGame);

    // Check authentication status
    _checkAuthState();
  }

  void _checkAuthState() {
    final gameStatsProvider = Provider.of<GameStatsProvider>(context, listen: false);
    final syncService = gameStatsProvider.syncService;

    // Check if user has a profile (indicating they're authenticated)
    syncService.getCurrentUserProfile().then((userProfile) {
      if (mounted) {
        setState(() {
          _isAuthenticated = userProfile != null;
        });

        // Redirect to sync screen if not authenticated
        if (!_isAuthenticated) {
          _navigateToSyncScreen();
        }
      }
    }).catchError((e) {
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
        });
        _navigateToSyncScreen();
      }
    });
  }

  void _navigateToSyncScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const SyncScreen(requiredForMultiplayer: true),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _gameCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Show loading while checking authentication
    if (!_isAuthenticated) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Multiplayer Quiz',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Game mode description
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.people,
                        size: 48,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Online Multiplayer Quiz',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Speel tegen anderen online! Creëer een spel of join met een game code.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Create Game Section
                Text(
                  'Start een nieuw spel',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Game Settings
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spel instellingen',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 16),

                      // Game limit type selection
                      Text(
                        'Beëindig spel door:',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Material(
                              color: _useQuestionLimit
                                  ? colorScheme.primary.withValues(alpha: 0.1)
                                  : colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: () => setState(() => _useQuestionLimit = true),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _useQuestionLimit
                                          ? colorScheme.primary
                                          : colorScheme.outline.withValues(alpha: 0.3),
                                      width: _useQuestionLimit ? 2 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Aantal vragen',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: _useQuestionLimit
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: _useQuestionLimit
                                              ? colorScheme.primary
                                              : colorScheme.onSurface,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Material(
                              color: !_useQuestionLimit
                                  ? colorScheme.primary.withValues(alpha: 0.1)
                                  : colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              child: InkWell(
                                onTap: () => setState(() => _useQuestionLimit = false),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: !_useQuestionLimit
                                          ? colorScheme.primary
                                          : colorScheme.outline.withValues(alpha: 0.3),
                                      width: !_useQuestionLimit ? 2 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    'Tijd limiet',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: !_useQuestionLimit
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: !_useQuestionLimit
                                              ? colorScheme.primary
                                              : colorScheme.onSurface,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Conditional settings based on limit type
                      if (_useQuestionLimit) ...[
                        // Number of questions
                        Text(
                          'Aantal vragen',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [5, 10, 15, 20].map((num) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              child: Material(
                                color: _selectedNumQuestions == num
                                    ? colorScheme.primary.withValues(alpha: 0.1)
                                    : colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () => setState(() => _selectedNumQuestions = num),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _selectedNumQuestions == num
                                            ? colorScheme.primary
                                            : colorScheme.outline.withValues(alpha: 0.3),
                                        width: _selectedNumQuestions == num ? 2 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      '$num',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: _selectedNumQuestions == num
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: _selectedNumQuestions == num
                                                ? colorScheme.primary
                                                : colorScheme.onSurface,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ] else ...[
                        // Time limit
                        Text(
                          'Tijd limiet (minuten)',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [1, 3, 5, 10].map((minutes) => Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              child: Material(
                                color: _selectedNumQuestions == minutes
                                    ? colorScheme.primary.withValues(alpha: 0.1)
                                    : colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  onTap: () => setState(() => _selectedNumQuestions = minutes),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _selectedNumQuestions == minutes
                                            ? colorScheme.primary
                                            : colorScheme.outline.withValues(alpha: 0.3),
                                        width: _selectedNumQuestions == minutes ? 2 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      '$minutes',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: _selectedNumQuestions == minutes
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: _selectedNumQuestions == minutes
                                                ? colorScheme.primary
                                                : colorScheme.onSurface,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _isCreatingGame ? null : _createGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isCreatingGame
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: Text(
                    _isCreatingGame ? 'Spel maken...' : 'Spel starten',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                const SizedBox(height: 32),

                // Join Game Section
                Text(
                  'Join een bestaand spel',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _gameCodeController,
                  decoration: InputDecoration(
                    labelText: 'Game Code (6 letters)',
                    hintText: 'Voer de 6-letter code in',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorText: _errorMessage,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 6,
                  onChanged: (value) {
                    setState(() {
                      _errorMessage = null;
                    });
                  },
                ),

                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _isJoiningGame ? null : _joinGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondary,
                    foregroundColor: colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _isJoiningGame
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    _isJoiningGame ? 'Verbinden...' : 'Join Spel',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),

                const SizedBox(height: 32),

                // Game rules
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Spelregels:',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      _buildRuleItem('• Maximaal 50 spelers per spel'),
                      _buildRuleItem('• 20 seconden per vraag om te antwoorden'),
                      _buildRuleItem('• Snellere antwoorden geven bonuspunten'),
                      _buildRuleItem('• Organizer bepaalt wanneer het spel begint'),
                      _buildRuleItem('• Organizer gaat door naar volgende vragen'),
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

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Future<void> _createGame() async {
    setState(() {
      _isCreatingGame = true;
      _errorMessage = null;
    });

    try {
      final settings = Provider.of<SettingsProvider>(context, listen: false);
      final multiplayerProvider = Provider.of<MultiplayerProvider>(context, listen: false);

      // Get current user info from sync service
      final syncService = Provider.of<GameStatsProvider>(context, listen: false).syncService;
      final userProfile = await syncService.getCurrentUserProfile();
      if (userProfile == null) {
        setState(() {
          _errorMessage = 'Kon gebruikersprofiel niet laden';
          _isCreatingGame = false;
        });
        return;
      }

      final gameCode = await multiplayerProvider.createGameSession(
        organizerId: userProfile['user_id'],
        organizerName: userProfile['username'] ?? 'Anoniem',
        numQuestions: _useQuestionLimit ? _selectedNumQuestions : null,
        timeLimitMinutes: !_useQuestionLimit ? _selectedNumQuestions : null,
        questionTimeSeconds: _selectedQuestionTime,
      );

      if (gameCode != null) {
        final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
        analyticsService.capture(context, 'create_multiplayer_game', properties: {
          'game_code': gameCode,
        });

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const MultiplayerWaitingRoomScreen(),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Kon spel niet maken';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fout bij maken spel: $e';
      });
    } finally {
      setState(() {
        _isCreatingGame = false;
      });
    }
  }

  Future<void> _joinGame() async {
    final gameCode = _gameCodeController.text.trim().toUpperCase();

    if (gameCode.length != 6) {
      setState(() {
        _errorMessage = 'Game code moet 6 letters bevatten';
      });
      return;
    }

    setState(() {
      _isJoiningGame = true;
      _errorMessage = null;
    });

    try {
      final multiplayerProvider = Provider.of<MultiplayerProvider>(context, listen: false);

      // Get current user info from sync service
      final syncService = Provider.of<GameStatsProvider>(context, listen: false).syncService;
      final userProfile = await syncService.getCurrentUserProfile();
      if (userProfile == null) {
        setState(() {
          _errorMessage = 'Kon gebruikersprofiel niet laden';
          _isJoiningGame = false;
        });
        return;
      }

      final success = await multiplayerProvider.joinGameSession(
        gameCode,
        userProfile['user_id'],
        userProfile['username'] ?? 'Anoniem',
      );

      if (success) {
        final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
        analyticsService.capture(context, 'join_multiplayer_game', properties: {
          'game_code': gameCode,
        });

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const MultiplayerWaitingRoomScreen(),
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage = 'Kon spel niet joinen - controleer de game code';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fout bij joinen spel: $e';
      });
    } finally {
      setState(() {
        _isJoiningGame = false;
      });
    }
  }
}
