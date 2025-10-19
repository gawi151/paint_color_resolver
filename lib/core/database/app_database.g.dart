// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PaintColorsTable extends PaintColors
    with TableInfo<$PaintColorsTable, PaintColorEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaintColorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<PaintBrand, String> brand =
      GeneratedColumn<String>(
        'brand',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PaintBrand>($PaintColorsTable.$converterbrand);
  static const VerificationMeta _brandMakerIdMeta = const VerificationMeta(
    'brandMakerId',
  );
  @override
  late final GeneratedColumn<String> brandMakerId = GeneratedColumn<String>(
    'brand_maker_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _labLMeta = const VerificationMeta('labL');
  @override
  late final GeneratedColumn<double> labL = GeneratedColumn<double>(
    'lab_l',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labAMeta = const VerificationMeta('labA');
  @override
  late final GeneratedColumn<double> labA = GeneratedColumn<double>(
    'lab_a',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labBMeta = const VerificationMeta('labB');
  @override
  late final GeneratedColumn<double> labB = GeneratedColumn<double>(
    'lab_b',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    brand,
    brandMakerId,
    labL,
    labA,
    labB,
    addedAt,
    updatedAt,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'paint_colors';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaintColorEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand_maker_id')) {
      context.handle(
        _brandMakerIdMeta,
        brandMakerId.isAcceptableOrUnknown(
          data['brand_maker_id']!,
          _brandMakerIdMeta,
        ),
      );
    }
    if (data.containsKey('lab_l')) {
      context.handle(
        _labLMeta,
        labL.isAcceptableOrUnknown(data['lab_l']!, _labLMeta),
      );
    } else if (isInserting) {
      context.missing(_labLMeta);
    }
    if (data.containsKey('lab_a')) {
      context.handle(
        _labAMeta,
        labA.isAcceptableOrUnknown(data['lab_a']!, _labAMeta),
      );
    } else if (isInserting) {
      context.missing(_labAMeta);
    }
    if (data.containsKey('lab_b')) {
      context.handle(
        _labBMeta,
        labB.isAcceptableOrUnknown(data['lab_b']!, _labBMeta),
      );
    } else if (isInserting) {
      context.missing(_labBMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaintColorEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaintColorEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: $PaintColorsTable.$converterbrand.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}brand'],
        )!,
      ),
      brandMakerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand_maker_id'],
      ),
      labL: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lab_l'],
      )!,
      labA: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lab_a'],
      )!,
      labB: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lab_b'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $PaintColorsTable createAlias(String alias) {
    return $PaintColorsTable(attachedDatabase, alias);
  }

  static TypeConverter<PaintBrand, String> $converterbrand =
      const PaintBrandConverter();
}

