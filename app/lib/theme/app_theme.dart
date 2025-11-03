import 'package:flutter/material.dart';

import '../utils/responsive_utils.dart';

// Re-export responsive utilities for backward compatibility
double getResponsiveFontSize(BuildContext context, double baseSize) =>
    ResponsiveUtils.getResponsiveFontSize(context, baseSize);

EdgeInsets getResponsivePadding(BuildContext context, EdgeInsets basePadding) =>
    ResponsiveUtils.getResponsivePadding(context, basePadding);

// Base TextTheme creator
TextTheme _createBaseTextTheme({
  required Color primaryColor,
  required Color bodyLargeColor,
  required Color bodyMediumColor,
}) {
  return TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: primaryColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: primaryColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: primaryColor,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      color: primaryColor,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: primaryColor,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: primaryColor,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: bodyLargeColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: bodyMediumColor,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: primaryColor,
    ),
  );
}

// Base ElevatedButtonThemeData creator
ElevatedButtonThemeData _createBaseElevatedButtonTheme(
    Color backgroundColor, Color foregroundColor) {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
  );
}

// Base CardThemeData creator
CardThemeData _createBaseCardTheme(Color cardColor) {
  return CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAlias,
    color: cardColor,
    surfaceTintColor: Colors.transparent,
  );
}

// Base AppBarTheme creator
AppBarTheme _createBaseAppBarTheme(
    Color backgroundColor, Color foregroundColor) {
  return AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: foregroundColor,
      letterSpacing: -0.1,
    ),
  );
}

// Base PageTransitionsTheme
const PageTransitionsTheme _basePageTransitionsTheme = PageTransitionsTheme(
  builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
  },
);

final ThemeData appLightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    brightness: Brightness.light,
  ).copyWith(
    primary: const Color(0xFF2563EB),
    secondary: const Color(0xFF7C3AED),
    tertiary: const Color(0xFFDC2626),
    surface: const Color(0xFFFAFAFA),
    surfaceContainerHighest: const Color(0xFFF8FAFC),
    onSurface: const Color(0xFF0F172A),
    outline: const Color(0xFFE2E8F0),
    outlineVariant: const Color(0xFFF1F5F9),
    shadow: const Color(0xFF0F172A),
  ),
  useMaterial3: true,
  textTheme: ThemeData.light().textTheme.merge(
        _createBaseTextTheme(
          primaryColor: const Color(0xFF0F172A),
          bodyLargeColor: const Color(0xFF334155),
          bodyMediumColor: const Color(0xFF475569),
        ),
      ).apply(fontFamily: 'Quicksand'),
  elevatedButtonTheme: _createBaseElevatedButtonTheme(
    const Color(0xFF2563EB),
    Colors.white,
  ),
  cardTheme: _createBaseCardTheme(Colors.white),
  appBarTheme: _createBaseAppBarTheme(
    Colors.white,
    const Color(0xFF0F172A),
  ),
  pageTransitionsTheme: _basePageTransitionsTheme,
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
);

final ThemeData appDarkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB),
    brightness: Brightness.dark,
  ).copyWith(
    primary: const Color(0xFF2563EB),
    secondary: const Color(0xFF7C3AED),
    tertiary: const Color(0xFFDC2626),
    surface: const Color(0xFF0F172A),
    surfaceContainerHighest: const Color(0xFF1E293B),
    onSurface: const Color(0xFFF8FAFC),
    outline: const Color(0xFF334155),
    outlineVariant: const Color(0xFF1E293B),
    shadow: const Color(0xFF000000),
  ),
  useMaterial3: true,
  textTheme: ThemeData.dark().textTheme.merge(
        _createBaseTextTheme(
          primaryColor: const Color(0xFFF8FAFC),
          bodyLargeColor: const Color(0xFFCBD5E1),
          bodyMediumColor: const Color(0xFF94A3B8),
        ),
      ).apply(fontFamily: 'Quicksand'),
  elevatedButtonTheme: _createBaseElevatedButtonTheme(
    const Color(0xFF2563EB),
    Colors.white,
  ),
  cardTheme: _createBaseCardTheme(const Color(0xFF1E293B)),
  appBarTheme: _createBaseAppBarTheme(
    const Color(0xFF0F172A),
    const Color(0xFFF8FAFC),
  ),
  pageTransitionsTheme: _basePageTransitionsTheme,
  scaffoldBackgroundColor: const Color(0xFF0F172A),
);

