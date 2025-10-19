import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/providers/color_mixing_provider.dart';
import 'package:paint_color_resolver/shared/utils/color_conversion_utils.dart';
import 'package:paint_color_resolver/shared/widgets/color_picker_input.dart';

final _log = Logger('ColorMixer');

/// Screen for selecting a target color and configuring mixing parameters.
///
/// Users can:
/// - Pick a target color using the color picker
/// - Select number of paints to mix (1, 2, or 3)
/// - Adjust quality threshold
/// - Trigger the mixing calculation
///
/// Once calculation completes, navigates to MixingResultsScreen.
@RoutePage()
class ColorMixerScreen extends ConsumerStatefulWidget {
  const ColorMixerScreen({super.key});

  @override
  ConsumerState<ColorMixerScreen> createState() => _ColorMixerScreenState();
}

class _ColorMixerScreenState extends ConsumerState<ColorMixerScreen> {
  bool _isCalculating = false;

  @override
  Widget build(BuildContext context) {
    final targetColor = ref.watch(targetColorProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Mixer'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Color Selection
            Text(
              'Target Color',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ColorPickerInput(
              initialHex: targetColor != null
                  ? ColorConversionUtils.labToHex(targetColor)
                  : '#FF0000',
              onColorChanged:
                  (
                    LabColor labColor, {
                    required bool isValidGamut,
                  }) {
                    // Delay provider modification until after widget
                    // tree is built
                    final update = Future.microtask(() {
                      ref
                          .read(targetColorProvider.notifier)
                          .setTargetColor(labColor);
                      _log.info(
                        'Target color set (Gamut: $isValidGamut)',
                      );
                    });
                    unawaited(update);
                  },
            ),
            const SizedBox(height: 32),

            // Number of Paints Selection
            Text(
              'Number of Paints to Mix',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildPaintCountSelector(),
            const SizedBox(height: 32),

            // Quality Threshold
            Text(
              'Quality Threshold',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildQualityThresholdSlider(),
            const SizedBox(height: 32),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: targetColor != null && !_isCalculating
                    ? () => _calculateAndNavigate(context)
                    : null,
                icon: _isCalculating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : const Icon(Icons.calculate),
                label: Text(
                  _isCalculating ? 'Calculating...' : 'Calculate Mixing',
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info text
            if (targetColor == null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Select a color to get started',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Builds the paint count selector (1, 2, or 3 paints)
  Widget _buildPaintCountSelector() {
    final numberOfPaints = ref.watch(numberOfPaintsProvider);

    return Row(
      children: [
        for (int i = 1; i <= 3; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i < 3 ? 12 : 0),
              child: ChoiceChip(
                selected: numberOfPaints == i,
                onSelected: (selected) {
                  if (selected) {
                    ref
                        .read(numberOfPaintsProvider.notifier)
                        .setNumberOfPaints(i);
                    _log.fine('Set number of paints to: $i');
                  }
                },
                label: Text('$i Paint${i > 1 ? 's' : ''}'),
              ),
            ),
          ),
      ],
    );
  }

  /// Builds the quality threshold slider
  Widget _buildQualityThresholdSlider() {
    final maxDeltaE = ref.watch(maxDeltaEThresholdProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Max Delta E (Color Difference):',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                maxDeltaE.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: maxDeltaE,
          min: 1,
          max: 20,
          divisions: 19,
          label: maxDeltaE.toStringAsFixed(1),
          onChanged: (value) {
            ref.read(maxDeltaEThresholdProvider.notifier).setMaxDeltaE(value);
            _log.fine('Set max Delta E to: $value');
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Lower = stricter matches, Higher = more options',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// Calculates mixing results and navigates to results screen
  Future<void> _calculateAndNavigate(BuildContext context) async {
    setState(() => _isCalculating = true);

    try {
      // Wait for the mixing calculation to complete
      final results = await ref.read(mixingResultsProvider.future);

      if (!context.mounted) return;

      _log.info('Mixing calculation complete: ${results.length} results');

      // Navigate to results screen
      if (context.mounted) {
        await context.router.push(const MixingResultsRoute());
      }
    } on Exception catch (e) {
      _log.severe('Mixing calculation failed', e);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calculation failed: $e'),
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (context.mounted) {
        setState(() => _isCalculating = false);
      }
    }
  }
}
