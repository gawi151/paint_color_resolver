// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'paint_color.dart';

class PaintColorMapper extends ClassMapperBase<PaintColor> {
  PaintColorMapper._();

  static PaintColorMapper? _instance;
  static PaintColorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PaintColorMapper._());
      LabColorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PaintColor';

  static int _$id(PaintColor v) => v.id;
  static const Field<PaintColor, int> _f$id = Field('id', _$id);
  static String _$name(PaintColor v) => v.name;
  static const Field<PaintColor, String> _f$name = Field('name', _$name);
  static PaintBrand _$brand(PaintColor v) => v.brand;
  static const Field<PaintColor, PaintBrand> _f$brand = Field('brand', _$brand);
  static LabColor _$labColor(PaintColor v) => v.labColor;
  static const Field<PaintColor, LabColor> _f$labColor = Field(
    'labColor',
    _$labColor,
  );
  static DateTime _$addedAt(PaintColor v) => v.addedAt;
  static const Field<PaintColor, DateTime> _f$addedAt = Field(
    'addedAt',
    _$addedAt,
  );
  static String? _$brandMakerId(PaintColor v) => v.brandMakerId;
  static const Field<PaintColor, String> _f$brandMakerId = Field(
    'brandMakerId',
    _$brandMakerId,
    opt: true,
  );

  @override
  final MappableFields<PaintColor> fields = const {
    #id: _f$id,
    #name: _f$name,
    #brand: _f$brand,
    #labColor: _f$labColor,
    #addedAt: _f$addedAt,
    #brandMakerId: _f$brandMakerId,
  };

  static PaintColor _instantiate(DecodingData data) {
    return PaintColor(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      brand: data.dec(_f$brand),
      labColor: data.dec(_f$labColor),
      addedAt: data.dec(_f$addedAt),
      brandMakerId: data.dec(_f$brandMakerId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PaintColor fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PaintColor>(map);
  }

  static PaintColor fromJson(String json) {
    return ensureInitialized().decodeJson<PaintColor>(json);
  }
}

mixin PaintColorMappable {
  String toJson() {
    return PaintColorMapper.ensureInitialized().encodeJson<PaintColor>(
      this as PaintColor,
    );
  }

  Map<String, dynamic> toMap() {
    return PaintColorMapper.ensureInitialized().encodeMap<PaintColor>(
      this as PaintColor,
    );
  }

  PaintColorCopyWith<PaintColor, PaintColor, PaintColor> get copyWith =>
      _PaintColorCopyWithImpl<PaintColor, PaintColor>(
        this as PaintColor,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PaintColorMapper.ensureInitialized().stringifyValue(
      this as PaintColor,
    );
  }

  @override
  bool operator ==(Object other) {
    return PaintColorMapper.ensureInitialized().equalsValue(
      this as PaintColor,
      other,
    );
  }

  @override
  int get hashCode {
    return PaintColorMapper.ensureInitialized().hashValue(this as PaintColor);
  }
}

extension PaintColorValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PaintColor, $Out> {
  PaintColorCopyWith<$R, PaintColor, $Out> get $asPaintColor =>
      $base.as((v, t, t2) => _PaintColorCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PaintColorCopyWith<$R, $In extends PaintColor, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  LabColorCopyWith<$R, LabColor, LabColor> get labColor;
  $R call({
    int? id,
    String? name,
    PaintBrand? brand,
    LabColor? labColor,
    DateTime? addedAt,
    String? brandMakerId,
  });
  PaintColorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PaintColorCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PaintColor, $Out>
    implements PaintColorCopyWith<$R, PaintColor, $Out> {
  _PaintColorCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PaintColor> $mapper =
      PaintColorMapper.ensureInitialized();
  @override
  LabColorCopyWith<$R, LabColor, LabColor> get labColor =>
      $value.labColor.copyWith.$chain((v) => call(labColor: v));
  @override
  $R call({
    int? id,
    String? name,
    PaintBrand? brand,
    LabColor? labColor,
    DateTime? addedAt,
    Object? brandMakerId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (brand != null) #brand: brand,
      if (labColor != null) #labColor: labColor,
      if (addedAt != null) #addedAt: addedAt,
      if (brandMakerId != $none) #brandMakerId: brandMakerId,
    }),
  );
  @override
  PaintColor $make(CopyWithData data) => PaintColor(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    brand: data.get(#brand, or: $value.brand),
    labColor: data.get(#labColor, or: $value.labColor),
    addedAt: data.get(#addedAt, or: $value.addedAt),
    brandMakerId: data.get(#brandMakerId, or: $value.brandMakerId),
  );

  @override
  PaintColorCopyWith<$R2, PaintColor, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PaintColorCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

