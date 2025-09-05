import 'package:flutter/material.dart';
import '../utils/responsive_utils.dart';
import '../utils/theme_utils.dart';
import '../providers/settings_provider.dart';

/// A reusable card widget with consistent styling and responsive design
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDesktop = context.isDesktop;

    return Container(
      margin: margin ?? EdgeInsets.symmetric(horizontal: context.responsiveHorizontalPadding(16)),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius ?? context.responsiveBorderRadius(24)),
        border: border ?? Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: context.responsiveElevation(24),
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: context.responsiveElevation(48),
            offset: const Offset(0, 16),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(context.responsiveHorizontalPadding(isDesktop ? 28 : 24)),
        child: child,
      ),
    );
  }
}

/// A reusable responsive container that adapts to screen size
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.margin,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveMaxWidth = context.responsiveMaxWidth(maxWidth: maxWidth);

    return Container(
      constraints: BoxConstraints(
        maxWidth: responsiveMaxWidth,
      ),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: context.responsiveHorizontalPadding(16),
        vertical: context.responsiveVerticalPadding(20),
      ),
      margin: margin,
      alignment: alignment,
      child: child,
    );
  }
}

/// A reusable animated fade and slide transition
class AppFadeSlideTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const AppFadeSlideTransition({
    super.key,
    required this.child,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// A reusable responsive text widget with theme awareness
class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextScaler? textScaler;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textScaler,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium;
    final responsiveStyle = baseStyle?.copyWith(
      fontSize: context.responsiveFontSize(baseStyle.fontSize ?? 14),
    );

    return Text(
      text,
      style: responsiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textScaler: textScaler ?? TextScaler.linear(MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2)),
    );
  }
}

/// A reusable responsive sized box
class ResponsiveSizedBox extends StatelessWidget {
  final double? width;
  final double? height;

  const ResponsiveSizedBox({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != null ? context.responsiveSpacing(width!) : null,
      height: height != null ? context.responsiveSpacing(height!) : null,
    );
  }
}

/// A reusable theme-aware color container
class ThemeAwareContainer extends StatelessWidget {
  final Widget child;
  final Color? lightColor;
  final Color? darkColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final Border? border;

  const ThemeAwareContainer({
    super.key,
    required this.child,
    this.lightColor,
    this.darkColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = context.themeAwareColor(
      light: lightColor ?? colorScheme.surface,
      dark: darkColor ?? colorScheme.surfaceContainerHighest,
    );

    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: border,
      ),
      child: child,
    );
  }
}

/// A reusable loading skeleton with responsive design
class AppSkeleton extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;

  const AppSkeleton({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width != null ? context.responsiveSpacing(width!) : null,
      height: height != null ? context.responsiveSpacing(height!) : null,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(context.responsiveBorderRadius(borderRadius)),
      ),
    );
  }
}

/// A reusable responsive grid layout
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double spacing;
  final double runSpacing;
  final double? childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.spacing = 16,
    this.runSpacing = 16,
    this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveSpacing = context.responsiveSpacing(spacing);
    final responsiveRunSpacing = context.responsiveSpacing(runSpacing);

    return Wrap(
      spacing: responsiveSpacing,
      runSpacing: responsiveRunSpacing,
      children: children,
    );
  }
}