import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/quiz_question.dart';
import '../theme/app_theme.dart';
import '../utils/responsive_utils.dart';
import '../services/performance_service.dart';
import 'answer_button.dart';

/// Combined animation controller for question card transitions and answer button feedback
class QuestionCardAnimationController {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _answerButtonScaleAnimation;

  final TickerProvider _vsync;
  final PerformanceService? _performanceService;

  QuestionCardAnimationController({
    required TickerProvider vsync,
    PerformanceService? performanceService,
  }) : _vsync = vsync,
       _performanceService = performanceService {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    // Use performance service to get optimal duration if available
    final baseDuration = const Duration(milliseconds: 250);
    final optimalDuration = _performanceService?.getOptimalAnimationDuration(baseDuration) ?? baseDuration;

    _controller = AnimationController(
      duration: optimalDuration,
      vsync: _vsync,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.5, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _answerButtonScaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  // Getters for animations
  Animation<double> get fadeAnimation => _fadeAnimation;
  Animation<Offset> get slideAnimation => _slideAnimation;
  Animation<double> get answerButtonScaleAnimation => _answerButtonScaleAnimation;

  // Controller methods
  void forward() => _controller.forward(from: 0.0);
  void reset() => _controller.reset();
  void dispose() => _controller.dispose();

  // Answer button feedback methods
  void playAnswerFeedback() => _controller.forward(from: 0.0);
  void reverseAnswerFeedback() => _controller.reverse();
}

class QuestionCard extends StatefulWidget {
  final QuizQuestion question;
  final int? selectedAnswerIndex;
  final bool isAnswering;
  final bool isTransitioning;
  final Function(int) onAnswerSelected;
  final String language;
  final PerformanceService? performanceService;

  const QuestionCard({
    super.key,
    required this.question,
    required this.selectedAnswerIndex,
    required this.isAnswering,
    required this.isTransitioning,
    required this.onAnswerSelected,
    required this.language,
    this.performanceService,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> with SingleTickerProviderStateMixin {
  late QuestionCardAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = QuestionCardAnimationController(
      vsync: this,
      performanceService: widget.performanceService,
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.question.question != oldWidget.question.question) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = context.isDesktop;

    Widget content = _buildQuestionContent(context, colorScheme, isDesktop);

    return AnimatedBuilder(
      animation: _animationController.fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _animationController.fadeAnimation,
          child: SlideTransition(
            position: _animationController.slideAnimation,
            child: child,
          ),
        );
      },
      child: content,
    );
  }
  
  Widget _buildQuestionContent(BuildContext context, ColorScheme colorScheme, bool isDesktop) {

    Widget content;
    switch (widget.question.type) {
      case QuestionType.mc:
        final options = widget.question.allOptions;
        final correctIndex = options.indexOf(widget.question.correctAnswer);
        content = Container(
          margin: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 16),
          child: Column(
            children: [
              // Enhanced question card with professional design
              Semantics(
                label: 'Multiple choice question',
                hint: 'Select the correct answer from the options below',
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.outline.withAlpha((0.1 * 255).round()),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha((0.08 * 255).round()),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha((0.04 * 255).round()),
                        blurRadius: 48,
                        offset: const Offset(0, 16),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 28.0 : 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Responsive question text with better overflow handling
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.3, // Limit height to 30% of screen
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Text(
                                widget.question.question,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                  height: 1.4,
                                  letterSpacing: -0.1,
                                  fontSize: isDesktop
                                    ? 24
                                    : MediaQuery.of(context).size.shortestSide < 360 ? 18 : 20,
                                ),
                                overflow: TextOverflow.visible,
                                textScaler: TextScaler.linear(MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2)), // Limit text scaling
                                semanticsLabel: widget.question.question,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: isDesktop ? 36 : 32),
                        // Answer options with improved spacing
                        Semantics(
                          label: 'Answer options',
                          hint: 'Choose one of the ${options.length} options',
                          child: Column(
                            children: List.generate(
                              options.length,
                              (index) {
                                AnswerFeedback feedback = AnswerFeedback.none;
                                if (widget.selectedAnswerIndex != null) {
                                  if (index == widget.selectedAnswerIndex && index == correctIndex) {
                                    feedback = AnswerFeedback.correct;
                                  } else if (index == widget.selectedAnswerIndex && index != correctIndex) {
                                    feedback = AnswerFeedback.incorrect;
                                  } else if (index == correctIndex) {
                                    feedback = AnswerFeedback.revealedCorrect;
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsets.only(bottom: isDesktop ? 14.0 : 12.0),
                                  child: AnswerButton(
                                    onPressed: widget.isAnswering || widget.selectedAnswerIndex != null ? null : () => widget.onAnswerSelected(index),
                                    feedback: feedback,
                                    label: options[index],
                                    colorScheme: colorScheme,
                                    letter: String.fromCharCode(65 + index),
                                    isDisabled: widget.isAnswering || widget.selectedAnswerIndex != null,
                                    externalScaleAnimation: _animationController.answerButtonScaleAnimation,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case QuestionType.fitb:
        final options = widget.question.allOptions;
        final correctIndex = options.indexOf(widget.question.correctAnswer);
        content = Container(
          margin: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 16),
          child: Column(
            children: [
              Semantics(
                label: 'Fill in the blank question',
                hint: 'Select the word that completes the sentence',
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.outline.withAlpha((0.1 * 255).round()),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha((0.08 * 255).round()),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha((0.04 * 255).round()),
                        blurRadius: 48,
                        offset: const Offset(0, 16),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 28.0 : 28.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Animated blank in question (like MC question text)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 8),
                          child: _FitbAnimatedBlankRow(
                            question: widget.question,
                            options: options,
                            selectedAnswerIndex: widget.selectedAnswerIndex,
                            isAnswering: widget.isAnswering,
                            onAnswerSelected: widget.onAnswerSelected,
                            colorScheme: colorScheme,
                            isDesktop: isDesktop,
                          ),
                        ),
                        SizedBox(height: isDesktop ? 36 : 32),
                        // Answer options with improved spacing (like MC)
                        Semantics(
                          label: 'Answer options',
                          hint: 'Choose the correct word to fill in the blank',
                          child: Column(
                            children: List.generate(
                              options.length,
                              (index) {
                                AnswerFeedback feedback = AnswerFeedback.none;
                                if (widget.selectedAnswerIndex != null) {
                                  if (index == widget.selectedAnswerIndex && index == correctIndex) {
                                    feedback = AnswerFeedback.correct;
                                  } else if (index == widget.selectedAnswerIndex && index != correctIndex) {
                                    feedback = AnswerFeedback.incorrect;
                                  } else if (index == correctIndex) {
                                    feedback = AnswerFeedback.revealedCorrect;
                                  }
                                }
                                return Padding(
                                  padding: EdgeInsets.only(bottom: isDesktop ? 14.0 : 12.0),
                                  child: AnswerButton(
                                    onPressed: widget.isAnswering || widget.selectedAnswerIndex != null ? null : () => widget.onAnswerSelected(index),
                                    feedback: feedback,
                                    label: options[index],
                                    colorScheme: colorScheme,
                                    letter: String.fromCharCode(65 + index),
                                    isDisabled: widget.isAnswering || widget.selectedAnswerIndex != null,
                                    externalScaleAnimation: _animationController.answerButtonScaleAnimation,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      case QuestionType.tf:
        final tfOptions = [
          'Goed',
          'Fout',
        ];
        // Determine correct index based on the actual correct answer
        final lcCorrect = widget.question.correctAnswer.toLowerCase();
        final correctIndex = (lcCorrect == 'waar' || lcCorrect == 'true' || lcCorrect == 'goed') ? 0 : 1;
        content = Container(
          margin: EdgeInsets.symmetric(horizontal: context.responsiveHorizontalPadding(isDesktop ? 20 : 16)),
          child: Column(
            children: [
              Semantics(
                label: 'True or False question',
                hint: 'Select whether the statement is true or false',
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: colorScheme.outline.withAlpha((0.1 * 255).round()),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha((0.08 * 255).round()),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: colorScheme.shadow.withAlpha((0.04 * 255).round()),
                        blurRadius: 48,
                        offset: const Offset(0, 16),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(context.responsiveHorizontalPadding(isDesktop ? 28.0 : 28.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 8),
                          child: Text(
                            widget.question.question,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              height: 1.5,
                              letterSpacing: -0.2,
                              fontSize: getResponsiveFontSize(context, 28),
                            ),
                            semanticsLabel: widget.question.question,
                          ),
                        ),
                        SizedBox(height: isDesktop ? 48 : 36),
                        Semantics(
                          label: 'Answer options',
                          hint: 'Choose True or False',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(2, (index) {
                              AnswerFeedback feedback = AnswerFeedback.none;
                              if (widget.selectedAnswerIndex != null) {
                                if (index == widget.selectedAnswerIndex && index == correctIndex) {
                                  feedback = AnswerFeedback.correct;
                                } else if (index == widget.selectedAnswerIndex && index != correctIndex) {
                                  feedback = AnswerFeedback.incorrect;
                                } else if (index == correctIndex) {
                                  feedback = AnswerFeedback.revealedCorrect;
                                }
                              }
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: AnswerButton(
                                    onPressed: widget.isAnswering || widget.selectedAnswerIndex != null ? null : () => widget.onAnswerSelected(index),
                                    feedback: feedback,
                                    label: tfOptions[index],
                                    colorScheme: colorScheme,
                                    letter: String.fromCharCode(65 + index),
                                    isLarge: true,
                                    isDisabled: widget.isAnswering || widget.selectedAnswerIndex != null,
                                    externalScaleAnimation: _animationController.answerButtonScaleAnimation,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
        break;
      // Add more cases for other question types here
    }

    if (isDesktop) {
      // All question types support keyboard shortcuts
      if (widget.question.type == QuestionType.mc || widget.question.type == QuestionType.fitb || widget.question.type == QuestionType.tf) {
        final options = widget.question.allOptions;
        content = Focus(
          autofocus: true,
          onKeyEvent: (FocusNode node, KeyEvent event) {
            if (event is KeyDownEvent && !widget.isAnswering && !widget.isTransitioning) {
              String key = event.logicalKey.keyLabel.toLowerCase();
              if (key == 'a' && options.isNotEmpty) {
                widget.onAnswerSelected(0);
                return KeyEventResult.handled;
              } else if (key == 'b' && options.length > 1) {
                widget.onAnswerSelected(1);
                return KeyEventResult.handled;
              } else if (key == 'c' && options.length > 2) {
                widget.onAnswerSelected(2);
                return KeyEventResult.handled;
              } else if (key == 'd' && options.length > 3) {
                widget.onAnswerSelected(3);
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: content,
        );
      }
    }

    return content;
  }
}

class _FitbAnimatedBlankRow extends StatefulWidget {
  final QuizQuestion question;
  final List<String> options;
  final int? selectedAnswerIndex;
  final bool isAnswering;
  final Function(int) onAnswerSelected;
  final ColorScheme colorScheme;
  final bool isDesktop;

  const _FitbAnimatedBlankRow({
    required this.question,
    required this.options,
    required this.selectedAnswerIndex,
    required this.isAnswering,
    required this.onAnswerSelected,
    required this.colorScheme,
    required this.isDesktop,
  });

  @override
  State<_FitbAnimatedBlankRow> createState() => _FitbAnimatedBlankRowState();
}

class _FitbAnimatedBlankRowState extends State<_FitbAnimatedBlankRow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250), // Optimized for better responsiveness
      vsync: this,
    );
    
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.1),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _colorAnimation = ColorTween(
      begin: widget.colorScheme.outlineVariant,
      end: const Color(0xFF10B981),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // If we already have a selected answer, run the animation
    if (widget.selectedAnswerIndex != null) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(_FitbAnimatedBlankRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedAnswerIndex != oldWidget.selectedAnswerIndex) {
      if (widget.selectedAnswerIndex != null) {
        _controller.reset();
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blankColor = widget.selectedAnswerIndex == null
        ? widget.colorScheme.outlineVariant
        : (widget.selectedAnswerIndex != null && widget.options[widget.selectedAnswerIndex!] == widget.question.correctAnswer)
            ? const Color(0xFF10B981)
            : const Color(0xFFEF4444);
    final blankText = widget.selectedAnswerIndex == null
        ? '______'
        : widget.options[widget.selectedAnswerIndex!];
    // Handle both '...' and '_____' as blank indicators
    final questionText = widget.question.question;
    final hasEllipsis = questionText.contains('...');
    final hasUnderscore = questionText.contains('_____');
    
    // If using ellipsis, replace them with underscores for consistent processing
    final processedText = hasEllipsis 
        ? questionText.replaceAll('...', '_____')
        : questionText;
        
    final questionParts = processedText.split('_____');
    final hasBlank = hasEllipsis || hasUnderscore;
    
    // If no blanks found, just return the question text
    if (!hasBlank) {
      return Text(
        questionText,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: widget.colorScheme.onSurface,
          height: 1.5,
          letterSpacing: -0.2,
          fontSize: getResponsiveFontSize(context, 24),
        ),
      );
    }

    // Build a list of widgets for each part of the question
    final List<Widget> children = [];
    
    for (int i = 0; i < questionParts.length; i++) {
      // Add the text part
      if (questionParts[i].isNotEmpty) {
        children.add(
          Text(
            questionParts[i],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: widget.colorScheme.onSurface,
              height: 1.5,
              letterSpacing: -0.2,
              fontSize: getResponsiveFontSize(context, 24),
            ),
          ),
        );
      }
      
      // Add the blank if we're not at the last part
      if (i < questionParts.length - 1) {
        children.add(
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250), // Optimized for better responsiveness
            switchInCurve: Curves.easeOutBack,
            switchOutCurve: Curves.easeInBack,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey('blank_$i'),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.selectedAnswerIndex != null 
                    ? _colorAnimation.value?.withValues(alpha: 0.1)
                    : blankColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.selectedAnswerIndex != null 
                      ? _colorAnimation.value ?? blankColor
                      : blankColor,
                  width: 3,
                ),
                boxShadow: widget.selectedAnswerIndex != null
                    ? [
                        BoxShadow(
                          color: (_colorAnimation.value ?? blankColor).withValues(alpha: 0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Text(
                      i == 0 ? blankText : '______',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: i == 0 
                            ? (widget.selectedAnswerIndex != null 
                                ? blankColor 
                                : blankColor)
                            : widget.colorScheme.outlineVariant,
                        fontSize: getResponsiveFontSize(context, 20), // Slightly reduced font size
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 4.0,
          runSpacing: 8.0,
          children: children,
        ),
      ),
    );
  }
} 