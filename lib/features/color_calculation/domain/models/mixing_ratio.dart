import 'package:dart_mappable/dart_mappable.dart';

part 'mixing_ratio.mapper.dart';

/// Represents the ratio of a single paint in a mix.
///
/// Contains the paint identifier (database ID) and its percentage
/// contribution (0-100). For multi-paint mixes, the sum of all ratios
/// must equal 100%.
///
/// ## Example:
/// ```dart
/// final ratio1 = MixingRatio(paintId: 1, percentage: 70);
/// final ratio2 = MixingRatio(paintId: 2, percentage: 30);
/// // Mix: 70% paint#1 + 30% paint#2 = 100%
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

  /// Database ID of the paint (from PaintColor.id).
  ///
  /// References a paint in the user's collection by its auto-increment ID.
  final int paintId;

  /// Percentage of this paint in the mix (0-100).
  ///
  /// Must be in 10% increments for MVP (0, 10, 20, ..., 100).
  final int percentage;

  @override
  String toString() => 'MixingRatio(paint#$paintId: $percentage%)';
}
