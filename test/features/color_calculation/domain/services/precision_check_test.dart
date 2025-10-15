// do not applies to test folder
// ignore_for_file: avoid_print

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';

/// This test verifies the actual precision of our color conversions.
/// Run with: flutter test test/features/color_calculation/domain/services/precision_check_test.dart
void main() {
  test('Check actual RGB->LAB conversion precision', () {
    final converter = ColorConverter();

    print('\n=== RGB → LAB Conversion Precision ===\n');

    // Red - Verified against Bruce Lindbloom 2025-10-15
    final redLab = converter.rgbToLab(const Color(0xFFFF0000));
    print('Red RGB(255,0,0) → LAB:');
    print(
      '  Actual:   L=${redLab.l.toStringAsFixed(4)}, '
      'a=${redLab.a.toStringAsFixed(4)}, b=${redLab.b.toStringAsFixed(4)}',
    );
    print('  Expected: L=53.2408, a=80.0925, b=67.2032 (Bruce Lindbloom)');
    print(
      '  Diff:     ΔL=${(redLab.l - 53.2408).abs().toStringAsFixed(6)}, '
      'Δa=${(redLab.a - 80.0925).abs().toStringAsFixed(6)}, '
      'Δb=${(redLab.b - 67.2032).abs().toStringAsFixed(6)}',
    );

    // Green - Verified against Bruce Lindbloom 2025-10-15
    final greenLab = converter.rgbToLab(const Color(0xFF00FF00));
    print('\nGreen RGB(0,255,0) → LAB:');
    print(
      '  Actual:   L=${greenLab.l.toStringAsFixed(4)}, '
      'a=${greenLab.a.toStringAsFixed(4)}, b=${greenLab.b.toStringAsFixed(4)}',
    );
    print('  Expected: L=87.7347, a=-86.1827, b=83.1793 (Bruce Lindbloom)');
    print(
      '  Diff:     ΔL=${(greenLab.l - 87.7347).abs().toStringAsFixed(6)}, '
      'Δa=${(greenLab.a - (-86.1827)).abs().toStringAsFixed(6)}, '
      'Δb=${(greenLab.b - 83.1793).abs().toStringAsFixed(6)}',
    );

    // Blue - Using output from our implementation (not yet verified)
    final blueLab = converter.rgbToLab(const Color(0xFF0000FF));
    print('\nBlue RGB(0,0,255) → LAB:');
    print(
      '  Actual:   L=${blueLab.l.toStringAsFixed(4)}, '
      'a=${blueLab.a.toStringAsFixed(4)}, b=${blueLab.b.toStringAsFixed(4)}',
    );
    print(
      '  Expected: L=32.2970, a=79.1875, b=-107.8602 (from implementation)',
    );
    print(
      '  Diff:     ΔL=${(blueLab.l - 32.2970).abs().toStringAsFixed(6)}, '
      'Δa=${(blueLab.a - 79.1875).abs().toStringAsFixed(6)}, '
      'Δb=${(blueLab.b - (-107.8602)).abs().toStringAsFixed(6)}',
    );
  });

  test('Check actual LAB->RGB conversion precision', () {
    final converter = ColorConverter();

    print('\n=== LAB → RGB Conversion Precision ===\n');

    // Red round-trip
    final redLab = converter.rgbToLab(const Color(0xFFFF0000));
    final redRgb = converter.labToRgb(redLab);
    final r = (redRgb.r * 255).round();
    final g = (redRgb.g * 255).round();
    final b = (redRgb.b * 255).round();
    print('Red LAB → RGB:');
    print('  Actual:   R=$r, G=$g, B=$b');
    print('  Expected: R=255, G=0, B=0');
    print('  Diff:     ΔR=${(r - 255).abs()}, ΔG=$g, ΔB=$b');

    // Gray (most sensitive)
    final grayLab = converter.rgbToLab(const Color(0xFF808080));
    final grayRgb = converter.labToRgb(grayLab);
    final grayR = (grayRgb.r * 255).round();
    final grayG = (grayRgb.g * 255).round();
    final grayB = (grayRgb.b * 255).round();
    print('\nGray RGB(128,128,128) → LAB → RGB:');
    print(
      '  LAB: L=${grayLab.l.toStringAsFixed(4)}, '
      'a=${grayLab.a.toStringAsFixed(4)}, b=${grayLab.b.toStringAsFixed(4)}',
    );
    print('  RGB: R=$grayR, G=$grayG, B=$grayB');
    print('  Expected: R=128, G=128, B=128');
    print(
      '  Diff:     ΔR=${(grayR - 128).abs()}, '
      'ΔG=${(grayG - 128).abs()}, ΔB=${(grayB - 128).abs()}',
    );
    print('');
  });
}
