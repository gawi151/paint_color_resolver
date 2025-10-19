import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:paint_color_resolver/shared/utils/color_conversion_utils.dart';

/// A card widget displaying a paint color with visual preview and action menu.
///
/// Shows:
/// - Paint name (primary text)
/// - Brand label (secondary text)
/// - Color preview circle
/// - Menu button (3-dot icon) for edit/delete actions
///
/// In debug mode, displays LAB values below the paint name for verification.
///
/// ## Usage:
/// ```dart
/// PaintCard(
///   paint: myPaint,
///   onEdit: () => Navigator.of(context).push(...),
///   onDelete: () => showDeleteConfirmation(...),
/// )
/// ```
class PaintCard extends StatelessWidget {
  const PaintCard({
    required this.paint,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  /// The paint to display.
  final PaintColor paint;

  /// Callback when user taps the Edit option in menu.
  final VoidCallback onEdit;

  /// Callback when user taps the Delete option in menu.
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Color preview circle
            _ColorPreview(labColor: paint.labColor),
            const SizedBox(width: 16),

            // Paint info (name, brand, debug LAB)
            Expanded(
              child: _PaintInfo(
                paint: paint,
                isDarkMode: isDarkMode,
              ),
            ),

            // Menu button (edit/delete options)
            _MenuButton(
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays the paint color as a circular preview.
class _ColorPreview extends StatelessWidget {
  const _ColorPreview({required this.labColor});
  final LabColor labColor;

  @override
  Widget build(BuildContext context) {
    final rgbColor = ColorConversionUtils.labToRgb(labColor);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: rgbColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: rgbColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

/// Displays paint name, brand, and debug LAB values (if in debug mode).
class _PaintInfo extends StatelessWidget {
  const _PaintInfo({
    required this.paint,
    required this.isDarkMode,
  });
  final PaintColor paint;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Paint name
        Text(
          paint.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Brand label
        Text(
          _brandDisplayName(paint.brand),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),

        // Debug: Show LAB values (only in debug mode)
        if (kDebugMode) ...[
          const SizedBox(height: 6),
          _DebugLabDisplay(labColor: paint.labColor),
        ],
      ],
    );
  }

  /// Returns user-friendly brand display name.
  String _brandDisplayName(PaintBrand brand) {
    return switch (brand) {
      PaintBrand.vallejo => 'Vallejo',
      PaintBrand.citadel => 'Citadel',
      PaintBrand.armyPainter => 'Army Painter',
      PaintBrand.reaper => 'Reaper',
      PaintBrand.scale75 => 'Scale75',
      PaintBrand.other => 'Other',
    };
  }
}

/// Displays LAB values for debugging purposes (debug mode only).
class _DebugLabDisplay extends StatelessWidget {
  const _DebugLabDisplay({required this.labColor});
  final LabColor labColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'L:${labColor.l.toStringAsFixed(1)} '
        'a:${labColor.a.toStringAsFixed(1)} '
        'b:${labColor.b.toStringAsFixed(1)}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Menu button that opens a BottomSheet with edit/delete options.
class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.onEdit,
    required this.onDelete,
  });
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'edit',
          onTap: onEdit,
          child: const Row(
            children: [
              Icon(Icons.edit_outlined, size: 18),
              SizedBox(width: 12),
              Text('Edit'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          onTap: onDelete,
          child: const Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.red),
              SizedBox(width: 12),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }
}
