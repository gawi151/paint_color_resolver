import 'package:flutter/widgets.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/color_match_quality.dart';

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
      return _buildCompact();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getBorderColor()),
      ),
      child: Text(
        _getLabel(),
        style: TextStyle(
          color: _getTextColor(),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Builds a compact dot badge
  Widget _buildCompact() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        shape: BoxShape.circle,
        border: Border.all(color: _getBorderColor(), width: 2),
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

  /// Gets the background color for the quality level
  Color _getBackgroundColor() {
    switch (quality) {
      case ColorMatchQuality.excellent:
        return const Color(0xFFE8F5E9);
      case ColorMatchQuality.good:
        return const Color(0xFFE3F2FD);
      case ColorMatchQuality.acceptable:
        return const Color(0xFFFFF8E1);
      case ColorMatchQuality.poor:
        return const Color(0xFFFFF3E0);
      case ColorMatchQuality.veryPoor:
        return const Color(0xFFFFEBEE);
    }
  }

  /// Gets the border color for the quality level
  Color _getBorderColor() {
    switch (quality) {
      case ColorMatchQuality.excellent:
        return const Color(0xFF66BB6A);
      case ColorMatchQuality.good:
        return const Color(0xFF42A5F5);
      case ColorMatchQuality.acceptable:
        return const Color(0xFFFFCA28);
      case ColorMatchQuality.poor:
        return const Color(0xFFFF9800);
      case ColorMatchQuality.veryPoor:
        return const Color(0xFFEF5350);
    }
  }

  /// Gets the text color for the quality level
  Color _getTextColor() {
    switch (quality) {
      case ColorMatchQuality.excellent:
        return const Color(0xFF388E3C);
      case ColorMatchQuality.good:
        return const Color(0xFF1976D2);
      case ColorMatchQuality.acceptable:
        return const Color(0xFFF57F17);
      case ColorMatchQuality.poor:
        return const Color(0xFFE65100);
      case ColorMatchQuality.veryPoor:
        return const Color(0xFFC62828);
    }
  }
}
