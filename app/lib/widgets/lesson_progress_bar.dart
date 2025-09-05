import 'package:flutter/material.dart';

/// A progress bar widget specifically for lesson mode in the quiz screen.
/// Shows current progress through a lesson with an animated fill and visual indicators.
class LessonProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const LessonProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final value = total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxW = constraints.maxWidth;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Track
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              // Animated fill
              AnimatedContainer(
                duration: const Duration(milliseconds: 400), // Optimized for better responsiveness
                curve: Curves.easeOutCubic,
                width: maxW * value,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      cs.primary,
                      cs.primary.withValues(alpha: 0.65),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: cs.primary.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 0.5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),

              // Soft shimmer overlay on the filled part
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: value == 0.0 ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200), // Faster opacity transition
                    child: FractionallySizedBox(
                      widthFactor: value,
                      alignment: Alignment.centerLeft,
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return const LinearGradient(
                            begin: Alignment(-1.0, 0.0),
                            end: Alignment(1.0, 0.0),
                            colors: [
                              Colors.transparent,
                              Colors.white54,
                              Colors.transparent,
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.srcATop,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 600), // Reduced from 900ms
                          curve: Curves.easeInOut,
                          width: maxW * value,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white.withValues(alpha: 0.10),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Cap dot with glow
              if (value > 0.0)
                Positioned(
                  left: (maxW * value) - 6,
                  top: -2,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 250), // Slightly faster scale animation
                    curve: Curves.easeOutBack,
                    scale: 1.0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: cs.primary.withValues(alpha: 0.6),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}