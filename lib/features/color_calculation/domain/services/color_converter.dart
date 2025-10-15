import 'dart:math';
import 'dart:ui';

import 'package:flutter_color/flutter_color.dart' as fc;

import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';

/// Service for converting colors between RGB and CIELAB color spaces.
///
/// ## Implementation Notes:
/// - **LAB → RGB**: Uses `flutter_color` package's
///   `CielabColor.getColorFromCielab()` which includes proper gamma correction
/// - **RGB → LAB**: Custom implementation with sRGB gamma correction and
///   D65 illuminant (standard daylight)
///
/// ## Color Space References:
/// - sRGB specification: https://en.wikipedia.org/wiki/SRGB
/// - D65 illuminant:
///   https://en.wikipedia.org/wiki/Standard_illuminant#D65_values
/// - Bruce Lindbloom's calculator:
///   http://www.brucelindbloom.com/index.html?Calc.html
class ColorConverter {
  /// D65 reference white point tristimulus values.
  ///
  /// D65 represents standard daylight and is the reference white used in sRGB.
  static const double _xn = 95.047;
  static const double _yn = 100;
  static const double _zn = 108.883;

  /// Converts an RGB color to CIELAB color space.
  ///
  /// The conversion follows these steps:
  /// 1. RGB (0-255) → Linear RGB (gamma correction/linearization)
  /// 2. Linear RGB → XYZ (matrix transformation with D65 illuminant)
  /// 3. XYZ → LAB (using D65 reference white point)
  ///
  /// ## Implementation:
  /// This is a custom implementation because `flutter_color` does not provide
  /// RGB → LAB conversion. The algorithm uses standard sRGB and CIELAB
  /// formulas.
  ///
  /// ## Example:
  /// ```dart
  /// final converter = ColorConverter();
  /// final redLab = converter.rgbToLab(Color(0xFFFF0000));
  /// print(redLab); // LabColor(L: 53.23, a: 80.11, b: 67.22)
  /// ```
  LabColor rgbToLab(Color color) {
    // Step 1: RGB → Linear RGB (gamma correction)
    final linearR = _gammaToLinear(color.r);
    final linearG = _gammaToLinear(color.g);
    final linearB = _gammaToLinear(color.b);

    // Step 2: Linear RGB → XYZ (D65 illuminant matrix)
    // Using sRGB → XYZ transformation matrix
    var x = linearR * 0.4124564 + linearG * 0.3575761 + linearB * 0.1804375;
    var y = linearR * 0.2126729 + linearG * 0.7151522 + linearB * 0.0721750;
    var z = linearR * 0.0193339 + linearG * 0.1191920 + linearB * 0.9503041;

    // Scale to 0-100 range
    x *= 100;
    y *= 100;
    z *= 100;

    // Step 3: XYZ → LAB
    final fx = _f(x / _xn);
    final fy = _f(y / _yn);
    final fz = _f(z / _zn);

    final l = (116 * fy - 16).clamp(0.0, 100.0);
    final a = (500 * (fx - fy)).clamp(-128.0, 127.0);
    final b = (200 * (fy - fz)).clamp(-128.0, 127.0);

    return LabColor(l: l, a: a, b: b);
  }

  /// Converts a CIELAB color to RGB color space.
  ///
  /// This uses the `flutter_color` package's
  /// `CielabColor.getColorFromCielab()` method which includes proper gamma
  /// correction and handles out-of-gamut colors.
  ///
  /// ## Out-of-Gamut Handling:
  /// Some LAB values cannot be represented in sRGB (especially highly saturated
  /// colors). These values are clamped to the nearest representable RGB color.
  ///
  /// ## Example:
  /// ```dart
  /// final converter = ColorConverter();
  /// final lab = LabColor(l: 53.23, a: 80.11, b: 67.22);
  /// final rgbColor = converter.labToRgb(lab);
  /// ```
  Color labToRgb(LabColor lab) {
    final rgbColor = fc.CielabColor.getColorFromCielab(lab.l, lab.a, lab.b, 1);
    return Color(rgbColor);
  }

  /// Converts a hex color string to CIELAB color space.
  ///
  /// Accepts formats: `#RRGGBB` or `RRGGBB`
  ///
  /// ## Example:
  /// ```dart
  /// final converter = ColorConverter();
  /// final lab = converter.hexToLab('#FF5733');
  /// ```
  LabColor hexToLab(String hex) {
    // Remove # if present
    final cleanHex = hex.replaceAll('#', '');

    // Validate hex format
    if (cleanHex.length != 6) {
      throw ArgumentError(
        'Invalid hex color format. Expected 6 characters (RRGGBB), got: $hex',
      );
    }

    // Parse hex to RGB
    final r = int.parse(cleanHex.substring(0, 2), radix: 16);
    final g = int.parse(cleanHex.substring(2, 4), radix: 16);
    final b = int.parse(cleanHex.substring(4, 6), radix: 16);

    final color = Color.fromARGB(255, r, g, b);
    return rgbToLab(color);
  }

  /// Removes gamma encoding from an sRGB component value (0.0 to 1.0).
  ///
  /// This converts from gamma-encoded sRGB to linear RGB, which represents
  /// actual light intensity. Required for accurate color space transformations.
  ///
  /// Formula from sRGB specification:
  /// - If value ≤ 0.04045: linear = value / 12.92
  /// - If value > 0.04045: linear = ((value + 0.055) / 1.055)^2.4
  double _gammaToLinear(double component) {
    if (component <= 0.04045) {
      return component / 12.92;
    } else {
      return pow((component + 0.055) / 1.055, 2.4).toDouble();
    }
  }

  /// Applies the f(t) function for XYZ → LAB conversion.
  ///
  /// This is part of the CIELAB formula that handles the perceptual
  /// non-linearity of human vision.
  ///
  /// Formula:
  /// - If t > δ³: f(t) = t^(1/3)
  /// - If t ≤ δ³: f(t) = t/(3δ²) + 4/29
  ///
  /// Where δ = 6/29
  double _f(double t) {
    const delta = 6.0 / 29.0;
    const threshold = delta * delta * delta;

    if (t > threshold) {
      return pow(t, 1.0 / 3.0).toDouble();
    } else {
      return t / (3 * delta * delta) + 4.0 / 29.0;
    }
  }
}
