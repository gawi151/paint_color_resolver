import 'package:flutter/material.dart';
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
        return Colors.green.shade50;
      case ColorMatchQuality.good:
        return Colors.blue.shade50;
      case ColorMatchQuality.acceptable:
        return Colors.amber.shade50;
      case ColorMatchQuality.poor:
        return Colors.orange.shade50;
      case ColorMatchQuality.veryPoor:
        return Colors.red.shade50;
    }
  }

  /// Gets the border color for the quality level
  Color _getBorderColor() {
    switch (quality) {
      case ColorMatchQuality.excellent:
        return Colors.green.shade400;
      case ColorMatchQuality.good:
        return Colors.blue.shade400;
      case ColorMatchQuality.acceptable:
        return Colors.amber.shade400;
      case ColorMatchQuality.poor:
        return Colors.orange.shade400;
      case ColorMatchQuality.veryPoor:
        return Colors.red.shade400;
    }
  }

  /// Gets the text color for the quality level
  Color _getTextColor() {
    switch (quality) {
      case ColorMatchQuality.excellent:
        return Colors.green.shade700;
      case ColorMatchQuality.good:
        return Colors.blue.shade700;
      case ColorMatchQuality.acceptable:
        return Colors.amber.shade700;
      case ColorMatchQuality.poor:
        return Colors.orange.shade700;
      case ColorMatchQuality.veryPoor:
        return Colors.red.shade700;
    }
  }
}
