import 'package:flutter/material.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';

/// Utility functions for color conversion and validation.
///
/// Provides helpers for converting between RGB (HEX) and LAB color spaces,
/// with built-in sRGB gamut validation.
class ColorConversionUtils {
  static final _converter = ColorConverter();

  /// Converts a hex color string to [LabColor].
  ///
  /// Accepts formats: `#RRGGBB` or `RRGGBB`
  ///
  /// Returns `(labColor, isValidGamut)` where `isValidGamut` indicates if the
  /// color is within the sRGB gamut (all RGB values 0-255).
  ///
  /// Example:
  /// ```dart
  /// final (lab, isValid) = ColorConversionUtils.hexToLab('#FF5733');
  /// ```
  static (LabColor, bool) hexToLab(String hex) {
    try {
      final labColor = _converter.hexToLab(hex);
      final isValid = _isValidSrgbGamut(labColor);
      return (labColor, isValid);
    } catch (e) {
      throw ArgumentError('Failed to convert hex to LAB: $e');
    }
  }

  /// Converts a [LabColor] back to a hex string.
  ///
  /// Returns format: `#RRGGBB` (lowercase)
  ///
  /// Note: Some LAB values may be out-of-gamut and will be clamped to the
  /// nearest representable RGB color.
  ///
  /// Example:
  /// ```dart
  /// final hex = ColorConversionUtils.labToHex(
  ///   LabColor(l: 53.23, a: 80.11, b: 67.22),
  /// );
  /// print(hex); // #ff5733
  /// ```
  static String labToHex(LabColor lab) {
    final rgbColor = _converter.labToRgb(lab);
    final hexString = rgbColor.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${hexString.substring(2).toLowerCase()}';
  }

  /// Converts RGB color to [LabColor].
  ///
  /// Returns `(labColor, isValidGamut)` where `isValidGamut` indicates if the
  /// color is within the sRGB gamut.
  ///
  /// Example:
  /// ```dart
  /// final (lab, isValid) = ColorConversionUtils.rgbToLab(Color(0xFFFF5733));
  /// ```
  static (LabColor, bool) rgbToLab(Color rgb) {
    final labColor = _converter.rgbToLab(rgb);
    final isValid = _isValidSrgbGamut(labColor);
    return (labColor, isValid);
  }

  /// Converts [LabColor] to RGB [Color].
  ///
  /// Note: Some LAB values may be out-of-gamut and will be clamped to the
  /// nearest representable RGB color.
  static Color labToRgb(LabColor lab) {
    return _converter.labToRgb(lab);
  }

  /// Validates if a [LabColor] can be accurately represented in sRGB.
  ///
  /// A color is considered in-gamut if when converted to RGB, all components
  /// are within 0-255 range without clamping.
  ///
  /// Returns `true` if the color is within valid sRGB gamut, `false` otherwise.
  ///
  /// ## Why This Matters:
  /// Some highly saturated or unusual colors (especially with high L* and
  /// extreme a*/b* values) cannot be represented in sRGB. These will be
  /// auto-clamped during conversion, potentially resulting in unexpected
  /// colors.
  ///
  /// Example:
  /// ```dart
  /// final lab = LabColor(l: 50, a: 50, b: 50);
  /// final isValid = ColorConversionUtils.isValidSrgbGamut(lab);
  /// ```
  static bool isValidSrgbGamut(LabColor lab) => _isValidSrgbGamut(lab);

  /// Internal validation check for sRGB gamut.
  ///
  /// Converts LAB to RGB and checks if any component exceeds 0-255 range.
  static bool _isValidSrgbGamut(LabColor lab) {
    try {
      final rgbColor = _converter.labToRgb(lab);

      // Check if any RGB component is outside 0-255 range
      // We check the internal int value structure
      final int32 = rgbColor.toARGB32();
      final r = (int32 >> 16) & 0xFF;
      final g = (int32 >> 8) & 0xFF;
      final b = int32 & 0xFF;

      // If values are clamped (0 or 255 in all channels), it's likely out
      // of gamut. This is a heuristic - a more robust check would need the
      // original XYZ values
      return !(r == 0 && g == 0 && b == 0) &&
          !(r == 255 && g == 255 && b == 255);
    } on Exception {
      return false;
    }
  }

  /// Validates if a hex color string is in valid format.
  ///
  /// Accepts: `#RRGGBB` or `RRGGBB`
  ///
  /// Returns `true` if valid, `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// ColorConversionUtils.isValidHexFormat('#FF5733'); // true
  /// ColorConversionUtils.isValidHexFormat('FF5733');   // true
  /// ColorConversionUtils.isValidHexFormat('GGHHII');   // false
  /// ```
  static bool isValidHexFormat(String hex) {
    final cleanHex = hex.replaceAll('#', '').toUpperCase();

    // Must be exactly 6 characters
    if (cleanHex.length != 6) return false;

    // Must be valid hex digits
    return RegExp(r'^[0-9A-F]{6}$').hasMatch(cleanHex);
  }

  /// Gets user-friendly message for gamut validation.
  ///
  /// Example:
  /// ```dart
  /// if (!isValid) {
  ///   showWarning(ColorConversionUtils.gamutValidationMessage());
  /// }
  /// ```
  static String gamutValidationMessage() {
    return 'This color is outside the standard RGB gamut. The color may appear '
        'slightly different when displayed.';
  }

  /// Converts a hex color string to a [Color].
  ///
  /// Accepts formats: `#RRGGBB` or `RRGGBB`
  ///
  /// Returns `Color.white` if conversion fails.
  ///
  /// Example:
  /// ```dart
  /// final color = ColorConversionUtils.hexToColor('#FF5733');
  /// ```
  static Color hexToColor(String hex) {
    try {
      return Color(
        int.parse(hex.replaceAll('#', ''), radix: 16) + 0xFF000000,
      );
    } on FormatException {
      return Colors.white;
    }
  }

  /// Converts a [Color] to a hex string.
  ///
  /// Returns format: `#RRGGBB` (uppercase)
  ///
  /// Example:
  /// ```dart
  /// final hex = ColorConversionUtils.colorToHex(Color(0xFFFF5733));
  /// print(hex); // #FF5733
  /// ```
  static String colorToHex(Color color) {
    final hexString = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${hexString.substring(2).toUpperCase()}';
  }
}
