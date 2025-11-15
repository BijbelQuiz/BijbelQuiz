import 'package:flutter/material.dart';

import '../utils/responsive_utils.dart';
import 'theme_manager.dart';

// Re-export responsive utilities for backward compatibility
double getResponsiveFontSize(BuildContext context, double baseSize) =>
    ResponsiveUtils.getResponsiveFontSize(context, baseSize);

EdgeInsets getResponsivePadding(BuildContext context, EdgeInsets basePadding) =>
    ResponsiveUtils.getResponsivePadding(context, basePadding);

/// Gets the light theme from the centralized theme system
ThemeData get appLightTheme => ThemeManager().getLightThemeData('light');

/// Gets the dark theme from the centralized theme system
ThemeData get appDarkTheme => ThemeManager().getDarkThemeData('dark');

/// Gets the OLED theme from the centralized theme system
ThemeData get oledTheme => ThemeManager().getThemeData('oled');

/// Gets the green theme from the centralized theme system
ThemeData get greenTheme => ThemeManager().getThemeData('green');

/// Gets the orange theme from the centralized theme system
ThemeData get orangeTheme => ThemeManager().getThemeData('orange');

/// Gets the grey theme from the centralized theme system
ThemeData get greyTheme => ThemeManager().getThemeData('grey');
