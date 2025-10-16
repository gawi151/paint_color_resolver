# Database Layer - Paint Color Resolver

This directory contains all database-related code using Drift (type-safe SQLite for Flutter).

## Directory Structure

```
lib/core/database/
├── app_database.dart          # Main database class (Drift @DriftDatabase)
├── app_database.g.dart        # Generated code (DO NOT EDIT)
├── providers/
│   ├── database_provider.dart  # Riverpod provider for database singleton
│   └── database_provider.g.dart # Generated code (DO NOT EDIT)
├── tables/
│   ├── paint_colors.dart       # PaintColors table definition
│   └── (additional tables)
├── daos/
│   ├── paint_colors_dao.dart   # PaintColorsDao - queries for paint_colors table
│   └── (additional DAOs)
└── README.md (this file)
```

## Key Concepts

### 1. Tables (`tables/` directory)
- Extend `Table` class from Drift
- Define columns as getters returning column types
- Examples: `IntColumn`, `TextColumn`, `DateTimeColumn`, `RealColumn`
- One table = one file for clarity

**Example:**
```dart
class PaintColors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get brand => text()();
  // ... more columns
}
```

### 2. DAOs (Data Access Objects) (`daos/` directory)
- Extend `DatabaseAccessor<AppDatabase>`
- Use `@DriftAccessor(tables: [TableName])` annotation
- Contain all query methods for a specific table
- One DAO = one file
- Methods return `Future<T>` for one-time queries or `Stream<T>` for reactive queries

**Example:**
```dart
@DriftAccessor(tables: [PaintColors])
class PaintColorsDao extends DatabaseAccessor<AppDatabase>
    with _$PaintColorsDaoMixin {
  // CRUD methods here
}
```

### 3. AppDatabase (Main Class)
- Registered in `@DriftDatabase` annotation with `tables: [...]` and `daos: [...]`
- Manages all tables and DAOs
- Handles schema versioning
- Provides connection to SQLite

### 4. Providers (Riverpod Integration)
- `database_provider.dart` - Singleton instance of AppDatabase
- Use in Riverpod providers to access database
- Enables reactive state management

## Type Converters

For custom types (e.g., enums), create type converters:

```dart
class PaintBrandConverter extends TypeConverter<PaintBrand, String> {
  const PaintBrandConverter();

  @override
  PaintBrand fromSql(String fromDb) =>
    PaintBrand.values.firstWhere((e) => e.name == fromDb);

  @override
  String toSql(PaintBrand value) => value.name;
}
```

Use in table:
```dart
TextColumn get brand => text().map(const PaintBrandConverter())();
```

## Code Generation

All Drift files require code generation. Generated files have `.g.dart` extension and should NEVER be edited manually.

### Generate Code
```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch for changes
dart run build_runner watch
```

## Common Column Types

| Dart Type | Column Type | SQL Type |
|-----------|------------|----------|
| `int` | `integer()` | INTEGER |
| `String` | `text()` | TEXT |
| `double` | `real()` | REAL |
| `bool` | `boolean()` | INTEGER (0/1) |
| `DateTime` | `dateTime()` | INTEGER or TEXT |
| `Uint8List` | `blob()` | BLOB |

## Column Modifiers

```dart
// Auto-increment (typically for IDs)
IntColumn get id => integer().autoIncrement()();

// Non-nullable (required)
TextColumn get name => text()();

// Nullable (optional)
TextColumn get description => text().nullable()();

// With length constraint
TextColumn get email => text().withLength(min: 5, max: 255)();

// With default value
BoolColumn get isActive => boolean().withDefault(const Constant(true))();

// Check constraint
IntColumn get age => integer().check(age.isBiggerOrEqualValue(0))();
```

## Reactive Queries (Streams)

DAOs can return streams that auto-update when data changes:

```dart
// One-time query
Future<List<PaintColor>> getAllPaints() => select(paintColors).get();

// Reactive query - auto-updates when paints change
Stream<List<PaintColor>> watchAllPaints() => select(paintColors).watch();
```

## CRUD Operations

```dart
// CREATE
Future<int> insertPaint(PaintColorsCompanion paint) =>
  into(paintColors).insert(paint);

// READ
Future<List<PaintColor>> getAllPaints() => select(paintColors).get();

// UPDATE
Future<bool> updatePaint(PaintColor paint) =>
  update(paintColors).replace(paint);

// DELETE
Future<void> deletePaint(int id) =>
  (delete(paintColors)..where((p) => p.id.equals(id))).go();
```

## Transactions

For atomic multi-step operations:

```dart
await db.transaction(() async {
  await update(paintColors).replace(paint);
  await into(mixingHistory).insert(history);
});
```

## Important Notes

1. **Always await queries** - Drift queries are async
2. **Never edit generated files** - `.g.dart` files are auto-generated
3. **One table per file** - Keep `tables/` clean and organized
4. **One DAO per file** - Keep `daos/` clean and organized
5. **Type safety** - Drift provides compile-time type checking
6. **Reactive by default** - Use `watch()` for UI updates

## Related Files

- `pubspec.yaml` - Contains `drift`, `drift_flutter`, `drift_dev` dependencies
- `lib/core/database/providers/database_provider.dart` - Riverpod integration
- `lib/shared/models/paint_color.dart` - Domain model for paint data

## Next Steps

1. Create `PaintColors` table in `tables/paint_colors.dart`
2. Create `PaintColorsDao` in `daos/paint_colors_dao.dart`
3. Create type converter for `PaintBrand` enum
4. Register table and DAO in `AppDatabase`
5. Run code generation: `dart run build_runner build`
6. Create Riverpod providers using DAOs
