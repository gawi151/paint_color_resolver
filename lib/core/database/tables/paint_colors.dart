import 'package:drift/drift.dart';
import 'package:paint_color_resolver/core/database/type_converters/paint_brand_converter.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';

/// Database table for storing paint color inventory.
///
/// Represents the user's collection of physical paints with their LAB color
/// space values for accurate color mixing calculations.
///
/// ## Schema:
/// - **id**: Auto-increment primary key
/// - **name**: Paint name (e.g., "Red Gore", "Ultramarine Blue")
/// - **brand**: Paint manufacturer (stored as enum name)
/// - **brandMakerId**: Optional product code/SKU (e.g., "vallejo_70926")
/// - **labL**: LAB Lightness value (0-100)
/// - **labA**: LAB a* component (green-red axis, -128 to 127)
/// - **labB**: LAB b* component (blue-yellow axis, -128 to 127)
/// - **addedAt**: When paint was added to collection
/// - **updatedAt**: Last modification timestamp
/// - **notes**: Optional user notes about the paint
///
/// ## LAB Color Space:
/// LAB values are stored as REAL (SQLite floating point) for precision in
/// color mixing calculations. This is critical for accurate Delta E
/// calculations and color matching.
///
/// ## Generated Data Class:
/// Drift generates a `PaintColor` data class from this table definition.
/// This is separate from the domain model in `lib/shared/models/paint_color.dart`.
///
/// ## Example Usage:
/// ```dart
/// // Insert paint
/// await db.into(db.paintColors).insert(
///   PaintColorsCompanion(
///     name: const Value('Red'),
///     brand: const Value('vallejo'),
///     labL: const Value(53.2),
///     labA: const Value(80.1),
///     labB: const Value(67.2),
///   ),
/// );
///
/// // Query all paints
/// final paints = await db.select(db.paintColors).get();
/// ```
@DataClassName('PaintColor')
class PaintColors extends Table {
  /// Auto-incrementing primary key.
  IntColumn get id => integer().autoIncrement()();

  /// Paint name (required, 1-100 characters).
  ///
  /// Examples: "Red Gore", "Ultramarine Blue", "Black Primer"
  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Paint brand/manufacturer.
  ///
  /// Stored as enum name string (e.g., "vallejo", "citadel").
  /// Converted to [PaintBrand] enum in Dart via [PaintBrandConverter].
  TextColumn get brand => text().map(const PaintBrandConverter())();

  /// Optional product code/SKU from the brand maker.
  ///
  /// Examples: "vallejo_70926", "citadel_51-01", "reaper_09021"
  ///
  /// Used for identifying specific paints and cross-referencing between
  /// paint databases. Nullable to support legacy paints without codes.
  TextColumn get brandMakerId => text().nullable()();

  /// LAB Lightness component (0-100).
  ///
  /// - 0 = absolute black
  /// - 50 = medium lightness
  /// - 100 = absolute white
  RealColumn get labL => real()();

  /// LAB a* component (-128 to 127).
  ///
  /// Represents the green-red axis:
  /// - Negative values = green
  /// - Positive values = red
  /// - 0 = neutral (gray)
  RealColumn get labA => real()();

  /// LAB b* component (-128 to 127).
  ///
  /// Represents the blue-yellow axis:
  /// - Negative values = blue
  /// - Positive values = yellow
  /// - 0 = neutral (gray)
  RealColumn get labB => real()();

  /// Timestamp when paint was added to collection.
  ///
  /// Defaults to current time on insert.
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  /// Timestamp when paint record was last updated.
  ///
  /// Defaults to current time on insert.
  /// Should be updated manually when paint data changes.
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  /// Optional user notes about the paint.
  ///
  /// Examples:
  /// - "Good for base coating"
  /// - "Running low, need to reorder"
  /// - "Slightly dried out"
  TextColumn get notes => text().nullable()();
}
