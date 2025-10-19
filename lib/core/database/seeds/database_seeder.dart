import 'package:drift/drift.dart' show Value;
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/database/app_database.dart';
import 'package:paint_color_resolver/core/database/seeds/vallejo_paints_seed.dart';

final _log = Logger('DatabaseSeeder');

/// Service responsible for seeding the database with initial paint data.
///
/// On first app run, this populates the paint inventory with a curated
/// collection of Vallejo paints. This provides users with a realistic
/// test set for color mixing calculations.
///
/// Seeding is idempotent - subsequent calls do nothing if paints already exist.
class DatabaseSeeder {
  /// Seeds the database with initial paint data if it's empty.
  ///
  /// This should be called on app startup (before presenting the UI).
  /// It checks if paints exist; if not, inserts the seed data.
  ///
  /// Returns true if seeding occurred, false if database was already populated.
  static Future<bool> seedIfEmpty(AppDatabase database) async {
    try {
      // Check if database already has paints
      final existingPaintsCount =
          await database.select(database.paintColors).get().then(
                (paints) => paints.length,
              );

      if (existingPaintsCount > 0) {
        _log.info(
          'Database already seeded with $existingPaintsCount paints. '
          'Skipping seeding.',
        );
        return false;
      }

      _log.info('Database is empty. Starting seed process...');

      // Generate seed paints
      final seedPaints = VallekoPaintsSeed.generateSeedPaints();
      _log.info('Generated ${seedPaints.length} seed paints');

      // Batch insert all paints
      await database.batch((batch) {
        batch.insertAll(
          database.paintColors,
          seedPaints.map((paint) {
            return PaintColorsCompanion(
              name: Value(paint.name),
              brand: Value(paint.brand),
              brandMakerId: Value(paint.brandMakerId),
              labL: Value(paint.labColor.l),
              labA: Value(paint.labColor.a),
              labB: Value(paint.labColor.b),
            );
          }),
        );
      });

      _log.info(
        'Successfully seeded database with ${seedPaints.length} Vallejo paints',
      );
      return true;
    } catch (e, stackTrace) {
      _log.severe('Failed to seed database', e, stackTrace);
      rethrow;
    }
  }

  /// Clears all paints from the database.
  ///
  /// Useful for testing or resetting the app. Use with caution!
  static Future<void> clearAllPaints(AppDatabase database) async {
    try {
      await database.delete(database.paintColors).go();
      _log.info('Cleared all paints from database');
    } catch (e, stackTrace) {
      _log.severe('Failed to clear paints', e, stackTrace);
      rethrow;
    }
  }
}
