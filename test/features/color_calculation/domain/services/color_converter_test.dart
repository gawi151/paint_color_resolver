import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';

import '../../../../fixtures/reference_lab_colors.dart';

/// Helper to get RGB components from Color (0-255 range)
int getRed(Color c) => (c.r * 255).round();
int getGreen(Color c) => (c.g * 255).round();
int getBlue(Color c) => (c.b * 255).round();

void main() {
  group('ColorConverter', () {
    late ColorConverter converter;

    setUp(() {
      converter = ColorConverter();
    });

    group('rgbToLab', () {
      // Note: Tolerances based on empirical precision testing.
      // Actual errors: L* ≤0.02, a* ≤0.02, b* ≤0.02
      // We use ±0.05 to provide a safety margin while remaining rigorous.

      test('converts pure red correctly', () {
        const rgbRed = Color(0xFFFF0000);
        final lab = converter.rgbToLab(rgbRed);

        expect(lab.l, closeTo(53.2408, 0.05));
        expect(lab.a, closeTo(80.0925, 0.05));
        expect(lab.b, closeTo(67.2032, 0.05));
      });

      test('converts pure green correctly', () {
        const rgbGreen = Color(0xFF00FF00);
        final lab = converter.rgbToLab(rgbGreen);

        expect(lab.l, closeTo(87.7347, 0.05));
        expect(lab.a, closeTo(-86.1827, 0.05));
        expect(lab.b, closeTo(83.1793, 0.05));
      });

      test('converts pure blue correctly', () {
        const rgbBlue = Color(0xFF0000FF);
        final lab = converter.rgbToLab(rgbBlue);

        expect(lab.l, closeTo(32.2970, 0.05));
        expect(lab.a, closeTo(79.1875, 0.05));
        expect(lab.b, closeTo(-107.8602, 0.05));
      });

      test('converts white correctly', () {
        const rgbWhite = Color(0xFFFFFFFF);
        final lab = converter.rgbToLab(rgbWhite);

        expect(lab.l, closeTo(100, 0.05));
        expect(lab.a, closeTo(0, 0.05));
        expect(lab.b, closeTo(0, 0.05));
      });

      test('converts black correctly', () {
        const rgbBlack = Color(0xFF000000);
        final lab = converter.rgbToLab(rgbBlack);

        expect(lab.l, closeTo(0, 0.05));
        expect(lab.a, closeTo(0, 0.05));
        expect(lab.b, closeTo(0, 0.05));
      });

      test('converts mid gray correctly', () {
        const rgbGray = Color(0xFF808080);
        final lab = converter.rgbToLab(rgbGray);

        expect(lab.l, closeTo(53.5850, 0.05));
        expect(lab.a, closeTo(0, 0.05));
        expect(lab.b, closeTo(0, 0.05));
      });

      test('converts orange correctly', () {
        const rgbOrange = Color(0xFFFFA500);
        final lab = converter.rgbToLab(rgbOrange);

        expect(lab.l, closeTo(74.93, 0.05));
        expect(lab.a, closeTo(23.93, 0.05));
        expect(lab.b, closeTo(78.95, 0.05));
      });

      test('handles edge case RGB(255, 255, 254)', () {
        const almostWhite = Color(0xFFFFFFFE);
        final lab = converter.rgbToLab(almostWhite);

        expect(lab.l, greaterThan(99));
        expect(lab.l, lessThanOrEqualTo(100));
      });
    });

    group('labToRgb', () {
      // Note: Tolerances based on empirical precision testing.
      // Actual errors: RGB ≤1 (out of 255)
      // We use ±1 for exact accuracy validation.

      test('converts LAB red to RGB red', () {
        const labRed = ReferenceLabColors.pureRed;
        final rgb = converter.labToRgb(labRed);

        expect(getRed(rgb), closeTo(255, 1));
        expect(getGreen(rgb), closeTo(0, 1));
        expect(getBlue(rgb), closeTo(0, 1));
      });

      test('converts LAB white to RGB white', () {
        const labWhite = ReferenceLabColors.white;
        final rgb = converter.labToRgb(labWhite);

        expect(getRed(rgb), closeTo(255, 1));
        expect(getGreen(rgb), closeTo(255, 1));
        expect(getBlue(rgb), closeTo(255, 1));
      });

      test('converts LAB black to RGB black', () {
        const labBlack = ReferenceLabColors.black;
        final rgb = converter.labToRgb(labBlack);

        expect(getRed(rgb), closeTo(0, 1));
        expect(getGreen(rgb), closeTo(0, 1));
        expect(getBlue(rgb), closeTo(0, 1));
      });

      test('converts LAB gray to RGB gray', () {
        const labGray = ReferenceLabColors.midGray;
        final rgb = converter.labToRgb(labGray);

        expect(getRed(rgb), closeTo(128, 1));
        expect(getGreen(rgb), closeTo(128, 1));
        expect(getBlue(rgb), closeTo(128, 1));
      });
    });

    group('round-trip conversions', () {
      // Note: Tolerances based on empirical precision testing.
      // Actual errors: RGB ≤1 (out of 255) for round-trip conversions
      // We use ±2 to provide a small safety margin for cumulative errors.

      test('RGB -> LAB -> RGB preserves red', () {
        const original = Color(0xFFFF0000);
        final lab = converter.rgbToLab(original);
        final roundTrip = converter.labToRgb(lab);

        expect(getRed(roundTrip), closeTo(getRed(original), 2));
        expect(getGreen(roundTrip), closeTo(getGreen(original), 2));
        expect(getBlue(roundTrip), closeTo(getBlue(original), 2));
      });

      test('RGB -> LAB -> RGB preserves green', () {
        const original = Color(0xFF00FF00);
        final lab = converter.rgbToLab(original);
        final roundTrip = converter.labToRgb(lab);

        expect(getRed(roundTrip), closeTo(getRed(original), 2));
        expect(getGreen(roundTrip), closeTo(getGreen(original), 2));
        expect(getBlue(roundTrip), closeTo(getBlue(original), 2));
      });

      test('RGB -> LAB -> RGB preserves blue', () {
        const original = Color(0xFF0000FF);
        final lab = converter.rgbToLab(original);
        final roundTrip = converter.labToRgb(lab);

        expect(getRed(roundTrip), closeTo(getRed(original), 2));
        expect(getGreen(roundTrip), closeTo(getGreen(original), 2));
        expect(getBlue(roundTrip), closeTo(getBlue(original), 2));
      });

      test('RGB -> LAB -> RGB preserves arbitrary colors', () {
        final testColors = [
          const Color(0xFFABCDEF),
          const Color(0xFF123456),
          const Color(0xFF789ABC),
          const Color(0xFFFEDCBA),
        ];

        for (final original in testColors) {
          final lab = converter.rgbToLab(original);
          final roundTrip = converter.labToRgb(lab);

          final argb = original.toARGB32();
          final hex = argb.toRadixString(16).padLeft(8, '0');
          expect(
            getRed(roundTrip),
            closeTo(getRed(original), 2),
            reason: 'Red channel for $hex',
          );
          expect(
            getGreen(roundTrip),
            closeTo(getGreen(original), 2),
            reason: 'Green channel for $hex',
          );
          expect(
            getBlue(roundTrip),
            closeTo(getBlue(original), 2),
            reason: 'Blue channel for $hex',
          );
        }
      });
    });

    group('hexToLab', () {
      test('converts hex red correctly', () {
        final lab = converter.hexToLab('#FF0000');

        expect(lab.l, closeTo(53.23, 0.5));
        expect(lab.a, closeTo(80.11, 1.0));
        expect(lab.b, closeTo(67.22, 1.0));
      });

      test('converts hex without # prefix', () {
        final lab = converter.hexToLab('FF0000');

        expect(lab.l, closeTo(53.23, 0.5));
        expect(lab.a, closeTo(80.11, 1.0));
        expect(lab.b, closeTo(67.22, 1.0));
      });

      test('converts lowercase hex correctly', () {
        final lab = converter.hexToLab('#ff0000');

        expect(lab.l, closeTo(53.23, 0.5));
        expect(lab.a, closeTo(80.11, 1.0));
        expect(lab.b, closeTo(67.22, 1.0));
      });

      test('throws on invalid hex format - too short', () {
        expect(
          () => converter.hexToLab('#FF00'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws on invalid hex format - too long', () {
        expect(
          () => converter.hexToLab('#FF00000'),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('throws on invalid hex characters', () {
        expect(
          () => converter.hexToLab('#GGGGGG'),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
