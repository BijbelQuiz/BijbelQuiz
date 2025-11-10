import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/logger.dart';

enum AnswerFeedback { none, correct, incorrect, revealedCorrect }

class AnswerButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final AnswerFeedback feedback;
  final String label;
  final ColorScheme colorScheme;
  final String? letter;
  final bool isLarge;
  final bool isDisabled;
  final bool isCompact; // New parameter for compact multiplayer layout
  final Animation<double>? externalScaleAnimation; // Optional external animation controller

  const AnswerButton({
    super.key,
    required this.onPressed,
    required this.feedback,
    required this.label,
    required this.colorScheme,
    this.letter,
    this.isLarge = false,
    this.isDisabled = false,
    this.isCompact = false,
    this.externalScaleAnimation,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Color _backgroundColor;
  late Color _borderColor;
  late Color _textColor;
  late Color _iconColor;

  @override
  void initState() {
    super.initState();

    // Use external animation if provided, otherwise create our own
    if (widget.externalScaleAnimation != null) {
      _scaleAnimation = widget.externalScaleAnimation!;
    } else {
      _animationController = AnimationController(
        duration: const Duration(milliseconds: 150),
        vsync: this,
      );
      _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
      );
      _elevationAnimation = Tween<double>(begin: 1.0, end: 4.0).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
      );
    }

    _setColors();
  }

  @override
  void didUpdateWidget(covariant AnswerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setColors();
  }

  void _setColors() {
    switch (widget.feedback) {
      case AnswerFeedback.correct:
        _backgroundColor = const Color(0xFF059669); // Darker green for better contrast
        _borderColor = const Color(0xFF059669);
        _textColor = Colors.white;
        _iconColor = Colors.white;
        break;
      case AnswerFeedback.incorrect:
        _backgroundColor = const Color(0xFFDC2626); // Solid red for better contrast
        _borderColor = const Color(0xFFDC2626);
        _textColor = Colors.white;
        _iconColor = Colors.white;
        break;
      case AnswerFeedback.revealedCorrect:
        _backgroundColor = const Color(0xFF059669).withAlpha((0.15 * 255).round());
        _borderColor = const Color(0xFF059669);
        _textColor = widget.colorScheme.onSurface;
        _iconColor = const Color(0xFF059669);
        break;
      case AnswerFeedback.none:
        _backgroundColor = widget.colorScheme.surface;
        _borderColor = widget.colorScheme.outline;
        _textColor = widget.colorScheme.onSurface;
        _iconColor = widget.colorScheme.onSurface;
        break;
    }
  }

  @override
  void dispose() {
    // Only dispose if we created our own controller
    if (widget.externalScaleAnimation == null && _animationController != null) {
      _animationController!.dispose();
    }
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled &&
        widget.externalScaleAnimation == null &&
        _animationController != null) {
      AppLogger.info('Answer button tapped down: ${widget.label}');
      _animationController!.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isDisabled &&
        widget.externalScaleAnimation == null &&
        _animationController != null) {
      AppLogger.info('Answer button tapped up: ${widget.label}');
      _animationController!.reverse();
    }
  }

  void _onTapCancel() {
    if (!widget.isDisabled &&
        widget.externalScaleAnimation == null &&
        _animationController != null) {
      AppLogger.info('Answer button tap cancelled: ${widget.label}');
      _animationController!.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final double verticalPadding = widget.isCompact
        ? (isDesktop ? 16 : 8) // Less cramped on desktop for multiplayer
        : widget.isLarge
            ? (isDesktop ? 36 : 28)
            : (isDesktop ? 18 : 16);
    final double fontSize = widget.isCompact
        ? (isDesktop ? 16 : 12) // Less cramped font size on desktop for multiplayer
        : widget.isLarge
            ? (isDesktop ? 32 : 24)
            : getResponsiveFontSize(context, 16);
    final double iconSize = widget.isCompact
        ? (isDesktop ? 20 : 14) // Less cramped icon size on desktop for multiplayer
        : widget.isLarge
            ? (isDesktop ? 48 : 36)
            : getResponsiveFontSize(context, 16);
    final double indicatorSize = widget.isCompact
        ? (isDesktop ? 32 : 24) // Less cramped indicator size on desktop for multiplayer
        : widget.isLarge
            ? (isDesktop ? 56 : 48)
            : (isDesktop ? 40 : 36);

    // Build semantic label based on feedback state
    String semanticLabel = widget.label;
    if (widget.feedback == AnswerFeedback.correct) {
      semanticLabel = 'Correct answer: ${widget.label}';
    } else if (widget.feedback == AnswerFeedback.incorrect) {
      semanticLabel = 'Incorrect answer: ${widget.label}';
    } else if (widget.feedback == AnswerFeedback.revealedCorrect) {
      semanticLabel = 'Correct answer revealed: ${widget.label}';
    }

    // Add letter prefix if available
    if (widget.letter != null) {
      semanticLabel = '${widget.letter}. $semanticLabel';
    }

    return AnimatedBuilder(
      animation: widget.externalScaleAnimation ?? _animationController!,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (widget.feedback == AnswerFeedback.correct ||
                    widget.feedback == AnswerFeedback.incorrect)
                  BoxShadow(
                    color: _backgroundColor.withAlpha((0.3 * 255).round()),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: 0,
                  )
                else
                  BoxShadow(
                    color: widget.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: Semantics(
              label: semanticLabel,
              hint: widget.isDisabled
                  ? 'Answer button disabled'
                  : widget.feedback == AnswerFeedback.none
                      ? 'Tap to select this answer'
                      : null,
              button: true,
              enabled: !widget.isDisabled,
              selected: widget.feedback == AnswerFeedback.correct ||
                  widget.feedback == AnswerFeedback.revealedCorrect,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.isDisabled ? null : widget.onPressed,
                  onTapDown: widget.isDisabled ? null : _onTapDown,
                  onTapUp: widget.isDisabled ? null : _onTapUp,
                  onTapCancel: widget.isDisabled ? null : _onTapCancel,
                  borderRadius: BorderRadius.circular(16),
                  focusColor:
                      widget.colorScheme.primary.withAlpha((0.1 * 255).round()),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.isCompact ? (isDesktop ? 16 : 8) : (isDesktop ? 24 : 20),
                      vertical: verticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _borderColor,
                        width: 1.5,
                      ),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // If available width is too small, stack the elements vertically
                        bool useVerticalLayout = constraints.maxWidth < 100;

                        if (useVerticalLayout) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (widget.letter != null) ...[
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: indicatorSize,
                                    height: indicatorSize,
                                    decoration: BoxDecoration(
                                      color: widget.feedback == AnswerFeedback.none
                                          ? widget.colorScheme.primary
                                              .withAlpha((0.1 * 255).round())
                                          : Colors.white.withAlpha((0.2 * 255).round()),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: widget.feedback == AnswerFeedback.none
                                            ? widget.colorScheme.primary
                                                .withAlpha((0.2 * 255).round())
                                            : Colors.white.withAlpha((0.3 * 255).round()),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.letter!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: _iconColor,
                                              fontSize:
                                                  getResponsiveFontSize(context, 16),
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                              ],
                              Text(
                                widget.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: _textColor,
                                      height: 1.4,
                                      letterSpacing: 0.1,
                                      fontSize: fontSize,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              if (widget.feedback == AnswerFeedback.correct ||
                                  widget.feedback == AnswerFeedback.revealedCorrect) ...[
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: widget.feedback == AnswerFeedback.correct
                                          ? Colors.white.withAlpha((0.2 * 255).round())
                                          : widget.colorScheme.primary
                                              .withAlpha((0.1 * 255).round()),
                                      borderRadius: BorderRadius.circular(8),
                                      border: widget.feedback ==
                                              AnswerFeedback.revealedCorrect
                                          ? Border.all(
                                              color: widget.colorScheme.primary
                                                  .withAlpha((0.3 * 255).round()),
                                              width: 1,
                                            )
                                          : null,
                                    ),
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: widget.feedback == AnswerFeedback.correct
                                          ? Colors.white
                                          : widget.colorScheme.primary,
                                      size: iconSize / 1.5, // Smaller icons for vertical layout
                                      semanticLabel: 'Correct answer indicator',
                                    ),
                                  ),
                                ),
                              ],
                              if (widget.feedback == AnswerFeedback.incorrect) ...[
                                const SizedBox(height: 4),
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha((0.2 * 255).round()),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      color: Colors.white,
                                      size: iconSize / 1.5, // Smaller icons for vertical layout
                                      semanticLabel: 'Incorrect answer indicator',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        } else {
                          // Original horizontal layout
                          return Row(
                            children: [
                              if (widget.letter != null)
                                Container(
                                  width: indicatorSize,
                                  height: indicatorSize,
                                  decoration: BoxDecoration(
                                    color: widget.feedback == AnswerFeedback.none
                                        ? widget.colorScheme.primary
                                            .withAlpha((0.1 * 255).round())
                                        : Colors.white.withAlpha((0.2 * 255).round()),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: widget.feedback == AnswerFeedback.none
                                          ? widget.colorScheme.primary
                                              .withAlpha((0.2 * 255).round())
                                          : Colors.white.withAlpha((0.3 * 255).round()),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.letter!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: _iconColor,
                                            fontSize:
                                                getResponsiveFontSize(context, 16),
                                          ),
                                    ),
                                  ),
                                ),
                              if (widget.letter != null)
                                SizedBox(width: widget.isCompact ? (isDesktop ? 12 : 8) : (isDesktop ? 18 : 16)),
                              Expanded(
                                child: Text(
                                  widget.label,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: _textColor,
                                        height: 1.4,
                                        letterSpacing: 0.1,
                                        fontSize: fontSize,
                                      ),
                                ),
                              ),
                              if (widget.feedback == AnswerFeedback.correct ||
                                  widget.feedback == AnswerFeedback.revealedCorrect)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: widget.feedback == AnswerFeedback.correct
                                        ? Colors.white.withAlpha((0.2 * 255).round())
                                        : widget.colorScheme.primary
                                            .withAlpha((0.1 * 255).round()),
                                    borderRadius: BorderRadius.circular(8),
                                    border: widget.feedback ==
                                            AnswerFeedback.revealedCorrect
                                        ? Border.all(
                                            color: widget.colorScheme.primary
                                                .withAlpha((0.3 * 255).round()),
                                            width: 1,
                                          )
                                        : null,
                                  ),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: widget.feedback == AnswerFeedback.correct
                                        ? Colors.white
                                        : widget.colorScheme.primary,
                                    size: iconSize,
                                    semanticLabel: 'Correct answer indicator',
                                  ),
                                ),
                              if (widget.feedback == AnswerFeedback.incorrect)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha((0.2 * 255).round()),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: iconSize,
                                    semanticLabel: 'Incorrect answer indicator',
                                  ),
                                ),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
} 