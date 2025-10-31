import 'package:bijbelquiz/services/analytics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/strings_nl.dart' as strings;
import 'sync_screen.dart';

/// Screen displaying social features of the app.
class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

/// Device size breakpoints for responsive design.
class _ResponsiveBreakpoints {
  static const double desktop = 800.0;
  static const double tablet = 600.0;
}

/// Spacing constants for consistent design.
class _SpacingConstants {
  static const double desktopPadding = 32.0;
  static const double tabletPadding = 24.0;
  static const double mobilePadding = 16.0;
  
  static const double desktopCardPadding = 16.0;
  static const double mobileCardPadding = 12.0;
  
  static const double desktopSpacing = 32.0;
  static const double mobileSpacing = 24.0;
  
  static const double desktopSmallSpacing = 16.0;
  static const double mobileSmallSpacing = 12.0;
  
  static const double iconDesktopSize = 120.0;
  static const double iconTabletSize = 100.0;
  static const double iconMobileSize = 80.0;
}

/// Represents device type based on screen size.
class _DeviceType {
  final bool isDesktop;
  final bool isTablet;
  final bool isMobile;

  const _DeviceType({
    required this.isDesktop,
    required this.isTablet,
    required this.isMobile,
  });
}

class _SocialScreenState extends State<SocialScreen> {
  bool _socialFeaturesEnabled = false;
  late AnalyticsService _analyticsService;

  @override
  void initState() {
    super.initState();
    _analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    _trackScreenAccess();
    // Social features enabled since feature flags removed
    _socialFeaturesEnabled = true;
  }

  /// Track screen access and feature availability.
  void _trackScreenAccess() {
    _analyticsService.screen(context, 'SocialScreen');
    _analyticsService.trackFeatureUsage(context, 'social_features', 'screen_accessed');
  }

  /// Get device type based on screen width.
  _DeviceType _getDeviceType(Size size) {
    final width = size.width;
    return _DeviceType(
      isDesktop: width > _ResponsiveBreakpoints.desktop,
      isTablet: width > _ResponsiveBreakpoints.tablet && width <= _ResponsiveBreakpoints.desktop,
      isMobile: width <= _ResponsiveBreakpoints.tablet,
    );
  }

  /// Get responsive padding based on device type.
  EdgeInsets _getResponsivePadding(_DeviceType deviceType) {
    final horizontalPadding = deviceType.isDesktop 
        ? _SpacingConstants.desktopPadding 
        : (deviceType.isTablet ? _SpacingConstants.tabletPadding : _SpacingConstants.mobilePadding);
    return EdgeInsets.symmetric(horizontal: horizontalPadding);
  }

  /// Get responsive size based on device type.
  double _getResponsiveSize(double desktop, double tablet, double mobile, _DeviceType deviceType) {
    return deviceType.isDesktop ? desktop : (deviceType.isTablet ? tablet : mobile);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final deviceType = _getDeviceType(size);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: _getResponsivePadding(deviceType),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: _getResponsiveSize(
                    _ResponsiveBreakpoints.desktop, 
                    _ResponsiveBreakpoints.tablet, 
                    double.infinity, 
                    deviceType,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBqidManagementCard(colorScheme, deviceType),
                    const SizedBox(height: 24), // Add some spacing below the BQID card
                    _buildSocialFeaturesContent(
                      colorScheme, 
                      deviceType, 
                      _socialFeaturesEnabled, // Pass the flag to determine content
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the app bar with consistent styling.
  AppBar _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.group_rounded,
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
    );
  }

  /// Builds the BQID management card.
  Widget _buildBqidManagementCard(ColorScheme colorScheme, _DeviceType deviceType) {
    final cardPadding = _getResponsiveSize(
      _SpacingConstants.desktopCardPadding,
      _SpacingConstants.desktopCardPadding,
      _SpacingConstants.mobileCardPadding,
      deviceType,
    );

    return Container(
      width: double.infinity,
      margin: EdgeInsets.zero,
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
          onTap: _handleBqidCardTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add,
                    size: 20,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(width: _getResponsiveSize(12, 12, 8, deviceType)),
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
    );
  }

  /// Handles tap on the BQID management card.
  void _handleBqidCardTap() {
    _analyticsService.capture(context, 'open_sync_screen');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SyncScreen(),
      ),
    );
  }

  /// Builds the social features content section, which can be either active or coming soon.
  Widget _buildSocialFeaturesContent(
    ColorScheme colorScheme, 
    _DeviceType deviceType, 
    bool featuresEnabled,
  ) {
    final iconSize = _getResponsiveSize(
      _SpacingConstants.iconDesktopSize,
      _SpacingConstants.iconTabletSize,
      _SpacingConstants.iconMobileSize,
      deviceType,
    );
    
    final iconColor = featuresEnabled 
        ? colorScheme.primary 
        : colorScheme.primary.withValues(alpha: 0.5);
    
    final titleColor = featuresEnabled 
        ? colorScheme.onSurface 
        : colorScheme.onSurface.withValues(alpha: 0.7);
    
    final subtitleColor = featuresEnabled 
        ? colorScheme.onSurface.withValues(alpha: 0.7) 
        : colorScheme.onSurface.withValues(alpha: 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.groups_rounded,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(height: _getResponsiveSize(
          _SpacingConstants.desktopSpacing,
          _SpacingConstants.desktopSpacing,
          _SpacingConstants.mobileSpacing,
          deviceType,
        )),
        Text(
          strings.AppStrings.moreSocialFeaturesComingSoon,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: _getResponsiveSize(
          _SpacingConstants.desktopSmallSpacing,
          _SpacingConstants.desktopSmallSpacing,
          _SpacingConstants.mobileSmallSpacing,
          deviceType,
        )),
        Text(
          strings.AppStrings.connectWithOtherUsers,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: subtitleColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}