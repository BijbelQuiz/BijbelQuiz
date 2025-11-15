import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/ad.dart';
import '../services/analytics_service.dart';

class AdWidget extends StatefulWidget {
  final Ad ad;
  final VoidCallback? onDismiss;
  final VoidCallback? onView;

  const AdWidget({
    super.key,
    required this.ad,
    this.onDismiss,
    this.onView,
  });

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  @override
  void initState() {
    super.initState();
    // Trigger view callback when ad is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.onView != null) {
        widget.onView!();
      }
      // Track ad view
      if (mounted) {
        final analyticsService =
            Provider.of<AnalyticsService>(context, listen: false);
        analyticsService.trackFeatureUsage(context, 'custom_ads', 'viewed',
            additionalProperties: {
              'ad_id': widget.ad.id,
              'ad_title': widget.ad.title,
            });
      }
    });
  }

  Future<void> _launchAdUrl() async {
    if (widget.ad.linkUrl == null) return;

    try {
      final uri = Uri.parse(widget.ad.linkUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);

        // Track ad click after confirming launch
        if (mounted) {
          final analyticsService =
              Provider.of<AnalyticsService>(context, listen: false);
          analyticsService.trackFeatureSuccess(context, 'custom_ads',
              additionalProperties: {
                'ad_id': widget.ad.id,
                'ad_title': widget.ad.title,
                'action': 'clicked',
              });
        }
      }
    } catch (e) {
      // Handle error silently for user experience
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withValues(alpha: 0.10),
            cs.primary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: cs.primary.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Premium ad indicator with gradient
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary.withValues(alpha: 0.20),
                  cs.primary.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: cs.primary.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.campaign_rounded,
                    color: cs.onPrimary,
                    size: 14,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Aanbevolen',
                  style: textTheme.labelMedium?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Large, prominent ad title with better typography
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.ad.title,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
                height: 1.1,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 20),

          // Enhanced ad text with better readability
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.ad.text,
              style: textTheme.bodyLarge?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.90),
                height: 1.5,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 32),

          // Enhanced action buttons with better styling
          if (widget.ad.linkUrl != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _launchAdUrl,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: cs.primary.withValues(alpha: 0.4),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 22),
                label: const Text('Meer informatie'),
              ),
            ),
            const SizedBox(height: 12),
          ] else ...[
            const SizedBox(height: 24),
          ],

          // Polished dismiss button
          if (widget.onDismiss != null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  if (!mounted) return;
                  final analyticsService =
                      Provider.of<AnalyticsService>(context, listen: false);
                  analyticsService.trackFeatureDismissal(context, 'custom_ads',
                      additionalProperties: {
                        'ad_id': widget.ad.id,
                        'ad_title': widget.ad.title,
                      });
                  widget.onDismiss!();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: cs.outlineVariant.withValues(alpha: 0.8),
                    width: 1.5,
                  ),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: Text('Sluiten',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.85),
                    )),
              ),
            ),
        ],
      ),
    );
  }
}