final ThemeData oledTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.grey[900]!,
    surface: Colors.black,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.white,
  ),
  useMaterial3: true,
  textTheme: ThemeData.dark().textTheme.merge(
        _createBaseTextTheme(
          primaryColor: Colors.white,
          bodyLargeColor: Colors.white,
          bodyMediumColor: Colors.white,
        ),
      ).apply(fontFamily: 'Quicksand'),
  elevatedButtonTheme: _createBaseElevatedButtonTheme(
    Colors.white,
    Colors.black,
  ),
  cardTheme: _createBaseCardTheme(Colors.black),
  appBarTheme: _createBaseAppBarTheme(
    Colors.black,
    Colors.white,
  ),
  pageTransitionsTheme: _basePageTransitionsTheme,
);

final ThemeData greenTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme:
      ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
  useMaterial3: true,
  textTheme: ThemeData.light().textTheme.merge(
        _createBaseTextTheme(
          primaryColor: const Color(0xFF0F172A),
          bodyLargeColor: const Color(0xFF334155),
          bodyMediumColor: const Color(0xFF475569),
        ),
      ).apply(fontFamily: 'Quicksand'),
  elevatedButtonTheme: _createBaseElevatedButtonTheme(
    Colors.green,
    Colors.white,
  ),
  cardTheme: _createBaseCardTheme(Colors.white),
  appBarTheme: _createBaseAppBarTheme(
    Colors.white,
    const Color(0xFF0F172A),
  ),
  pageTransitionsTheme: _basePageTransitionsTheme,
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
);

final ThemeData orangeTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.orange, brightness: Brightness.light),
  useMaterial3: true,
  textTheme: ThemeData.light().textTheme.merge(
        _createBaseTextTheme(
          primaryColor: const Color(0xFF0F172A),
          bodyLargeColor: const Color(0xFF334155),
          bodyMediumColor: const Color(0xFF475569),
        ),
      ).apply(fontFamily: 'Quicksand'),
  elevatedButtonTheme: _createBaseElevatedButtonTheme(
    Colors.orange,
    Colors.white,
  ),
  cardTheme: _createBaseCardTheme(Colors.white),
  appBarTheme: _createBaseAppBarTheme(
    Colors.white,
    const Color(0xFF0F172A),
  ),
  pageTransitionsTheme: _basePageTransitionsTheme,
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
);

final ThemeData greyTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF4B5563),
    brightness: Brightness.dark,
  ).copyWith(
    primary: const Color(0xFF4B5563),
    secondary: const Color(0xFF374151),
    tertiary: const Color(0xFF6B7280),
    surface: const Color(0xFF1F2937),
    surfaceContainerHighest: const Color(0xFF374151),
    onSurface: const Color(0xFFF9FAFB),
    outline: const Color(0xFF4B5563),
    outlineVariant: const Color(0xFF374151),
    shadow: const Color(0xFF111827),
  ),
  useMaterial3: true,
  textTheme: ThemeData.dark().textTheme.merge(
        _createBaseTextTheme(
          primaryColor: const Color(0xFFF9FAFB),
          bodyLargeColor: const Color(0xFFFFFFFF),
          bodyMediumColor: const Color(0xE6FFFFFF),
        ),
      ).apply(fontFamily: 'Quicksand'),
  elevatedButtonTheme: _createBaseElevatedButtonTheme(
    const Color(0xFF4B5563),
    Colors.white,
  ),
  cardTheme: _createBaseCardTheme(const Color(0xFF374151)),
  appBarTheme: _createBaseAppBarTheme(
    const Color(0xFF1F2937),
    const Color(0xFFF9FAFB),
  ),
  pageTransitionsTheme: _basePageTransitionsTheme,
  scaffoldBackgroundColor: const Color(0xFF111827),
);