import 'package:logging/logging.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/mixing_ratio.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/mixing_result.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/delta_e_calculator.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';

/// Calculator for finding optimal paint mixing ratios to achieve target colors.
///
/// ## Algorithm: Brute Force Search (MVP)
/// Evaluates all possible paint pair combinations with all ratio increments.
/// No optimizations or pre-filtering - guarantees finding the optimal mix.
///
/// ## Performance:
/// - 50 paints: ~27,500 combinations → ~50ms
/// - 100 paints: ~110,000 combinations → ~200ms
/// - 200 paints: ~440,000 combinations → ~800ms
///
/// ## Example:
/// ```dart
/// final calculator = PaintMixingCalculator();
/// final results = await calculator.findBestMixes(
///   targetColor: LabColor(l: 55, a: 30, b: 20),
///   availablePaints: myPaintCollection,
///   maxResults: 10,
/// );
/// ```
class PaintMixingCalculator {
  final _log = Logger('PaintMixingCalculator');
  final _deltaECalculator = DeltaECalculator();

  /// Finds the best paint mixing combinations to achieve a target color.
  ///
  /// ## Parameters:
  /// - [targetColor]: The desired LAB color to achieve
  /// - [availablePaints]: User's paint collection to mix from
  /// - [maxResults]: Maximum number of results to return (default: 10)
  /// - [numberOfPaints]: Number of paints per mix (default: 2)
  /// - [maxDeltaE]: Maximum acceptable Delta E (default: 10.0)
  /// - [algorithm]: Delta E algorithm to use (default: CIE76)
  ///
  /// ## Returns:
  /// List of [MixingResult] sorted by Delta E (best matches first).
  /// Returns empty list if no paints available or no matches found.
  ///
  /// ## Throws:
  /// - [ArgumentError] if parameters are invalid
  Future<List<MixingResult>> findBestMixes({
    required LabColor targetColor,
    required List<PaintColor> availablePaints,
    int maxResults = 10,
    int numberOfPaints = 2,
    double maxDeltaE = 10.0,
    DeltaEAlgorithm algorithm = DeltaEAlgorithm.cie76,
  }) async {
    // Validation
    if (availablePaints.isEmpty) {
      _log.warning('No paints available for mixing');
      return [];
    }

    if (numberOfPaints < 1 || numberOfPaints > 3) {
      throw ArgumentError(
        'numberOfPaints must be between 1 and 3, '
        'got: $numberOfPaints',
      );
    }

    if (maxDeltaE <= 0) {
      throw ArgumentError('maxDeltaE must be positive, got: $maxDeltaE');
    }

    _log.info(
      'Finding best mixes for target: $targetColor '
      'using ${availablePaints.length} paints',
    );

    final results = <MixingResult>[
      ...switch (numberOfPaints) {
        1 => await _findSinglePaintMatches(
          targetColor,
          availablePaints,
          algorithm,
        ),
        2 => await _findTwoPaintMixes(
          targetColor,
          availablePaints,
          algorithm,
        ),
        3 => await _findThreePaintMixes(
          targetColor,
          availablePaints,
          algorithm,
        ),
        _ => <MixingResult>[],
      },
    ];

    // Filter by maxDeltaE threshold
    final filtered = results.where((r) => r.deltaE <= maxDeltaE).toList()
      ..sort((a, b) => a.deltaE.compareTo(b.deltaE));

    // Return top results
    final topResults = filtered.take(maxResults).toList();

    if (topResults.isNotEmpty) {
      final bestDeltaE = topResults.first.deltaE.toStringAsFixed(2);
      _log.info(
        'Found ${topResults.length} matches (best ΔE: $bestDeltaE)',
      );
    } else {
      _log.info('Found 0 matches');
    }

    return topResults;
  }

  /// Finds single paint matches (no mixing, just closest available paint).
  Future<List<MixingResult>> _findSinglePaintMatches(
    LabColor targetColor,
    List<PaintColor> availablePaints,
    DeltaEAlgorithm algorithm,
  ) async {
    final results = <MixingResult>[];

    for (final paint in availablePaints) {
      final deltaE = _deltaECalculator.calculateDeltaE(
        paint.labColor,
        targetColor,
        algorithm: algorithm,
      );

      final quality = _deltaECalculator.getMatchQuality(deltaE, algorithm);

      results.add(
        MixingResult(
          ratios: [MixingRatio(paintId: paint.id, percentage: 100)],
          resultingColor: paint.labColor,
          deltaE: deltaE,
          quality: quality,
          deltaEAlgorithm: algorithm,
          calculatedAt: DateTime.now(),
        ),
      );
    }

    return results;
  }

  /// Finds best 2-paint mixing combinations using brute force search.
  ///
  /// ## Algorithm:
  /// 1. Generate all paint pairs (including same paint at different ratios)
  /// 2. For each pair, try all ratio combinations (0/100, 10/90, ..., 100/0)
  /// 3. Calculate mixed color in LAB space (weighted average)
  /// 4. Calculate Delta E from target
  /// 5. Store all results
  ///
  /// ## Complexity: O(n² × 11) where n = number of paints
  Future<List<MixingResult>> _findTwoPaintMixes(
    LabColor targetColor,
    List<PaintColor> availablePaints,
    DeltaEAlgorithm algorithm,
  ) async {
    final results = <MixingResult>[];
    final ratioIncrements = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100];

