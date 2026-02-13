import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:paint_color_resolver/shared/utils/color_conversion_utils.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ShadCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Color preview circle
              _ColorPreview(labColor: paint.labColor),
              const SizedBox(width: 16),

              // Paint info (name, brand, debug LAB)
              Expanded(child: _PaintInfo(paint: paint)),

              // Menu button (edit/delete options)
              _MenuButton(
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ],
          ),
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
    final theme = ShadTheme.of(context);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: rgbColor,
        border: Border.all(
          color: theme.colorScheme.border,
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
  const _PaintInfo({required this.paint});
  final PaintColor paint;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Paint name
        Text(
          paint.name,
          style: theme.textTheme.p.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: 4),

        // Brand label
        Text(
          _brandDisplayName(paint.brand),
          style: theme.textTheme.small,
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
    final theme = ShadTheme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.destructive.withValues(alpha: 0.1),
        borderRadius: theme.radius,
        border: Border.all(
          color: theme.colorScheme.destructive.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        'L:${labColor.l.toStringAsFixed(1)} '
        'a:${labColor.a.toStringAsFixed(1)} '
        'b:${labColor.b.toStringAsFixed(1)}',
        style: theme.textTheme.small.copyWith(
          color: theme.colorScheme.destructive,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

/// Menu button that opens a dialog with edit/delete options.
class _MenuButton extends StatelessWidget {
  const _MenuButton({
    required this.onEdit,
    required this.onDelete,
  });
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ShadButton.ghost(
      leading: const Icon(LucideIcons.ellipsisVertical, size: 18),
      onPressed: () async {
        await showShadDialog<void>(
          context: context,
          builder: (context) => ShadDialog(
            title: const Text('Actions'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onEdit();
                  },
                  child: const Row(
                    children: [
                      Icon(LucideIcons.pencil, size: 18),
                      SizedBox(width: 12),
                      Text('Edit'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ShadButton.destructive(
                  onPressed: () {
                    Navigator.pop(context);
                    onDelete();
                  },
                  child: const Row(
                    children: [
                      Icon(LucideIcons.trash, size: 18),
                      SizedBox(width: 12),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
