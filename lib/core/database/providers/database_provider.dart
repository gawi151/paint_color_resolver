import 'package:paint_color_resolver/core/database/app_database.dart';
import 'package:paint_color_resolver/core/database/daos/paint_colors_dao.dart';
import 'package:paint_color_resolver/core/database/seeds/database_seeder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Provides singleton instance of the Drift database.
///
/// This provider ensures a single database instance is used throughout the app.
/// The database is lazy-initialized on first access.
///
/// ## Usage in Providers
/// ```dart
/// @riverpod
/// class SomeRepository extends _$SomeRepository {
///   @override
///   Future<List<Data>> build() async {
///     final db = ref.read(databaseProvider);
///     return db.someDao.getData();
///   }
/// }
/// ```
///
/// ## Usage in Widgets
/// ```dart
/// Consumer(
///   builder: (context, ref, _) {
///     final db = ref.watch(databaseProvider);
///     // Use db...
///   },
/// )
/// ```
@riverpod
AppDatabase database(Ref ref) {
  // When the provider is destroyed, the database connection is kept alive
  // In a real app, you might add cleanup logic here
  return AppDatabase();
}

/// Provides the PaintColorsDao for paint inventory operations.
///
/// ## Usage in Providers
/// ```dart
/// @riverpod
/// class PaintInventory extends _$PaintInventory {
///   @override
///   Future<List<PaintColor>> build() async {
///     final dao = ref.read(paintColorsDaoProvider);
///     return dao.getAllPaints();
///   }
/// }
/// ```
///
/// ## Usage in Widgets
/// ```dart
/// Consumer(
///   builder: (context, ref, _) {
///     final dao = ref.watch(paintColorsDaoProvider);
///     // Use dao for paint operations...
///   },
/// )
/// ```
@riverpod
PaintColorsDao paintColorsDao(Ref ref) {
  return ref.read(databaseProvider).paintColorsDao;
}

/// Ensures the database is seeded with initial paint data on first run.
///
/// This provider runs the database seeding logic when watched, ensuring that
/// the app always has paint inventory available for testing the mixing
/// algorithm.
///
/// The seeding is idempotent - subsequent app runs skip seeding if paints
/// exist.
///
/// ## Usage in App
/// Watch this provider on startup to ensure seeding completes before showing
/// UI:
/// ```dart
/// @override
/// FutureOr<void> build() async {
///   await ref.watch(databaseInitializationProvider.future);
/// }
/// ```
@riverpod
Future<void> databaseInitialization(Ref ref) async {
  final database = ref.read(databaseProvider);
  await DatabaseSeeder.seedIfEmpty(database);
}
