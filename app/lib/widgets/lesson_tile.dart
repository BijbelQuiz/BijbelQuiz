import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/lesson.dart';
import '../providers/settings_provider.dart';

class LessonTile extends StatefulWidget {
  final Lesson lesson;
  final int index;
  final bool unlocked;
  final bool playable;
  final int stars;
  final bool recommended;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.lesson,
    required this.index,
    required this.unlocked,
    required this.playable,
    required this.stars,
    required this.onTap,
    this.recommended = false,
  });

  @override
  State<LessonTile> createState() => _LessonTileState();
}

class _LessonTileState extends State<LessonTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _shadowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.playable) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.playable) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.playable) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final gradient = settings.colorfulMode
        ? _tileGradientForIndex(cs, widget.index)
        : _singleColorGradient(cs);

    String semanticLabel =
        'Lesson ${widget.lesson.index + 1}: ${widget.lesson.title}';
    String hint = '';

    if (!widget.unlocked) {
      semanticLabel = '$semanticLabel (locked)';
      hint = 'This lesson is locked. Complete previous lessons to unlock it.';
    } else if (!widget.playable) {
      semanticLabel = '$semanticLabel (unlocked but not playable)';
      hint =
          'This lesson is unlocked but you can only play the most recent unlocked lesson.';
    } else {
      hint = 'Tap to start this lesson';
    }

    if (widget.recommended) {
      semanticLabel = 'Recommended: $semanticLabel';
    }

    return Semantics(
      label: semanticLabel,
      hint: hint,
      button: widget.playable,
      enabled: widget.playable,
      selected: widget.recommended,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: 0.12 * _shadowAnimation.value),
                    blurRadius: 16 * _shadowAnimation.value,
                    offset: Offset(0, 6 * _shadowAnimation.value),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
        child: InkWell(
          onTap: widget.playable ? widget.onTap : null,
          onTapDown: widget.playable ? _onTapDown : null,
          onTapUp: widget.playable ? _onTapUp : null,
          onTapCancel: widget.playable ? _onTapCancel : null,
          borderRadius: BorderRadius.circular(18),
          focusColor: widget.playable
              ? cs.primary.withAlpha((0.1 * 255).round())
              : null,
          child: Opacity(
            opacity: widget.unlocked && !widget.playable ? 0.55 : 1.0,
            child: Ink(
              decoration: BoxDecoration(
                gradient: widget.unlocked ? gradient : null,
                color: widget.unlocked ? null : cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: widget.recommended
                      ? cs.primary
                      : cs.outlineVariant.withValues(alpha: 0.7),
                  width: widget.recommended ? 2.0 : 1.0,
                ),
              ),
              child: Stack(
                children: [
                  if (widget.unlocked)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: (widget.unlocked
                                  ? cs.surface
                                  : cs.surfaceContainerHigh)
                              .withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: cs.outlineVariant),
                        ),
                        child: Text(
                          'Les ${widget.lesson.index + 1}',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  if (widget.unlocked)
                    Positioned.fill(
                      child: Center(
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: cs.primary.withValues(alpha: 0.15),
                          child: Icon(
                            Icons.menu_book,
                            color: cs.primary,
                            size: 36,
                            semanticLabel:
                                'Book icon representing lesson content',
                          ),
                        ),
                      ),
                    )
                  else
                    Positioned.fill(
                      child: Center(
                        child: Icon(
                          Icons.lock_rounded,
                          color: cs.onSurface.withValues(alpha: 0.7),
                          size: 40,
                          semanticLabel: 'Locked lesson',
                        ),
                      ),
                    ),
                  if (widget.recommended)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.recommend_rounded,
                          color: cs.onPrimary,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _tileGradientForIndex(ColorScheme cs, int i) {
    final palettes = <List<Color>>[
      [
        cs.primaryContainer.withValues(alpha: 0.7),
        cs.primary.withValues(alpha: 0.3)
      ],
      [
        const Color(0xFF10B981).withValues(alpha: 0.6),
        const Color(0xFF34D399).withValues(alpha: 0.3)
      ],
      [
        const Color(0xFF6366F1).withValues(alpha: 0.6),
        const Color(0xFFA78BFA).withValues(alpha: 0.32)
      ],
      [
        const Color(0xFFF59E0B).withValues(alpha: 0.6),
        const Color(0xFFFCD34D).withValues(alpha: 0.32)
      ],
      [
        const Color(0xFFEF4444).withValues(alpha: 0.6),
        const Color(0xFFF87171).withValues(alpha: 0.32)
      ],
      [
        const Color(0xFF06B6D4).withValues(alpha: 0.6),
        const Color(0xFF67E8F9).withValues(alpha: 0.32)
      ],
    ];
    final colors = palettes[i % palettes.length];
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  LinearGradient _singleColorGradient(ColorScheme cs) {
    // Use a single, consistent gradient for all lesson tiles
    // This creates a subtle blue gradient that matches the app's theme
    return LinearGradient(
      colors: [
        cs.primaryContainer.withValues(alpha: 0.7),
        cs.primary.withValues(alpha: 0.3)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
