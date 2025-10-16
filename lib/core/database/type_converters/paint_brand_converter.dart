import 'package:drift/drift.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';

/// Type converter for storing [PaintBrand] enum as TEXT in the database.
///
/// Converts between the domain [PaintBrand] enum and its string representation
/// for database persistence. This maintains type safety in Dart while using
/// efficient text storage in SQLite.
///
/// ## Example:
/// ```dart
/// // In table definition:
/// TextColumn get brand => text().map(const PaintBrandConverter())();
///
/// // Automatic conversion:
/// PaintBrand.vallejo -> "vallejo" (database)
/// "vallejo" -> PaintBrand.vallejo (Dart)
/// ```
class PaintBrandConverter extends TypeConverter<PaintBrand, String> {
  /// Creates a const instance of the converter.
  const PaintBrandConverter();

  @override
  PaintBrand fromSql(String fromDb) {
    // Find enum value by name, matching database string
    return PaintBrand.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => PaintBrand.other,
    );
  }

  @override
  String toSql(PaintBrand value) {
    // Store enum name as string
    return value.name;
  }
}
