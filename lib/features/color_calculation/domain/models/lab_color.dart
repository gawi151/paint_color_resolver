import 'package:dart_mappable/dart_mappable.dart';

part 'lab_color.mapper.dart';

/// Represents a color in the CIELAB (LAB) color space.
///
/// LAB is a perceptually uniform color space designed to match human vision.
/// Unlike RGB, equal distances in LAB space correspond to roughly equal
/// perceived color differences, making it ideal for color mixing calculations.
///
/// ## Color Space Parameters:
/// - **L (Lightness)**: 0 (black) to 100 (white)
/// - **a**: Green (-128) to Red (+127)
/// - **b**: Blue (-128) to Yellow (+127)
///
/// ## Reference White Point:
/// D65 illuminant (standard daylight) is used for all conversions.
///
/// See: https://en.wikipedia.org/wiki/CIELAB_color_space
@MappableClass()
class LabColor with LabColorMappable {
  /// Creates a LAB color with validation.
  ///
  /// Throws [ArgumentError] if values are out of valid ranges:
  /// - L must be between 0 and 100
  /// - a must be between -128 and 127
  /// - b must be between -128 and 127
  const LabColor({
    required this.l,
    required this.a,
    required this.b,
  }) : assert(
         l >= 0 && l <= 100,
         'Lightness (L) must be between 0 and 100, got: $l',
       ),
       assert(
         a >= -128 && a <= 127,
         'a component must be between -128 and 127, got: $a',
       ),
       assert(
         b >= -128 && b <= 127,
         'b component must be between -128 and 127, got: $b',
       );

  /// Creates a LAB color representing black (L=0, a=0, b=0).
  const LabColor.black() : l = 0, a = 0, b = 0;

  /// Creates a LAB color representing white (L=100, a=0, b=0).
  const LabColor.white() : l = 100, a = 0, b = 0;

  /// Lightness: 0 (black) to 100 (white)
  final double l;

  /// Green (-128) to Red (+127)
  final double a;

  /// Blue (-128) to Yellow (+127)
  final double b;

  @override
  String toString() =>
      'LabColor(L: ${l.toStringAsFixed(2)}, '
      'a: ${a.toStringAsFixed(2)}, b: ${b.toStringAsFixed(2)})';
}
