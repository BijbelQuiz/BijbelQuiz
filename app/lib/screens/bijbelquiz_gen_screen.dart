import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/game_stats_provider.dart';
import '../services/time_tracking_service.dart';
import '../utils/bijbelquiz_gen_utils.dart';
import '../l10n/strings_nl.dart' as strings;
import '../constants/urls.dart';

class AnimatedCounter extends StatefulWidget {
  final num endNumber;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int decimalPlaces;

  const AnimatedCounter({
    super.key,
    required this.endNumber,
    this.duration = const Duration(milliseconds: 1000),
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.decimalPlaces = 0,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: 0,
      end: widget.endNumber.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _animation.addListener(() {
      setState(() {
        _currentValue = _animation.value;
      });
    });

    // Start animation after a short delay to ensure widget is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.endNumber != widget.endNumber) {
      // Reset and animate to new value
      _currentValue = oldWidget.endNumber.toDouble();
      _controller.reset();
      _animation = Tween<double>(
        begin: _currentValue,
        end: widget.endNumber.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      
      _animation.addListener(() {
        setState(() {
          _currentValue = _animation.value;
        });
      });
      
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayValue;
    if (widget.decimalPlaces == 0) {
      displayValue = '${widget.prefix}${_currentValue.toInt()}${widget.suffix}';
    } else {
      displayValue = '${widget.prefix}${_currentValue.toStringAsFixed(widget.decimalPlaces)}${widget.suffix}';
    }

    return Text(
      displayValue,
      style: widget.style,
      textAlign: TextAlign.center,
    );
  }
}

class BijbelQuizGenScreen extends StatefulWidget {
  const BijbelQuizGenScreen({super.key});

  @override
  State<BijbelQuizGenScreen> createState() => _BijbelQuizGenScreenState();
}

class _BijbelQuizGenScreenState extends State<BijbelQuizGenScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameStats = context.watch<GameStatsProvider>();
    final timeTrackingService = TimeTrackingService.instance;

    final pages = [
      _buildWelcomePage(context),
      _buildQuestionsAnsweredPage(context, gameStats),
      _buildMistakesPage(context, gameStats),
      _buildTimeSpentPage(context, timeTrackingService),
      _buildBestStreakPage(context, gameStats),
      _buildYearInReviewPage(context, gameStats, timeTrackingService),
      _buildThankYouPage(context),
      _buildDonationPage(context),
    ];

    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        // Calculate current page in real-time
        int currentPage =
            _pageController.hasClients ? _pageController.page?.round() ?? 0 : 0;

        // Define background colors for each page
        final pageBackgroundColors = [
          Colors.grey.shade300, // Welcome page - light grey
          Colors.purple.shade200, // Questions answered page - purple
          Colors.orange.shade300, // Mistakes page - orange
          Colors.green.shade300, // Time spent page - light blue
          Colors.pink.shade300, // Best streak page - pink
          Colors.amber.shade200, // Year in review page - amber
          Colors.lightBlue.shade200, // Thank you page - light blue
          Colors.yellow.shade200, // Donation page - yellow
        ];

        return Scaffold(
          backgroundColor: pageBackgroundColors[currentPage],
          body: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  // Optional: Add state update for other functionality if needed
                },
                children: pages,
              ),
              // Skip button (only on first page)
              // Skip button (only on first page)
              if (currentPage == 0)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  right: 16,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      strings.AppStrings.bijbelquizGenSkip,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              // Page indicator
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pages.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentPage == index
                            ? Colors.black
                            : Colors.black.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),
              // Navigation buttons
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (currentPage > 0)
                      OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black, width: 2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {
                        if (currentPage < pages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomePage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          Text(
            strings.AppStrings.bijbelquizGenTitle,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${strings.AppStrings.bijbelquizGenSubtitle} ${BijbelQuizGenPeriod.getStatsYear()}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Text(
            strings.AppStrings.bijbelquizGenWelcomeText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsAnsweredPage(
      BuildContext context, GameStatsProvider gameStats) {
    final totalQuestions = gameStats.score + gameStats.incorrectAnswers;
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.question_answer,
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          Text(
            strings.AppStrings.questionsAnswered,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            strings.AppStrings.bijbelquizGenQuestionsSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AnimatedCounter(
            endNumber: totalQuestions,
            duration: const Duration(milliseconds: 1500),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMistakesPage(BuildContext context, GameStatsProvider gameStats) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          Text(
            strings.AppStrings.mistakesMade,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            strings.AppStrings.bijbelquizGenMistakesSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AnimatedCounter(
            endNumber: gameStats.incorrectAnswers,
            duration: const Duration(milliseconds: 1500),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSpentPage(
      BuildContext context, TimeTrackingService timeTracking) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timer,
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          Text(
            strings.AppStrings.timeSpent,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            strings.AppStrings.bijbelquizGenTimeSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            timeTracking.getTotalTimeSpentFormatted(),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          AnimatedCounter(
            endNumber: timeTracking.getTotalTimeSpentInHours(),
            decimalPlaces: 1,
            suffix: ' ${strings.AppStrings.hours}',
            duration: const Duration(milliseconds: 1500),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestStreakPage(
      BuildContext context, GameStatsProvider gameStats) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_fire_department,
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          Text(
            strings.AppStrings.bijbelquizGenBestStreak,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            strings.AppStrings.bijbelquizGenStreakSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AnimatedCounter(
            endNumber: gameStats.longestStreak,
            duration: const Duration(milliseconds: 1500),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearInReviewPage(BuildContext context,
      GameStatsProvider gameStats, TimeTrackingService timeTracking) {
    final totalQuestions = gameStats.score + gameStats.incorrectAnswers;
    final correctPercentage = totalQuestions > 0
        ? (gameStats.score / totalQuestions * 100).round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          Text(
            strings.AppStrings.yearInReview,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            strings.AppStrings.bijbelquizGenYearReviewSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Column(
              children: [
                _buildStatRow(context, 
                  AnimatedCounter(
                    endNumber: gameStats.score,
                    duration: const Duration(milliseconds: 1500),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  strings.AppStrings.correctAnswers, 
                  Colors.black
                ),
                const Divider(height: 16, thickness: 1),
                _buildStatRow(context, 
                  AnimatedCounter(
                    endNumber: correctPercentage,
                    duration: const Duration(milliseconds: 1500),
                    suffix: '%',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  strings.AppStrings.accuracy, 
                  Colors.black
                ),
                const Divider(height: 16, thickness: 1),
                _buildStatRow(
                    context,
                    AnimatedCounter(
                      endNumber: timeTracking.getTotalTimeSpentInHours(),
                      duration: const Duration(milliseconds: 1500),
                      decimalPlaces: 1,
                      suffix: ' ${strings.AppStrings.hours}',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    strings.AppStrings.hours,
                    Colors.black),
                const Divider(height: 16, thickness: 1),
                _buildStatRow(context,
                  AnimatedCounter(
                    endNumber: gameStats.currentStreak,
                    duration: const Duration(milliseconds: 1500),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  strings.AppStrings.currentStreak, 
                  Colors.black
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(
      BuildContext context, Widget valueWidget, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.black,
                ),
          ),
          valueWidget,
        ],
      ),
    );
  }

  Widget _buildThankYouPage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          Text(
            strings.AppStrings.thankYouForSupport,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            strings.AppStrings.bijbelquizGenThankYouText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDonationPage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monetization_on,
            size: 80,
            color: Colors.black,
          ),
          const SizedBox(height: 24),
          Text(
            strings.AppStrings.supportWithDonation,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            strings.AppStrings.bijbelquizGenDonationText,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          OutlinedButton.icon(
            onPressed: () async {
              final Uri url = Uri.parse(AppUrls.donateUrl);
              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                throw Exception('Could not launch ${AppUrls.donateUrl}');
              }
            },
            icon: Icon(
              Icons.favorite,
              size: 18,
              color: Colors.black,
            ),
            label: Text(
              strings.AppStrings.bijbelquizGenDonateButton,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Colors.black,
                width: 2,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
