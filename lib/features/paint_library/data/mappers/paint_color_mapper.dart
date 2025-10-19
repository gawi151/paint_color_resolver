import 'package:paint_color_resolver/core/database/app_database.dart' as db;
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart' as domain;

/// Mapper for converting between database and domain paint color models.
///
/// The database layer (Drift) generates a `PaintColorEntity` class with
/// database-specific fields. This mapper converts that to the domain
/// `PaintColor` model used throughout the application.
///
/// This mapper is the only place where database entities are exposed.
/// All other layers work exclusively with domain models.
class PaintColorMapper {
  const PaintColorMapper._();

  /// Converts a database PaintColorEntity to a domain PaintColor.
  ///
  /// Maps all fields from the database model, converting LAB components
  /// and brand to the appropriate domain types.
  static domain.PaintColor fromDatabase(db.PaintColorEntity dbPaint) {
    return domain.PaintColor(
      id: dbPaint.id,
      name: dbPaint.name,
      brand: dbPaint.brand,
      brandMakerId: dbPaint.brandMakerId,
      labColor: LabColor(
        l: dbPaint.labL,
        a: dbPaint.labA,
        b: dbPaint.labB,
      ),
      addedAt: dbPaint.addedAt,
    );
  }

  /// Converts a list of database PaintColorEntities to domain PaintColors.
  static List<domain.PaintColor> fromDatabaseList(
    List<db.PaintColorEntity> dbPaints,
  ) {
    return dbPaints.map(fromDatabase).toList();
  }

  /// Converts a database PaintColorEntity (nullable) to a domain
  /// PaintColor (nullable).
  static domain.PaintColor? fromDatabaseNullable(
    db.PaintColorEntity? dbPaint,
  ) {
    return dbPaint != null ? fromDatabase(dbPaint) : null;
  }
}
