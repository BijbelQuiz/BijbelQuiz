import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../models/bible_chat_message.dart';

/// Widget for displaying a chat message bubble
class ChatMessageBubble extends StatelessWidget {
  final BibleChatMessage message;
  final bool isError;
  final Function(String)? onBibleReferenceTap;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.isError = false,
    this.onBibleReferenceTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          _buildAvatar(isUser, colorScheme),
          const SizedBox(width: 12),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!isUser) _buildBotLabel(colorScheme),
              const SizedBox(height: 4),
              _buildMessageBubble(isUser, colorScheme),
              const SizedBox(height: 4),
              _buildTimestamp(colorScheme),
            ],
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 12),
          _buildAvatar(isUser, colorScheme),
        ],
      ],
    );
  }

  Widget _buildAvatar(bool isUser, ColorScheme colorScheme) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isError
            ? LinearGradient(
                colors: [
                  colorScheme.errorContainer,
                  colorScheme.errorContainer.withAlpha((0.8 * 255).round()),
                ],
              )
            : (isUser
                ? LinearGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withAlpha((0.8 * 255).round()),
                    ],
                  )
                : LinearGradient(
                    colors: [
                      colorScheme.secondaryContainer,
                      colorScheme.secondaryContainer.withAlpha((0.8 * 255).round()),
                    ],
                  )),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha((0.1 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isError ? Icons.error : (isUser ? Icons.person : Icons.smart_toy),
        color: isError
            ? colorScheme.onErrorContainer
            : (isUser ? colorScheme.onPrimary : colorScheme.onSecondaryContainer),
        size: 20,
      ),
    );
  }

  Widget _buildBotLabel(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isError
            ? colorScheme.errorContainer.withAlpha((0.7 * 255).round())
            : colorScheme.primaryContainer.withAlpha((0.5 * 255).round()),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isError ? 'Fout' : 'BijbelBot',
        style: TextStyle(
          color: isError
              ? colorScheme.onErrorContainer
              : colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildMessageBubble(bool isUser, ColorScheme colorScheme) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isError
            ? colorScheme.errorContainer
            : (isUser ? colorScheme.primary : colorScheme.surfaceContainerHighest),
        borderRadius: BorderRadius.circular(20).copyWith(
          bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(4),
          bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(20),
        ),
        border: isError
            ? Border.all(
                color: colorScheme.error.withAlpha((0.5 * 255).round()),
                width: 1,
              )
            : null,
        boxShadow: isError
            ? [
                BoxShadow(
                  color: colorScheme.error.withAlpha((0.1 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [
                BoxShadow(
                  color: colorScheme.shadow.withAlpha((0.08 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isError) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 18,
                  color: colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Sorry, er is een fout opgetreden bij het verwerken van uw vraag. Probeer opnieuw.',
                    style: TextStyle(
                      color: colorScheme.onErrorContainer,
                      height: 1.4,
                      letterSpacing: 0.1,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            _buildMessageContent(isUser, colorScheme),
          ],
          if (message.bibleReferences != null && message.bibleReferences!.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildBibleReferences(colorScheme),
          ],
        ],
      ),
    );
     },
   );
 }

  Widget _buildBibleReferences(ColorScheme colorScheme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: message.bibleReferences!.map((reference) {
        return InkWell(
          onTap: () => onBibleReferenceTap?.call(reference),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withAlpha((0.3 * 255).round()),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book,
                  size: 16,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  reference,
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessageContent(bool isUser, ColorScheme colorScheme) {
    final textColor = isUser ? colorScheme.onPrimary : colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildMarkdownContent(message.content, textColor, colorScheme),
        ),
      ],
    );
  }

  Widget _buildMarkdownContent(String content, Color textColor, ColorScheme colorScheme) {
    try {
      return MarkdownBody(
        data: content,
        styleSheet: _getMarkdownStyleSheet(textColor, colorScheme),
        selectable: true,
      );
    } catch (e) {
      // Fallback to plain text if markdown parsing fails
      return Text(
        content,
        style: TextStyle(
          color: textColor,
          height: 1.4,
          letterSpacing: 0.1,
          fontSize: 16,
        ),
      );
    }
  }

  MarkdownStyleSheet _getMarkdownStyleSheet(Color textColor, ColorScheme colorScheme) {
    return MarkdownStyleSheet(
      p: TextStyle(
        color: textColor,
        height: 1.4,
        letterSpacing: 0.1,
        fontSize: 16,
      ),
      h1: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        height: 1.3,
        fontSize: 24,
      ),
      h2: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        height: 1.3,
        fontSize: 22,
      ),
      h3: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        height: 1.3,
        fontSize: 18,
      ),
      strong: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      em: TextStyle(
        color: textColor,
        fontStyle: FontStyle.italic,
        fontSize: 16,
      ),
      code: TextStyle(
        color: textColor,
        backgroundColor: colorScheme.surfaceContainerHighest.withAlpha((0.5 * 255).round()),
        fontFamily: 'monospace',
        fontSize: 14,
      ),
      blockquote: TextStyle(
        color: textColor.withAlpha((0.8 * 255).round()),
        height: 1.4,
        fontSize: 16,
      ),
      blockquoteDecoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha((0.3 * 255).round()),
        border: Border(
          left: BorderSide(
            color: colorScheme.outline.withAlpha((0.5 * 255).round()),
            width: 4,
          ),
        ),
      ),
      listBullet: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withAlpha((0.3 * 255).round()),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildTimestamp(ColorScheme colorScheme) {
    final timestamp = DateFormat('HH:mm').format(message.timestamp);

    return Text(
      timestamp,
      style: TextStyle(
        color: colorScheme.onSurface.withAlpha((0.6 * 255).round()),
        fontSize: 11,
      ),
    );
  }
}