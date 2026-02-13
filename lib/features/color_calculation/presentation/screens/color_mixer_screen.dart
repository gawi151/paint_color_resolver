import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show Material, Slider;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/providers/color_mixing_provider.dart';
import 'package:paint_color_resolver/shared/utils/color_conversion_utils.dart';
import 'package:paint_color_resolver/shared/widgets/color_picker_input.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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

    return Column(
      children: [
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
          child: const Text(
            'Color Mixer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ShadToaster(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Target Color Selection
                  const Text(
                    'Target Color',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ColorPickerInput(
                    initialHex: targetColor != null
                        ? ColorConversionUtils.labToHex(targetColor)
                        : '#FF0000',
                    onColorChanged:
                        (
                          labColor, {
                          required isValidGamut,
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
                  const Text(
                    'Number of Paints to Mix',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildPaintCountSelector(),
                  const SizedBox(height: 32),

                  // Quality Threshold
                  const Text(
                    'Quality Threshold',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildQualityThresholdSlider(),
                  const SizedBox(height: 32),

                  // Calculate Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ShadButton(
                      onPressed: targetColor != null && !_isCalculating
                          ? () => _calculateAndNavigate(context)
                          : null,
                      leading: _isCalculating
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: ShadProgress(),
                            )
                          : const Icon(LucideIcons.slidersHorizontal),
                      child: Text(
                        _isCalculating ? 'Calculating...' : 'Calculate Mixing',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info text
                  if (targetColor == null)
                    const ShadCard(
                      child: Row(
                        children: [
                          Icon(
                            LucideIcons.info,
                            color: Color(0xFFFF9800),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Select a color to get started',
                              style: TextStyle(color: Color(0xFFFF9800)),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
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
              child: ShadButton(
                onPressed: () {
                  ref
                      .read(numberOfPaintsProvider.notifier)
                      .setNumberOfPaints(i);
                  _log.fine('Set number of paints to: $i');
                },
                // Highlight selected paint count
                backgroundColor: numberOfPaints == i
                    ? ShadTheme.of(context).colorScheme.primary
                    : null,
                foregroundColor: numberOfPaints == i
                    ? ShadTheme.of(context).colorScheme.primaryForeground
                    : null,
                child: Text('$i Paint${i > 1 ? 's' : ''}'),
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
            const Text(
              'Max Delta E (Color Difference):',
              style: TextStyle(fontSize: 14),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: ShadTheme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: ShadTheme.of(context).radius,
              ),
              child: Text(
                maxDeltaE.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Material(
          child: Slider(
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
        ),
        const SizedBox(height: 8),
        const Text(
          'Lower = stricter matches, Higher = more options',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF9E9E9E),
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

      ShadToaster.of(context).show(
        ShadToast.destructive(
          title: const Text('Calculation failed'),
          description: Text(e.toString()),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (context.mounted) {
        setState(() => _isCalculating = false);
      }
    }
  }
}
