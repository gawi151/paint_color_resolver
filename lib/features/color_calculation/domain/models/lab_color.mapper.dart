// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'lab_color.dart';

class LabColorMapper extends ClassMapperBase<LabColor> {
  LabColorMapper._();

  static LabColorMapper? _instance;
  static LabColorMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LabColorMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'LabColor';

  static double _$l(LabColor v) => v.l;
  static const Field<LabColor, double> _f$l = Field('l', _$l);
  static double _$a(LabColor v) => v.a;
  static const Field<LabColor, double> _f$a = Field('a', _$a);
  static double _$b(LabColor v) => v.b;
  static const Field<LabColor, double> _f$b = Field('b', _$b);

  @override
  final MappableFields<LabColor> fields = const {#l: _f$l, #a: _f$a, #b: _f$b};

  static LabColor _instantiate(DecodingData data) {
    return LabColor(l: data.dec(_f$l), a: data.dec(_f$a), b: data.dec(_f$b));
  }

  @override
  final Function instantiate = _instantiate;

  static LabColor fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LabColor>(map);
  }

  static LabColor fromJson(String json) {
    return ensureInitialized().decodeJson<LabColor>(json);
  }
}

mixin LabColorMappable {
  String toJson() {
    return LabColorMapper.ensureInitialized().encodeJson<LabColor>(
      this as LabColor,
    );
  }

  Map<String, dynamic> toMap() {
    return LabColorMapper.ensureInitialized().encodeMap<LabColor>(
      this as LabColor,
    );
  }

  LabColorCopyWith<LabColor, LabColor, LabColor> get copyWith =>
      _LabColorCopyWithImpl<LabColor, LabColor>(
        this as LabColor,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return LabColorMapper.ensureInitialized().stringifyValue(this as LabColor);
  }

  @override
  bool operator ==(Object other) {
    return LabColorMapper.ensureInitialized().equalsValue(
      this as LabColor,
      other,
    );
  }

  @override
  int get hashCode {
    return LabColorMapper.ensureInitialized().hashValue(this as LabColor);
  }
}

extension LabColorValueCopy<$R, $Out> on ObjectCopyWith<$R, LabColor, $Out> {
  LabColorCopyWith<$R, LabColor, $Out> get $asLabColor =>
      $base.as((v, t, t2) => _LabColorCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class LabColorCopyWith<$R, $In extends LabColor, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? l, double? a, double? b});
  LabColorCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _LabColorCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LabColor, $Out>
    implements LabColorCopyWith<$R, LabColor, $Out> {
  _LabColorCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LabColor> $mapper =
      LabColorMapper.ensureInitialized();
  @override
  $R call({double? l, double? a, double? b}) => $apply(
    FieldCopyWithData({
      if (l != null) #l: l,
      if (a != null) #a: a,
      if (b != null) #b: b,
    }),
  );
  @override
  LabColor $make(CopyWithData data) => LabColor(
    l: data.get(#l, or: $value.l),
    a: data.get(#a, or: $value.a),
    b: data.get(#b, or: $value.b),
  );

  @override
  LabColorCopyWith<$R2, LabColor, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _LabColorCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

