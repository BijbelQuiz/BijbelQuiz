import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum AnswerFeedback { none, correct, incorrect, revealedCorrect }

class AnswerButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final AnswerFeedback feedback;
  final String label;
  final ColorScheme colorScheme;
  final String? letter;
  final bool isLarge;
  final bool isDisabled;

  const AnswerButton({
    super.key,
    required this.onPressed,
    required this.feedback,
    required this.label,
    required this.colorScheme,
    this.letter,
    this.isLarge = false,
    this.isDisabled = false,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Color _backgroundColor;
  late Color _borderColor;
  late Color _textColor;
  late Color _iconColor;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
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
        _backgroundColor = const Color(0xFF10B981);
        _borderColor = const Color(0xFF10B981);
        _textColor = Colors.white;
        _iconColor = Colors.white;
        break;
      case AnswerFeedback.incorrect:
        _backgroundColor = const Color(0xFFEF4444);
        _borderColor = const Color(0xFFEF4444);
        _textColor = Colors.white;
        _iconColor = Colors.white;
        break;
      case AnswerFeedback.revealedCorrect:
        _backgroundColor = const Color(0xFF10B981).withAlpha((0.15 * 255).round());
        _borderColor = const Color(0xFF10B981);
        _textColor = widget.colorScheme.onSurface;
        _iconColor = const Color(0xFF10B981);
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
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (!widget.isDisabled) _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    if (!widget.isDisabled) _animationController.reverse();
  }

  void _onTapCancel() {
    if (!widget.isDisabled) _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final double verticalPadding = widget.isLarge ? (isDesktop ? 36 : 28) : (isDesktop ? 18 : 16);
    final double fontSize = widget.isLarge ? (isDesktop ? 32 : 24) : getResponsiveFontSize(context, 16);
    final double iconSize = widget.isLarge ? (isDesktop ? 48 : 36) : getResponsiveFontSize(context, 16);
    final double indicatorSize = widget.isLarge ? (isDesktop ? 56 : 48) : (isDesktop ? 40 : 36);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (widget.feedback == AnswerFeedback.correct || widget.feedback == AnswerFeedback.incorrect)
                  BoxShadow(
                    color: _backgroundColor.withAlpha((0.3 * 255).round()),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  )
                else
                  BoxShadow(
                    color: widget.colorScheme.shadow.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isDisabled ? null : widget.onPressed,
                onTapDown: widget.isDisabled ? null : _onTapDown,
                onTapUp: widget.isDisabled ? null : _onTapUp,
                onTapCancel: widget.isDisabled ? null : _onTapCancel,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 24 : 20,
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
                  child: Row(
                    children: [
                      if (widget.letter != null)
                        Container(
                          width: indicatorSize,
                          height: indicatorSize,
                          decoration: BoxDecoration(
                            color: widget.feedback == AnswerFeedback.none
                                ? widget.colorScheme.primary.withAlpha((0.1 * 255).round())
                                : Colors.white.withAlpha((0.2 * 255).round()),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: widget.feedback == AnswerFeedback.none
                                  ? widget.colorScheme.primary.withAlpha((0.2 * 255).round())
                                  : Colors.white.withAlpha((0.3 * 255).round()),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              widget.letter!,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: _iconColor,
                                fontSize: getResponsiveFontSize(context, 16),
                              ),
                            ),
                          ),
                        ),
                      if (widget.letter != null)
                        SizedBox(width: isDesktop ? 18 : 16),
                      Expanded(
                        child: Text(
                          widget.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: _textColor,
                            height: 1.4,
                            letterSpacing: 0.1,
                            fontSize: fontSize,
                          ),
                          semanticsLabel: widget.label,
                        ),
                      ),
                      if (widget.feedback == AnswerFeedback.correct || widget.feedback == AnswerFeedback.revealedCorrect)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: widget.feedback == AnswerFeedback.correct 
                                ? Colors.white.withAlpha((0.2 * 255).round())
                                : widget.colorScheme.primary.withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(8),
                            border: widget.feedback == AnswerFeedback.revealedCorrect
                                ? Border.all(
                                    color: widget.colorScheme.primary.withAlpha((0.3 * 255).round()),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: widget.feedback == AnswerFeedback.correct ? Colors.white : widget.colorScheme.primary,
                            size: iconSize,
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
                          ),
                        ),
                    ],
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