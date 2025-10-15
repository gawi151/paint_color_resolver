import 'package:flutter_test/flutter_test.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/color_match_quality.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/delta_e_calculator.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/paint_mixing_calculator.dart';

import '../../../../fixtures/test_paint_colors.dart';

void main() {
  group('PaintMixingCalculator', () {
    late PaintMixingCalculator calculator;

    setUp(() {
      calculator = PaintMixingCalculator();
    });

    group('input validation', () {
      test('returns empty list for empty paint inventory', () async {
        final results = await calculator.findBestMixes(
          targetColor: const LabColor(l: 50, a: 0, b: 0),
          availablePaints: [],
        );

        expect(results, isEmpty);
      });

      test('throws ArgumentError for invalid numberOfPaints', () async {
        expect(
          () => calculator.findBestMixes(
            targetColor: const LabColor(l: 50, a: 0, b: 0),
            availablePaints: TestPaintColors.smallCollection,
            numberOfPaints: 0,
          ),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => calculator.findBestMixes(
            targetColor: const LabColor(l: 50, a: 0, b: 0),
            availablePaints: TestPaintColors.smallCollection,
            numberOfPaints: 4,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws ArgumentError for invalid maxDeltaE', () async {
        expect(
          () => calculator.findBestMixes(
            targetColor: const LabColor(l: 50, a: 0, b: 0),
            availablePaints: TestPaintColors.smallCollection,
            maxDeltaE: 0,
          ),
          throwsA(isA<ArgumentError>()),
        );

        expect(
          () => calculator.findBestMixes(
            targetColor: const LabColor(l: 50, a: 0, b: 0),
            availablePaints: TestPaintColors.smallCollection,
            maxDeltaE: -5,
          ),
          throwsA(isA<ArgumentError>()),
        );
      });
    });

    group('single paint matching (numberOfPaints=1)', () {
      test('finds exact match when target is in inventory', () async {
        final targetPaint = TestPaintColors.vallejoRed;

        final results = await calculator.findBestMixes(
          targetColor: targetPaint.labColor,
          availablePaints: [targetPaint],
          numberOfPaints: 1,
        );

        expect(results, isNotEmpty);
        expect(results.first.deltaE, closeTo(0, 0.0001));
        expect(results.first.ratios.length, equals(1));
        expect(results.first.ratios.first.percentage, equals(100));
      });

      test('finds closest single paint', () async {
        const targetColor = LabColor(l: 50, a: 10, b: 10);

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection,
          numberOfPaints: 1,
          maxDeltaE: 100, // Allow any match for this test
        );

        expect(results, isNotEmpty);
        expect(results.first.ratios.length, equals(1));
        expect(results.first.ratios.first.percentage, equals(100));
      });

      test('returns results sorted by Delta E', () async {
        const targetColor = LabColor(l: 50, a: 10, b: 10);

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection,
          numberOfPaints: 1,
        );

        // Verify results are sorted (best match first)
        for (var i = 0; i < results.length - 1; i++) {
          expect(
            results[i].deltaE,
            lessThanOrEqualTo(results[i + 1].deltaE),
          );
        }
      });
    });

    group('two-paint mixing (numberOfPaints=2)', () {
      test('finds 50/50 mix', () async {
        // Target color is exactly halfway between red and white
        final red = TestPaintColors.vallejoRed;
        final white = TestPaintColors.vallejoWhite;

        final targetColor = LabColor(
          l: (red.labColor.l + white.labColor.l) / 2,
          a: (red.labColor.a + white.labColor.a) / 2,
          b: (red.labColor.b + white.labColor.b) / 2,
        );

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: [red, white],
        );

        expect(results, isNotEmpty);

        // Find the 50/50 mix
        final fiftyFifty = results.firstWhere(
          (r) =>
              r.ratios.any((ratio) => ratio.percentage == 50) &&
              r.ratios.length == 2,
        );

        expect(fiftyFifty.deltaE, closeTo(0, 0.1));
      });

      test('finds 70/30 mix', () async {
        // Target color is 70% red, 30% white
        final red = TestPaintColors.vallejoRed;
        final white = TestPaintColors.vallejoWhite;

        final targetColor = LabColor(
          l: red.labColor.l * 0.7 + white.labColor.l * 0.3,
          a: red.labColor.a * 0.7 + white.labColor.a * 0.3,
          b: red.labColor.b * 0.7 + white.labColor.b * 0.3,
        );

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: [red, white],
        );

        expect(results, isNotEmpty);

        // Find the 70/30 mix
        final seventyThirty = results.firstWhere(
          (r) =>
              r.ratios.any((ratio) => ratio.percentage == 70) &&
              r.ratios.length == 2,
        );

        expect(seventyThirty.deltaE, closeTo(0, 0.1));
      });

      test('evaluates all paint pair combinations', () async {
        const targetColor = LabColor(l: 50, a: 0, b: 0);
        final paints = TestPaintColors.smallCollection.take(3).toList();

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: paints,
          maxDeltaE: 100, // Allow any match for this test
          maxResults: 100, // Get all combinations
        );

        // With 3 paints: 3×3 = 9 pairs × 11 ratios = 99 combinations
        // But we filter out 0/100 duplicates, so expect fewer unique results
        expect(results.length, greaterThan(50));
      });

      test('respects maxResults parameter', () async {
        const targetColor = LabColor(l: 50, a: 0, b: 0);

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection,
          maxResults: 5,
        );

        expect(results.length, lessThanOrEqualTo(5));
      });

      test('respects maxDeltaE threshold', () async {
        const targetColor = LabColor(l: 50, a: 0, b: 0);

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection,
          maxDeltaE: 5,
        );

        // All results should have Delta E ≤ 5
        for (final result in results) {
          expect(result.deltaE, lessThanOrEqualTo(5));
        }
      });

      test('validates mixing ratios sum to 100%', () async {
        const targetColor = LabColor(l: 50, a: 0, b: 0);

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection.take(3).toList(),
          maxDeltaE: 100, // Allow any match for this test
        );

        for (final result in results) {
          final sum = result.ratios.fold<int>(
            0,
            (sum, r) => sum + r.percentage,
          );
          expect(sum, equals(100), reason: 'Ratios must sum to 100%');
        }
      });

      test('returns results sorted by Delta E (best first)', () async {
        const targetColor = LabColor(l: 50, a: 20, b: 10);

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection,
        );

        // Verify sorted order
        for (var i = 0; i < results.length - 1; i++) {
          expect(
            results[i].deltaE,
            lessThanOrEqualTo(results[i + 1].deltaE),
            reason: 'Results must be sorted by Delta E ascending',
          );
        }
      });

      test('includes quality assessment in results', () async {
        const targetColor = LabColor(l: 50, a: 0, b: 0);

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection,
        );

        expect(results, isNotEmpty);

        // All results should have quality assessment
        for (final result in results) {
          expect(result.quality, isNotNull);
          expect(result.quality, isA<ColorMatchQuality>());
        }
      });

      test('uses specified Delta E algorithm', () async {
        const targetColor = LabColor(l: 50, a: 20, b: 10);

        final resultsCIE76 = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection.take(3).toList(),
          maxDeltaE: 100, // Allow any match for this test
        );

        final resultsCIEDE2000 = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: TestPaintColors.smallCollection.take(3).toList(),
          algorithm: DeltaEAlgorithm.ciede2000,
          maxDeltaE: 100, // Allow any match for this test
        );

        // Results should differ because algorithms calculate Delta E
        // differently
        expect(resultsCIE76.first.deltaE, isNot(resultsCIEDE2000.first.deltaE));
        expect(resultsCIE76.first.deltaEAlgorithm, DeltaEAlgorithm.cie76);
        expect(
          resultsCIEDE2000.first.deltaEAlgorithm,
          DeltaEAlgorithm.ciede2000,
        );
      });
    });

    group('three-paint mixing (numberOfPaints=3)', () {
      test('finds valid 3-paint mixes', () async {
        const targetColor = LabColor(l: 50, a: 0, b: 0);
        final paints = TestPaintColors.smallCollection.take(3).toList();

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: paints,
          numberOfPaints: 3,
        );

        expect(results, isNotEmpty);

        // Check first result
        expect(results.first.ratios.length, equals(3));

        // Ratios should sum to 100
        final sum = results.first.ratios.fold<int>(
          0,
          (sum, r) => sum + r.percentage,
        );
        expect(sum, equals(100));
      });

      test('uses 20% increments for 3-paint mixes', () async {
        const targetColor = LabColor(l: 50, a: 0, b: 0);
        final paints = TestPaintColors.smallCollection.take(3).toList();

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: paints,
          numberOfPaints: 3,
          maxResults: 20,
        );

        // All percentages should be multiples of 20
        for (final result in results) {
          for (final ratio in result.ratios) {
            expect(ratio.percentage % 20, equals(0));
          }
        }
      });

      test('validates 3-paint ratios sum to 100%', () async {
        const targetColor = LabColor(l: 50, a: 10, b: 10);
        final paints = TestPaintColors.smallCollection.take(4).toList();

        final results = await calculator.findBestMixes(
          targetColor: targetColor,
          availablePaints: paints,
          numberOfPaints: 3,
        );

        for (final result in results) {
          final sum = result.ratios.fold<int>(
            0,
            (sum, r) => sum + r.percentage,
          );
          expect(sum, equals(100), reason: '3-paint ratios must sum to 100%');
        }
      });
    });

    group('performance', () {
      test(
        'completes in reasonable time for small collection (10 paints)',
        () async {
          const targetColor = LabColor(l: 50, a: 0, b: 0);

          final stopwatch = Stopwatch()..start();

          await calculator.findBestMixes(
            targetColor: targetColor,
            availablePaints: TestPaintColors.smallCollection,
          );

          stopwatch.stop();

          // Should complete in < 500ms for 10 paints
          // (10×10×11 = 1,100 combinations)
          expect(stopwatch.elapsedMilliseconds, lessThan(500));
        },
        timeout: const Timeout(Duration(seconds: 2)),
      );

      test(
        'completes in reasonable time for medium collection (50 paints)',
        () async {
          const targetColor = LabColor(l: 50, a: 0, b: 0);

          final stopwatch = Stopwatch()..start();

          await calculator.findBestMixes(
            targetColor: targetColor,
            availablePaints: TestPaintColors.mediumCollection,
          );

          stopwatch.stop();

          // Should complete in < 2000ms for 50 paints
          // (50×50×11 = 27,500 combinations)
          expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        },
        timeout: const Timeout(Duration(seconds: 5)),
      );
    });
  });
}
