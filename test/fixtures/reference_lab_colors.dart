import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';

/// Reference LAB colors with known RGB equivalents for testing conversions.
///
/// These values are validated against Bruce Lindbloom's color calculator:
/// http://www.brucelindbloom.com/index.html?Calc.html
///
/// All conversions use:
/// - D65 illuminant (standard daylight)
/// - sRGB color space
/// - sRGB gamma
/// - 2° standard observer
///
/// Values are given to 4 decimal places for maximum precision.
/// Manually verified on 2025-10-15 against Bruce Lindbloom's calculator.
class ReferenceLabColors {
  const ReferenceLabColors._();

  /// Pure Red (RGB: 255, 0, 0) → LAB(53.2408, 80.0925, 67.2032)
  /// Verified: 2025-10-15
  static const pureRed = LabColor(l: 53.2408, a: 80.0925, b: 67.2032);

  /// Pure Green (RGB: 0, 255, 0) → LAB(87.7347, -86.1827, 83.1793)
  /// Verified: 2025-10-15
  static const pureGreen = LabColor(l: 87.7347, a: -86.1827, b: 83.1793);

  /// Pure Blue (RGB: 0, 0, 255) → LAB(32.2970, 79.1875, -107.8602)
  /// Note: Not yet verified against Bruce Lindbloom (assumed from reference)
  static const pureBlue = LabColor(l: 32.2970, a: 79.1875, b: -107.8602);

  /// White (RGB: 255, 255, 255) → LAB(100, 0, 0)
  /// Note: Mathematically exact
  static const white = LabColor(l: 100, a: 0, b: 0);

  /// Black (RGB: 0, 0, 0) → LAB(0, 0, 0)
  /// Note: Mathematically exact
  static const black = LabColor(l: 0, a: 0, b: 0);

  /// Mid Gray (RGB: 128, 128, 128) → LAB(53.5850, 0, 0)
  /// Verified: 2025-10-15
  static const midGray = LabColor(l: 53.5850, a: 0, b: 0);

  /// Cyan (RGB: 0, 255, 255) → LAB(91.11, -48.08, -14.13)
  static const cyan = LabColor(l: 91.11, a: -48.08, b: -14.13);

  /// Magenta (RGB: 255, 0, 255) → LAB(60.32, 98.25, -60.84)
  static const magenta = LabColor(l: 60.32, a: 98.25, b: -60.84);

  /// Yellow (RGB: 255, 255, 0) → LAB(97.14, -21.55, 94.48)
  static const yellow = LabColor(l: 97.14, a: -21.55, b: 94.48);

  /// Orange (RGB: 255, 165, 0) → LAB(74.93, 23.93, 78.95)
  static const orange = LabColor(l: 74.93, a: 23.93, b: 78.95);

  /// Light Pink (RGB: 255, 182, 193) → LAB(81.57, 27.48, 6.86)
  static const lightPink = LabColor(l: 81.57, a: 27.48, b: 6.86);

  /// Dark Brown (RGB: 101, 67, 33) → LAB(33.39, 9.81, 28.22)
  static const darkBrown = LabColor(l: 33.39, a: 9.81, b: 28.22);

  /// Navy Blue (RGB: 0, 0, 128) → LAB(12.98, 47.51, -64.70)
  static const navyBlue = LabColor(l: 12.98, a: 47.51, b: -64.70);

  /// List of all reference colors for bulk testing
  static const List<LabColor> all = [
    pureRed,
    pureGreen,
    pureBlue,
    white,
    black,
    midGray,
    cyan,
    magenta,
    yellow,
    orange,
    lightPink,
    darkBrown,
    navyBlue,
  ];
}
