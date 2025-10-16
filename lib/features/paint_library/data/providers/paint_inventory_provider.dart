import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/database/app_database.dart';
import 'package:paint_color_resolver/core/database/providers/database_provider.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart'
    hide PaintColor;

final _log = Logger('PaintInventory');

/// Manages the complete paint inventory state.
///
/// This provider loads, adds, edits, and removes paints from the user's
/// collection using the underlying Drift database layer.
///
/// ## State Management:
/// - Uses AsyncNotifierProvider for async state with loading/error handling
/// - Automatically reloads inventory after mutations
/// - Integrates with PaintColorsDao for database operations
///
/// ## Usage in Widgets:
/// ```dart
/// Consumer(
///   builder: (context, ref, _) {
///     final inventoryAsync = ref.watch(paintInventoryProvider);
///
///     return inventoryAsync.when(
///       data: (paints) => ListView.builder(
///         itemCount: paints.length,
///         itemBuilder: (context, index) => Text(paints[index].name),
///       ),
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => Text('Error: $error'),
///     );
///   },
/// )
/// ```
///
/// ## Adding a Paint:
/// ```dart
/// await ref.read(paintInventoryProvider.notifier).addPaint(
///   name: 'Ultramarine Blue',
///   brand: PaintBrand.vallejo,
///   labColor: LabColor(l: 32.3, a: 68.3, b: -112.0),
///   notes: 'Good for shadows',
/// );
/// ```
final paintInventoryProvider =
    AsyncNotifierProvider<PaintInventoryNotifier, List<PaintColor>>(
      PaintInventoryNotifier.new,
    );

/// Notifier for managing paint inventory state.
class PaintInventoryNotifier extends AsyncNotifier<List<PaintColor>> {
  @override
  Future<List<PaintColor>> build() async {
    _log.fine('Loading paint inventory');

    try {
      final dao = ref.read(paintColorsDaoProvider);
      final paints = await dao.getAllPaints();
      _log.info('Loaded ${paints.length} paints from database');
      return paints;
    } catch (e, stackTrace) {
      _log.severe('Failed to load paint inventory', e, stackTrace);
      rethrow;
    }
  }

  /// Adds a new paint to the inventory.
  ///
  /// Validates inputs, creates the paint record, inserts into database,
  /// and reloads the full inventory.
  ///
  /// ## Parameters:
  /// - **name**: Paint name (must not be empty)
  /// - **brand**: Paint manufacturer
  /// - **labColor**: Color in LAB color space
  /// - **notes**: Optional user notes
  ///
  /// ## Example:
  /// ```dart
  /// await notifier.addPaint(
  ///   name: 'Goblin Green',
  ///   brand: PaintBrand.citadel,
  ///   labColor: LabColor(l: 45.0, a: -30.0, b: 50.0),
  ///   notes: 'Classic Citadel green',
  /// );
  /// ```
  ///
  /// ## Throws:
  /// - [ArgumentError] if name is empty
  /// - [InvalidDataException] if LAB values are out of range
  /// - Database exceptions on insert failure
  Future<void> addPaint({
    required String name,
    required PaintBrand brand,
    required LabColor labColor,
    String? notes,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      throw ArgumentError('Paint name cannot be empty');
    }

    _log.info('Adding paint: $name by ${brand.name}');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dao = ref.read(paintColorsDaoProvider);

      // Create paint companion for insertion
      final paintCompanion = PaintColorsCompanion.insert(
        name: name.trim(),
        brand: brand,
        labL: labColor.l,
        labA: labColor.a,
        labB: labColor.b,
        notes: Value(notes),
      );

      // Insert and get generated ID
      final id = await dao.insertPaint(paintCompanion);
      _log.info('Successfully added paint with ID: $id');

      // Reload full inventory
      return dao.getAllPaints();
    });
  }

  /// Edits an existing paint in the inventory.
  ///
  /// Updates the paint record with new values and reloads the inventory.
  ///
  /// ## Parameters:
  /// - **paintId**: ID of paint to edit
  /// - **name**: Updated paint name
  /// - **brand**: Updated brand
  /// - **labColor**: Updated LAB color
  /// - **notes**: Updated notes (optional)
  ///
  /// ## Example:
  /// ```dart
  /// await notifier.editPaint(
  ///   paintId: 42,
  ///   name: 'Blood Red (Updated)',
  ///   brand: PaintBrand.citadel,
  ///   labColor: LabColor(l: 40.0, a: 70.0, b: 60.0),
  ///   notes: 'Reformulated version',
  /// );
  /// ```
  ///
  /// ## Throws:
  /// - [ArgumentError] if name is empty
  /// - Database exceptions if paint not found or update fails
  Future<void> editPaint({
    required int paintId,
    required String name,
    required PaintBrand brand,
    required LabColor labColor,
    String? notes,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      throw ArgumentError('Paint name cannot be empty');
    }

    _log.info('Editing paint id=$paintId');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dao = ref.read(paintColorsDaoProvider);

      // Get existing paint to preserve timestamps
      final existingPaint = await dao.getPaintById(paintId);
      if (existingPaint == null) {
        throw ArgumentError('Paint with ID $paintId not found');
      }

      // Create updated paint record
      final updatedPaint = existingPaint.copyWith(
        name: name.trim(),
        brand: brand,
        labL: labColor.l,
        labA: labColor.a,
        labB: labColor.b,
        notes: Value(notes),
        updatedAt: DateTime.now(),
      );

      // Update in database
      final success = await dao.updatePaint(updatedPaint);
      if (!success) {
        throw Exception('Failed to update paint ID $paintId');
      }

      _log.info('Successfully updated paint ID: $paintId');

      // Reload full inventory
      return dao.getAllPaints();
    });
  }

  /// Removes a paint from the inventory.
  ///
  /// Deletes the paint record from the database and reloads the inventory.
  ///
  /// ## Example:
  /// ```dart
  /// await notifier.removePaint(42);
  /// ```
  ///
  /// ## Parameters:
  /// - **paintId**: ID of paint to remove
  ///
  /// ## Note:
  /// This operation is permanent. Consider implementing a confirmation
  /// dialog in the UI before calling this method.
  Future<void> removePaint(int paintId) async {
    _log.info('Removing paint id=$paintId');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dao = ref.read(paintColorsDaoProvider);

      // Delete from database
      await dao.deletePaint(paintId);
      _log.info('Successfully removed paint ID: $paintId');

      // Reload full inventory
      return dao.getAllPaints();
    });
  }

  /// Force reloads the paint inventory from the database.
  ///
  /// Useful for syncing after external changes or manual refresh.
  ///
  /// ## Example:
  /// ```dart
  /// await notifier.refreshInventory();
  /// ```
  Future<void> refreshInventory() async {
    _log.info('Refreshing paint inventory');

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dao = ref.read(paintColorsDaoProvider);
      final paints = await dao.getAllPaints();
      _log.info('Refreshed inventory: ${paints.length} paints');
      return paints;
    });
  }
}
