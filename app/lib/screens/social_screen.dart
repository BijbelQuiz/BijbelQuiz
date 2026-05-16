import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bijbelquiz/l10n/app_localizations.dart';
import 'sync_screen.dart';
import '../services/logger.dart';
import '../services/messaging_service.dart';
import '../utils/automatic_error_reporter.dart';
import '../config/supabase_config.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  late MessagingService _messagingService;

  User? _currentUser;
  List<Message> _activeMessages = [];
  bool _isLoadingMessages = true;
  String? _errorMessage;

  final Map<String, List<ReactionCount>> _messageReactions = {};
  final Map<String, String?> _userReactions = {};
  final List<String> _availableEmojis = ['👍', '❤️', '😊', '😢', '😮', '😡'];

  Widget _getIconForEmoji(String emoji, Color color) {
    IconData iconData;
    switch (emoji) {
      case '👍':
        iconData = Icons.thumb_up_outlined;
        break;
      case '❤️':
        iconData = Icons.favorite_outline;
        break;
      case '😊':
        iconData = Icons.sentiment_satisfied_alt_outlined;
        break;
      case '😢':
        iconData = Icons.sentiment_dissatisfied_outlined;
        break;
      case '😮':
        iconData = Icons.sentiment_neutral_outlined;
        break;
      case '😡':
        iconData = Icons.sentiment_very_dissatisfied_outlined;
        break;
      default:
        iconData = Icons.error_outline;
    }
    return Icon(iconData, size: 20, color: color);
  }

  @override
  void initState() {
    super.initState();
    _messagingService = Provider.of<MessagingService>(context, listen: false);
    _checkAuthState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_currentUser == null) {
        _navigateToSyncScreen();
      } else {
        _loadMessages();
      }
    });
  }

  void _checkAuthState() {
    try {
      final user = SupabaseConfig.maybeClient?.auth.currentUser;
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      AppLogger.error('Error checking auth state', e);
      setState(() {
        _currentUser = null;
      });
    }
  }

  Future<void> _loadMessages() async {
    try {
      setState(() {
        _isLoadingMessages = true;
        _errorMessage = null;
      });

      final messages = await _messagingService.getActiveMessages();
      await _loadReactionsForMessages(messages);

      if (mounted) {
        setState(() {
          _activeMessages = messages;
          _isLoadingMessages = false;
        });
      }
    } catch (e) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Error loading messages in SocialScreen',
        additionalInfo: {'error': e.toString()},
      );
      if (mounted) {
        setState(() {
          _isLoadingMessages = false;
          _errorMessage = AppLocalizations.of(context)!.errorLoadingMessages;
        });
      }
    }
  }

  Future<void> _loadReactionsForMessages(List<Message> messages) async {
    final newMessageReactions = <String, List<ReactionCount>>{};
    final newUserReactions = <String, String?>{};

    for (final message in messages) {
      try {
        final reactionCounts =
            await _messagingService.getMessageReactionCounts(message.id);
        newMessageReactions[message.id] = reactionCounts;

        final userReaction =
            await _messagingService.getUserMessageReaction(message.id, null);
        newUserReactions[message.id] = userReaction;
      } catch (e) {
        debugPrint('Error loading reactions for message ${message.id}: $e');
      }
    }

    if (mounted) {
      setState(() {
        _messageReactions.addAll(newMessageReactions);
        _userReactions.addAll(newUserReactions);
      });
    }
  }

  Future<void> _handleReaction(String messageId, String emoji) async {
    try {
      final result = await _messagingService.toggleMessageReaction(
        messageId: messageId,
        userId: null,
        emoji: emoji,
      );

      if (mounted) {
        setState(() {
          if (result.action == 'removed') {
            _userReactions[messageId] = null;
          } else {
            _userReactions[messageId] = result.userReaction;
          }
        });
      }

      final updatedCounts =
          await _messagingService.getMessageReactionCounts(messageId);
      if (mounted) {
        setState(() {
          _messageReactions[messageId] = updatedCounts;
        });
      }

      final currentUserId = _messagingService.getCurrentUserId();
      if (mounted && currentUserId != null) {
      }
    } catch (e) {
      AppLogger.error(
          'Failed to update reaction for message $messageId with emoji $emoji',
          e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(AppLocalizations.of(context)!.errorUpdatingReaction)),
        );
      }

      AutomaticErrorReporter.reportStorageError(
        message: 'Error handling message reaction',
        additionalInfo: {
          'message_id': messageId,
          'emoji': emoji,
          'error': e.toString(),
        },
      );
    }
  }

  int _getReactionCount(String messageId, String emoji) {
    final reactions = _messageReactions[messageId];
    if (reactions == null) return 0;

    final reaction = reactions.firstWhere(
      (r) => r.emoji == emoji,
      orElse: () => ReactionCount(emoji: emoji, count: 0),
    );

    return reaction.count;
  }

  bool _hasUserReactedWith(String messageId, String emoji) {
    final userReaction = _userReactions[messageId];
    return userReaction == emoji;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAuthState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (_currentUser == null) {
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
                Icons.group_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.social,
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen = constraints.maxWidth > 600;
            final horizontalPadding = isLargeScreen ? 24.0 : 16.0;
            final maxContainerWidth =
                isLargeScreen ? 600.0 : constraints.maxWidth;

            return RefreshIndicator(
              onRefresh: () {
                return _loadMessages();
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: maxContainerWidth,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBqidManagementCard(colorScheme, textTheme),
                        const SizedBox(height: 24),
                        _buildMessagesSection(colorScheme, textTheme),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBqidManagementCard(
      ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SyncScreen(),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_add,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.manageYourBqid,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context)!.manageYourBqidSubtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Semantics(
                  label: AppLocalizations.of(context)!.openBQIDSettings,
                  excludeSemantics: true,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessagesSection(ColorScheme colorScheme, TextTheme textTheme) {
    if (_errorMessage != null) {
      return _buildErrorCard(colorScheme, textTheme);
    }

    if (_isLoadingMessages) {
      return _buildLoadingIndicator(colorScheme);
    }

    if (_activeMessages.isEmpty) {
      return _buildEmptyMessagesCard(colorScheme, textTheme);
    }

    return Column(
      children: [
        ..._activeMessages.map(
          (message) => _buildMessageCard(message, colorScheme, textTheme),
        ),
      ],
    );
  }

  Widget _buildErrorCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      color: colorScheme.errorContainer,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Semantics(
              label: AppLocalizations.of(context)!
                  .sectionIcon(AppLocalizations.of(context)!.manageYourBqid),
              excludeSemantics: true,
              child: Icon(
                Icons.person_add,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ??
                  AppLocalizations.of(context)!.errorLoadingMessages,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onErrorContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMessages,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.loadingMessages),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMessagesCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      color: colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.message_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noActiveMessages,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.noActiveMessagesSubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageCard(
      Message message, ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            if (message.createdBy != null && message.createdBy!.isNotEmpty)
              Text(
                message.createdBy!,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              const SizedBox.shrink(),
            if (message.createdBy != null && message.createdBy!.isNotEmpty)
              const SizedBox(height: 12),
            Text(
              message.content,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            _buildEmojiReactionsRow(message, colorScheme, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildEmojiReactionsRow(
      Message message, ColorScheme colorScheme, TextTheme textTheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: _availableEmojis.map((emoji) {
        final isReacted = _hasUserReactedWith(message.id, emoji);
        final count = _getReactionCount(message.id, emoji);

        return Semantics(
          button: true,
          label: AppLocalizations.of(context)!.reactionButton(
              emoji, count, isReacted ? 'selected' : 'not_selected'),
          child: InkWell(
            onTap: () => _handleReaction(message.id, emoji),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isReacted
                    ? colorScheme.primaryContainer
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isReacted
                    ? Border.all(color: colorScheme.primary, width: 1)
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getIconForEmoji(
                    emoji,
                    isReacted
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      count.toString(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: isReacted
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _navigateToSyncScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SyncScreen(requiredForSocial: true),
      ),
    );
  }
}
