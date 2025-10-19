// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mixing_ratio.dart';

class MixingRatioMapper extends ClassMapperBase<MixingRatio> {
  MixingRatioMapper._();

  static MixingRatioMapper? _instance;
  static MixingRatioMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MixingRatioMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MixingRatio';

  static int _$paintId(MixingRatio v) => v.paintId;
  static const Field<MixingRatio, int> _f$paintId = Field('paintId', _$paintId);
  static int _$percentage(MixingRatio v) => v.percentage;
  static const Field<MixingRatio, int> _f$percentage = Field(
    'percentage',
    _$percentage,
  );

  @override
  final MappableFields<MixingRatio> fields = const {
    #paintId: _f$paintId,
    #percentage: _f$percentage,
  };

  static MixingRatio _instantiate(DecodingData data) {
    return MixingRatio(
      paintId: data.dec(_f$paintId),
      percentage: data.dec(_f$percentage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MixingRatio fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MixingRatio>(map);
  }

  static MixingRatio fromJson(String json) {
    return ensureInitialized().decodeJson<MixingRatio>(json);
  }
}

mixin MixingRatioMappable {
  String toJson() {
    return MixingRatioMapper.ensureInitialized().encodeJson<MixingRatio>(
      this as MixingRatio,
    );
  }

  Map<String, dynamic> toMap() {
    return MixingRatioMapper.ensureInitialized().encodeMap<MixingRatio>(
      this as MixingRatio,
    );
  }

  MixingRatioCopyWith<MixingRatio, MixingRatio, MixingRatio> get copyWith =>
      _MixingRatioCopyWithImpl<MixingRatio, MixingRatio>(
        this as MixingRatio,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MixingRatioMapper.ensureInitialized().stringifyValue(
      this as MixingRatio,
    );
  }

  @override
  bool operator ==(Object other) {
    return MixingRatioMapper.ensureInitialized().equalsValue(
      this as MixingRatio,
      other,
    );
  }

  @override
  int get hashCode {
    return MixingRatioMapper.ensureInitialized().hashValue(this as MixingRatio);
  }
}

extension MixingRatioValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MixingRatio, $Out> {
  MixingRatioCopyWith<$R, MixingRatio, $Out> get $asMixingRatio =>
      $base.as((v, t, t2) => _MixingRatioCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MixingRatioCopyWith<$R, $In extends MixingRatio, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? paintId, int? percentage});
  MixingRatioCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MixingRatioCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MixingRatio, $Out>
    implements MixingRatioCopyWith<$R, MixingRatio, $Out> {
  _MixingRatioCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MixingRatio> $mapper =
      MixingRatioMapper.ensureInitialized();
  @override
  $R call({int? paintId, int? percentage}) => $apply(
    FieldCopyWithData({
      if (paintId != null) #paintId: paintId,
      if (percentage != null) #percentage: percentage,
    }),
  );
  @override
  MixingRatio $make(CopyWithData data) => MixingRatio(
    paintId: data.get(#paintId, or: $value.paintId),
    percentage: data.get(#percentage, or: $value.percentage),
  );

  @override
  MixingRatioCopyWith<$R2, MixingRatio, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MixingRatioCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

