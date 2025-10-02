import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/bible_reference.dart';
import '../services/logger.dart';
import '../theme/app_theme.dart';

/// Display widget for formatted Bible references.
///
/// Features:
/// - Display formatted Bible references
/// - Clickable verse links
/// - Multiple translation support
/// - Copy reference functionality
class BibleReferenceWidget extends StatefulWidget {
  /// The Bible reference to display
  final BibleReference reference;

  /// Callback when the reference is tapped
  final VoidCallback? onTap;

  /// Whether to show the translation information
  final bool showTranslation;

  /// Whether to show the copy button
  final bool showCopyButton;

  /// The style variant for the widget
  final BibleReferenceStyle style;

  /// Custom text style for the reference text
  final TextStyle? textStyle;

  /// Whether the widget should be compact
  final bool isCompact;

  const BibleReferenceWidget({
    super.key,
    required this.reference,
    this.onTap,
    this.showTranslation = true,
    this.showCopyButton = true,
    this.style = BibleReferenceStyle.card,
    this.textStyle,
    this.isCompact = false,
  });

  @override
  State<BibleReferenceWidget> createState() => _BibleReferenceWidgetState();
}

class _BibleReferenceWidgetState extends State<BibleReferenceWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: _buildReferenceContent(colorScheme),
          ),
        );
      },
    );
  }

  Widget _buildReferenceContent(ColorScheme colorScheme) {
    switch (widget.style) {
      case BibleReferenceStyle.card:
        return _buildCardStyle(colorScheme);
      case BibleReferenceStyle.chip:
        return _buildChipStyle(colorScheme);
      case BibleReferenceStyle.inline:
        return _buildInlineStyle(colorScheme);
      case BibleReferenceStyle.minimal:
        return _buildMinimalStyle(colorScheme);
    }
  }

  Widget _buildCardStyle(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: widget.onTap,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildReferenceText(colorScheme),
                  ),
                  if (widget.showCopyButton) ...[
                    const SizedBox(width: 8),
                    _buildCopyButton(colorScheme),
                  ],
                ],
              ),
              if (widget.showTranslation && !widget.isCompact) ...[
                const SizedBox(height: 8),
                _buildTranslationInfo(colorScheme),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChipStyle(ColorScheme colorScheme) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
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
            const SizedBox(width: 8),
            _buildReferenceText(colorScheme),
            if (widget.showCopyButton) ...[
              const SizedBox(width: 8),
              _buildCopyButton(colorScheme, size: 'small'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInlineStyle(ColorScheme colorScheme) {
    return InkWell(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildReferenceText(colorScheme),
          if (widget.showCopyButton) ...[
            const SizedBox(width: 4),
            _buildCopyButton(colorScheme, size: 'small'),
          ],
        ],
      ),
    );
  }

  Widget _buildMinimalStyle(ColorScheme colorScheme) {
    return InkWell(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: _buildReferenceText(colorScheme),
    );
  }

  Widget _buildReferenceText(ColorScheme colorScheme) {
    final text = Text(
      widget.reference.shortReference,
      style: widget.textStyle ?? Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w600,
        decoration: widget.onTap != null ? TextDecoration.underline : null,
        decorationColor: colorScheme.primary.withAlpha((0.5 * 255).round()),
      ),
    );

    return text;
  }

  Widget _buildTranslationInfo(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        widget.reference.displayString,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCopyButton(ColorScheme colorScheme, {String size = 'normal'}) {
    final buttonSize = size == 'small' ? 24.0 : 32.0;
    final iconSize = size == 'small' ? 16.0 : 20.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(buttonSize / 2),
        onTap: _copyToClipboard,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha((0.5 * 255).round()),
            borderRadius: BorderRadius.circular(buttonSize / 2),
          ),
          child: Icon(
            Icons.copy,
            size: iconSize,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  void _copyToClipboard() async {
    final referenceText = widget.reference.fullReference;
    await Clipboard.setData(ClipboardData(text: referenceText));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bible reference copied: $referenceText'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          action: SnackBarAction(
            label: 'Share',
            onPressed: _shareReference,
          ),
        ),
      );
    }
  }

  void _shareReference() {
    final referenceText = widget.reference.fullReference;
    final shareText = 'Bible reference: $referenceText (${widget.reference.displayString})';

    // In a real implementation, you would use share_plus package
    AppLogger.info('Sharing Bible reference: $shareText');

    Clipboard.setData(ClipboardData(text: shareText));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bible reference copied for sharing'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      );
    }
  }
}

/// Style variants for Bible reference widgets
enum BibleReferenceStyle {
  /// Card style with full information and actions
  card,

  /// Chip style for compact display
  chip,

  /// Inline style for text integration
  inline,

  /// Minimal style with just the reference text
  minimal,
}

/// Utility class for Bible reference formatting
class BibleReferenceFormatter {
  /// Formats a Bible reference for display
  static String formatReference(BibleReference reference, {bool includeTranslation = true}) {
    final base = reference.shortReference;
    return includeTranslation ? '$base (${reference.displayString})' : base;
  }

  /// Creates a BibleReference from a string (e.g., "Genesis 1:1-3")
  static BibleReference parseReference(String referenceString, {BibleTranslation? translation}) {
    return BibleReference.fromString(
      referenceString,
      translation: translation ?? BibleTranslation.statenvertaling,
    );
  }

  /// Validates if a string is a valid Bible reference format
  static bool isValidReference(String referenceString) {
    final regex = RegExp(r'^\w+\s+\d+:\d+(?:-\d+)?$');
    return regex.hasMatch(referenceString.trim());
  }
}