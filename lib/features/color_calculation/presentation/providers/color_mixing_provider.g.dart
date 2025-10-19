// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_mixing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(TargetColor)
const targetColorProvider = TargetColorProvider._();

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
final class TargetColorProvider
    extends $NotifierProvider<TargetColor, LabColor?> {
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
  const TargetColorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'targetColorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$targetColorHash();

  @$internal
  @override
  TargetColor create() => TargetColor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LabColor? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LabColor?>(value),
    );
  }
}

String _$targetColorHash() => r'9ebf54c4d7926b67378f8658a6176dbe1f08c549';

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

abstract class _$TargetColor extends $Notifier<LabColor?> {
  LabColor? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LabColor?, LabColor?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LabColor?, LabColor?>,
              LabColor?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
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

@ProviderFor(NumberOfPaints)
const numberOfPaintsProvider = NumberOfPaintsProvider._();

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
final class NumberOfPaintsProvider
    extends $NotifierProvider<NumberOfPaints, int> {
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
  const NumberOfPaintsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'numberOfPaintsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$numberOfPaintsHash();

  @$internal
  @override
  NumberOfPaints create() => NumberOfPaints();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$numberOfPaintsHash() => r'a10a6f35eef5d77e43319e44a3afbd3af95842ee';

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

abstract class _$NumberOfPaints extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
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

@ProviderFor(MaxDeltaEThreshold)
const maxDeltaEThresholdProvider = MaxDeltaEThresholdProvider._();

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
final class MaxDeltaEThresholdProvider
    extends $NotifierProvider<MaxDeltaEThreshold, double> {
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
  const MaxDeltaEThresholdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maxDeltaEThresholdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maxDeltaEThresholdHash();

  @$internal
  @override
  MaxDeltaEThreshold create() => MaxDeltaEThreshold();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$maxDeltaEThresholdHash() =>
    r'959d35fea1f90bc61ceb07637b583e7ce85b9913';

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

abstract class _$MaxDeltaEThreshold extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
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

@ProviderFor(mixingResults)
const mixingResultsProvider = MixingResultsProvider._();

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

final class MixingResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MixingResult>>,
          List<MixingResult>,
          FutureOr<List<MixingResult>>
        >
    with
        $FutureModifier<List<MixingResult>>,
        $FutureProvider<List<MixingResult>> {
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
  const MixingResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mixingResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mixingResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<MixingResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MixingResult>> create(Ref ref) {
    return mixingResults(ref);
  }
}

String _$mixingResultsHash() => r'4f0cdd42449f34a565e966aafbf05319575ee4b6';

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

@ProviderFor(bestMixingResult)
const bestMixingResultProvider = BestMixingResultProvider._();

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

final class BestMixingResultProvider
    extends
        $FunctionalProvider<
          AsyncValue<MixingResult?>,
          MixingResult?,
          FutureOr<MixingResult?>
        >
    with $FutureModifier<MixingResult?>, $FutureProvider<MixingResult?> {
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
  const BestMixingResultProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bestMixingResultProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bestMixingResultHash();

  @$internal
  @override
  $FutureProviderElement<MixingResult?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MixingResult?> create(Ref ref) {
    return bestMixingResult(ref);
  }
}

String _$bestMixingResultHash() => r'6000a8464f6c9dd90104ea61e1421b8a5d6f6a11';

/// Filter for viewing results by quality threshold.
///
/// Allows users to toggle between viewing all results or just
/// "acceptable or better" matches.

@ProviderFor(QualityFilterEnabled)
const qualityFilterEnabledProvider = QualityFilterEnabledProvider._();

/// Filter for viewing results by quality threshold.
///
/// Allows users to toggle between viewing all results or just
/// "acceptable or better" matches.
final class QualityFilterEnabledProvider
    extends $NotifierProvider<QualityFilterEnabled, bool> {
  /// Filter for viewing results by quality threshold.
  ///
  /// Allows users to toggle between viewing all results or just
  /// "acceptable or better" matches.
  const QualityFilterEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'qualityFilterEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$qualityFilterEnabledHash();

  @$internal
  @override
  QualityFilterEnabled create() => QualityFilterEnabled();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$qualityFilterEnabledHash() =>
    r'd4dccccc190221ad0b08ff4ef766092ddf7d1fcb';

/// Filter for viewing results by quality threshold.
///
/// Allows users to toggle between viewing all results or just
/// "acceptable or better" matches.

abstract class _$QualityFilterEnabled extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Filtered mixing results based on quality threshold.
///
/// Returns results filtered by quality if the quality filter is enabled.
/// This provides a simpler view for users who only want "good" matches or
/// better.

@ProviderFor(filteredMixingResults)
const filteredMixingResultsProvider = FilteredMixingResultsProvider._();

/// Filtered mixing results based on quality threshold.
///
/// Returns results filtered by quality if the quality filter is enabled.
/// This provides a simpler view for users who only want "good" matches or
/// better.

final class FilteredMixingResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MixingResult>>,
          List<MixingResult>,
          FutureOr<List<MixingResult>>
        >
    with
        $FutureModifier<List<MixingResult>>,
        $FutureProvider<List<MixingResult>> {
  /// Filtered mixing results based on quality threshold.
  ///
  /// Returns results filtered by quality if the quality filter is enabled.
  /// This provides a simpler view for users who only want "good" matches or
  /// better.
  const FilteredMixingResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredMixingResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredMixingResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<MixingResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MixingResult>> create(Ref ref) {
    return filteredMixingResults(ref);
  }
}

String _$filteredMixingResultsHash() =>
    r'2132e11fd0eed662957137db807b4d402bf7251d';

/// State holder for UI filters (sorting, etc.)

@ProviderFor(MixingResultsSort)
const mixingResultsSortProvider = MixingResultsSortProvider._();

/// State holder for UI filters (sorting, etc.)
final class MixingResultsSortProvider
    extends $NotifierProvider<MixingResultsSort, MixingSortOption> {
  /// State holder for UI filters (sorting, etc.)
  const MixingResultsSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mixingResultsSortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mixingResultsSortHash();

  @$internal
  @override
  MixingResultsSort create() => MixingResultsSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MixingSortOption value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MixingSortOption>(value),
    );
  }
}

String _$mixingResultsSortHash() => r'6398af9685d05dd12e892d1129bec6886e7e9985';

/// State holder for UI filters (sorting, etc.)

abstract class _$MixingResultsSort extends $Notifier<MixingSortOption> {
  MixingSortOption build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<MixingSortOption, MixingSortOption>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MixingSortOption, MixingSortOption>,
              MixingSortOption,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Sorted mixing results based on user preference

@ProviderFor(sortedMixingResults)
const sortedMixingResultsProvider = SortedMixingResultsProvider._();

/// Sorted mixing results based on user preference

final class SortedMixingResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MixingResult>>,
          List<MixingResult>,
          FutureOr<List<MixingResult>>
        >
    with
        $FutureModifier<List<MixingResult>>,
        $FutureProvider<List<MixingResult>> {
  /// Sorted mixing results based on user preference
  const SortedMixingResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortedMixingResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortedMixingResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<MixingResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MixingResult>> create(Ref ref) {
    return sortedMixingResults(ref);
  }
}

String _$sortedMixingResultsHash() =>
    r'17fc54f464b45e2a427ac67366a2ab2c1543ee58';
