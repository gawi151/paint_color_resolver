import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/database/providers/database_provider.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/color_match_quality.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/mixing_result.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/paint_mixing_calculator.dart';
import 'package:paint_color_resolver/features/paint_library/data/mappers/paint_color_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_mixing_provider.g.dart';

final _log = Logger('ColorMixing');

/// Provider for the selected target color that the user wants to match.
///
/// This stores the LAB color that the user has chosen via the color picker.
/// The user can change this at any time, which will trigger recalculation
/// of mixing recommendations.
///
/// ## Usage:
/// ```dart
/// // Watch the target color
/// final targetColor = ref.watch(targetColorProvider);
///
/// // Update the target color
/// ref.read(targetColorProvider.notifier).setTargetColor(newColor);
/// ```
@riverpod
class TargetColor extends _$TargetColor {
  @override
  LabColor? build() {
    // Initially no target color selected
    return null;
  }

  /// Sets the target LAB color to match.
  void setTargetColor(LabColor color) {
    _log.fine('Target color set to: $color');
    state = color;
  }

  /// Convenience method to set target color from RGB hex string.
  ///
  /// Useful when integrating with the color picker widget.
  /// Example: `setTargetColorFromHex('#FF5733')`.
  void setTargetColorFromHex(String hexColor) {
    try {
      final converter = ColorConverter();
      final labColor = converter.hexToLab(hexColor);
      setTargetColor(labColor);
      _log.info('Target color set from hex: $hexColor → $labColor');
    } catch (e) {
      _log.severe('Failed to set target color from hex: $hexColor', e);
      rethrow;
    }
  }

  /// Clears the target color selection.
  void clearTargetColor() {
    _log.fine('Target color cleared');
    state = null;
  }
}

/// Provider for the number of paints to mix (1, 2, or 3).
///
/// Controls how many paints should be mixed together to achieve the target.
/// Fewer paints = simpler mixes, more paints = potentially better matches.
///
/// ## Usage:
/// ```dart
/// final numberOfPaints = ref.watch(numberOfPaintsProvider);
/// ref.read(numberOfPaintsProvider.notifier).state = 3; // Mix 3 paints
/// ```
@riverpod
class NumberOfPaints extends _$NumberOfPaints {
  @override
  int build() {
    // Default to 2-paint mixing (good balance of simplicity and quality)
    return 2;
  }

  /// Sets the number of paints to mix (1, 2, or 3).
  void setNumberOfPaints(int count) {
    if (count < 1 || count > 3) {
      throw ArgumentError('numberOfPaints must be 1, 2, or 3, got: $count');
    }
    _log.fine('Number of paints set to: $count');
    state = count;
  }
}

/// Provider for the maximum Delta E threshold for filtering results.
///
/// Only paint combinations with Delta E less than this threshold will be
/// returned. Lower values = stricter matching, higher values = more options.
///
/// ## Default: 10.0 (acceptable matches)
/// - Less than 2.0: Excellent matches
/// - 2.0-5.0: Good matches (recommended)
/// - 5.0-10.0: Acceptable matches
/// - Greater than 10.0: Poor matches (usually avoided)
@riverpod
class MaxDeltaEThreshold extends _$MaxDeltaEThreshold {
  @override
  double build() {
    // Default to accepting good matches up to slightly poorer quality
    return 10;
  }

  /// Sets the maximum Delta E threshold.
  void setMaxDeltaE(double value) {
    if (value <= 0) {
      throw ArgumentError('maxDeltaE must be positive, got: $value');
    }
    _log.fine('Max Delta E set to: $value');
    state = value;
  }
}

