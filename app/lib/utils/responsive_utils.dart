import 'package:flutter/material.dart';

/// Utility class for responsive design calculations and device type detection
class ResponsiveUtils {
  // Breakpoint constants
  static const double desktopBreakpoint = 800;
  static const double tabletBreakpoint = 600;
  static const double smallPhoneBreakpoint = 350;

  /// Determines if the current screen size is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > desktopBreakpoint;
  }

  /// Determines if the current screen size is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > tabletBreakpoint && width <= desktopBreakpoint;
  }

  /// Determines if the current screen size is mobile (small phone)
  static bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < smallPhoneBreakpoint;
  }

  /// Determines if the current screen size is mobile (not desktop or tablet)
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= tabletBreakpoint;
  }

  /// Gets responsive font size based on device type
  static double getResponsiveFontSize(BuildContext context, double baseSize) {
    if (isDesktop(context)) {
      // More conservative scaling for desktop - only increase by 10-15% instead of 25-50%
      return baseSize * 1.1;
    } else if (isTablet(context)) {
      return baseSize * 1.05;
    } else if (isSmallPhone(context)) {
      return baseSize * 0.85;
    }
    return baseSize;
  }

  /// Gets responsive padding based on device type
  static EdgeInsets getResponsivePadding(BuildContext context, EdgeInsets basePadding) {
    if (isDesktop(context)) {
      // More conservative padding scaling for desktop
      return EdgeInsets.symmetric(
        horizontal: basePadding.horizontal * 1.2,
        vertical: basePadding.vertical * 1.1,
      );
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: basePadding.horizontal * 1.1,
        vertical: basePadding.vertical * 1.05,
      );
    }
    return basePadding;
  }

  /// Gets responsive margin based on device type
  static EdgeInsets getResponsiveMargin(BuildContext context, EdgeInsets baseMargin) {
    if (isDesktop(context)) {
      return EdgeInsets.symmetric(
        horizontal: baseMargin.horizontal * 1.1,
        vertical: baseMargin.vertical * 1.05,
      );
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: baseMargin.horizontal * 1.05,
        vertical: baseMargin.vertical * 1.02,
      );
    }
    return baseMargin;
  }

  /// Gets responsive spacing (SizedBox height/width) based on device type
  static double getResponsiveSpacing(BuildContext context, double baseSpacing) {
    if (isDesktop(context)) {
      return baseSpacing * 1.2;
    } else if (isTablet(context)) {
      return baseSpacing * 1.1;
    } else if (isSmallPhone(context)) {
      return baseSpacing * 0.9;
    }
    return baseSpacing;
  }

  /// Gets responsive border radius based on device type
  static double getResponsiveBorderRadius(BuildContext context, double baseRadius) {
    if (isDesktop(context)) {
      return baseRadius * 1.1;
    } else if (isTablet(context)) {
      return baseRadius * 1.05;
    }
    return baseRadius;
  }

  /// Gets responsive elevation based on device type
  static double getResponsiveElevation(BuildContext context, double baseElevation) {
    if (isDesktop(context)) {
      return baseElevation * 1.2;
    } else if (isTablet(context)) {
      return baseElevation * 1.1;
    }
    return baseElevation;
  }

  /// Gets responsive icon size based on device type
  static double getResponsiveIconSize(BuildContext context, double baseSize) {
    if (isDesktop(context)) {
      return baseSize * 1.15;
    } else if (isTablet(context)) {
      return baseSize * 1.1;
    } else if (isSmallPhone(context)) {
      return baseSize * 0.9;
    }
    return baseSize;
  }

  /// Gets responsive max width for content containers
  static double getResponsiveMaxWidth(BuildContext context, {double? maxWidth}) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (maxWidth != null) {
      return maxWidth.clamp(0, screenWidth * 0.9);
    }

    if (isDesktop(context)) {
      return 800;
    } else if (isTablet(context)) {
      return 600;
    }
    return double.infinity;
  }

  /// Gets responsive horizontal padding for screens
  static double getResponsiveHorizontalPadding(BuildContext context, double basePadding) {
    if (isDesktop(context)) {
      return basePadding * 1.5;
    } else if (isTablet(context)) {
      return basePadding * 1.2;
    } else if (isSmallPhone(context)) {
      return basePadding * 0.8;
    }
    return basePadding;
  }

  /// Gets responsive vertical padding for screens
  static double getResponsiveVerticalPadding(BuildContext context, double basePadding) {
    if (isDesktop(context)) {
      return basePadding * 1.2;
    } else if (isTablet(context)) {
      return basePadding * 1.1;
    }
    return basePadding;
  }
}

/// Extension methods for easier responsive design
extension ResponsiveContext on BuildContext {
  bool get isDesktop => ResponsiveUtils.isDesktop(this);
  bool get isTablet => ResponsiveUtils.isTablet(this);
  bool get isSmallPhone => ResponsiveUtils.isSmallPhone(this);
  bool get isMobile => ResponsiveUtils.isMobile(this);

  double responsiveFontSize(double baseSize) => ResponsiveUtils.getResponsiveFontSize(this, baseSize);
  EdgeInsets responsivePadding(EdgeInsets basePadding) => ResponsiveUtils.getResponsivePadding(this, basePadding);
  EdgeInsets responsiveMargin(EdgeInsets baseMargin) => ResponsiveUtils.getResponsiveMargin(this, baseMargin);
  double responsiveSpacing(double baseSpacing) => ResponsiveUtils.getResponsiveSpacing(this, baseSpacing);
  double responsiveBorderRadius(double baseRadius) => ResponsiveUtils.getResponsiveBorderRadius(this, baseRadius);
  double responsiveElevation(double baseElevation) => ResponsiveUtils.getResponsiveElevation(this, baseElevation);
  double responsiveIconSize(double baseSize) => ResponsiveUtils.getResponsiveIconSize(this, baseSize);
  double responsiveMaxWidth({double? maxWidth}) => ResponsiveUtils.getResponsiveMaxWidth(this, maxWidth: maxWidth);
  double responsiveHorizontalPadding(double basePadding) => ResponsiveUtils.getResponsiveHorizontalPadding(this, basePadding);
  double responsiveVerticalPadding(double basePadding) => ResponsiveUtils.getResponsiveVerticalPadding(this, basePadding);
}