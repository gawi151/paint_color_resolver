import 'dart:math';

import 'package:paint_color_resolver/features/color_calculation/domain/models/color_match_quality.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';

/// Specifies which Delta E algorithm to use for color difference calculation.
///
/// Different algorithms have different accuracy and complexity trade-offs.
enum DeltaEAlgorithm {
  /// CIE76 (Delta E 1976): Simple Euclidean distance in LAB space.
  ///
  /// - **Pros**: Fast, simple to understand and implement
  /// - **Cons**: Less perceptually uniform in saturated colors
  /// - **Formula**: √((ΔL)² + (Δa)² + (Δb)²)
  /// - **JND**: ~2.3 (revised from original 1.0)
  cie76,

  /// CIEDE2000 (Delta E 2000): Advanced perceptually uniform formula.
  ///
  /// - **Pros**: Industry standard, excellent perceptual uniformity
  /// - **Cons**: More complex calculation (~50 lines of code)
  /// - **JND**: ~1.0 (imperceptible to most observers)
  /// - **Reference**: "The CIEDE2000 Color-Difference Formula" - Sharma et al.
  ciede2000,
}

/// Calculator for measuring perceptual color differences using Delta E formulas.
///
/// Delta E (ΔE) measures how different two colors appear to the human eye.
/// Lower values indicate more similar colors.
///
/// ## Algorithms:
/// - **CIE76**: Simple Euclidean distance (MVP default)
/// - **CIEDE2000**: Advanced perceptually uniform formula (industry standard)
///
/// ## Example:
/// ```dart
/// final calculator = DeltaECalculator();
/// final color1 = LabColor(l: 50, a: 20, b: 30);
/// final color2 = LabColor(l: 52, a: 22, b: 28);
///
/// final deltaE = calculator.calculateDeltaE(color1, color2);
/// final quality = calculator.getMatchQuality(deltaE, DeltaEAlgorithm.cie76);
/// ```
class DeltaECalculator {
  /// Calculates Delta E between two colors using the specified algorithm.
  ///
  /// Defaults to CIE76 for MVP (faster and simpler).
  double calculateDeltaE(
    LabColor color1,
    LabColor color2, {
    DeltaEAlgorithm algorithm = DeltaEAlgorithm.cie76,
  }) {
    switch (algorithm) {
      case DeltaEAlgorithm.cie76:
        return calculateCIE76(color1, color2);
      case DeltaEAlgorithm.ciede2000:
        return calculateCIEDE2000(color1, color2);
    }
  }

  /// Calculates Delta E using CIE76 formula (simple Euclidean distance).
  ///
  /// Formula: ΔE = √((ΔL)² + (Δa)² + (Δb)²)
  ///
  /// This is the simplest and fastest Delta E calculation, treating LAB
  /// as a uniform 3D space. While not perfectly perceptually uniform,
  /// it's sufficient for most paint mixing applications.
  ///
  /// ## Interpretation (CIE76):
  /// - ΔE < 2.3: Just Noticeable Difference (JND)
  /// - ΔE < 5.0: Good match for miniature painting
  /// - ΔE < 10.0: Acceptable for most purposes
  /// - ΔE > 10.0: Clear color difference
  double calculateCIE76(LabColor color1, LabColor color2) {
    final deltaL = color2.l - color1.l;
    final deltaA = color2.a - color1.a;
    final deltaB = color2.b - color1.b;

    return sqrt(deltaL * deltaL + deltaA * deltaA + deltaB * deltaB);
  }