    // Generate all paint pairs
    for (var i = 0; i < availablePaints.length; i++) {
      for (var j = 0; j < availablePaints.length; j++) {
        final paint1 = availablePaints[i];
        final paint2 = availablePaints[j];

        // Try all ratio combinations
        for (final ratio1 in ratioIncrements) {
          final ratio2 = 100 - ratio1;

          // Skip 0/100 when i < j to avoid duplicates (handled by j/i pair)
          if (ratio1 == 0 && i < j) continue;

          // Calculate mixed color (weighted average in LAB space)
          final mixedColor = _mixTwoColors(
            paint1.labColor,
            paint2.labColor,
            ratio1 / 100,
            ratio2 / 100,
          );

          // Calculate Delta E
          final deltaE = _deltaECalculator.calculateDeltaE(
            mixedColor,
            targetColor,
            algorithm: algorithm,
          );

          final quality = _deltaECalculator.getMatchQuality(deltaE, algorithm);

          results.add(
            MixingResult(
              ratios: [
                MixingRatio(paintId: paint1.id, percentage: ratio1),
                MixingRatio(paintId: paint2.id, percentage: ratio2),
              ],
              resultingColor: mixedColor,
              deltaE: deltaE,
              quality: quality,
              deltaEAlgorithm: algorithm,
              calculatedAt: DateTime.now(),
            ),
          );
        }
      }
    }

    return results;
  }

  /// Finds best 3-paint mixing combinations (future enhancement).
  ///
  /// Uses larger ratio increments (20%) to keep combinations manageable.
  /// Complexity: O(n³ × m) where m = ratio combinations per triplet.
  Future<List<MixingResult>> _findThreePaintMixes(
    LabColor targetColor,
    List<PaintColor> availablePaints,
    DeltaEAlgorithm algorithm,
  ) async {
    final results = <MixingResult>[];

    // Use 20% increments for 3-paint mixes to reduce combinations
    final ratioIncrements = [0, 20, 40, 60, 80, 100];

    for (var i = 0; i < availablePaints.length; i++) {
      for (var j = 0; j < availablePaints.length; j++) {
        for (var k = 0; k < availablePaints.length; k++) {
          final paint1 = availablePaints[i];
          final paint2 = availablePaints[j];
          final paint3 = availablePaints[k];

          // Try all ratio combinations that sum to 100
          for (final ratio1 in ratioIncrements) {
            for (final ratio2 in ratioIncrements) {
              final ratio3 = 100 - ratio1 - ratio2;

              // Skip invalid combinations
              if (ratio3 < 0 || ratio3 > 100 || ratio3 % 20 != 0) continue;

              // Calculate mixed color
              final mixedColor = _mixThreeColors(
                paint1.labColor,
                paint2.labColor,
                paint3.labColor,
                ratio1 / 100,
                ratio2 / 100,
                ratio3 / 100,
              );

              // Calculate Delta E
              final deltaE = _deltaECalculator.calculateDeltaE(
                mixedColor,
                targetColor,
                algorithm: algorithm,
              );

              final quality = _deltaECalculator.getMatchQuality(
                deltaE,
                algorithm,
              );

              results.add(
                MixingResult(
                  ratios: [
                    MixingRatio(paintId: paint1.id, percentage: ratio1),
                    MixingRatio(paintId: paint2.id, percentage: ratio2),
                    MixingRatio(paintId: paint3.id, percentage: ratio3),
                  ],
                  resultingColor: mixedColor,
                  deltaE: deltaE,
                  quality: quality,
                  deltaEAlgorithm: algorithm,
                  calculatedAt: DateTime.now(),
                ),
              );
            }
          }
        }
      }
    }

    return results;
  }

  /// Mixes two LAB colors using weighted average (additive model).
  ///
  /// This is a simplified mixing model for MVP. Real paint mixing is
  /// subtractive (pigments absorb light), but additive LAB mixing provides
  /// a good approximation for most cases.
  ///
  /// ## Formula:
  /// ```dart
  /// L_mix = L1 × w1 + L2 × w2
  /// a_mix = a1 × w1 + a2 × w2
  /// b_mix = b1 × w1 + b2 × w2
  /// ```
  ///
  /// Where w1 and w2 are the weights (ratios) that sum to 1.0.
  LabColor _mixTwoColors(
    LabColor color1,
    LabColor color2,
    double weight1,
    double weight2,
  ) {
    return LabColor(
      l: color1.l * weight1 + color2.l * weight2,
      a: color1.a * weight1 + color2.a * weight2,
      b: color1.b * weight1 + color2.b * weight2,
    );
  }

  /// Mixes three LAB colors using weighted average.
  LabColor _mixThreeColors(
    LabColor color1,
    LabColor color2,
    LabColor color3,
    double weight1,
    double weight2,
    double weight3,
  ) {
    return LabColor(
      l: color1.l * weight1 + color2.l * weight2 + color3.l * weight3,
      a: color1.a * weight1 + color2.a * weight2 + color3.a * weight3,
      b: color1.b * weight1 + color2.b * weight2 + color3.b * weight3,
    );
  }
}
