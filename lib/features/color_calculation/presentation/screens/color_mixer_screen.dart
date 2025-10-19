import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/providers/color_mixing_provider.dart';

final _log = Logger('ColorMixer');

/// Screen for selecting a target color and configuring mixing parameters.
///
/// Users can:
/// - Pick a target color using the color picker
/// - Select number of paints to mix (1, 2, or 3)
/// - Adjust quality threshold
/// - Trigger the mixing calculation
///
/// Once calculation completes, navigates to [MixingResultsScreen].
@RoutePage()
class ColorMixerScreen extends ConsumerStatefulWidget {
  const ColorMixerScreen({super.key});

  @override
  ConsumerState<ColorMixerScreen> createState() => _ColorMixerScreenState();
}

class _ColorMixerScreenState extends ConsumerState<ColorMixerScreen> {
  Color _selectedColor = Colors.red;
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
            _buildColorPicker(context),
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

  /// Builds the color picker widget
  Widget _buildColorPicker(BuildContext context) {
    final targetColor = ref.watch(targetColorProvider);

    return GestureDetector(
      onTap: () => _showColorPicker(context),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Color Swatch
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
            ),

            // Color Info
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selected Color',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      if (targetColor != null)
                        Text(
                          'LAB(L:${targetColor.l.toStringAsFixed(1)}, '
                          'a:${targetColor.a.toStringAsFixed(1)}, '
                          'b:${targetColor.b.toStringAsFixed(1)})',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      else
                        Text(
                          'No color selected',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                    ],
                  ),
                  Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
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

  /// Shows the color picker and updates the target color
  void _showColorPicker(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick Target Color'),
        content: ColorPicker(
          color: _selectedColor,
          onColorChanged: (color) {
            setState(() => _selectedColor = color);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Convert selected color to LAB and store
              try {
                final hexColor =
                    '#${_selectedColor.toARGB32().toRadixString(16)
                    .padLeft(8, '0')
                    .substring(2)
                    .toUpperCase()}';
                ref
                    .read(targetColorProvider.notifier)
                    .setTargetColorFromHex(hexColor);
                _log.info('Target color set: $hexColor');
                Navigator.pop(context);
              } on Exception catch (e) {
                _log.severe('Failed to set target color', e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
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

/// Simple color picker widget
class ColorPicker extends StatefulWidget {
  const ColorPicker({
    required this.color,
    required this.onColorChanged,
    super.key,
  });

  final Color color;
  final ValueChanged<Color> onColorChanged;

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late HSVColor _hsvColor;

  @override
  void initState() {
    super.initState();
    _hsvColor = HSVColor.fromColor(widget.color);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hue slider
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Text('Hue:'),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: _hsvColor.hue,
                  max: 360,
                  onChanged: (value) {
                    setState(() {
                      _hsvColor = _hsvColor.withHue(value);
                      widget.onColorChanged(_hsvColor.toColor());
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Saturation slider
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Text('Sat:'),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: _hsvColor.saturation,
                  onChanged: (value) {
                    setState(() {
                      _hsvColor = _hsvColor.withSaturation(value);
                      widget.onColorChanged(_hsvColor.toColor());
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Brightness slider
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              const Text('Brightness:'),
              const SizedBox(width: 12),
              Expanded(
                child: Slider(
                  value: _hsvColor.value,
                  onChanged: (value) {
                    setState(() {
                      _hsvColor = _hsvColor.withValue(value);
                      widget.onColorChanged(_hsvColor.toColor());
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Color preview
        const SizedBox(height: 12),
        Container(
          height: 60,
          decoration: BoxDecoration(
            color: widget.color,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
