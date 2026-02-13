// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'mixing_result.dart';

class MixingResultMapper extends ClassMapperBase<MixingResult> {
  MixingResultMapper._();

  static MixingResultMapper? _instance;
  static MixingResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MixingResultMapper._());
      MixingRatioMapper.ensureInitialized();
      LabColorMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MixingResult';

  static List<MixingRatio> _$ratios(MixingResult v) => v.ratios;
  static const Field<MixingResult, List<MixingRatio>> _f$ratios = Field(
    'ratios',
    _$ratios,
  );
  static LabColor _$resultingColor(MixingResult v) => v.resultingColor;
  static const Field<MixingResult, LabColor> _f$resultingColor = Field(
    'resultingColor',
    _$resultingColor,
  );
  static double _$deltaE(MixingResult v) => v.deltaE;
  static const Field<MixingResult, double> _f$deltaE = Field(
    'deltaE',
    _$deltaE,
  );
  static ColorMatchQuality _$quality(MixingResult v) => v.quality;
  static const Field<MixingResult, ColorMatchQuality> _f$quality = Field(
    'quality',
    _$quality,
  );
  static DeltaEAlgorithm _$deltaEAlgorithm(MixingResult v) => v.deltaEAlgorithm;
  static const Field<MixingResult, DeltaEAlgorithm> _f$deltaEAlgorithm = Field(
    'deltaEAlgorithm',
    _$deltaEAlgorithm,
  );
  static DateTime _$calculatedAt(MixingResult v) => v.calculatedAt;
  static const Field<MixingResult, DateTime> _f$calculatedAt = Field(
    'calculatedAt',
    _$calculatedAt,
  );

  @override
  final MappableFields<MixingResult> fields = const {
    #ratios: _f$ratios,
    #resultingColor: _f$resultingColor,
    #deltaE: _f$deltaE,
    #quality: _f$quality,
    #deltaEAlgorithm: _f$deltaEAlgorithm,
    #calculatedAt: _f$calculatedAt,
  };

  static MixingResult _instantiate(DecodingData data) {
    return MixingResult(
      ratios: data.dec(_f$ratios),
      resultingColor: data.dec(_f$resultingColor),
      deltaE: data.dec(_f$deltaE),
      quality: data.dec(_f$quality),
      deltaEAlgorithm: data.dec(_f$deltaEAlgorithm),
      calculatedAt: data.dec(_f$calculatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MixingResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MixingResult>(map);
  }

  static MixingResult fromJson(String json) {
    return ensureInitialized().decodeJson<MixingResult>(json);
  }
}

mixin MixingResultMappable {
  String toJson() {
    return MixingResultMapper.ensureInitialized().encodeJson<MixingResult>(
      this as MixingResult,
    );
  }

  Map<String, dynamic> toMap() {
    return MixingResultMapper.ensureInitialized().encodeMap<MixingResult>(
      this as MixingResult,
    );
  }

  MixingResultCopyWith<MixingResult, MixingResult, MixingResult> get copyWith =>
      _MixingResultCopyWithImpl<MixingResult, MixingResult>(
        this as MixingResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MixingResultMapper.ensureInitialized().stringifyValue(
      this as MixingResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return MixingResultMapper.ensureInitialized().equalsValue(
      this as MixingResult,
      other,
    );
  }

  @override
  int get hashCode {
    return MixingResultMapper.ensureInitialized().hashValue(
      this as MixingResult,
    );
  }
}

extension MixingResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MixingResult, $Out> {
  MixingResultCopyWith<$R, MixingResult, $Out> get $asMixingResult =>
      $base.as((v, t, t2) => _MixingResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MixingResultCopyWith<$R, $In extends MixingResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    MixingRatio,
    MixingRatioCopyWith<$R, MixingRatio, MixingRatio>
  >
  get ratios;
  LabColorCopyWith<$R, LabColor, LabColor> get resultingColor;
  $R call({
    List<MixingRatio>? ratios,
    LabColor? resultingColor,
    double? deltaE,
    ColorMatchQuality? quality,
    DeltaEAlgorithm? deltaEAlgorithm,
    DateTime? calculatedAt,
  });
  MixingResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MixingResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MixingResult, $Out>
    implements MixingResultCopyWith<$R, MixingResult, $Out> {
  _MixingResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MixingResult> $mapper =
      MixingResultMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    MixingRatio,
    MixingRatioCopyWith<$R, MixingRatio, MixingRatio>
  >
  get ratios => ListCopyWith(
    $value.ratios,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(ratios: v),
  );
  @override
  LabColorCopyWith<$R, LabColor, LabColor> get resultingColor =>
      $value.resultingColor.copyWith.$chain((v) => call(resultingColor: v));
  @override
  $R call({
    List<MixingRatio>? ratios,
    LabColor? resultingColor,
    double? deltaE,
    ColorMatchQuality? quality,
    DeltaEAlgorithm? deltaEAlgorithm,
    DateTime? calculatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (ratios != null) #ratios: ratios,
      if (resultingColor != null) #resultingColor: resultingColor,
      if (deltaE != null) #deltaE: deltaE,
      if (quality != null) #quality: quality,
      if (deltaEAlgorithm != null) #deltaEAlgorithm: deltaEAlgorithm,
      if (calculatedAt != null) #calculatedAt: calculatedAt,
    }),
  );
  @override
  MixingResult $make(CopyWithData data) => MixingResult(
    ratios: data.get(#ratios, or: $value.ratios),
    resultingColor: data.get(#resultingColor, or: $value.resultingColor),
    deltaE: data.get(#deltaE, or: $value.deltaE),
    quality: data.get(#quality, or: $value.quality),
    deltaEAlgorithm: data.get(#deltaEAlgorithm, or: $value.deltaEAlgorithm),
    calculatedAt: data.get(#calculatedAt, or: $value.calculatedAt),
  );

  @override
  MixingResultCopyWith<$R2, MixingResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MixingResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

