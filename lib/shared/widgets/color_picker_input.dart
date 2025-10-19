import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/shared/utils/color_conversion_utils.dart';
import 'package:paint_color_resolver/shared/widgets/debug_lab_display.dart';

/// A widget for selecting colors with visual picker and HEX input.
///
/// Features:
/// - Color picker UI (flutter_colorpicker)
/// - HEX code input field (#RRGGBB)
/// - Color preview box
/// - Debug mode: displays calculated LAB values
/// - Gamut validation: warns if color is outside sRGB range
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
/// - `onColorChanged`: Called when color is selected, provides LAB color
///   and gamut validity
/// - `initialHex`: Optional initial HEX value to display (defaults to
///   white #FFFFFF)
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
  late TextEditingController _hexController;
  bool _isValidGamut = true;
  String _gamutWarning = '';

  @override
  void initState() {
    super.initState();

    // Parse initial hex or default to white
    final initialHex = widget.initialHex ?? '#FFFFFF';
    _selectedColor = ColorConversionUtils.hexToColor(initialHex);
    _hexController = TextEditingController(text: initialHex);
    _updateLabAndGamut(_selectedColor);
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  /// Updates local LAB color and gamut validation state only.
  /// Does NOT notify parent callback (used during initialization).
  void _updateLabAndGamut(Color color) {
    final (labColor, isValid) = ColorConversionUtils.rgbToLab(color);

    setState(() {
      _isValidGamut = isValid;
      _gamutWarning = isValid
          ? ''
          : ColorConversionUtils.gamutValidationMessage();
    });
  }

  /// Updates LAB color and notifies parent of the change.
  /// Called only when user actively changes the color.
  void _handleColorChanged(Color color) {
    _updateLabAndGamut(color);

    final (labColor, isValid) = ColorConversionUtils.rgbToLab(color);
    widget.onColorChanged(labColor, isValidGamut: isValid);
  }

  /// Handles HEX input field changes.
  void _onHexInputChanged(String value) {
    if (!ColorConversionUtils.isValidHexFormat(value)) {
      return; // Don't update if invalid format
    }

    final newColor = ColorConversionUtils.hexToColor(value);
    setState(() {
      _selectedColor = newColor;
    });

    _handleColorChanged(newColor);
  }

  /// Opens the color picker dialog.
  void _showColorPicker() {
    unawaited(
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color;
                  _hexController.text = ColorConversionUtils.colorToHex(color);
                });
              },
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
              displayThumbColor: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );

    // After dialog closes, notify parent of color change
    Future.delayed(const Duration(milliseconds: 300), () {
      _handleColorChanged(_selectedColor);
    });
  }

  /// Builds suffix icon for HEX input (validation indicator).
  Widget? _buildSuffixIcon() {
    if (_hexController.text.isEmpty) return null;

    if (!ColorConversionUtils.isValidHexFormat(_hexController.text)) {
      return Icon(
        Icons.close,
        color: Theme.of(context).colorScheme.error,
      );
    }

    return Icon(
      Icons.check,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  /// Gets error text for HEX input validation.
  String? _getHexInputError() {
    if (_hexController.text.isEmpty) return null;

    if (!ColorConversionUtils.isValidHexFormat(_hexController.text)) {
      return 'Invalid format. Use #RRGGBB';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final (labColor, _) = ColorConversionUtils.rgbToLab(_selectedColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Color preview and picker button
        Row(
          children: [
            // Preview circle
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedColor,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Buttons
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Color Picker button
                  ElevatedButton.icon(
                    onPressed: _showColorPicker,
                    icon: const Icon(Icons.palette),
                    label: const Text('Pick Color'),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // HEX input field
        TextFormField(
          controller: _hexController,
          decoration: InputDecoration(
            labelText: 'HEX Color',
            hintText: '#RRGGBB',
            prefixIcon: const Icon(Icons.tag),
            suffixIcon: _buildSuffixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            errorText: _getHexInputError(),
            helperText: 'Format: #RRGGBB (e.g., #FF5733)',
          ),
          onChanged: _onHexInputChanged,
          textCapitalization: TextCapitalization.characters,
          maxLength: 7,
          buildCounter:
              (
                context, {
                required currentLength,
                required isFocused,
                maxLength,
              }) {
                return null; // Hide character counter
              },
        ),

        const SizedBox(height: 12),

        // Debug: LAB values display
        DebugLabDisplay.maybeShow(labColor: labColor),

        // Gamut warning (if out of gamut)
        if (!_isValidGamut && _gamutWarning.isNotEmpty) ...[
          const SizedBox(height: 8),
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
                    _gamutWarning,
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
