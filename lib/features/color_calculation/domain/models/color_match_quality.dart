/// Represents the quality of a color match based on Delta E values.
///
/// Quality thresholds depend on which Delta E algorithm is used:
///
/// ## CIE76 (Delta E 1976) Thresholds:
/// - `excellent`: ΔE < 2.3 (at or below Just Noticeable Difference)
/// - `good`: ΔE 2.3-5.0 (perceptible but acceptable)
/// - `acceptable`: ΔE 5.0-10.0 (noticeable but usable)
/// - `poor`: ΔE 10.0-20.0 (clear difference)
/// - `veryPoor`: ΔE > 20.0 (very different colors)
///
/// ## CIEDE2000 (Delta E 2000) Thresholds:
/// - `excellent`: ΔE < 1.0 (imperceptible to most observers)
/// - `good`: ΔE 1.0-2.0 (perceptible through close observation)
/// - `acceptable`: ΔE 2.0-5.0 (perceptible at a glance)
/// - `poor`: ΔE 5.0-10.0 (clear difference)
/// - `veryPoor`: ΔE > 10.0 (very different colors)
enum ColorMatchQuality {
  /// Imperceptible or just noticeable difference.
  ///
  /// CIE76: ΔE < 2.3 | CIEDE2000: ΔE < 1.0
  excellent,

  /// Perceptible but acceptable for color matching.
  ///
  /// CIE76: ΔE 2.3-5.0 | CIEDE2000: ΔE 1.0-2.0
  good,

  /// Noticeable but still usable for practical purposes.
  ///
  /// CIE76: ΔE 5.0-10.0 | CIEDE2000: ΔE 2.0-5.0
  acceptable,

  /// Clear color difference, colors appear similar but distinct.
  ///
  /// CIE76: ΔE 10.0-20.0 | CIEDE2000: ΔE 5.0-10.0
  poor,

  /// Very different colors.
  ///
  /// CIE76: ΔE > 20.0 | CIEDE2000: ΔE > 10.0
  veryPoor,
}
