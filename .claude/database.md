# Database & Persistence (Drift)

## Overview

**Drift** generates type-safe SQLite queries from Dart code. No manual SQL strings, no migrations - schema updates generate migrations automatically.

- **Location:** `lib/core/database/`
- **No raw SQL:** All queries written in Dart
- **Automatic migrations:** Schema changes trigger drift to generate migration files

## Project Structure

```
lib/core/database/
├── app_database.dart      # Main database class
├── tables/
│   ├── paint_colors.dart
│   └── mixing_results.dart
└── daos/
    ├── paint_dao.dart
    └── mixing_result_dao.dart
```

## Table Definition Pattern

File: `lib/core/database/tables/paint_colors.dart`

```dart
import 'package:drift/drift.dart';

class PaintColors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get brand => text()();

  // LAB color space
  IntColumn get labL => integer()();      // 0-100
  IntColumn get labA => integer()();      // -128 to 127
  IntColumn get labB => integer()();      // -128 to 127

  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

**Constraints:**
- Use `.withLength()` for text field validation
- Use `.withDefault()` for sensible defaults
- Mark required fields without `.nullable()`

## Main Database Class

File: `lib/core/database/app_database.dart`

```dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/paint_colors.dart';
import 'daos/paint_dao.dart';

part 'app_database.g.dart';  // Generated file

@DriftDatabase(tables: [PaintColors], daos: [PaintDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAllTables();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Migration from v1 to v2 (when needed)
        await m.addColumn(paintColors, paintColors.someNewColumn);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'app_database');
}
```

**Pattern:**
- One `@DriftDatabase` class per app
- Include all tables and DAOs
- Versioning in `schemaVersion`
- Handle migrations in `onUpgrade`

## DAO Pattern

File: `lib/core/database/daos/paint_dao.dart`

```dart
import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/paint_colors.dart';

part 'paint_dao.g.dart';

@DriftAccessor(includes: {'paint_colors'})
class PaintDao extends DatabaseAccessor<AppDatabase> {
  PaintDao(super.db);

  // ✅ Type-safe query
  Future<List<PaintColor>> getAllPaints() => select(db.paintColors).get();

  // ✅ With filtering
  Future<List<PaintColor>> getPaintsByBrand(String brand) {
    return (select(db.paintColors)
          ..where((tbl) => tbl.brand.equals(brand)))
        .get();
  }

  // ✅ Insert
  Future<int> insertPaint(PaintsColorsCompanion paint) {
    return into(db.paintColors).insert(paint);
  }

  // ✅ Update
  Future<bool> updatePaint(PaintColor paint) {
    return update(db.paintColors).replace(paint);
  }

  // ✅ Delete
  Future<int> deletePaint(int id) {
    return (delete(db.paintColors)..where((tbl) => tbl.id.equals(id))).go();
  }

  // ✅ Count
  Future<int> paintCount() {
    return (select(db.paintColors).count()).getSingle();
  }
}
```

**Key Points:**
- Use `DatabaseAccessor` base class
- Return `Future` for async operations
- Queries are type-safe - compilation errors catch schema mismatches
- DAO naming: `[Entity]Dao`

## Code Generation

After defining tables/DAOs, generate Drift code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**Generated files:**
- `app_database.g.dart` - Database implementation
- `paint_dao.g.dart` - DAO implementation
- `*_drift.g.dart` - Migration support files

**Never edit generated files manually.**

## Usage in Riverpod

File: `lib/features/paint_library/presentation/paint_inventory_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:paint_color_resolver/core/database/app_database.dart';

part 'paint_inventory_provider.g.dart';

// Provide database singleton
@riverpod
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}

// Provide DAO
@riverpod
PaintDao paintDao(Ref ref) {
  return ref.read(appDatabaseProvider).paintDao;
}

// Fetch all paints
@riverpod
Future<List<PaintColor>> paintInventory(Ref ref) async {
  return ref.read(paintDaoProvider).getAllPaints();
}

// Mutate: Add paint
@riverpod
class AddPaint extends _$AddPaint {
  @override
  Future<void> build() async {
    return;
  }

  Future<void> addNewPaint(PaintColor paint) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final dao = ref.read(paintDaoProvider);
      await dao.insertPaint(paint.toCompanion(insert: true));
      // Invalidate cache to refetch
      ref.invalidate(paintInventoryProvider);
    });
  }
}
```

**Pattern:**
- Database as singleton provider
- DAOs as derived providers
- Queries as simple future providers
- Mutations as `AsyncNotifier` providers

## Common Queries

### Filtering with Multiple Conditions

```dart
Future<List<PaintColor>> searchPaints(String query, String brand) {
  return (select(db.paintColors)
        ..where((p) => p.name.like('%$query%'))
        ..where((p) => p.brand.equals(brand)))
      .get();
}
```

### Sorting

```dart
Future<List<PaintColor>> getPaintsSorted() {
  return (select(db.paintColors)
        ..orderBy([(p) => OrderingTerm(expression: p.name)]))
      .get();
}
```

### Transactions

```dart
Future<void> replacePaintCollection(List<PaintColor> newPaints) async {
  await db.transaction(() async {
    await delete(db.paintColors).go();
    for (final paint in newPaints) {
      await into(db.paintColors).insert(paint.toCompanion(insert: true));
    }
  });
}
```

## Debugging

**View generated SQL:**
```dart
// Enable drift logging
driftRuntimeOptions.dontWarnAboutMultiplePlugins = true;
// SQL will print to console during queries
```

**Check database file:**
- Windows: Check app data folder or project build directory
- Web: IndexedDB in browser dev tools

## Schema Versioning

When updating tables:

1. **Modify table definition** in `tables/[name].dart`
2. **Increment `schemaVersion`** in `app_database.dart`
3. **Add migration logic** in `onUpgrade` callback
4. **Run code generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## References

- **Drift Documentation:** https://drift.simonbinder.eu/
- **Database Setup:** `lib/core/database/`
- **Usage in Providers:** [riverpod.md](riverpod.md)
