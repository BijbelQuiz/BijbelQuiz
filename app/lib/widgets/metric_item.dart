import 'package:flutter/material.dart';

class MetricItem extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final ColorScheme colorScheme;
  final Animation<double> animation;
  final int previousValue;
  final Color? timeColor;
  final Color? color;
  final VoidCallback? onAnimationComplete;
  final bool isSmallPhone;
  final bool highlight;
  final double scale;

  const MetricItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.colorScheme,
    required this.animation,
    required this.previousValue,
    this.timeColor,
    this.color,
    this.onAnimationComplete,
    this.isSmallPhone = false,
    this.highlight = false,
    this.scale = 1.0,
  });

  @override
  State<MetricItem> createState() => _MetricItemState();
}

class _MetricItemState extends State<MetricItem> {
  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: widget.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
      fontWeight: FontWeight.w500,
    );
    int currentValue = int.parse(widget.value);
    final metricColor = widget.color ?? widget.colorScheme.primary;
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;
    final isMobile = size.width <= 600;

    // For mobile devices, show only the icon and value (no label text)
    if (isMobile) {
      return GestureDetector(
        onTap: () {
          _showMetricPopup(context, currentValue, metricColor);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: (widget.isSmallPhone ? 2 : 8) * widget.scale,
            vertical: (widget.isSmallPhone ? 6 : 8) * widget.scale,
          ),
          decoration: BoxDecoration(
            color: widget.colorScheme.surface,
            borderRadius: BorderRadius.circular((widget.isSmallPhone ? 10 : 14) * widget.scale),
            border: Border.all(
              color: widget.highlight
                  ? Colors.deepOrange.withAlpha((0.85 * 255).round())
                  : widget.colorScheme.outline.withAlpha((0.1 * 255).round()),
              width: (widget.highlight ? 3 : 1) * widget.scale,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25), // subtle, small shadow
                blurRadius: 4 * widget.scale,
                offset: Offset(0, 2 * widget.scale),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: (widget.isSmallPhone ? 16 : 24) * widget.scale,
                height: (widget.isSmallPhone ? 16 : 24) * widget.scale,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      metricColor.withAlpha((0.15 * 255).round()),
                      metricColor.withAlpha((0.08 * 255).round()),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular((widget.isSmallPhone ? 5 : 8) * widget.scale),
                  border: Border.all(
                    color: metricColor.withAlpha((0.2 * 255).round()),
                    width: 1 * widget.scale,
                  ),
                ),
                child: Icon(
                  widget.icon, 
                  color: metricColor, 
                  size: (widget.isSmallPhone ? 10 : 16) * widget.scale,
                ),
              ),
              SizedBox(width: (widget.isSmallPhone ? 4 : 6) * widget.scale),
              // Animated value only (no label)
              Flexible(
                child: AnimatedBuilder(
                  animation: widget.animation,
                  builder: (context, child) {
                    double animationValue = widget.animation.value.clamp(0.0, 1.0);
                    if (animationValue >= 1.0 && widget.onAnimationComplete != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        widget.onAnimationComplete?.call();
                      });
                    }
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: (widget.isSmallPhone ? 20 : 30) * widget.scale,
                        maxWidth: (widget.isSmallPhone ? 60 : 80) * widget.scale,
                      ),
                      child: SizedBox(
                        height: (widget.isSmallPhone ? 18 : 22) * widget.scale,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(0, -16 * widget.scale * animationValue),
                              child: Opacity(
                                opacity: (1 - animationValue).clamp(0.0, 1.0),
                                child: Text(
                                  widget.previousValue.toString(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: (widget.label == 'Time' || widget.label == 'Tijd') && widget.previousValue <= 5 
                                        ? widget.timeColor 
                                        : metricColor,
                                    letterSpacing: -0.3,
                                    fontSize: (widget.isSmallPhone ? 12 : 16) * widget.scale,
                                  ),
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(0, 16 * widget.scale * (1 - animationValue)),
                              child: Opacity(
                                opacity: animationValue.clamp(0.0, 1.0),
                                child: Text(
                                  currentValue.toString(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: (widget.label == 'Time' || widget.label == 'Tijd') && currentValue <= 5 
                                        ? widget.timeColor 
                                        : metricColor,
                                    letterSpacing: -0.3,
                                    fontSize: (widget.isSmallPhone ? 12 : 16) * widget.scale,
                                  ),
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    // For desktop/tablet, show the full metric item with text
    Widget content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: (isDesktop ? 16 : 12) * widget.scale,
        vertical: (isDesktop ? 10 : 8) * widget.scale,
      ),
      decoration: BoxDecoration(
        color: widget.colorScheme.surface,
        borderRadius: BorderRadius.circular(14 * widget.scale),
        border: Border.all(
          color: widget.highlight
              ? Colors.deepOrange.withAlpha((0.85 * 255).round())
              : widget.colorScheme.outline.withAlpha((0.1 * 255).round()),
          width: (widget.highlight ? 3 : 1) * widget.scale,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25), // subtle, small shadow
            blurRadius: 4 * widget.scale,
            offset: Offset(0, 2 * widget.scale),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon with compact background
          Center(
            child: Container(
              width: (isDesktop ? 36 : 28) * widget.scale,
              height: (isDesktop ? 36 : 28) * widget.scale,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    metricColor.withAlpha((0.15 * 255).round()),
                    metricColor.withAlpha((0.08 * 255).round()),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10 * widget.scale),
                border: Border.all(
                  color: metricColor.withAlpha((0.2 * 255).round()),
                  width: 1.2 * widget.scale,
                ),
              ),
              child: Icon(
                widget.icon, 
                color: metricColor, 
                size: (isDesktop ? 20 : 16) * widget.scale,
              ),
            ),
          ),
          SizedBox(width: (isDesktop ? 12 : 8) * widget.scale),
          // Animated value with compact typography
          Center(
            child: AnimatedBuilder(
              animation: widget.animation,
              builder: (context, child) {
                double animationValue = widget.animation.value.clamp(0.0, 1.0);
                if (animationValue >= 1.0 && widget.onAnimationComplete != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onAnimationComplete?.call();
                  });
                }
                return SizedBox(
                  height: (isDesktop ? 28 : 22) * widget.scale,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, -((isDesktop ? 22 : 16) * widget.scale) * animationValue),
                        child: Opacity(
                          opacity: (1 - animationValue).clamp(0.0, 1.0),
                          child: Text(
                            widget.previousValue.toString(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: (widget.label == 'Time' || widget.label == 'Tijd') && widget.previousValue <= 5 
                                  ? widget.timeColor 
                                  : metricColor,
                              letterSpacing: -0.3,
                              fontSize: (isDesktop ? 20 : 16) * widget.scale,
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, ((isDesktop ? 22 : 16) * widget.scale) * (1 - animationValue)),
                        child: Opacity(
                          opacity: animationValue.clamp(0.0, 1.0),
                          child: Text(
                            currentValue.toString(),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: (widget.label == 'Time' || widget.label == 'Tijd') && currentValue <= 5 
                                  ? widget.timeColor 
                                  : metricColor,
                              letterSpacing: -0.3,
                              fontSize: (isDesktop ? 20 : 16) * widget.scale,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(width: (isDesktop ? 10 : 6) * widget.scale),
          // Label with compact styling
          Center(
            child: Text(
              widget.label,
              style: baseStyle?.copyWith(
                fontSize: (isDesktop ? 14 : 12) * widget.scale,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );

    return content;
  }

  void _showMetricPopup(BuildContext context, int currentValue, Color metricColor) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    
    OverlayEntry? overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx, // Position at the same x as the icon
        top: position.dy + renderBox.size.height + 8, // Position below the icon with 8px gap
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withAlpha(48),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(overlayEntry);
    
    // Auto-remove after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry?.remove();
    });
  }
} 