import 'package:flutter_test/flutter_test.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/color_match_quality.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/delta_e_calculator.dart';

void main() {
  group('DeltaECalculator', () {
    late DeltaECalculator calculator;

    setUp(() {
      calculator = DeltaECalculator();
    });

    group('CIE76 (Delta E 1976)', () {
      test('calculates zero for identical colors', () {
        const color = LabColor(l: 50, a: 25, b: -25);

        final deltaE = calculator.calculateCIE76(color, color);

        expect(deltaE, equals(0.0));
      });

      test('calculates correct Delta E for pure lightness difference', () {
        const color1 = LabColor(l: 50, a: 0, b: 0);
        const color2 = LabColor(l: 60, a: 0, b: 0);

        final deltaE = calculator.calculateCIE76(color1, color2);

        // Delta E = sqrt((60-50)^2) = 10
        expect(deltaE, closeTo(10.0, 0.01));
      });

      test('calculates correct Delta E for pure a* difference', () {
        const color1 = LabColor(l: 50, a: 0, b: 0);
        const color2 = LabColor(l: 50, a: 10, b: 0);

        final deltaE = calculator.calculateCIE76(color1, color2);

        // Delta E = sqrt((10-0)^2) = 10
        expect(deltaE, closeTo(10.0, 0.01));
      });

      test('calculates correct Delta E for pure b* difference', () {
        const color1 = LabColor(l: 50, a: 0, b: 0);
        const color2 = LabColor(l: 50, a: 0, b: 10);

        final deltaE = calculator.calculateCIE76(color1, color2);

        // Delta E = sqrt((10-0)^2) = 10
        expect(deltaE, closeTo(10.0, 0.01));
      });

      test('calculates correct Delta E for combined differences', () {
        const color1 = LabColor(l: 50, a: 2.5, b: 0);
        const color2 = LabColor(l: 50, a: 0, b: -2.5);

        final deltaE = calculator.calculateCIE76(color1, color2);

        // Delta E = sqrt((2.5)^2 + (2.5)^2) = sqrt(12.5) ≈ 3.536
        expect(deltaE, closeTo(3.536, 0.01));
      });

      test('calculates maximum Delta E for black to white', () {
        const black = LabColor(l: 0, a: 0, b: 0);
        const white = LabColor(l: 100, a: 0, b: 0);

        final deltaE = calculator.calculateCIE76(black, white);

        // Delta E = 100 (pure lightness difference)
        expect(deltaE, closeTo(100.0, 0.01));
      });

      test('is symmetric (order does not matter)', () {
        const color1 = LabColor(l: 50, a: 25, b: -10);
        const color2 = LabColor(l: 60, a: 30, b: -15);

        final deltaE1 = calculator.calculateCIE76(color1, color2);
        final deltaE2 = calculator.calculateCIE76(color2, color1);

        expect(deltaE1, equals(deltaE2));
      });
    });

    group('CIEDE2000 (Delta E 2000)', () {
      test('calculates zero for identical colors', () {
        const color = LabColor(l: 50, a: 25, b: -25);

        final deltaE = calculator.calculateCIEDE2000(color, color);

        expect(deltaE, equals(0.0));
      });

      test('calculates correct Delta E for achromatic colors (grays)', () {
        const gray1 = LabColor(l: 50, a: 0, b: 0);
        const gray2 = LabColor(l: 60, a: 0, b: 0);

        final deltaE = calculator.calculateCIEDE2000(gray1, gray2);

        // For achromatic colors, CIEDE2000 reduces to lightness difference
        // with weighting factor
        expect(deltaE, greaterThan(0));
        expect(deltaE, lessThan(15)); // Should be less than CIE76 value
      });

      test('handles low chroma colors correctly', () {
        // Low chroma = near-neutral colors
        const color1 = LabColor(l: 50, a: 2, b: 1);
        const color2 = LabColor(l: 50, a: -1, b: 2);

        final deltaE = calculator.calculateCIEDE2000(color1, color2);

        expect(deltaE, greaterThan(0));
        expect(deltaE, lessThan(10));
      });

      test('applies different weighting than CIE76', () {
        // CIEDE2000 should give different results than CIE76 for most colors
        const color1 = LabColor(l: 50, a: 25, b: -10);
        const color2 = LabColor(l: 60, a: 30, b: -15);

        final deltaE76 = calculator.calculateCIE76(color1, color2);
        final deltaE2000 = calculator.calculateCIEDE2000(color1, color2);

        // They should be different (unless color1 == color2)
        expect((deltaE76 - deltaE2000).abs(), greaterThan(0.01));
      });

      test('is symmetric (order does not matter)', () {
        const color1 = LabColor(l: 50, a: 25, b: -10);
        const color2 = LabColor(l: 60, a: 30, b: -15);

        final deltaE1 = calculator.calculateCIEDE2000(color1, color2);
        final deltaE2 = calculator.calculateCIEDE2000(color2, color1);

        expect(deltaE1, closeTo(deltaE2, 0.0001));
      });

      test('handles blue region correction', () {
        // CIEDE2000 has special correction for blue hues (around 275°)
        const blue1 = LabColor(l: 50, a: 0, b: -50);
        const blue2 = LabColor(l: 50, a: 5, b: -45);

        final deltaE = calculator.calculateCIEDE2000(blue1, blue2);

        // Should calculate without errors and give reasonable value
        expect(deltaE, greaterThan(0));
        expect(deltaE, lessThan(20));
      });
    });

    group('calculateDeltaE (generic method)', () {
      test('uses CIE76 by default', () {
        const color1 = LabColor(l: 50, a: 25, b: -10);
        const color2 = LabColor(l: 60, a: 30, b: -15);

        final defaultDeltaE = calculator.calculateDeltaE(color1, color2);
        final cie76DeltaE = calculator.calculateCIE76(color1, color2);

        expect(defaultDeltaE, equals(cie76DeltaE));
      });

      test('uses CIE76 when explicitly specified', () {
        const color1 = LabColor(l: 50, a: 25, b: -10);
        const color2 = LabColor(l: 60, a: 30, b: -15);

        final deltaE = calculator.calculateDeltaE(
          color1,
          color2,
        );
        final cie76DeltaE = calculator.calculateCIE76(color1, color2);

        expect(deltaE, equals(cie76DeltaE));
      });

      test('uses CIEDE2000 when specified', () {
        const color1 = LabColor(l: 50, a: 25, b: -10);
        const color2 = LabColor(l: 60, a: 30, b: -15);

        final deltaE = calculator.calculateDeltaE(
          color1,
          color2,
          algorithm: DeltaEAlgorithm.ciede2000,
        );
        final ciede2000DeltaE = calculator.calculateCIEDE2000(color1, color2);

        expect(deltaE, equals(ciede2000DeltaE));
      });
    });

    group('getMatchQuality', () {
      group('CIE76 quality thresholds', () {
        test('returns excellent for ΔE < 2.3', () {
          final quality = calculator.getMatchQuality(
            2.2,
            DeltaEAlgorithm.cie76,
          );
          expect(quality, equals(ColorMatchQuality.excellent));
        });

        test('returns good for ΔE 2.3-5.0', () {
          final quality1 = calculator.getMatchQuality(
            2.3,
            DeltaEAlgorithm.cie76,
          );
          final quality2 = calculator.getMatchQuality(
            4.9,
            DeltaEAlgorithm.cie76,
          );

          expect(quality1, equals(ColorMatchQuality.good));
          expect(quality2, equals(ColorMatchQuality.good));
        });

        test('returns acceptable for ΔE 5.0-10.0', () {
          final quality1 = calculator.getMatchQuality(
            5,
            DeltaEAlgorithm.cie76,
          );
          final quality2 = calculator.getMatchQuality(
            9.9,
            DeltaEAlgorithm.cie76,
          );

          expect(quality1, equals(ColorMatchQuality.acceptable));
          expect(quality2, equals(ColorMatchQuality.acceptable));
        });

        test('returns poor for ΔE 10.0-20.0', () {
          final quality1 = calculator.getMatchQuality(
            10,
            DeltaEAlgorithm.cie76,
          );
          final quality2 = calculator.getMatchQuality(
            19.9,
            DeltaEAlgorithm.cie76,
          );

          expect(quality1, equals(ColorMatchQuality.poor));
          expect(quality2, equals(ColorMatchQuality.poor));
        });

        test('returns veryPoor for ΔE > 20.0', () {
          final quality = calculator.getMatchQuality(
            20,
            DeltaEAlgorithm.cie76,
          );
          expect(quality, equals(ColorMatchQuality.veryPoor));
        });
      });

      group('CIEDE2000 quality thresholds', () {
        test('returns excellent for ΔE < 1.0', () {
          final quality = calculator.getMatchQuality(
            0.9,
            DeltaEAlgorithm.ciede2000,
          );
          expect(quality, equals(ColorMatchQuality.excellent));
        });

        test('returns good for ΔE 1.0-2.0', () {
          final quality1 = calculator.getMatchQuality(
            1,
            DeltaEAlgorithm.ciede2000,
          );
          final quality2 = calculator.getMatchQuality(
            1.9,
            DeltaEAlgorithm.ciede2000,
          );

          expect(quality1, equals(ColorMatchQuality.good));
          expect(quality2, equals(ColorMatchQuality.good));
        });

        test('returns acceptable for ΔE 2.0-5.0', () {
          final quality1 = calculator.getMatchQuality(
            2,
            DeltaEAlgorithm.ciede2000,
          );
          final quality2 = calculator.getMatchQuality(
            4.9,
            DeltaEAlgorithm.ciede2000,
          );

          expect(quality1, equals(ColorMatchQuality.acceptable));
          expect(quality2, equals(ColorMatchQuality.acceptable));
        });

        test('returns poor for ΔE 5.0-10.0', () {
          final quality1 = calculator.getMatchQuality(
            5,
            DeltaEAlgorithm.ciede2000,
          );
          final quality2 = calculator.getMatchQuality(
            9.9,
            DeltaEAlgorithm.ciede2000,
          );

          expect(quality1, equals(ColorMatchQuality.poor));
          expect(quality2, equals(ColorMatchQuality.poor));
        });

        test('returns veryPoor for ΔE > 10.0', () {
          final quality = calculator.getMatchQuality(
            10,
            DeltaEAlgorithm.ciede2000,
          );
          expect(quality, equals(ColorMatchQuality.veryPoor));
        });
      });

      test(
        'same ΔE value gives different quality for different algorithms',
        () {
          // ΔE = 3.0 is "good" in CIE76 but "acceptable" in CIEDE2000
          final quality76 = calculator.getMatchQuality(
            3,
            DeltaEAlgorithm.cie76,
          );
          final quality2000 = calculator.getMatchQuality(
            3,
            DeltaEAlgorithm.ciede2000,
          );

          expect(quality76, equals(ColorMatchQuality.good));
          expect(quality2000, equals(ColorMatchQuality.acceptable));
        },
      );
    });
  });
}