class PaintColorEntity extends DataClass
    implements Insertable<PaintColorEntity> {
  /// Auto-incrementing primary key.
  final int id;

  /// Paint name (required, 1-100 characters).
  ///
  /// Examples: "Red Gore", "Ultramarine Blue", "Black Primer"
  final String name;

  /// Paint brand/manufacturer.
  ///
  /// Stored as enum name string (e.g., "vallejo", "citadel").
  /// Converted to [PaintBrand] enum in Dart via [PaintBrandConverter].
  final PaintBrand brand;

  /// Optional product code/SKU from the brand maker.
  ///
  /// Examples: "vallejo_70926", "citadel_51-01", "reaper_09021"
  ///
  /// Used for identifying specific paints and cross-referencing between
  /// paint databases. Nullable to support legacy paints without codes.
  final String? brandMakerId;

  /// LAB Lightness component (0-100).
  ///
  /// - 0 = absolute black
  /// - 50 = medium lightness
  /// - 100 = absolute white
  final double labL;

  /// LAB a* component (-128 to 127).
  ///
  /// Represents the green-red axis:
  /// - Negative values = green
  /// - Positive values = red
  /// - 0 = neutral (gray)
  final double labA;

  /// LAB b* component (-128 to 127).
  ///
  /// Represents the blue-yellow axis:
  /// - Negative values = blue
  /// - Positive values = yellow
  /// - 0 = neutral (gray)
  final double labB;

  /// Timestamp when paint was added to collection.
  ///
  /// Defaults to current time on insert.
  final DateTime addedAt;

  /// Timestamp when paint record was last updated.
  ///
  /// Defaults to current time on insert.
  /// Should be updated manually when paint data changes.
  final DateTime updatedAt;

  /// Optional user notes about the paint.
  ///
  /// Examples:
  /// - "Good for base coating"
  /// - "Running low, need to reorder"
  /// - "Slightly dried out"
  final String? notes;
  const PaintColorEntity({
    required this.id,
    required this.name,
    required this.brand,
    this.brandMakerId,
    required this.labL,
    required this.labA,
    required this.labB,
    required this.addedAt,
    required this.updatedAt,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['brand'] = Variable<String>(
        $PaintColorsTable.$converterbrand.toSql(brand),
      );
    }
    if (!nullToAbsent || brandMakerId != null) {
      map['brand_maker_id'] = Variable<String>(brandMakerId);
    }
    map['lab_l'] = Variable<double>(labL);
    map['lab_a'] = Variable<double>(labA);
    map['lab_b'] = Variable<double>(labB);
    map['added_at'] = Variable<DateTime>(addedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  PaintColorsCompanion toCompanion(bool nullToAbsent) {
    return PaintColorsCompanion(
      id: Value(id),
      name: Value(name),
      brand: Value(brand),
      brandMakerId: brandMakerId == null && nullToAbsent
          ? const Value.absent()
          : Value(brandMakerId),
      labL: Value(labL),
      labA: Value(labA),
      labB: Value(labB),
      addedAt: Value(addedAt),
      updatedAt: Value(updatedAt),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory PaintColorEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaintColorEntity(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<PaintBrand>(json['brand']),
      brandMakerId: serializer.fromJson<String?>(json['brandMakerId']),
      labL: serializer.fromJson<double>(json['labL']),
      labA: serializer.fromJson<double>(json['labA']),
      labB: serializer.fromJson<double>(json['labB']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<PaintBrand>(brand),
      'brandMakerId': serializer.toJson<String?>(brandMakerId),
      'labL': serializer.toJson<double>(labL),
      'labA': serializer.toJson<double>(labA),
      'labB': serializer.toJson<double>(labB),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  PaintColorEntity copyWith({
    int? id,
    String? name,
    PaintBrand? brand,
    Value<String?> brandMakerId = const Value.absent(),
    double? labL,
    double? labA,
    double? labB,
    DateTime? addedAt,
    DateTime? updatedAt,
    Value<String?> notes = const Value.absent(),
  }) => PaintColorEntity(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand ?? this.brand,
    brandMakerId: brandMakerId.present ? brandMakerId.value : this.brandMakerId,
    labL: labL ?? this.labL,
    labA: labA ?? this.labA,
    labB: labB ?? this.labB,
    addedAt: addedAt ?? this.addedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    notes: notes.present ? notes.value : this.notes,
  );
  PaintColorEntity copyWithCompanion(PaintColorsCompanion data) {
    return PaintColorEntity(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      brandMakerId: data.brandMakerId.present
          ? data.brandMakerId.value
          : this.brandMakerId,
      labL: data.labL.present ? data.labL.value : this.labL,
      labA: data.labA.present ? data.labA.value : this.labA,
      labB: data.labB.present ? data.labB.value : this.labB,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaintColorEntity(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('brandMakerId: $brandMakerId, ')
          ..write('labL: $labL, ')
          ..write('labA: $labA, ')
          ..write('labB: $labB, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    brand,
    brandMakerId,
    labL,
    labA,
    labB,
    addedAt,
    updatedAt,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaintColorEntity &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.brandMakerId == this.brandMakerId &&
          other.labL == this.labL &&
          other.labA == this.labA &&
          other.labB == this.labB &&
          other.addedAt == this.addedAt &&
          other.updatedAt == this.updatedAt &&
          other.notes == this.notes);
}

class PaintColorsCompanion extends UpdateCompanion<PaintColorEntity> {
  final Value<int> id;
  final Value<String> name;
  final Value<PaintBrand> brand;
  final Value<String?> brandMakerId;
  final Value<double> labL;
  final Value<double> labA;
  final Value<double> labB;
  final Value<DateTime> addedAt;
  final Value<DateTime> updatedAt;
  final Value<String?> notes;
  const PaintColorsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.brandMakerId = const Value.absent(),
    this.labL = const Value.absent(),
    this.labA = const Value.absent(),
    this.labB = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.notes = const Value.absent(),
  });
  PaintColorsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required PaintBrand brand,
    this.brandMakerId = const Value.absent(),
    required double labL,
    required double labA,
    required double labB,
    this.addedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.notes = const Value.absent(),
  }) : name = Value(name),
       brand = Value(brand),
       labL = Value(labL),
       labA = Value(labA),
       labB = Value(labB);
  static Insertable<PaintColorEntity> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? brandMakerId,
    Expression<double>? labL,
    Expression<double>? labA,
    Expression<double>? labB,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (brandMakerId != null) 'brand_maker_id': brandMakerId,
      if (labL != null) 'lab_l': labL,
      if (labA != null) 'lab_a': labA,
      if (labB != null) 'lab_b': labB,
      if (addedAt != null) 'added_at': addedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (notes != null) 'notes': notes,
    });
  }

  PaintColorsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<PaintBrand>? brand,
    Value<String?>? brandMakerId,
    Value<double>? labL,
    Value<double>? labA,
    Value<double>? labB,
    Value<DateTime>? addedAt,
    Value<DateTime>? updatedAt,
    Value<String?>? notes,
  }) {
    return PaintColorsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      brandMakerId: brandMakerId ?? this.brandMakerId,
      labL: labL ?? this.labL,
      labA: labA ?? this.labA,
      labB: labB ?? this.labB,
      addedAt: addedAt ?? this.addedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(
        $PaintColorsTable.$converterbrand.toSql(brand.value),
      );
    }
    if (brandMakerId.present) {
      map['brand_maker_id'] = Variable<String>(brandMakerId.value);
    }
    if (labL.present) {
      map['lab_l'] = Variable<double>(labL.value);
    }
    if (labA.present) {
      map['lab_a'] = Variable<double>(labA.value);
    }
    if (labB.present) {
      map['lab_b'] = Variable<double>(labB.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaintColorsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('brandMakerId: $brandMakerId, ')
          ..write('labL: $labL, ')
          ..write('labA: $labA, ')
          ..write('labB: $labB, ')
          ..write('addedAt: $addedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PaintColorsTable paintColors = $PaintColorsTable(this);
  late final PaintColorsDao paintColorsDao = PaintColorsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [paintColors];
}

typedef $$PaintColorsTableCreateCompanionBuilder =
    PaintColorsCompanion Function({
      Value<int> id,
      required String name,
      required PaintBrand brand,
      Value<String?> brandMakerId,
      required double labL,
      required double labA,
      required double labB,
      Value<DateTime> addedAt,
      Value<DateTime> updatedAt,
      Value<String?> notes,
    });
typedef $$PaintColorsTableUpdateCompanionBuilder =
    PaintColorsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<PaintBrand> brand,
      Value<String?> brandMakerId,
      Value<double> labL,
      Value<double> labA,
      Value<double> labB,
      Value<DateTime> addedAt,
      Value<DateTime> updatedAt,
      Value<String?> notes,
    });

class $$PaintColorsTableFilterComposer
    extends Composer<_$AppDatabase, $PaintColorsTable> {
  $$PaintColorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaintBrand, PaintBrand, String> get brand =>
      $composableBuilder(
        column: $table.brand,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get brandMakerId => $composableBuilder(
    column: $table.brandMakerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get labL => $composableBuilder(
    column: $table.labL,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get labA => $composableBuilder(
    column: $table.labA,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get labB => $composableBuilder(
    column: $table.labB,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaintColorsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaintColorsTable> {
  $$PaintColorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brandMakerId => $composableBuilder(
    column: $table.brandMakerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get labL => $composableBuilder(
    column: $table.labL,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get labA => $composableBuilder(
    column: $table.labA,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get labB => $composableBuilder(
    column: $table.labB,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaintColorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaintColorsTable> {
  $$PaintColorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PaintBrand, String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get brandMakerId => $composableBuilder(
    column: $table.brandMakerId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get labL =>
      $composableBuilder(column: $table.labL, builder: (column) => column);

  GeneratedColumn<double> get labA =>
      $composableBuilder(column: $table.labA, builder: (column) => column);

  GeneratedColumn<double> get labB =>
      $composableBuilder(column: $table.labB, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$PaintColorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaintColorsTable,
          PaintColorEntity,
          $$PaintColorsTableFilterComposer,
          $$PaintColorsTableOrderingComposer,
          $$PaintColorsTableAnnotationComposer,
          $$PaintColorsTableCreateCompanionBuilder,
          $$PaintColorsTableUpdateCompanionBuilder,
          (
            PaintColorEntity,
            BaseReferences<_$AppDatabase, $PaintColorsTable, PaintColorEntity>,
          ),
          PaintColorEntity,
          PrefetchHooks Function()
        > {
  $$PaintColorsTableTableManager(_$AppDatabase db, $PaintColorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaintColorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaintColorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaintColorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<PaintBrand> brand = const Value.absent(),
                Value<String?> brandMakerId = const Value.absent(),
                Value<double> labL = const Value.absent(),
                Value<double> labA = const Value.absent(),
                Value<double> labB = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => PaintColorsCompanion(
                id: id,
                name: name,
                brand: brand,
                brandMakerId: brandMakerId,
                labL: labL,
                labA: labA,
                labB: labB,
                addedAt: addedAt,
                updatedAt: updatedAt,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required PaintBrand brand,
                Value<String?> brandMakerId = const Value.absent(),
                required double labL,
                required double labA,
                required double labB,
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => PaintColorsCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                brandMakerId: brandMakerId,
                labL: labL,
                labA: labA,
                labB: labB,
                addedAt: addedAt,
                updatedAt: updatedAt,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaintColorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaintColorsTable,
      PaintColorEntity,
      $$PaintColorsTableFilterComposer,
      $$PaintColorsTableOrderingComposer,
      $$PaintColorsTableAnnotationComposer,
      $$PaintColorsTableCreateCompanionBuilder,
      $$PaintColorsTableUpdateCompanionBuilder,
      (
        PaintColorEntity,
        BaseReferences<_$AppDatabase, $PaintColorsTable, PaintColorEntity>,
      ),
      PaintColorEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PaintColorsTableTableManager get paintColors =>
      $$PaintColorsTableTableManager(_db, _db.paintColors);
}
