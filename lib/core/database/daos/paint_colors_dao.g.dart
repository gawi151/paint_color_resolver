// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paint_colors_dao.dart';

// ignore_for_file: type=lint
mixin _$PaintColorsDaoMixin on DatabaseAccessor<AppDatabase> {
  $PaintColorsTable get paintColors => attachedDatabase.paintColors;
  PaintColorsDaoManager get managers => PaintColorsDaoManager(this);
}

class PaintColorsDaoManager {
  final _$PaintColorsDaoMixin _db;
  PaintColorsDaoManager(this._db);
  $$PaintColorsTableTableManager get paintColors =>
      $$PaintColorsTableTableManager(_db.attachedDatabase, _db.paintColors);
}
