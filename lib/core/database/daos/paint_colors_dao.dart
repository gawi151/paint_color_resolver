import 'package:drift/drift.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/database/app_database.dart';
import 'package:paint_color_resolver/core/database/tables/paint_colors.dart';

part 'paint_colors_dao.g.dart';

final _log = Logger('PaintColorsDao');

/// Data Access Object for paint color inventory operations.
///
/// Provides type-safe CRUD operations and reactive queries for the paint
/// collection. All queries are optimized for the color mixing calculation
/// feature's requirements.
///
/// ## Features:
/// - One-time queries with `Future<T>` return types
/// - Reactive queries with `Stream<T>` for automatic UI updates
/// - Optimized queries for common operations (by brand, by ID, etc.)
/// - Batch operations for bulk updates/deletes
///
/// ## Usage:
/// ```dart
/// final dao = db.paintColorsDao;
///
/// // Insert paint
/// final id = await dao.insertPaint(
///   PaintColorsCompanion.insert(
///     name: 'Red',
///     brand: PaintBrand.vallejo,
///     labL: 53.2,
///     labA: 80.1,
///     labB: 67.2,
///   ),
/// );
///
/// // Watch all paints (reactive)
/// dao.watchAllPaints().listen((paints) {
///   print('Paint count: ${paints.length}');
/// });
/// ```
@DriftAccessor(tables: [PaintColors])
class PaintColorsDao extends DatabaseAccessor<AppDatabase>
    with _$PaintColorsDaoMixin {
  /// Creates the DAO with a reference to the parent database.
  PaintColorsDao(super.attachedDatabase);

  // CREATE OPERATIONS

  /// Inserts a new paint into the collection.
  ///
  /// Returns the auto-generated ID of the inserted paint.
  ///
  /// ## Example:
  /// ```dart
  /// final id = await dao.insertPaint(
  ///   PaintColorsCompanion.insert(
  ///     name: 'Ultramarine Blue',
  ///     brand: PaintBrand.vallejo,
  ///     labL: 32.3,
  ///     labA: 68.3,
  ///     labB: -112.0,
  ///     notes: const Value('Good for shadows'),
  ///   ),
  /// );
  /// print('Inserted paint with ID: $id');
  /// ```
  ///
  /// Throws [InvalidDataException] if required fields are missing or invalid.
  Future<int> insertPaint(PaintColorsCompanion paint) async {
    _log.fine('Inserting paint: ${paint.name.value}');

    try {
      final id = await into(paintColors).insert(paint);
      _log.info('Successfully inserted paint with ID: $id');
      return id;
    } catch (e, stackTrace) {
      _log.severe('Failed to insert paint', e, stackTrace);
      rethrow;
    }
  }

  // READ OPERATIONS (One-time queries)

  /// Retrieves all paints in the collection, sorted alphabetically by name.
  ///
  /// Returns an empty list if no paints exist.
  ///
  /// ## Example:
  /// ```dart
  /// final allPaints = await dao.getAllPaints();
  /// print('Total paints: ${allPaints.length}');
  /// ```
  Future<List<PaintColorEntity>> getAllPaints() async {
    _log.fine('Fetching all paints');

    final query = select(paintColors)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name),
      ]);

    final paints = await query.get();
    _log.fine('Retrieved ${paints.length} paints');
    return paints;
  }

  /// Retrieves a specific paint by its ID.
  ///
  /// Returns `null` if no paint with the given ID exists.
  ///
  /// ## Example:
  /// ```dart
  /// final paint = await dao.getPaintById(42);
  /// if (paint != null) {
  ///   print('Found: ${paint.name}');
  /// }
  /// ```
  Future<PaintColorEntity?> getPaintById(int id) async {
    _log.fine('Fetching paint with ID: $id');

    final query = select(paintColors)..where((t) => t.id.equals(id));

    return query.getSingleOrNull();
  }

  /// Finds all paints from a specific brand.
  ///
  /// Returns paints sorted by name.
  ///
  /// ## Example:
  /// ```dart
  /// final vallejoPaints = await dao.findPaintsByBrand('vallejo');
  /// print('Vallejo paints: ${vallejoPaints.length}');
  /// ```
  Future<List<PaintColorEntity>> findPaintsByBrand(String brand) async {
    _log.fine('Fetching paints for brand: $brand');

    final query = select(paintColors)
      ..where((t) => t.brand.equals(brand))
      ..orderBy([
        (t) => OrderingTerm(expression: t.name),
      ]);

    final paints = await query.get();
    _log.fine('Found ${paints.length} paints for brand: $brand');
    return paints;
  }

  // READ OPERATIONS (Reactive streams)

  /// Watches all paints in the collection with reactive updates.
  ///
  /// The stream emits a new list whenever the paint collection changes
  /// (insert, update, or delete). Paints are sorted alphabetically by name.
  ///
  /// ## Example:
  /// ```dart
  /// StreamBuilder<List<PaintColorEntity>>(
  ///   stream: dao.watchAllPaints(),
  ///   builder: (context, snapshot) {
  ///     if (!snapshot.hasData) return CircularProgressIndicator();
  ///     final paints = snapshot.data!;
  ///     return ListView(
  ///       children: paints.map((p) => Text(p.name)).toList(),
  ///     );
  ///   },
  /// );
  /// ```
  Stream<List<PaintColorEntity>> watchAllPaints() {
    _log.fine('Setting up watch stream for all paints');

    final query = select(paintColors)
      ..orderBy([
        (t) => OrderingTerm(expression: t.name),
      ]);

    return query.watch();
  }

  /// Watches a specific paint by ID with reactive updates.
  ///
  /// The stream emits whenever the paint changes or is deleted.
  /// Emits `null` if the paint doesn't exist or is deleted.
  ///
  /// ## Example:
  /// ```dart
  /// StreamBuilder<PaintColorEntity?>(
  ///   stream: dao.watchPaintById(42),
  ///   builder: (context, snapshot) {
  ///     final paint = snapshot.data;
  ///     if (paint == null) return Text('Paint not found');
  ///     return Text(paint.name);
  ///   },
  /// );
  /// ```
  Stream<PaintColorEntity?> watchPaintById(int id) {
    _log.fine('Setting up watch stream for paint ID: $id');

    final query = select(paintColors)..where((t) => t.id.equals(id));

    return query.watchSingleOrNull();
  }

  /// Watches paints from a specific brand with reactive updates.
  ///
  /// The stream emits whenever paints from this brand are added, updated,
  /// or deleted. Results are sorted alphabetically by name.
  ///
  /// ## Example:
  /// ```dart
  /// StreamBuilder<List<PaintColorEntity>>(
  ///   stream: dao.watchPaintsByBrand('vallejo'),
  ///   builder: (context, snapshot) {
  ///     if (!snapshot.hasData) return CircularProgressIndicator();
  ///     return Text('Vallejo paints: ${snapshot.data!.length}');
  ///   },
  /// );
  /// ```
  Stream<List<PaintColorEntity>> watchPaintsByBrand(String brand) {
    _log.fine('Setting up watch stream for brand: $brand');

    final query = select(paintColors)
      ..where((t) => t.brand.equals(brand))
      ..orderBy([
        (t) => OrderingTerm(expression: t.name),
      ]);

    return query.watch();
  }

  // UPDATE OPERATIONS

  /// Updates an existing paint record with new data.
  ///
  /// Returns `true` if the paint was updated, `false` if no paint with
  /// that ID exists.
  ///
  /// **Note:** This replaces the entire record. Consider updating the
  /// `updatedAt` timestamp when calling this method.
  ///
  /// ## Example:
  /// ```dart
  /// final paint = await dao.getPaintById(42);
  /// if (paint != null) {
  ///   final updated = paint.copyWith(
  ///     notes: 'Updated notes',
  ///     updatedAt: DateTime.now(),
  ///   );
  ///   final success = await dao.updatePaint(updated);
  ///   print('Update successful: $success');
  /// }
  /// ```
  Future<bool> updatePaint(PaintColorEntity paint) async {
    _log.fine('Updating paint ID: ${paint.id}');

    try {
      final updated = await update(paintColors).replace(paint);
      if (updated) {
        _log.info('Successfully updated paint ID: ${paint.id}');
      } else {
        _log.warning('Paint not found for update, ID: ${paint.id}');
      }
      return updated;
    } catch (e, stackTrace) {
      _log.severe('Failed to update paint ID: ${paint.id}', e, stackTrace);
      rethrow;
    }
  }

  /// Updates only the notes field for a specific paint.
  ///
  /// This is a partial update optimized for the common case of updating
  /// user notes without touching other fields.
  ///
  /// ## Example:
  /// ```dart
  /// await dao.updatePaintNotes(42, 'Running low, need to reorder');
  /// ```
  Future<void> updatePaintNotes(int id, String notes) async {
    _log.fine('Updating notes for paint ID: $id');

    try {
      await (update(paintColors)..where((t) => t.id.equals(id))).write(
        PaintColorsCompanion(
          notes: Value(notes),
          updatedAt: Value(DateTime.now()),
        ),
      );
      _log.info('Successfully updated notes for paint ID: $id');
    } catch (e, stackTrace) {
      _log.severe('Failed to update notes for paint ID: $id', e, stackTrace);
      rethrow;
    }
  }

  // DELETE OPERATIONS

  /// Deletes a paint from the collection by ID.
  ///
  /// Does nothing if the paint doesn't exist.
  ///
  /// ## Example:
  /// ```dart
  /// await dao.deletePaint(42);
  /// print('Paint deleted');
  /// ```
  Future<void> deletePaint(int id) async {
    _log.fine('Deleting paint ID: $id');

    try {
      final deletedCount = await (delete(
        paintColors,
      )..where((t) => t.id.equals(id))).go();

      if (deletedCount > 0) {
        _log.info('Successfully deleted paint ID: $id');
      } else {
        _log.warning('Paint not found for deletion, ID: $id');
      }
    } catch (e, stackTrace) {
      _log.severe('Failed to delete paint ID: $id', e, stackTrace);
      rethrow;
    }
  }

  /// Deletes all paints from the collection.
  ///
  /// **Warning:** This is a destructive operation. Use with caution.
  /// Primarily intended for testing and bulk resets.
  ///
  /// ## Example:
  /// ```dart
  /// await dao.deleteAllPaints();
  /// print('All paints deleted');
  /// ```
  Future<void> deleteAllPaints() async {
    _log.warning('Deleting ALL paints from collection');

    try {
      final deletedCount = await delete(paintColors).go();
      _log.info('Successfully deleted $deletedCount paints');
    } catch (e, stackTrace) {
      _log.severe('Failed to delete all paints', e, stackTrace);
      rethrow;
    }
  }

  // HELPER OPERATIONS

  /// Returns the total number of paints in the collection.
  ///
  /// ## Example:
  /// ```dart
  /// final count = await dao.countPaints();
  /// print('You have $count paints');
  /// ```
  Future<int> countPaints() async {
    _log.fine('Counting total paints');

    final countExpression = paintColors.id.count();
    final query = selectOnly(paintColors)..addColumns([countExpression]);

    final result = await query.getSingle();
    final count = result.read(countExpression) ?? 0;

    _log.fine('Total paint count: $count');
    return count;
  }

  /// Returns a distinct list of all brands present in the collection.
  ///
  /// Useful for filtering UI and analytics.
  ///
  /// ## Example:
  /// ```dart
  /// final brands = await dao.getAllBrands();
  /// print('Available brands: ${brands.join(', ')}');
  /// ```
  Future<List<String>> getAllBrands() async {
    _log.fine('Fetching distinct brands');

    final query = selectOnly(paintColors, distinct: true)
      ..addColumns([paintColors.brand])
      ..orderBy([
        OrderingTerm(expression: paintColors.brand),
      ]);

    final results = await query.get();
    final brands = results
        .map((row) => row.read(paintColors.brand))
        .whereType<String>()
        .toList();

    _log.fine('Found ${brands.length} distinct brands');
    return brands;
  }
}
