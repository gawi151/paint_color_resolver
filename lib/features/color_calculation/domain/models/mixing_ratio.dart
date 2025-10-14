import 'package:dart_mappable/dart_mappable.dart';

part 'mixing_ratio.mapper.dart';

/// Represents the ratio of a single paint in a mix.
///
/// Contains the paint identifier and its percentage contribution (0-100).
/// For multi-paint mixes, the sum of all ratios must equal 100%.
///
/// ## Example:
/// ```dart
/// final ratio1 = MixingRatio(paintId: 'vallejo_red', percentage: 70);
/// final ratio2 = MixingRatio(paintId: 'vallejo_white', percentage: 30);
/// // Mix: 70% red + 30% white = 100%
/// ```
@MappableClass()
class MixingRatio with MixingRatioMappable {
  /// Creates a mixing ratio with validation.
  ///
  /// Throws [ArgumentError] if:
  /// - percentage is not between 0 and 100
  /// - percentage is not a multiple of 10 (for MVP)
  const MixingRatio({
    required this.paintId,
    required this.percentage,
  }) : assert(
         percentage >= 0 && percentage <= 100,
         'Percentage must be between 0 and 100, got: $percentage',
       ),
       assert(
         percentage % 10 == 0,
         'Percentage must be in 10% increments, got: $percentage',
       );

  /// Unique identifier of the paint.
  ///
  /// This should reference a paint in the user's collection.
  final String paintId;

  /// Percentage of this paint in the mix (0-100).
  ///
  /// Must be in 10% increments for MVP (0, 10, 20, ..., 100).
  final int percentage;

  @override
  String toString() => 'MixingRatio($paintId: $percentage%)';
}
