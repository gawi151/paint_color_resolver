import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/providers/color_mixing_provider.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/widgets/mixing_result_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Screen displaying the calculated mixing recommendations.
///
/// Shows a list of the best paint combinations sorted by quality.
/// Each result displays:
/// - Paint names and mixing ratios
/// - Predicted result color
/// - Delta E (color difference)
/// - Quality rating (Excellent/Good/Acceptable/etc)
///
/// Users can:
/// - View details of each mix
/// - Sort results by different criteria
/// - Filter by quality threshold
@RoutePage()
class MixingResultsScreen extends ConsumerWidget {
  const MixingResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final targetColor = ref.watch(targetColorProvider);
    final resultsAsync = ref.watch(sortedMixingResultsProvider);

    return Column(
      children: [
        // Custom AppBar replacement
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.card,
            border: Border(
              bottom: BorderSide(
                color: ShadTheme.of(context).colorScheme.border,
              ),
            ),
          ),
          child: Row(
            children: [
              ShadButton.ghost(
                leading: const Icon(LucideIcons.arrowLeft),
                onPressed: () => context.router.pop(),
              ),
              const SizedBox(width: 8),
              const Text(
                'Mixing Recommendations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Body
        Expanded(
          child: resultsAsync.when(
            // Results loaded successfully
            data: (results) {
              if (results.isEmpty) {
                return _buildEmptyState(context);
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Target color display at top
                    if (targetColor != null) ...[
                      _buildTargetColorSection(context, targetColor),
                      const ShadSeparator.horizontal(),
                    ],

                    // Results list
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      itemCount: results.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => MixingResultCard(
                        result: results[index],
                        index: index + 1,
                        targetColor: targetColor,
                      ),
                    ),
                  ],
                ),
              );
            },

            // Loading state
            loading: () => const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShadProgress(),
                  SizedBox(height: 16),
                  Text('Calculating optimal mixes...'),
                ],
              ),
            ),

            // Error state
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.circleX,
                    size: 64,
                    color: ShadTheme.of(context).colorScheme.destructive,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Calculation failed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ShadButton(
                    onPressed: () => context.router.pop(),
                    child: const Text('Back to Setup'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the target color display section
  Widget _buildTargetColorSection(BuildContext context, LabColor targetColor) {
    // Convert LAB to RGB using proper color science
    final converter = ColorConverter();
    final rgbColor = converter.labToRgb(targetColor);

    return Container(
      padding: const EdgeInsets.all(16),
      color: ShadTheme.of(context).colorScheme.muted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Color',
            style: ShadTheme.of(context).textTheme.large,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Color swatch
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: rgbColor,
                  border: Border.all(
                    color: ShadTheme.of(context).colorScheme.border,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 16),
              // Color values
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LAB Color Values',
                      style: ShadTheme.of(context).textTheme.small,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'L: ${targetColor.l.toStringAsFixed(1)}',
                      style: ShadTheme.of(context).textTheme.p,
                    ),
                    Text(
                      'a: ${targetColor.a.toStringAsFixed(1)}',
                      style: ShadTheme.of(context).textTheme.p,
                    ),
                    Text(
                      'b: ${targetColor.b.toStringAsFixed(1)}',
                      style: ShadTheme.of(context).textTheme.p,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the empty state when no results found
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.searchX,
            size: 64,
            color: ShadTheme.of(context).colorScheme.mutedForeground,
          ),
          const SizedBox(height: 16),
          Text(
            'No Matching Combinations Found',
            style: ShadTheme.of(context).textTheme.large,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Try adjusting the quality threshold or selecting'
              ' a different target color',
              textAlign: TextAlign.center,
              style: ShadTheme.of(context).textTheme.p.copyWith(
                color: ShadTheme.of(context).colorScheme.mutedForeground,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ShadButton(
            onPressed: () => context.router.pop(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
