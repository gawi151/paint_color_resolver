import 'package:dart_mappable/dart_mappable.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';

part 'paint_color.mapper.dart';

/// Represents a paint brand/manufacturer.
enum PaintBrand {
  /// Vallejo Model Color (primary brand for MVP)
  vallejo,

  /// Games Workshop Citadel paints
  citadel,

  /// The Army Painter
  armyPainter,

  /// Reaper Master Series
  reaper,

  /// Scale75
  scale75,

  /// Other/Unknown brand
  other,
}

/// Represents an individual paint color in the user's collection.
///
/// Contains:
/// - Unique identifier
/// - Paint name (e.g., "Red Gore", "Ultramarine Blue")
/// - Brand/manufacturer
/// - LAB color space representation
/// - Date added to collection
///
/// ## Example:
/// ```dart
/// final paint = PaintColor(
///   id: 'vallejo_70926',
///   name: 'Red',
///   brand: PaintBrand.vallejo,
///   labColor: LabColor(l: 53.2, a: 80.1, b: 67.2),
///   addedAt: DateTime.now(),
/// );
/// ```
@MappableClass()
class PaintColor with PaintColorMappable {
  /// Creates a paint color instance.
  const PaintColor({
    required this.id,
    required this.name,
    required this.brand,
    required this.labColor,
    required this.addedAt,
  });

  /// Unique identifier for this paint.
  final String id;

  /// Human-readable name of the paint.
  final String name;

  /// The brand/manufacturer of the paint.
  final PaintBrand brand;

  /// The color represented in LAB color space.
  ///
  /// LAB is used instead of RGB because it's perceptually uniform,
  /// making it ideal for color mixing calculations.
  final LabColor labColor;

  /// When this paint was added to the user's collection.
  final DateTime addedAt;

  @override
  String toString() => 'PaintColor($name by ${brand.name}, $labColor)';
}
