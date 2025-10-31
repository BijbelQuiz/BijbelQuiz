import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/strings_nl.dart' as strings;
import 'sync_screen.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  bool _socialFeaturesEnabled = false;

  @override
  void initState() {
    super.initState();
    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);

    analyticsService.screen(context, 'SocialScreen');

    // Track social screen access and feature availability
    analyticsService.trackFeatureUsage(context, 'social_features', 'screen_accessed');

    // Social features enabled since feature flags removed
    _socialFeaturesEnabled = true;
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Responsive design
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isTablet = size.width > 600 && size.width <= 800;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
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
                Icons.group_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              strings.AppStrings.social,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: isDesktop ? 32 : (isTablet ? 24 : 16),
            right: isDesktop ? 32 : (isTablet ? 24 : 16),
            top: 0,
            bottom: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? 800 : (isTablet ? 600 : double.infinity),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BQID Management Card at the top of the page with minimum margin
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.zero, // Ensure zero margin at the top
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Provider.of<AnalyticsService>(context, listen: false).capture(context, 'open_sync_screen');
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SyncScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: EdgeInsets.all(isDesktop ? 16 : 12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.person_add,
                                    size: 20,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                SizedBox(width: isDesktop ? 12 : 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        strings.AppStrings.manageYourBqid,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        strings.AppStrings.manageYourBqidSubtitle,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24), // Add some spacing below the BQID card
                    _socialFeaturesEnabled
                      ? _buildSocialFeaturesContent(colorScheme, isDesktop, isTablet)
                      : _buildComingSoonContent(colorScheme, isDesktop, isTablet),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialFeaturesContent(ColorScheme colorScheme, bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.groups_rounded,
          size: isDesktop ? 120 : (isTablet ? 100 : 80),
          color: colorScheme.primary,
        ),
        SizedBox(height: isDesktop ? 32 : 24),
        Text(
          strings.AppStrings.moreSocialFeaturesComingSoon,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isDesktop ? 16 : 12),
        Text(
          strings.AppStrings.connectWithOtherUsers,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildComingSoonContent(ColorScheme colorScheme, bool isDesktop, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.groups_rounded,
          size: isDesktop ? 120 : (isTablet ? 100 : 80),
          color: colorScheme.primary.withValues(alpha: 0.5),
        ),
        SizedBox(height: isDesktop ? 32 : 24),
        Text(
          strings.AppStrings.moreSocialFeaturesComingSoon,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isDesktop ? 16 : 12),
        Text(
          strings.AppStrings.moreSocialFeaturesComingSoon,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}