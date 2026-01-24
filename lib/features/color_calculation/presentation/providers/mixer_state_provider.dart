import 'package:logging/logging.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/providers/color_mixing_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mixer_state_provider.g.dart';

final _log = Logger('MixerState');

/// State model representing the complete mixer configuration.
///
/// This bundles all the mixing parameters together for convenient access
/// and serialization. Unlike individual providers, this gives us a single
/// point of reference for all mixer settings.
class MixerState {
  const MixerState({
    required this.targetColor,
    required this.numberOfPaints,
    required this.maxDeltaE,
  });

  /// The target LAB color to match
  final LabColor? targetColor;

  /// Number of paints to mix (1, 2, or 3)
  final int numberOfPaints;

  /// Maximum acceptable color difference (Delta E threshold)
  final double maxDeltaE;

  /// Creates a copy of this state with specified fields replaced.
  ///
  /// Useful for updating individual properties while preserving others.
  MixerState copyWith({
    LabColor? targetColor,
    int? numberOfPaints,
    double? maxDeltaE,
  }) {
    return MixerState(
      targetColor: targetColor ?? this.targetColor,
      numberOfPaints: numberOfPaints ?? this.numberOfPaints,
      maxDeltaE: maxDeltaE ?? this.maxDeltaE,
    );
  }

  @override
  String toString() =>
      'MixerState(target: $targetColor, '
      'paints: $numberOfPaints, maxDeltaE: $maxDeltaE)';
}

/// Provider that exposes the complete mixer state as a single read-only object.
///
/// This watches all the individual mixer providers and combines them into
/// a single state object. This is useful for components that need to access
/// all mixer settings without watching multiple providers separately.
///
/// **Important:** This provider is READ-ONLY. To modify mixer state, use
/// the individual providers (targetColorProvider, numberOfPaintsProvider, etc.)
///
/// ## Usage:
/// ```dart
/// final mixerState = ref.watch(mixerStateProvider);
///
/// Text('Target: ${mixerState.targetColor}, '
///      'Paints: ${mixerState.numberOfPaints}');
/// ```
@riverpod
MixerState mixerState(Ref ref) {
  final targetColor = ref.watch(targetColorProvider);
  final numberOfPaints = ref.watch(numberOfPaintsProvider);
  final maxDeltaE = ref.watch(maxDeltaEThresholdProvider);

  _log.finest(
    'Mixer state updated: target=$targetColor, '
    'paints=$numberOfPaints, maxDeltaE=$maxDeltaE',
  );

  return MixerState(
    targetColor: targetColor,
    numberOfPaints: numberOfPaints,
    maxDeltaE: maxDeltaE,
  );
}

/// Provider for resetting all mixer state to defaults.
///
/// This notifier provides a convenient way to reset the entire mixer
/// back to its initial state. Useful after completing a mix or when
/// starting a fresh calculation.
///
/// ## Usage:
/// ```dart
/// // Reset all mixer settings to defaults
/// ref.read(mixerResetProvider.notifier).resetAll();
/// ```
@riverpod
class MixerReset extends _$MixerReset {
  @override
  void build() {
    // This provider doesn't hold state, just provides methods
  }

  /// Resets all mixer settings to their default values.
  ///
  /// This clears:
  /// - Target color (set to null)
  /// - Number of paints (reset to 2)
  /// - Max Delta E threshold (reset to 10)
  void resetAll() {
    _log.info('Resetting all mixer state to defaults');

    ref.read(targetColorProvider.notifier).clearTargetColor();
    ref.read(numberOfPaintsProvider.notifier).setNumberOfPaints(2);
    ref.read(maxDeltaEThresholdProvider.notifier).setMaxDeltaE(10);
  }

  /// Clears only the target color, preserving other settings.
  void clearTargetColor() {
    _log.fine('Clearing target color');
    ref.read(targetColorProvider.notifier).clearTargetColor();
  }

  /// Resets the number of paints to the default (2 paints).
  void resetNumberOfPaints() {
    _log.fine('Resetting number of paints to default (2)');
    ref.read(numberOfPaintsProvider.notifier).setNumberOfPaints(2);
  }

  /// Resets the max Delta E threshold to the default (10.0).
  void resetMaxDeltaE() {
    _log.fine('Resetting max Delta E to default (10.0)');
    ref.read(maxDeltaEThresholdProvider.notifier).setMaxDeltaE(10);
  }
}
