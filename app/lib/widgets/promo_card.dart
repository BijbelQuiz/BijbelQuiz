import 'package:flutter/material.dart';

import '../constants/urls.dart';
import '../l10n/strings_nl.dart' as strings;

class PromoCard extends StatelessWidget {
   final bool isDonation;
   final bool isSatisfaction;
   final bool isDifficulty;
   final String? socialMediaType;
   final VoidCallback onDismiss;
   final Function(String) onAction;

   const PromoCard({
     super.key,
     required this.isDonation,
     required this.isSatisfaction,
     required this.isDifficulty,
     this.socialMediaType,
     required this.onDismiss,
     required this.onAction,
   });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    List<Color> gradientColors;
    if (isDonation) {
      gradientColors = [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)];
    } else if (isSatisfaction) {
      gradientColors = [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)];
    } else if (isDifficulty) {
      gradientColors = [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)];
    } else if (socialMediaType != null) {
      gradientColors = [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)];
    } else {
      gradientColors = [cs.primary.withValues(alpha: 0.14), cs.primary.withValues(alpha: 0.06)];
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDonation
                    ? Icons.favorite_rounded
                    : isSatisfaction
                        ? Icons.feedback_rounded
                        : isDifficulty
                            ? Icons.tune_rounded
                            : socialMediaType == 'mastodon'
                                ? Icons.alternate_email
                                : socialMediaType == 'pixelfed'
                                    ? Icons.camera_alt
                                    : socialMediaType == 'kwebler'
                                        ? Icons.group
                                        : socialMediaType == 'signal'
                                            ? Icons.message
                                            : socialMediaType == 'discord'
                                                ? Icons.discord
                                                : socialMediaType == 'bluesky'
                                                    ? Icons.cloud
                                                    : socialMediaType == 'nooki'
                                                        ? Icons.group
                                                        : Icons.group_add_rounded,
                color: cs.onSurface.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isDonation
                      ? strings.AppStrings.donate
                      : isSatisfaction
                          ? strings.AppStrings.satisfactionSurvey
                          : isDifficulty
                              ? strings.AppStrings.difficultyFeedbackTitle
                              : socialMediaType == 'mastodon'
                                  ? strings.AppStrings.followMastodon
                                  : socialMediaType == 'pixelfed'
                                      ? strings.AppStrings.followPixelfed
                                      : socialMediaType == 'kwebler'
                                          ? strings.AppStrings.followKwebler
                                          : socialMediaType == 'signal'
                                              ? strings.AppStrings.followSignal
                                              : socialMediaType == 'discord'
                                                  ? strings.AppStrings.followDiscord
                                                  : socialMediaType == 'bluesky'
                                                      ? strings.AppStrings.followBluesky
                                                      : socialMediaType == 'nooki'
                                                          ? strings.AppStrings.followNooki
                                                          : strings.AppStrings.followUs,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: Icon(Icons.close, color: cs.onSurface.withValues(alpha: 0.6)),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isDonation
                ? strings.AppStrings.donateExplanation
                : isSatisfaction
                    ? strings.AppStrings.satisfactionSurveyMessage
                    : isDifficulty
                        ? strings.AppStrings.difficultyFeedbackMessage
                        : 'Volg ons op ${socialMediaType ?? 'social media'} voor updates en community!',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          if (isDonation) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onAction(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.favorite_rounded),
                    label: Text(strings.AppStrings.donateButton),
                  ),
                ),
              ],
            ),
          ] else if (isSatisfaction) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onAction(''),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.feedback_rounded),
                    label: Text(strings.AppStrings.satisfactionSurveyButton),
                  ),
                ),
              ],
            ),
          ] else if (isDifficulty) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onAction('too_hard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(strings.AppStrings.difficultyTooHard),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onAction('good'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(strings.AppStrings.difficultyGood),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onAction('too_easy'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(strings.AppStrings.difficultyTooEasy),
                  ),
                ),
              ],
            ),
          ] else if (socialMediaType != null) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => onAction(
                      socialMediaType == 'mastodon'
                          ? strings.AppStrings.mastodonUrl
                          : socialMediaType == 'pixelfed'
                              ? AppUrls.pixelfedUrl
                              : socialMediaType == 'kwebler'
                                  ? strings.AppStrings.kweblerUrl
                                  : socialMediaType == 'signal'
                                      ? strings.AppStrings.signalUrl
                                      : socialMediaType == 'discord'
                                          ? strings.AppStrings.discordUrl
                                          : socialMediaType == 'bluesky'
                                              ? strings.AppStrings.blueskyUrl
                                              : socialMediaType == 'nooki'
                                                  ? strings.AppStrings.nookiUrl
                                                  : '',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(
                      socialMediaType == 'mastodon'
                          ? Icons.alternate_email
                          : socialMediaType == 'pixelfed'
                              ? Icons.camera_alt
                              : socialMediaType == 'kwebler'
                                  ? Icons.group
                                  : socialMediaType == 'signal'
                                      ? Icons.message
                                      : socialMediaType == 'discord'
                                          ? Icons.discord
                                          : socialMediaType == 'bluesky'
                                              ? Icons.cloud
                                              : socialMediaType == 'nooki'
                                                  ? Icons.group
                                                  : Icons.group_add_rounded,
                    ),
                    label: Text(
                      socialMediaType == 'mastodon'
                          ? strings.AppStrings.followMastodon
                          : socialMediaType == 'pixelfed'
                              ? strings.AppStrings.followPixelfed
                              : socialMediaType == 'kwebler'
                                  ? strings.AppStrings.followKwebler
                                  : socialMediaType == 'signal'
                                      ? strings.AppStrings.followSignal
                                      : socialMediaType == 'discord'
                                          ? strings.AppStrings.followDiscord
                                          : socialMediaType == 'bluesky'
                                              ? strings.AppStrings.followBluesky
                                              : socialMediaType == 'nooki'
                                                  ? strings.AppStrings.followNooki
                                                  : strings.AppStrings.followUs,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _SocialButton(
                  label: strings.AppStrings.followMastodon,
                  icon: Icons.alternate_email,
                  onPressed: () => onAction(strings.AppStrings.mastodonUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followPixelfed,
                  icon: Icons.camera_alt,
                  onPressed: () => onAction(AppUrls.pixelfedUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followKwebler,
                  icon: Icons.group,
                  onPressed: () => onAction(strings.AppStrings.kweblerUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followSignal,
                  icon: Icons.message,
                  onPressed: () => onAction(strings.AppStrings.signalUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followDiscord,
                  icon: Icons.discord,
                  onPressed: () => onAction(strings.AppStrings.discordUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followBluesky,
                  icon: Icons.cloud,
                  onPressed: () => onAction(strings.AppStrings.blueskyUrl),
                ),
                _SocialButton(
                  label: strings.AppStrings.followNooki,
                  icon: Icons.group,
                  onPressed: () => onAction(strings.AppStrings.nookiUrl),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: cs.outlineVariant),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      icon: Icon(icon, size: 16),
      label: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}
