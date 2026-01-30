import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/database/app_database.dart';
import 'package:paint_color_resolver/core/database/providers/database_provider.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/paint_library/data/mappers/paint_color_mapper.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart'
    hide PaintColorMapper;

final _log = Logger('PaintInventory');

/// Manages the complete paint inventory state.
///
/// This provider loads, adds, edits, and removes paints from the user's
/// collection using the underlying Drift database layer.
///
/// ## State Management:
/// - Uses AsyncNotifierProvider for async state with loading/error handling
/// - Uses optimistic updates for instant UI feedback
/// - Persists changes to database in the background
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

/// Notifier for managing paint inventory state with optimistic updates.
class PaintInventoryNotifier extends AsyncNotifier<List<PaintColor>> {
  @override
  Future<List<PaintColor>> build() async {
    _log.fine('Loading paint inventory');

    try {
      final dao = ref.read(paintColorsDaoProvider);
      final dbPaints = await dao.getAllPaints();
      final paints = PaintColorMapper.fromDatabaseList(dbPaints);
      _log.info('Loaded ${paints.length} paints from database');
      return paints;
    } catch (e, stackTrace) {
      _log.severe('Failed to load paint inventory', e, stackTrace);
      rethrow;
    }
  }

  /// Adds a new paint to the inventory with optimistic update.
  ///
  /// The UI updates immediately, then the paint is persisted to database.
  /// If database insert fails, the optimistic update is reverted.
  ///
  /// ## Parameters:
  /// - **name**: Paint name (must not be empty)
  /// - **brand**: Paint manufacturer
  /// - **labColor**: Color in LAB color space
  /// - **brandMakerId**: Optional product code/SKU (e.g., "vallejo_70926")
  /// - **notes**: Optional user notes
  ///
  /// ## Example:
  /// ```dart
  /// await notifier.addPaint(
  ///   name: 'Goblin Green',
  ///   brand: PaintBrand.citadel,
  ///   labColor: LabColor(l: 45.0, a: -30.0, b: 50.0),
  ///   brandMakerId: 'citadel_51-25',
  ///   notes: 'Classic Citadel green',
  /// );
  /// ```
  ///
  /// ## Throws:
  /// - [ArgumentError] if name is empty
  /// - Database exceptions on insert failure (optimistic update is reverted)
  Future<void> addPaint({
    required String name,
    required PaintBrand brand,
    required LabColor labColor,
    String? brandMakerId,
    String? notes,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      throw ArgumentError('Paint name cannot be empty');
    }

    _log.info('Adding paint: $name by ${brand.name}');

    if (!state.hasValue) return;

    final currentState = state.value!;

    try {
      final dao = ref.read(paintColorsDaoProvider);

      // Create paint companion for insertion
      final paintCompanion = PaintColorsCompanion.insert(
        name: name.trim(),
        brand: brand,
        labL: labColor.l,
        labA: labColor.a,
        labB: labColor.b,
        brandMakerId: Value(brandMakerId),
        notes: Value(notes),
      );

      // Insert to database first to get the generated ID
      final id = await dao.insertPaint(paintCompanion);
      _log.info('Successfully added paint with ID: $id');

      // Optimistically update state with the new paint
      final now = DateTime.now();
      final newPaint = PaintColor(
        id: id,
        name: name.trim(),
        brand: brand,
        labColor: labColor,
        brandMakerId: brandMakerId,
        addedAt: now,
      );

      state = AsyncValue.data([...currentState, newPaint]);
    } catch (e, stackTrace) {
      _log.severe('Failed to add paint', e, stackTrace);
      // State remains unchanged on error
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Edits an existing paint in the inventory with optimistic update.
  ///
  /// The UI updates immediately, then the change is persisted to database.
  /// If database update fails, the optimistic update is reverted.
  ///
  /// ## Parameters:
  /// - **paintId**: ID of paint to edit
  /// - **name**: Updated paint name
  /// - **brand**: Updated brand
  /// - **labColor**: Updated LAB color
  /// - **brandMakerId**: Updated product code/SKU (optional)
  /// - **notes**: Updated notes (optional)
  ///
  /// ## Example:
  /// ```dart
  /// await notifier.editPaint(
  ///   paintId: 42,
  ///   name: 'Blood Red (Updated)',
  ///   brand: PaintBrand.citadel,
  ///   labColor: LabColor(l: 40.0, a: 70.0, b: 60.0),
  ///   brandMakerId: 'citadel_51-31',
  ///   notes: 'Reformulated version',
  /// );
  /// ```
  ///
  /// ## Throws:
  /// - [ArgumentError] if name is empty or paint not found
  /// - Database exceptions if update fails (optimistic update is reverted)
  Future<void> editPaint({
    required int paintId,
    required String name,
    required PaintBrand brand,
    required LabColor labColor,
    String? brandMakerId,
    String? notes,
  }) async {
    // Validate inputs
    if (name.trim().isEmpty) {
      throw ArgumentError('Paint name cannot be empty');
    }

    _log.info('Editing paint id=$paintId');

    if (!state.hasValue) return;

    final currentState = state.value!;

    // Find the existing paint to preserve timestamps
    final existingPaintIndex =
        currentState.indexWhere((PaintColor p) => p.id == paintId);
    if (existingPaintIndex == -1) {
      throw ArgumentError('Paint with ID $paintId not found in state');
    }

    final existingPaint = currentState[existingPaintIndex];

    // Create optimistically updated paint
    final updatedPaint = PaintColor(
      id: paintId,
      name: name.trim(),
      brand: brand,
      labColor: labColor,
      brandMakerId: brandMakerId,
      addedAt: existingPaint.addedAt,
    );

    // Optimistically update state
    final updatedList = <PaintColor>[...currentState];
    updatedList[existingPaintIndex] = updatedPaint;
    state = AsyncValue.data(updatedList);

    try {
      final dao = ref.read(paintColorsDaoProvider);

      // Get existing paint from database to preserve timestamps
      final dbPaint = await dao.getPaintById(paintId);
      if (dbPaint == null) {
        throw ArgumentError('Paint with ID $paintId not found in database');
      }

      // Create updated paint record
      final dbUpdatedPaint = dbPaint.copyWith(
        name: name.trim(),
        brand: brand,
        labL: labColor.l,
        labA: labColor.a,
        labB: labColor.b,
        brandMakerId: Value(brandMakerId),
        notes: Value(notes),
        updatedAt: DateTime.now(),
      );

      // Update in database
      final success = await dao.updatePaint(dbUpdatedPaint);
      if (!success) {
        throw Exception('Failed to update paint ID $paintId');
      }

      _log.info('Successfully updated paint ID: $paintId');
      // State already updated optimistically, no need to change
    } catch (e, stackTrace) {
      _log.severe('Failed to edit paint', e, stackTrace);
      // Revert optimistic update
      state = AsyncValue.data(currentState);
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Removes a paint from the inventory with optimistic update.
  ///
  /// The UI updates immediately, then the paint is deleted from database.
  /// If database delete fails, the optimistic update is reverted.
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

    if (!state.hasValue) return;

    final currentState = state.value!;

    // Find the paint to remove
    final existingPaintIndex =
        currentState.indexWhere((PaintColor p) => p.id == paintId);
    if (existingPaintIndex == -1) {
      _log.warning('Paint ID $paintId not found in state');
      return;
    }

    // Optimistically remove from state
    final updatedList = <PaintColor>[
      ...currentState,
    ]..removeAt(existingPaintIndex);
    state = AsyncValue.data(updatedList);

    try {
      final dao = ref.read(paintColorsDaoProvider);

      // Delete from database
      await dao.deletePaint(paintId);
      _log.info('Successfully removed paint ID: $paintId');
      // State already updated optimistically, no need to change
    } catch (e, stackTrace) {
      _log.severe('Failed to remove paint', e, stackTrace);
      // Revert optimistic update
      state = AsyncValue.data(currentState);
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
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
      final dbPaints = await dao.getAllPaints();
      final paints = PaintColorMapper.fromDatabaseList(dbPaints);
      _log.info('Refreshed inventory: ${paints.length} paints');
      return paints;
    });
  }
}
