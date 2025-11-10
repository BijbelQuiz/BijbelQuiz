import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/messaging_service.dart';
import '../services/analytics_service.dart';
import '../l10n/strings_nl.dart' as strings;
import '../utils/automatic_error_reporter.dart';
// Remove this relative import as it's incorrect

/// Screen to display admin messages to the users
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  late MessagingService _messagingService;
  late AnalyticsService _analyticsService;
  List<Message> _activeMessages = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  // Reaction data - maps messageId to list of reaction counts
  final Map<String, List<ReactionCount>> _messageReactions = {};
  // Maps messageId to the current user's reaction emoji
  final Map<String, String?> _userReactions = {};
  
  // Available emojis for reactions
  final List<String> _availableEmojis = ['👍', '❤️', '😊', '😢', '😮', '😡'];

  @override
  void initState() {
    super.initState();
    _messagingService = Provider.of<MessagingService>(context, listen: false);
    _analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    _loadMessages();
    _analyticsService.screen(context, 'MessagesScreen');
    _analyticsService.trackFeatureUsage(context, 'messaging', 'screen_accessed');
  }

  /// Load all active messages from the database
  Future<void> _loadMessages() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final messages = await _messagingService.getActiveMessages();
      
      // Load reaction data for all messages
      await _loadReactionsForMessages(messages);
      
      if (mounted) {
        _messagingService.trackMessagesViewed(_analyticsService, context);
        setState(() {
          _activeMessages = messages;
          _isLoading = false;
        });
      }
    } catch (e) {
      AutomaticErrorReporter.reportStorageError(
        message: 'Error loading messages in MessagesScreen',
        additionalInfo: {'error': e.toString()},
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = strings.AppStrings.errorLoadingMessages;
        });
      }
    }
  }

  /// Load reactions for all messages
  Future<void> _loadReactionsForMessages(List<Message> messages) async {
    final currentUserId = _messagingService.getCurrentUserId();
    // Use anonymous user ID for anonymous users
    final effectiveUserId = currentUserId ?? 'anonymous_user_2024';
    
    final newMessageReactions = <String, List<ReactionCount>>{};
    final newUserReactions = <String, String?>{};
    
    for (final message in messages) {
      try {
        // Load reaction counts
        final reactionCounts = await _messagingService.getMessageReactionCounts(message.id);
        newMessageReactions[message.id] = reactionCounts;
        
        // Load current user's reaction (works for both authenticated and anonymous)
        final userReaction = await _messagingService.getUserMessageReaction(message.id, effectiveUserId);
        newUserReactions[message.id] = userReaction;
      } catch (e) {
        // Log error but continue loading other messages
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

  /// Handles emoji reaction on a message
  Future<void> _handleReaction(String messageId, String emoji) async {
    final currentUserId = _messagingService.getCurrentUserId();

    try {
      // Show loading state for this specific message
      if (mounted) {
        setState(() {
          // Could add a loading state for the reaction button if needed
        });
      }

      final result = await _messagingService.toggleMessageReaction(
        messageId: messageId,
        userId: currentUserId, // This can be null for anonymous users
        emoji: emoji,
      );

      // Update local state based on the result
      if (mounted) {
        setState(() {
          if (result.action == 'removed') {
            // Remove user's reaction
            _userReactions[messageId] = null;
          } else {
            // User has a reaction now
            _userReactions[messageId] = result.userReaction;
          }
        });
      }

      // Reload reaction counts for this message
      final updatedCounts = await _messagingService.getMessageReactionCounts(messageId);
      if (mounted) {
        setState(() {
          _messageReactions[messageId] = updatedCounts;
        });
      }

      // Track analytics (only for authenticated users)
      if (mounted && currentUserId != null) {
        _analyticsService.trackFeatureUsage(
          context,
          'messaging',
          'message_reaction_${result.action}',
          additionalProperties: {
            'message_id': messageId,
            'emoji': emoji,
            'action': result.action,
          },
        );
      }

    } catch (e) {
      // Show error feedback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update reaction: $e')),
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

  /// Gets the count for a specific emoji on a message
  int _getReactionCount(String messageId, String emoji) {
    final reactions = _messageReactions[messageId];
    if (reactions == null) return 0;
    
    final reaction = reactions.firstWhere(
      (r) => r.emoji == emoji,
      orElse: () => ReactionCount(emoji: emoji, count: 0),
    );
    
    return reaction.count;
  }

  /// Checks if the current user has reacted with a specific emoji
  bool _hasUserReactedWith(String messageId, String emoji) {
    final userReaction = _userReactions[messageId];
    return userReaction == emoji;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
                Icons.message_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strings.AppStrings.messages,
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.onSurface),
            onPressed: () {
              _messagingService.trackMessagesRefreshed(_analyticsService, context);
              _loadMessages();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen = constraints.maxWidth > 600;
            final horizontalPadding = isLargeScreen ? 24.0 : 16.0;
            final maxContainerWidth = isLargeScreen ? 600.0 : constraints.maxWidth;

            return RefreshIndicator(
              onRefresh: () {
                _messagingService.trackMessagesRefreshed(_analyticsService, context);
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
                        if (_errorMessage != null)
                          _buildErrorCard(colorScheme, textTheme)
                        else if (_isLoading)
                          _buildLoadingIndicator(colorScheme)
                        else if (_activeMessages.isEmpty)
                          _buildEmptyMessagesCard(colorScheme, textTheme)
                        else
                          _buildMessagesList(colorScheme, textTheme),
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

  /// Builds a card to display error messages
  Widget _buildErrorCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      color: colorScheme.errorContainer,
      margin: const EdgeInsets.only(top: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? strings.AppStrings.errorLoadingMessages,
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
              child: Text(strings.AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the loading indicator
  Widget _buildLoadingIndicator(ColorScheme colorScheme) {
    return const Padding(
      padding: EdgeInsets.only(top: 32.0),
      child: Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading messages...'),
          ],
        ),
      ),
    );
  }

  /// Builds a card for when there are no active messages
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
              strings.AppStrings.noActiveMessages,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              strings.AppStrings.noActiveMessagesSubtitle,
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

  /// Builds the list of active messages
  Widget _buildMessagesList(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      children: [
        ..._activeMessages.map((message) => _buildMessageCard(message, colorScheme, textTheme)),
      ],
    );
  }

  /// Builds a card for a single message
  Widget _buildMessageCard(Message message, ColorScheme colorScheme, TextTheme textTheme) {
    final timeUntilExpiration = _getTimeUntilExpiration(message.expirationDate);
    final isExpiringSoon = _isExpiringSoon(message.expirationDate);

    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    message.title,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (isExpiringSoon && message.expirationDate != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      strings.AppStrings.expiringSoon,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (message.expirationDate != null)
              Text(
                '${strings.AppStrings.expiresIn} $timeUntilExpiration',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              Text(
                strings.AppStrings.noExpirationDate,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 12),
            Text(
              message.content,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            // Emoji reactions row
            _buildEmojiReactionsRow(message, colorScheme, textTheme),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${strings.AppStrings.created}: ${_formatDate(message.createdAt)}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the emoji reactions row
  Widget _buildEmojiReactionsRow(Message message, ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _availableEmojis.map((emoji) {
        final isReacted = _hasUserReactedWith(message.id, emoji);
        final count = _getReactionCount(message.id, emoji);
        
        return Padding(
          padding: const EdgeInsets.only(right: 16),
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
                  Text(
                    emoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Text(
                      count.toString(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: isReacted
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
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

  /// Formats a date for display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays == 0) {
      // Same day - show time
      return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      // Within a week - show day and month
      return '${date.day}/${date.month}';
    } else {
      // Otherwise - show full date
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  /// Gets the time until expiration in a human-readable format
  String _getTimeUntilExpiration(DateTime? expirationDate) {
    if (expirationDate == null) {
      return strings.AppStrings.noExpirationDate;
    }
    
    final now = DateTime.now();
    final difference = expirationDate.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ${strings.AppStrings.days}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${strings.AppStrings.hoursMessage}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${strings.AppStrings.minutes}';
    } else {
      return strings.AppStrings.lessThanAMinute;
    }
  }

  /// Checks if a message is expiring soon (less than 24 hours)
  bool _isExpiringSoon(DateTime? expirationDate) {
    if (expirationDate == null) {
      return false;
    }
    
    final now = DateTime.now();
    final difference = expirationDate.difference(now);
    return difference.inHours <= 24 && difference.inHours >= 0;
  }
}