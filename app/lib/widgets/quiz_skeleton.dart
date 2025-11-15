import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class QuizSkeleton extends StatelessWidget {
  final bool isDesktop;
  final bool isTablet;
  final bool isSmallPhone;
  final String questionType; // 'mc', 'fitb', 'tf'
  final int answerCount;
  final int metricsCount;
  const QuizSkeleton({
    super.key,
    this.isDesktop = false,
    this.isTablet = false,
    this.isSmallPhone = false,
    this.questionType = 'mc', // default to multiple choice
    this.answerCount = 4, // default to 4 answers
    this.metricsCount = 4, // default to 4 metrics
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final orig = colorScheme.surfaceContainerHighest;
    // Use Color.fromRGBO for better Android compatibility with alpha
    final baseColor = Color.fromRGBO(
      ((orig.r * 255.0).round() & 0xff),
      ((orig.g * 255.0).round() & 0xff),
      ((orig.b * 255.0).round() & 0xff),
      0.3, // 30% opacity
    );
    final highlightColor = Color.fromRGBO(
      ((orig.r * 255.0).round() & 0xff),
      ((orig.g * 255.0).round() & 0xff),
      ((orig.b * 255.0).round() & 0xff),
      0.6, // 60% opacity
    );
    // Use metricsCount from parameter
    // Use answerCount from parameter
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 800 : (isTablet ? 600 : double.infinity),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 32 : (isTablet ? 24 : 16),
              vertical: 20,
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Metrics row skeleton
                    if (isDesktop || isTablet)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 16 : 12,
                          vertical: isDesktop ? 12 : 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outline
                                .withAlpha((0.1 * 255).round()),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow
                                  .withAlpha((0.03 * 255).round()),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16,
                          runSpacing: 12,
                          children: List.generate(
                              metricsCount,
                              (i) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: baseColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 40,
                                        height: 12,
                                        color: baseColor,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 32,
                                        height: 8,
                                        color: baseColor,
                                      ),
                                    ],
                                  )),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.outline
                                .withAlpha((0.1 * 255).round()),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow
                                  .withAlpha((0.03 * 255).round()),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: baseColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 40,
                                        height: 12,
                                        color: baseColor,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 32,
                                        height: 8,
                                        color: baseColor,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: baseColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 40,
                                        height: 12,
                                        color: baseColor,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 32,
                                        height: 8,
                                        color: baseColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: baseColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 40,
                                        height: 12,
                                        color: baseColor,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 32,
                                        height: 8,
                                        color: baseColor,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: baseColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        width: 40,
                                        height: 12,
                                        color: baseColor,
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        width: 32,
                                        height: 8,
                                        color: baseColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: isDesktop ? 24 : 20),
                    // Question card skeleton
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 16),
                      decoration: BoxDecoration(
                        color: baseColor,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: colorScheme.outline
                              .withAlpha((0.1 * 255).round()),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow
                                .withAlpha((0.08 * 255).round()),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: colorScheme.shadow
                                .withAlpha((0.04 * 255).round()),
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
                            // Question text skeleton
                            Container(
                              width: double.infinity,
                              height: isDesktop ? 32 : 28,
                              margin: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? 12 : 8),
                              decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(height: isDesktop ? 36 : 32),
                            // Answer buttons skeleton
                            ...List.generate(
                                answerCount,
                                (index) => Padding(
                                      padding: EdgeInsets.only(
                                          bottom: isDesktop ? 14.0 : 12.0),
                                      child: Container(
                                        width: double.infinity,
                                        height: isSmallPhone ? 36 : 44,
                                        decoration: BoxDecoration(
                                          color: baseColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
