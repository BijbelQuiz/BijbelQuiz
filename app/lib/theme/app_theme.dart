import 'package:flutter/material.dart';

import '../utils/responsive_utils.dart';

// Re-export responsive utilities for backward compatibility
double getResponsiveFontSize(BuildContext context, double baseSize) =>
    ResponsiveUtils.getResponsiveFontSize(context, baseSize);

EdgeInsets getResponsivePadding(BuildContext context, EdgeInsets basePadding) =>
    ResponsiveUtils.getResponsivePadding(context, basePadding);

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
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'Quicksand',
    bodyColor: const Color(0xFF0F172A),
    displayColor: const Color(0xFF0F172A),
  ).copyWith(
    headlineLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFF0F172A),
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFF0F172A),
    ),
    headlineSmall: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: Color(0xFF0F172A),
    ),
    titleLarge: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      color: Color(0xFF0F172A),
    ),
    titleMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF0F172A),
    ),
    titleSmall: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: Color(0xFF0F172A),
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Color(0xFF334155),
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Color(0xFF475569),
    ),
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: Color(0xFF0F172A),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      backgroundColor: const Color(0xFF2563EB),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAlias,
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF0F172A),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF0F172A),
      letterSpacing: -0.1,
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
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
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'Quicksand',
    bodyColor: const Color(0xFFF8FAFC),
    displayColor: const Color(0xFFF8FAFC),
  ).copyWith(
    headlineLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFFF8FAFC),
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFFF8FAFC),
    ),
    headlineSmall: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: Color(0xFFF8FAFC),
    ),
    titleLarge: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      color: Color(0xFFF8FAFC),
    ),
    titleMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFFF8FAFC),
    ),
    titleSmall: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: Color(0xFFF8FAFC),
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Color(0xFFCBD5E1),
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Color(0xFF94A3B8),
    ),
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: Color(0xFFF8FAFC),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      backgroundColor: const Color(0xFF2563EB),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAlias,
    color: const Color(0xFF1E293B),
    surfaceTintColor: Colors.transparent,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Color(0xFF0F172A),
    foregroundColor: Color(0xFFF8FAFC),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFFF8FAFC),
      letterSpacing: -0.1,
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
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
  textTheme: ThemeData.dark().textTheme.apply(
    fontFamily: 'Quicksand',
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ).copyWith(
    headlineLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Colors.white,
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Colors.white,
    ),
    headlineSmall: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: Colors.white,
    ),
    titleLarge: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      color: Colors.white,
    ),
    titleMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Colors.white,
    ),
    titleSmall: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: Colors.white,
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Colors.white,
    ),
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAlias,
    color: Colors.black,
    surfaceTintColor: Colors.transparent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: -0.1,
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);

final ThemeData greenTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.light),
  useMaterial3: true,
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'Quicksand',
    bodyColor: const Color(0xFF0F172A),
    displayColor: const Color(0xFF0F172A),
  ).copyWith(
    headlineLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFF0F172A),
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFF0F172A),
    ),
    headlineSmall: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: Color(0xFF0F172A),
    ),
    titleLarge: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      color: Color(0xFF0F172A),
    ),
    titleMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF0F172A),
    ),
    titleSmall: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: Color(0xFF0F172A),
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Color(0xFF334155),
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Color(0xFF475569),
    ),
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: Color(0xFF0F172A),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAlias,
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF0F172A),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF0F172A),
      letterSpacing: -0.1,
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
);

final ThemeData orangeTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.light),
  useMaterial3: true,
  textTheme: ThemeData.light().textTheme.apply(
    fontFamily: 'Quicksand',
    bodyColor: const Color(0xFF0F172A),
    displayColor: const Color(0xFF0F172A),
  ).copyWith(
    headlineLarge: const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: Color(0xFF0F172A),
    ),
    headlineMedium: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      color: Color(0xFF0F172A),
    ),
    headlineSmall: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: Color(0xFF0F172A),
    ),
    titleLarge: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.1,
      color: Color(0xFF0F172A),
    ),
    titleMedium: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: Color(0xFF0F172A),
    ),
    titleSmall: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: Color(0xFF0F172A),
    ),
    bodyLarge: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Color(0xFF334155),
    ),
    bodyMedium: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      color: Color(0xFF475569),
    ),
    labelLarge: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: Color(0xFF0F172A),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAlias,
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
  ),
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.white,
    foregroundColor: Color(0xFF0F172A),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF0F172A),
      letterSpacing: -0.1,
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
); 