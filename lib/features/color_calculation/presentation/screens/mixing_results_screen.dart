import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/providers/color_mixing_provider.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/widgets/mixing_result_card.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mixing Recommendations'),
        elevation: 0,
      ),
      body: resultsAsync.when(
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
                  const Divider(height: 0),
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
              CircularProgressIndicator(),
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
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
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
              ElevatedButton.icon(
                onPressed: () => context.router.pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the target color display section
  Widget _buildTargetColorSection(BuildContext context, LabColor targetColor) {
    // Convert LAB to RGB using proper color science
    final converter = ColorConverter();
    final rgbColor = converter.labToRgb(targetColor);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Color',
            style: Theme.of(context).textTheme.titleMedium,
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
                  border: Border.all(color: Colors.grey),
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
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'L: ${targetColor.l.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'a: ${targetColor.a.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'b: ${targetColor.b.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodyMedium,
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
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No Matching Combinations Found',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Try adjusting the quality threshold or selecting'
              ' a different target color',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.router.pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
