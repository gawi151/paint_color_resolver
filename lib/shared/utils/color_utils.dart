import 'package:flutter/widgets.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/color_match_quality.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Returns a contrasting text color for a given background color.
///
/// Uses luminance calculation to determine if background is light or dark,
/// then returns appropriate text color for contrast.
///
/// Based on WCAG recommendations: luminance > 0.5 indicates
/// light background (use dark text), luminance <= 0.5 indicates
/// dark background (use light text).
Color getContrastingTextColor(Color backgroundColor) {
  final luminance = backgroundColor.computeLuminance();
  return luminance > 0.5
      ? const Color(0xFF000000) // Black text on light backgrounds
      : const Color(0xFFFFFFFF); // White text on dark backgrounds
}

/// Returns a background color for a quality badge.
///
/// Maps quality tiers to theme-aware colors that adapt to both light and
/// dark modes with opacity variants for visual hierarchy.
Color getQualityBadgeBackground(
  ColorMatchQuality quality,
  BuildContext context,
) {
  final colorScheme = ShadTheme.of(context).colorScheme;

  return switch (quality) {
    ColorMatchQuality.excellent => colorScheme.primary.withValues(alpha: 0.15),
    ColorMatchQuality.good => colorScheme.primary.withValues(alpha: 0.1),
    ColorMatchQuality.acceptable => colorScheme.primary.withValues(alpha: 0.08),
    ColorMatchQuality.poor => colorScheme.destructive.withValues(alpha: 0.15),
    ColorMatchQuality.veryPoor => colorScheme.destructive.withValues(
      alpha: 0.2,
    ),
  };
}

/// Returns a border color for a quality badge.
///
/// Maps quality tiers to theme-aware border colors.
Color getQualityBadgeBorder(
  ColorMatchQuality quality,
  BuildContext context,
) {
  final colorScheme = ShadTheme.of(context).colorScheme;

  return switch (quality) {
    ColorMatchQuality.excellent ||
    ColorMatchQuality.good => colorScheme.primary,
    ColorMatchQuality.acceptable ||
    ColorMatchQuality.poor ||
    ColorMatchQuality.veryPoor => colorScheme.destructive,
  };
}

/// Returns a text color for a quality badge.
///
/// Maps quality tiers to theme-aware text colors with appropriate contrast.
Color getQualityBadgeText(
  ColorMatchQuality quality,
  BuildContext context,
) {
  final colorScheme = ShadTheme.of(context).colorScheme;

  return switch (quality) {
    ColorMatchQuality.excellent ||
    ColorMatchQuality.good => colorScheme.primaryForeground,
    ColorMatchQuality.acceptable ||
    ColorMatchQuality.poor ||
    ColorMatchQuality.veryPoor => colorScheme.destructiveForeground,
  };
}
