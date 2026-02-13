import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/mixing_result.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/widgets/quality_badge.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Card displaying a single mixing recommendation.
///
/// Shows:
/// - Rank number (1st, 2nd, etc)
/// - Paint names and brands with mixing ratios
/// - Result color swatch
/// - Delta E value and quality rating
/// - Target color comparison
class MixingResultCard extends ConsumerWidget {
  const MixingResultCard({
    required this.result,
    required this.index,
    this.targetColor,
    super.key,
  });

  /// The mixing result to display
  final MixingResult result;

  /// The rank/position in the results list (1-indexed)
  final int index;

  /// Optional target color for comparison display
  final LabColor? targetColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with rank and quality
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rank
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ShadTheme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#$index',
                    style: ShadTheme.of(context).textTheme.large.copyWith(
                      color: const Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Delta E and Quality
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'ΔE: ${result.deltaE.toStringAsFixed(2)}',
                      style: ShadTheme.of(context).textTheme.large.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    QualityBadge(quality: result.quality),
                  ],
                ),
              ],
            ),
          ),

          // Paint ratios section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mix Formula',
                  style: ShadTheme.of(context).textTheme.small.copyWith(
                    color: const Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 8),
                ..._buildPaintRatios(context, ref),
              ],
            ),
          ),

          // Color swatches section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFFAFAFA),
              border: Border(
                top: BorderSide(color: Color(0xFFEEEEEE)),
              ),
            ),
            child: Row(
              children: [
                // Target color (if provided)
                if (targetColor != null) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Target',
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                            color: const Color(0xFF9E9E9E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildColorSwatch(targetColor!),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                ],

                // Result color
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Result',
                        style: ShadTheme.of(context).textTheme.small.copyWith(
                          color: const Color(0xFF9E9E9E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildColorSwatch(result.resultingColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the paint ratio display widgets with paint names and brands
  List<Widget> _buildPaintRatios(BuildContext context, WidgetRef ref) {
    final ratios = <Widget>[];

    // Watch the paint inventory to get paint details
    ref.watch(paintInventoryProvider).whenData((paints) {
      // Create a map for fast lookups
      final paintMap = {for (final p in paints) p.id: p};

      for (var i = 0; i < result.ratios.length; i++) {
        final ratio = result.ratios[i];
        final paint = paintMap[ratio.paintId];

        ratios.add(
          Padding(
            padding: EdgeInsets.only(top: i > 0 ? 6 : 0),
            child: Row(
              children: [
                // Ratio percentage badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ShadTheme.of(context).colorScheme.primary.withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${ratio.percentage}%',
                    style: ShadTheme.of(context).textTheme.large.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ShadTheme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Color preview swatch
                if (paint != null)
                  Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: _getPaintDisplayColor(paint),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                // Paint name and brand
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paint?.name ?? 'Unknown Paint',
                        style: ShadTheme.of(context).textTheme.large.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (paint != null)
                        Text(
                          paint.brand.name.toUpperCase(),
                          style: ShadTheme.of(context).textTheme.small.copyWith(
                            color: const Color(0xFF9E9E9E),
                            fontSize: 11,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // Plus sign (if not last)
                if (i < result.ratios.length - 1) ...[
                  const SizedBox(width: 8),
                  Text(
                    '+',
                    style: ShadTheme.of(context).textTheme.large.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }
    });

    return ratios;
  }

  /// Builds a color swatch for displaying LAB color
  Widget _buildColorSwatch(LabColor labColor) {
    final rgbColor = _getPaintDisplayColor(null, labColor);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: rgbColor,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'L:${labColor.l.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gets the RGB color for displaying a paint's LAB color
  /// Handles both PaintColor objects and direct LabColor values
  Color _getPaintDisplayColor(PaintColor? paint, [LabColor? labColor]) {
    final converter = ColorConverter();
    try {
      final labColorToConvert = labColor ?? paint?.labColor;
      if (labColorToConvert == null) return const Color(0xFFE0E0E0);

      return converter.labToRgb(labColorToConvert);
    } on Exception {
      // Fallback if conversion fails
      return const Color(0xFFE0E0E0);
    }
  }
}
