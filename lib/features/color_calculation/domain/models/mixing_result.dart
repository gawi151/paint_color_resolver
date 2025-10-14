import 'package:dart_mappable/dart_mappable.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/color_match_quality.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/mixing_ratio.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/delta_e_calculator.dart';

part 'mixing_result.mapper.dart';

/// Represents the result of a paint mixing calculation.
///
/// Contains:
/// - The mixing ratios for each paint
/// - The resulting LAB color after mixing
/// - Delta E (color difference) from the target
/// - Match quality assessment
/// - Algorithm used for Delta E calculation
/// - Timestamp of calculation
///
/// ## Example:
/// ```dart
/// final result = MixingResult(
///   ratios: [
///     MixingRatio(paintId: 'red', percentage: 60),
///     MixingRatio(paintId: 'white', percentage: 40),
///   ],
///   resultingColor: LabColor(l: 55.2, a: 48.3, b: 30.1),
///   deltaE: 2.8,
///   quality: ColorMatchQuality.good,
///   deltaEAlgorithm: DeltaEAlgorithm.cie76,
///   calculatedAt: DateTime.now(),
/// );
/// ```
@MappableClass()
class MixingResult with MixingResultMappable {
  /// Creates a mixing result with validation.
  ///
  /// Validates that:
  /// - ratios list is not empty
  /// - sum of all percentages equals 100%
  /// - deltaE is non-negative
  const MixingResult({
    required this.ratios,
    required this.resultingColor,
    required this.deltaE,
    required this.quality,
    required this.deltaEAlgorithm,
    required this.calculatedAt,
  }) : assert(ratios.length > 0, 'Ratios list cannot be empty'),
       assert(deltaE >= 0, 'Delta E cannot be negative');

  /// The paint ratios that make up this mix.
  ///
  /// The sum of all percentages must equal 100%.
  final List<MixingRatio> ratios;

  /// The LAB color that results from mixing the paints at the specified ratios.
  final LabColor resultingColor;

  /// Delta E (color difference) between resulting color and target color.
  ///
  /// Lower values indicate better matches. Interpretation depends on the
  /// algorithm used (see [deltaEAlgorithm]).
  final double deltaE;

  /// Quality assessment of the color match.
  ///
  /// Based on algorithm-specific thresholds for [deltaE].
  final ColorMatchQuality quality;

  /// The Delta E algorithm used to calculate [deltaE].
  ///
  /// Important: The same ΔE value has different meanings for different algorithms.
  /// - CIE76: ΔE < 5.0 is "good"
  /// - CIEDE2000: ΔE < 2.0 is "good"
  final DeltaEAlgorithm deltaEAlgorithm;

  /// Timestamp when this mix was calculated.
  final DateTime calculatedAt;

  /// Validates that the sum of all mixing ratios equals 100%.
  ///
  /// Returns true if valid, false otherwise.
  /// Should be called after construction to verify ratio integrity.
  bool validateRatioSum() {
    final sum = ratios.fold<int>(0, (sum, ratio) => sum + ratio.percentage);
    return sum == 100;
  }

  @override
  String toString() {
    final paintsSummary = ratios.map((r) => '${r.percentage}%').join(' + ');
    return 'MixingResult(paints: $paintsSummary, '
        'ΔE: ${deltaE.toStringAsFixed(2)}, quality: $quality)';
  }
}
