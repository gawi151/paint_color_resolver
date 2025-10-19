import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/database/daos/paint_colors_dao.dart';
import 'package:paint_color_resolver/core/database/tables/paint_colors.dart';
import 'package:paint_color_resolver/core/database/type_converters/paint_brand_converter.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

final _log = Logger('AppDatabase');

/// Main database class for Paint Color Resolver.
///
/// Manages all database tables, migrations, and provides access to DAOs.
/// Uses Drift for type-safe, reactive database operations with SQLite.
///
/// ## Database Features
/// - Type-safe queries with code generation
/// - Reactive streams for automatic UI updates
/// - Transaction support for multi-operation consistency
/// - Schema versioning and migrations
///
/// ## Usage
/// ```dart
/// final db = AppDatabase();
/// final paints = await db.paintColorsDao.getAllPaints();
/// ```
@DriftDatabase(
  tables: [PaintColors],
  daos: [PaintColorsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Current database schema version.
  /// Increment this when adding new tables or modifying existing ones.
  @override
  int get schemaVersion => 1;

  /// Optional: Define migrations if needed
  /// ```dart
  /// @override
  /// MigrationStrategy get migration => MigrationStrategy(
  ///   onCreate: (Migrator m) async {
  ///     await m.createAll();
  ///   },
  /// );
  /// ```

  /// Opens a connection to the Drift database.
  /// Uses SQLite via drift_flutter for Flutter apps (native and web).
  ///
  /// For native platforms (Windows, macOS, etc.):
  /// Uses the native SQLite library
  ///
  /// For web platform:
  /// Uses WebAssembly-compiled SQLite with IndexedDB or OPFS backing
  static QueryExecutor _openConnection() {
    _log.info('Opening Paint Color Resolver database');
    return driftDatabase(
      name: 'paint_resolver_db',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
        onResult: (result) {
          if (result.missingFeatures.isNotEmpty) {
            _log.warning(
              'Using ${result.chosenImplementation} due to unsupported '
              'browser features: ${result.missingFeatures}',
            );
          } else {
            _log.info('Using ${result.chosenImplementation} for web storage');
          }
        },
      ),
    );
  }
}
