import 'package:flutter/widgets.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/color_match_quality.dart';
import 'package:paint_color_resolver/shared/utils/color_utils.dart';

/// Visual badge indicating the quality of a color match.
///
/// Displays the quality level with appropriate colors:
/// - Excellent: Green
/// - Good: Blue
/// - Acceptable: Yellow/Orange
/// - Poor: Orange/Red
/// - Very Poor: Red
class QualityBadge extends StatelessWidget {
  const QualityBadge({
    required this.quality,
    this.compact = false,
    super.key,
  });

  /// The quality level to display
  final ColorMatchQuality quality;

  /// If true, shows a compact badge with just a color dot
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: getQualityBadgeBackground(quality, context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: getQualityBadgeBorder(quality, context),
        ),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: getQualityBadgeText(quality, context),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Builds a compact dot badge
  Widget _buildCompact(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: getQualityBadgeBackground(quality, context),
        shape: BoxShape.circle,
        border: Border.all(
          color: getQualityBadgeBorder(quality, context),
          width: 2,
        ),
      ),
    );
  }

  /// Gets the display label for the quality level
  String _getLabel() {
    switch (quality) {
      case ColorMatchQuality.excellent:
        return 'Excellent';
      case ColorMatchQuality.good:
        return 'Good';
      case ColorMatchQuality.acceptable:
        return 'Acceptable';
      case ColorMatchQuality.poor:
        return 'Poor';
      case ColorMatchQuality.veryPoor:
        return 'Very Poor';
    }
  }
}
