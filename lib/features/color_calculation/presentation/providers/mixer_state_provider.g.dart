// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mixer_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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

@ProviderFor(mixerState)
final mixerStateProvider = MixerStateProvider._();

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

final class MixerStateProvider
    extends $FunctionalProvider<MixerState, MixerState, MixerState>
    with $Provider<MixerState> {
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
  MixerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mixerStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mixerStateHash();

  @$internal
  @override
  $ProviderElement<MixerState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MixerState create(Ref ref) {
    return mixerState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MixerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MixerState>(value),
    );
  }
}

String _$mixerStateHash() => r'd3a69b087e4477b539aff3d2bd966398afe30d32';

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

@ProviderFor(MixerReset)
final mixerResetProvider = MixerResetProvider._();

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
final class MixerResetProvider extends $NotifierProvider<MixerReset, void> {
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
  MixerResetProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mixerResetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mixerResetHash();

  @$internal
  @override
  MixerReset create() => MixerReset();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$mixerResetHash() => r'cf4a8ba836d0d26b95ae912df6037b88adc571a7';

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

abstract class _$MixerReset extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