  /// Calculates Delta E using CIEDE2000 formula (most accurate).
  ///
  /// CIEDE2000 is the industry standard for professional color matching.
  /// It accounts for perceptual non-uniformities in LAB space, especially
  /// in saturated colors.
  ///
  /// ## Key Improvements over CIE76:
  /// - Weighting factors for lightness, chroma, and hue
  /// - Rotation function for blue region
  /// - Better handling of neutral colors (low chroma)
  ///
  /// ## Interpretation (CIEDE2000):
  /// - ΔE < 1.0: Imperceptible to most observers
  /// - ΔE < 2.0: Perceptible through close observation
  /// - ΔE < 5.0: Acceptable for color matching
  /// - ΔE > 5.0: Clear color difference
  ///
  /// ## Reference:
  /// "The CIEDE2000 Color-Difference Formula: Implementation Notes,
  /// Supplementary Test Data, and Mathematical Observations"
  /// - Sharma, Wu, Dalal (2005)
  ///
  /// Implementation based on Bruce Lindbloom's reference:
  /// http://www.brucelindbloom.com/index.html?Eqn_DeltaE_CIE2000.html
  double calculateCIEDE2000(LabColor color1, LabColor color2) {
    // Weighting factors (set to 1 for standard conditions)
    const kL = 1.0; // Lightness weight
    const kC = 1.0; // Chroma weight
    const kH = 1.0; // Hue weight

    // Step 1: Calculate C' (chroma with G correction factor)
    final c1 = sqrt(color1.a * color1.a + color1.b * color1.b);
    final c2 = sqrt(color2.a * color2.a + color2.b * color2.b);
    final cBar = (c1 + c2) / 2.0;

    final g = 0.5 * (1 - sqrt(pow(cBar, 7) / (pow(cBar, 7) + pow(25.0, 7))));

    final a1Prime = (1 + g) * color1.a;
    final a2Prime = (1 + g) * color2.a;

    final c1Prime = sqrt(a1Prime * a1Prime + color1.b * color1.b);
    final c2Prime = sqrt(a2Prime * a2Prime + color2.b * color2.b);

    // Step 2: Calculate h' (hue angle)
    final h1Prime = _calculateHuePrime(a1Prime, color1.b);
    final h2Prime = _calculateHuePrime(a2Prime, color2.b);

    // Step 3: Calculate ΔL', ΔC', ΔH'
    final deltaLPrime = color2.l - color1.l;
    final deltaCPrime = c2Prime - c1Prime;

    double deltaHPrime;
    if (c1Prime * c2Prime == 0) {
      deltaHPrime = 0;
    } else {
      final diff = h2Prime - h1Prime;
      if (diff.abs() <= 180) {
        deltaHPrime = diff;
      } else if (diff > 180) {
        deltaHPrime = diff - 360;
      } else {
        deltaHPrime = diff + 360;
      }
    }

    final deltaHHPrime =
        2 * sqrt(c1Prime * c2Prime) * sin(_degreesToRadians(deltaHPrime / 2));

    // Step 4: Calculate average values
    final lBarPrime = (color1.l + color2.l) / 2;
    final cBarPrime = (c1Prime + c2Prime) / 2;

    double hBarPrime;
    if (c1Prime * c2Prime == 0) {
      hBarPrime = h1Prime + h2Prime;
    } else {
      final sum = h1Prime + h2Prime;
      final diff = (h1Prime - h2Prime).abs();
      if (diff <= 180) {
        hBarPrime = sum / 2;
      } else if (sum < 360) {
        hBarPrime = (sum + 360) / 2;
      } else {
        hBarPrime = (sum - 360) / 2;
      }
    }

    // Step 5: Calculate T (hue-dependent function)
    final t =
        1 -
        0.17 * cos(_degreesToRadians(hBarPrime - 30)) +
        0.24 * cos(_degreesToRadians(2 * hBarPrime)) +
        0.32 * cos(_degreesToRadians(3 * hBarPrime + 6)) -
        0.20 * cos(_degreesToRadians(4 * hBarPrime - 63));

    // Step 6: Calculate ΔΘ (rotation function for blue region)
    final deltaTheta = 30 * exp(-pow((hBarPrime - 275) / 25, 2));

    // Step 7: Calculate RC (chroma-dependent rotation factor)
    final rC = 2 * sqrt(pow(cBarPrime, 7) / (pow(cBarPrime, 7) + pow(25.0, 7)));

    // Step 8: Calculate RT (rotation term)
    final rT = -sin(_degreesToRadians(2 * deltaTheta)) * rC;

    // Step 9: Calculate SL, SC, SH (weighting functions)
    final sL =
        1 +
        ((0.015 * pow(lBarPrime - 50, 2)) / sqrt(20 + pow(lBarPrime - 50, 2)));
    final sC = 1 + 0.045 * cBarPrime;
    final sH = 1 + 0.015 * cBarPrime * t;

    // Step 10: Calculate final CIEDE2000
    final lightness = deltaLPrime / (kL * sL);
    final chroma = deltaCPrime / (kC * sC);
    final hue = deltaHHPrime / (kH * sH);

    return sqrt(
      lightness * lightness + chroma * chroma + hue * hue + rT * chroma * hue,
    );
  }

  /// Determines color match quality based on Delta E value and algorithm.
  ///
  /// Uses algorithm-specific thresholds since the same ΔE value has
  /// different meanings in CIE76 vs CIEDE2000.
  ColorMatchQuality getMatchQuality(
    double deltaE,
    DeltaEAlgorithm algorithm,
  ) {
    switch (algorithm) {
      case DeltaEAlgorithm.cie76:
        return _getQualityCIE76(deltaE);
      case DeltaEAlgorithm.ciede2000:
        return _getQualityCIEDE2000(deltaE);
    }
  }

  /// Returns quality rating for CIE76 Delta E values.
  ColorMatchQuality _getQualityCIE76(double deltaE) {
    if (deltaE < 2.3) return ColorMatchQuality.excellent;
    if (deltaE < 5.0) return ColorMatchQuality.good;
    if (deltaE < 10.0) return ColorMatchQuality.acceptable;
    if (deltaE < 20.0) return ColorMatchQuality.poor;
    return ColorMatchQuality.veryPoor;
  }

  /// Returns quality rating for CIEDE2000 Delta E values.
  ColorMatchQuality _getQualityCIEDE2000(double deltaE) {
    if (deltaE < 1.0) return ColorMatchQuality.excellent;
    if (deltaE < 2.0) return ColorMatchQuality.good;
    if (deltaE < 5.0) return ColorMatchQuality.acceptable;
    if (deltaE < 10.0) return ColorMatchQuality.poor;
    return ColorMatchQuality.veryPoor;
  }

  /// Calculates hue angle h' in degrees (0-360).
  ///
  /// Handles special case where both a' and b are zero (achromatic color).
  double _calculateHuePrime(double aPrime, double b) {
    if (aPrime == 0 && b == 0) {
      return 0;
    }

    final hue = atan2(b, aPrime) * 180 / pi;
    return hue >= 0 ? hue : hue + 360;
  }

  /// Converts degrees to radians.
  double _degreesToRadians(double degrees) => degrees * pi / 180;
}
