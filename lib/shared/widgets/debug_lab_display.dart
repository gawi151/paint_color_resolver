import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';

/// A debug widget that displays LAB color values in a styled container.
///
/// This widget is only rendered in debug mode and can be placed anywhere in the
/// app to display and verify LAB color values during development.
///
/// Shows:
/// - L* value (lightness: 0-100)
/// - a* value (red-green axis: -128 to 127)
/// - b* value (yellow-blue axis: -128 to 127)
///
/// ## Usage:
/// ```dart
/// if (kDebugMode) {
///   DebugLabDisplay(labColor: myLabColor)
/// }
/// ```
///
/// Or use the [DebugLabDisplay.maybeShow] helper for conditional rendering:
/// ```dart
/// DebugLabDisplay.maybeShow(labColor: myLabColor)
/// ```
class DebugLabDisplay extends StatelessWidget {
  const DebugLabDisplay({
    required this.labColor,
    this.title,
    super.key,
  });

  /// The LAB color values to display.
  final LabColor labColor;

  /// Optional title for the debug display.
  final String? title;

  /// Conditionally shows the debug display only in debug mode.
  ///
  /// This is a convenience helper to avoid wrapping with `if (kDebugMode)`.
  ///
  /// Example:
  /// ```dart
  /// DebugLabDisplay.maybeShow(labColor: myLabColor, title: 'Selected Color')
  /// ```
  static Widget maybeShow({
    required LabColor labColor,
    String? title,
  }) {
    if (!kDebugMode) return const SizedBox.shrink();
    return DebugLabDisplay(labColor: labColor, title: title);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title ?? 'Debug: LAB Values',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 8),

          // LAB values with monospace font
          Text(
            'L: ${labColor.l.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
          Text(
            'a: ${labColor.a.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
          Text(
            'b: ${labColor.b.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
