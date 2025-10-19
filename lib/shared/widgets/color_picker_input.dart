import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/shared/utils/color_conversion_utils.dart';
import 'package:paint_color_resolver/shared/widgets/debug_lab_display.dart';

/// Facade widget for inline color picking with HueRingPicker.
///
/// Shows the color picker directly inline (no dialog) with:
/// - HueRingPicker for visual color selection with built-in HEX input
/// - Gamut validation warnings
/// - Debug LAB display (debug mode only)
///
/// ## Usage:
/// ```dart
/// ColorPickerInput(
///   onColorChanged: (labColor, isValidGamut) {
///     setState(() => selectedColor = labColor);
///   },
///   initialHex: '#FF5733',
/// )
/// ```
///
/// ## Callbacks:
/// - `onColorChanged`: Called when color changes, provides LAB color and gamut
///  validity
/// - `initialHex`: Optional initial HEX value (defaults to #FFFFFF)
class ColorPickerInput extends StatefulWidget {
  const ColorPickerInput({
    required this.onColorChanged,
    this.initialHex,
    super.key,
  });

  /// Callback when color is selected.
  /// Provides: (labColor, isValidGamut)
  final void Function(LabColor labColor, {required bool isValidGamut})
  onColorChanged;

  /// Initial HEX color value (format: #RRGGBB)
  /// Defaults to white (#FFFFFF) if not provided.
  final String? initialHex;

  @override
  State<ColorPickerInput> createState() => _ColorPickerInputState();
}

class _ColorPickerInputState extends State<ColorPickerInput> {
  late Color _selectedColor;
  bool _isValidGamut = true;

  @override
  void initState() {
    super.initState();
    // Parse initial hex or default to white
    final initialHex = widget.initialHex ?? '#FFFFFF';
    _selectedColor = ColorConversionUtils.hexToColor(initialHex);
    // Defer gamut update to after first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateGamut(_selectedColor);
      }
    });
  }

  /// Updates gamut validation and notifies parent of color change.
  void _handleColorChanged(Color color) {
    // Defer state changes to after build phase
    final update = Future.microtask(() {
      if (!mounted) return;
      setState(() {
        _selectedColor = color;
      });
      _updateGamut(color);
    });
    unawaited(update);
  }

  /// Updates gamut validation state and notifies parent.
  void _updateGamut(Color color) {
    final (labColor, isValid) = ColorConversionUtils.rgbToLab(color);
    if (!mounted) return;
    setState(() {
      _isValidGamut = isValid;
    });
    widget.onColorChanged(labColor, isValidGamut: isValid);
  }

  @override
  Widget build(BuildContext context) {
    final (labColor, _) = ColorConversionUtils.rgbToLab(_selectedColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Inline HueRingPicker
        HueRingPicker(
          pickerColor: _selectedColor,
          onColorChanged: _handleColorChanged,
        ),

        const SizedBox(height: 16),

        // Debug: LAB values display
        DebugLabDisplay.maybeShow(labColor: labColor),

        // Gamut warning (if out of gamut)
        if (!_isValidGamut) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ColorConversionUtils.gamutValidationMessage(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
