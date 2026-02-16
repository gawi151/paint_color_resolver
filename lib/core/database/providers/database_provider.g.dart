// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(database)
final databaseProvider = DatabaseProvider._();

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

final class DatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
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
  DatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return database(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$databaseHash() => r'e5a1fa0e8ff9aa131f847f28519ec2098e6d0f76';

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

@ProviderFor(paintColorsDao)
final paintColorsDaoProvider = PaintColorsDaoProvider._();

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

final class PaintColorsDaoProvider
    extends $FunctionalProvider<PaintColorsDao, PaintColorsDao, PaintColorsDao>
    with $Provider<PaintColorsDao> {
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
  PaintColorsDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paintColorsDaoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paintColorsDaoHash();

  @$internal
  @override
  $ProviderElement<PaintColorsDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaintColorsDao create(Ref ref) {
    return paintColorsDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaintColorsDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaintColorsDao>(value),
    );
  }
}

String _$paintColorsDaoHash() => r'1fa471b3e6740f3aa8d40ddd571eee6a3370f2b7';

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

@ProviderFor(databaseInitialization)
final databaseInitializationProvider = DatabaseInitializationProvider._();

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

final class DatabaseInitializationProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
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
  DatabaseInitializationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'databaseInitializationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$databaseInitializationHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return databaseInitialization(ref);
  }
}

String _$databaseInitializationHash() =>
    r'29f595f8fd7e24625161e3825b20c21eeefb6370';
