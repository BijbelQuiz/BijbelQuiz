import 'package:flutter/material.dart';

enum TopSnackBarStyle { info, success, warning, error }

void showTopSnackBar(
  BuildContext context,
  String message, {
  TopSnackBarStyle style = TopSnackBarStyle.info,
  Duration duration = const Duration(seconds: 3),
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) return;
  final ThemeData theme = Theme.of(context);
  final ColorScheme cs = theme.colorScheme;

  // Choose colors and icon based on style
  Color backgroundColor;
  Color accentColor;
  IconData icon;
  switch (style) {
    case TopSnackBarStyle.success:
      backgroundColor = cs.surfaceContainerHighest;
      accentColor = cs.primary;
      icon = Icons.check_circle_rounded;
      break;
    case TopSnackBarStyle.warning:
      backgroundColor = const Color(0xFFFFF4E5);
      accentColor = const Color(0xFFB45309);
      icon = Icons.warning_amber_rounded;
      break;
    case TopSnackBarStyle.error:
      backgroundColor = cs.errorContainer.withValues(alpha: 0.9);
      accentColor = cs.onErrorContainer;
      icon = Icons.error_outline_rounded;
      break;
    case TopSnackBarStyle.info:
      backgroundColor = cs.surfaceContainerHigh;
      accentColor = cs.primary;
      icon = Icons.info_outline_rounded;
      break;
  }

  final double topInset = MediaQuery.of(context).padding.top + 12;

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    dismissDirection: DismissDirection.up,
    duration: duration,
    margin: EdgeInsets.fromLTRB(12, topInset, 12, 0),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    backgroundColor: backgroundColor,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: accentColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
    action: (actionLabel != null && onAction != null)
        ? SnackBarAction(
            label: actionLabel,
            onPressed: onAction,
            textColor: accentColor,
          )
        : null,
  );

  // In case older banners were shown previously
  messenger.clearMaterialBanners();
  messenger.clearSnackBars();
  messenger.showSnackBar(snackBar);
}
