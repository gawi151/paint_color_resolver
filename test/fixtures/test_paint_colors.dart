import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';

/// Test paint colors with realistic LAB values for testing mixing algorithms.
///
/// These represent a small paint collection inspired by Vallejo Model Color
/// and other miniature paint ranges.
class TestPaintColors {
  const TestPaintColors._();

  /// Vallejo Red - Bright primary red
  static final vallejoRed = PaintColor(
    id: 'vallejo_70926',
    name: 'Red',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 45.2, a: 68.4, b: 55.1),
    addedAt: DateTime(2024),
  );

  /// Vallejo Blue - Deep blue
  static final vallejoBlue = PaintColor(
    id: 'vallejo_70925',
    name: 'Blue',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 28.5, a: 15.2, b: -52.8),
    addedAt: DateTime(2024),
  );

  /// Vallejo Yellow - Bright yellow
  static final vallejoYellow = PaintColor(
    id: 'vallejo_70948',
    name: 'Yellow',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 92.1, a: -15.3, b: 88.2),
    addedAt: DateTime(2024),
  );

  /// Vallejo White - Pure white
  static final vallejoWhite = PaintColor(
    id: 'vallejo_70951',
    name: 'White',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 98.5, a: 0.2, b: -0.1),
    addedAt: DateTime(2024),
  );

  /// Vallejo Black - Deep black
  static final vallejoBlack = PaintColor(
    id: 'vallejo_70950',
    name: 'Black',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 5.2, a: 0.1, b: -0.2),
    addedAt: DateTime(2024),
  );

  /// Vallejo Flat Earth - Medium brown
  static final vallejoFlatEarth = PaintColor(
    id: 'vallejo_70983',
    name: 'Flat Earth',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 38.7, a: 8.3, b: 22.5),
    addedAt: DateTime(2024),
  );

  /// Vallejo German Camo Beige - Light tan
  static final vallejoGermanCamoBeige = PaintColor(
    id: 'vallejo_70821',
    name: 'German Camo Beige',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 68.4, a: 5.2, b: 28.9),
    addedAt: DateTime(2024),
  );

  /// Vallejo Orange - Vivid orange
  static final vallejoOrange = PaintColor(
    id: 'vallejo_70733',
    name: 'Orange',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 62.8, a: 38.7, b: 68.3),
    addedAt: DateTime(2024),
  );

  /// Vallejo Green - Medium green
  static final vallejoGreen = PaintColor(
    id: 'vallejo_70968',
    name: 'Green',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 52.3, a: -35.8, b: 28.4),
    addedAt: DateTime(2024),
  );

  /// Vallejo Purple - Deep purple
  static final vallejoPurple = PaintColor(
    id: 'vallejo_70960',
    name: 'Purple',
    brand: PaintBrand.vallejo,
    labColor: const LabColor(l: 32.5, a: 48.2, b: -38.7),
    addedAt: DateTime(2024),
  );

  /// Small collection (10 paints) for basic testing
  static final List<PaintColor> smallCollection = [
    vallejoRed,
    vallejoBlue,
    vallejoYellow,
    vallejoWhite,
    vallejoBlack,
    vallejoFlatEarth,
    vallejoGermanCamoBeige,
    vallejoOrange,
    vallejoGreen,
    vallejoPurple,
  ];

  /// Medium collection (50 paints) for performance testing
  /// Creates duplicates with slight variations for testing purposes
  static List<PaintColor> get mediumCollection {
    final paints = <PaintColor>[];
    for (var i = 0; i < 5; i++) {
      for (final paint in smallCollection) {
        paints.add(
          PaintColor(
            id: '${paint.id}_var$i',
            name: '${paint.name} Variant $i',
            brand: paint.brand,
            labColor: LabColor(
              l: (paint.labColor.l + i * 2).clamp(0.0, 100.0),
              a: (paint.labColor.a + i * 0.5).clamp(-128.0, 127.0),
              b: (paint.labColor.b + i * 0.5).clamp(-128.0, 127.0),
            ),
            addedAt: paint.addedAt,
          ),
        );
      }
    }
    return paints;
  }
}