/// Async provider that calculates the best paint mixing recommendations.
///
/// This is the main provider that orchestrates the mixing calculation.
/// It watches:
/// - The target color (user selection)
/// - The number of paints to mix
/// - The max Delta E threshold
/// - The available paint inventory
///
/// When any of these change, the calculation is automatically re-run.
///
/// ## Returns:
/// AsyncValue containing up to 10 best mixing combinations,
/// sorted by Delta E (best matches first).
///
/// ## States:
/// - **Loading**: Calculation in progress
/// - **Data**: Results ready (list of MixingResult objects)
/// - **Error**: Calculation failed (shows error message)
///
/// ## Usage:
/// ```dart
/// Consumer(
///   builder: (context, ref, _) {
///     final results = ref.watch(mixingResultsProvider);
///
///     return results.when(
///       data: (mixes) => ListView(
///         children: mixes.map((mix) => ResultCard(mix)).toList(),
///       ),
///       loading: () => const CircularProgressIndicator(),
///       error: (err, st) => Text('Error: $err'),
///     );
///   },
/// )
/// ```
@riverpod
Future<List<MixingResult>> mixingResults(Ref ref) async {
  // Watch all the input state
  final targetColor = ref.watch(targetColorProvider);
  final numberOfPaints = ref.watch(numberOfPaintsProvider);
  final maxDeltaE = ref.watch(maxDeltaEThresholdProvider);

  // If no target color selected, return empty results
  if (targetColor == null) {
    _log.fine('No target color selected, returning empty results');
    return [];
  }

  try {
    _log.info(
      'Starting mixing calculation: '
      'target=$targetColor, '
      'numberOfPaints=$numberOfPaints, '
      'maxDeltaE=$maxDeltaE',
    );

    // Fetch the paint inventory from the database
    final dao = ref.read(paintColorsDaoProvider);
    final paintEntities = await dao.getAllPaints();

    // Convert database entities to domain models
    final availablePaints = PaintColorMapper.fromDatabaseList(paintEntities);

    _log.info(
      'Fetched ${availablePaints.length} paints for mixing calculation',
    );

    if (availablePaints.isEmpty) {
      _log.warning('No paints available in inventory');
      return [];
    }

    // Run the mixing calculator
    final calculator = PaintMixingCalculator();
    final results = await calculator.findBestMixes(
      targetColor: targetColor,
      availablePaints: availablePaints,
      numberOfPaints: numberOfPaints,
      maxDeltaE: maxDeltaE,
    );

    _log.info(
      'Mixing calculation complete: found ${results.length} valid mixes',
    );

    return results;
  } catch (e, stackTrace) {
    _log.severe('Mixing calculation failed', e, stackTrace);
    rethrow;
  }
}

/// Provider to get the best (top) mixing result.
///
/// Convenience provider that returns just the single best mix.
/// Useful for quick previews without needing to watch the full list.
///
/// ## Returns:
/// An async value with the best mix, or null if no results.
///
/// ## Usage:
/// ```dart
/// final bestMix = ref.watch(bestMixingResultProvider);
/// ```
@riverpod
Future<MixingResult?> bestMixingResult(Ref ref) async {
  final results = await ref.watch(mixingResultsProvider.future);
  return results.isEmpty ? null : results.first;
}

/// Filter for viewing results by quality threshold.
///
/// Allows users to toggle between viewing all results or just
/// "acceptable or better" matches.
@riverpod
class QualityFilterEnabled extends _$QualityFilterEnabled {
  @override
  bool build() {
    return false; // Show all results by default
  }

  void toggle() {
    state = !state;
  }

  void enable() {
    state = true;
  }

  void disable() {
    state = false;
  }
}

/// Filtered mixing results based on quality threshold.
///
/// Returns results filtered by quality if the quality filter is enabled.
/// This provides a simpler view for users who only want "good" matches or
/// better.
@riverpod
Future<List<MixingResult>> filteredMixingResults(Ref ref) async {
  final allResults = await ref.watch(mixingResultsProvider.future);
  final filterEnabled = ref.watch(qualityFilterEnabledProvider);

  if (!filterEnabled) {
    return allResults;
  }

  // Filter to only "good" or better quality (not acceptable or worse)
  return allResults
      .where((result) => result.quality.index <= ColorMatchQuality.good.index)
      .toList();
}

/// State holder for UI filters (sorting, etc.)
@riverpod
class MixingResultsSort extends _$MixingResultsSort {
  @override
  MixingSortOption build() {
    // Sort by Delta E (best matches first) by default
    return MixingSortOption.deltaE;
  }

  /// Sets the sort option for results (Riverpod pattern: methods not setters)
  // ignore: use_setters_to_change_properties
  void updateSortOption(MixingSortOption option) => state = option;
}

/// Options for sorting mixing results
enum MixingSortOption {
  /// Sort by Delta E (best color matches first)
  deltaE,

  /// Sort by fewest paints (simplest mixes first)
  simplicity,

  /// Sort by best quality rating (excellent before good)
  quality,
}

/// Extension to apply sorting to results
extension MixingResultsSorting on List<MixingResult> {
  /// Sorts results according to the specified option
  List<MixingResult> sortBy(MixingSortOption option) {
    final sorted = List<MixingResult>.from(this);

    switch (option) {
      case MixingSortOption.deltaE:
        // Already sorted by Delta E by default from calculator
        return sorted;

      case MixingSortOption.simplicity:
        sorted.sort((a, b) => a.ratios.length.compareTo(b.ratios.length));
        return sorted;

      case MixingSortOption.quality:
        sorted.sort((a, b) => a.quality.index.compareTo(b.quality.index));
        return sorted;
    }
  }
}

/// Sorted mixing results based on user preference
@riverpod
Future<List<MixingResult>> sortedMixingResults(Ref ref) async {
  final results = await ref.watch(filteredMixingResultsProvider.future);
  final sortOption = ref.watch(mixingResultsSortProvider);

  return results.sortBy(sortOption);
}
