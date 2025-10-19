# Testing Strategy

## Coverage Target: 75%

Focus on **real-world scenarios and edge cases** rather than raw coverage metrics.

## Test Organization

```
test/
├── features/
│   ├── color_calculation/
│   │   ├── domain/
│   │   │   ├── lab_color_test.dart
│   │   │   ├── delta_e_test.dart
│   │   │   ├── color_converter_test.dart
│   │   │   └── mixing_algorithm_test.dart
│   │   └── presentation/
│   │       └── color_picker_widget_test.dart
│   ├── paint_library/
│   │   ├── data/
│   │   │   └── paint_repository_test.dart
│   │   └── presentation/
│   │       └── paint_list_test.dart
│   └── mixing_history/
│       └── mixing_result_repository_test.dart
└── shared/
    └── utils/
        └── color_utils_test.dart
```

**File Naming:** `source_file_test.dart` (matching the source file)

## Unit Tests (Domain Logic)

### Color Conversion Testing

File: `test/features/color_calculation/domain/color_converter_test.dart`

**Priority:** CRITICAL - Color science must be accurate

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';

void main() {
  group('ColorConverter', () {
    late ColorConverter converter;

    setUp(() {
      converter = ColorConverter();
    });

    group('LAB to RGB conversion', () {
      test('converts neutral LAB (50, 0, 0) to middle gray', () {
        final labColor = LabColor(l: 50, a: 0, b: 0);
        final rgbColor = converter.labToRgb(labColor);

        // Should be close to 50% gray (127-128)
        expect(rgbColor.red, inInclusiveRange(110, 145));
        expect(rgbColor.green, inInclusiveRange(110, 145));
        expect(rgbColor.blue, inInclusiveRange(110, 145));
      });

      test('converts pure white LAB (100, 0, 0) to RGB white', () {
        final labColor = LabColor(l: 100, a: 0, b: 0);
        final rgbColor = converter.labToRgb(labColor);

        expect(rgbColor, Color.fromARGB(255, 255, 255, 255));
      });

      test('converts pure black LAB (0, 0, 0) to RGB black', () {
        final labColor = LabColor(l: 0, a: 0, b: 0);
        final rgbColor = converter.labToRgb(labColor);

        expect(rgbColor, Color.fromARGB(255, 0, 0, 0));
      });

      test('red hue (positive a axis) produces reddish color', () {
        final labColor = LabColor(l: 50, a: 50, b: 0);
        final rgbColor = converter.labToRgb(labColor);

        // Red channel should be dominant
        expect(rgbColor.red, greaterThan(rgbColor.green));
        expect(rgbColor.red, greaterThan(rgbColor.blue));
      });

      test('blue hue (positive b axis) produces bluish color', () {
        final labColor = LabColor(l: 50, a: 0, b: 50);
        final rgbColor = converter.labToRgb(labColor);

        // Blue channel should be dominant
        expect(rgbColor.blue, greaterThan(rgbColor.red));
      });
    });

    group('RGB to LAB conversion', () {
      test('converts RGB white to LAB white (100, 0, 0)', () {
        final rgbColor = const Color.fromARGB(255, 255, 255, 255);
        final labColor = converter.rgbToLab(rgbColor);

        expect(labColor.l, inInclusiveRange(99, 100));
        expect(labColor.a, inInclusiveRange(-5, 5));
        expect(labColor.b, inInclusiveRange(-5, 5));
      });

      test('round-trip conversion preserves color', () {
        final originalRgb = const Color.fromARGB(255, 200, 100, 50);
        final lab = converter.rgbToLab(originalRgb);
        final convertedRgb = converter.labToRgb(lab);

        // Allow small tolerance for rounding
        expect(convertedRgb.red, inInclusiveRange(originalRgb.red - 5, originalRgb.red + 5));
        expect(convertedRgb.green, inInclusiveRange(originalRgb.green - 5, originalRgb.green + 5));
        expect(convertedRgb.blue, inInclusiveRange(originalRgb.blue - 5, originalRgb.blue + 5));
      });
    });
  });
}
```

### Delta E Testing

File: `test/features/color_calculation/domain/delta_e_test.dart`

**Focus:** Verify Delta E calculations match color science standards

```dart
void main() {
  group('Delta E 2000', () {
    test('identical colors have deltaE of 0', () {
      final color1 = LabColor(l: 50, a: 20, b: 30);
      final color2 = LabColor(l: 50, a: 20, b: 30);

      final deltaE = calculateDeltaE2000(color1, color2);
      expect(deltaE, lessThan(0.01)); // Allow floating point rounding
    });

    test('significantly different colors have deltaE > 5', () {
      final color1 = LabColor(l: 100, a: 0, b: 0);    // White
      final color2 = LabColor(l: 0, a: 0, b: 0);      // Black

      final deltaE = calculateDeltaE2000(color1, color2);
      expect(deltaE, greaterThan(50)); // Large difference
    });

    test('slightly different colors have deltaE < 2', () {
      final color1 = LabColor(l: 50, a: 20, b: 30);
      final color2 = LabColor(l: 51, a: 21, b: 31);

      final deltaE = calculateDeltaE2000(color1, color2);
      expect(deltaE, lessThan(2)); // Perceptually similar
    });
  });
}
```

### Mixing Algorithm Testing

File: `test/features/color_calculation/domain/mixing_algorithm_test.dart`

**Focus:** Real paint mixing scenarios

```dart
void main() {
  group('Paint Mixing Algorithm', () {
    late ColorMixer mixer;
    late List<PaintColor> inventory;

    setUp(() {
      mixer = ColorMixer();
      // Test inventory: primary colors
      inventory = [
        PaintColor(
          id: '1',
          name: 'Red',
          brand: PaintBrand.vallejo,
          labColor: LabColor(l: 40, a: 60, b: 40),
        ),
        PaintColor(
          id: '2',
          name: 'Yellow',
          brand: PaintBrand.vallejo,
          labColor: LabColor(l: 80, a: -5, b: 80),
        ),
        PaintColor(
          id: '3',
          name: 'Blue',
          brand: PaintBrand.vallejo,
          labColor: LabColor(l: 40, a: -10, b: -50),
        ),
      ];
    });

    test('finds exact match in inventory', () {
      // Target is exact red from inventory
      final target = LabColor(l: 40, a: 60, b: 40);
      final result = mixer.findBestMix(target, inventory, maxPaints: 1);

      expect(result.ratios, isNotEmpty);
      expect(result.deltaE, lessThan(1)); // Exact or near-exact match
    });

    test('finds two-paint mix for target color', () {
      // Target is orange (between red and yellow)
      final target = LabColor(l: 60, a: 30, b: 60);
      final result = mixer.findBestMix(target, inventory, maxPaints: 2);

      expect(result.ratios.length, lessThanOrEqualTo(2));
      expect(result.deltaE, lessThan(5)); // Good match
    });

    test('respects paint limit constraint', () {
      final target = LabColor(l: 50, a: 20, b: 20);
      final result = mixer.findBestMix(target, inventory, maxPaints: 2);

      expect(result.ratios.length, lessThanOrEqualTo(2));
    });

    test('returns empty result for impossible color', () {
      // Target far outside gamut of available paints
      final target = LabColor(l: 150, a: 200, b: 200); // Invalid LAB values
      final result = mixer.findBestMix(target, inventory, maxPaints: 2);

      expect(result.ratios, isEmpty);
      expect(result.deltaE, greaterThan(50)); // Very poor match
    });
  });
}
```

## Widget Tests

### Color Picker Testing

File: `test/features/color_calculation/presentation/color_picker_widget_test.dart`

```dart
void main() {
  group('ColorPickerWidget', () {
    testWidgets('displays color preview', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              initialColor: const Color.fromARGB(255, 255, 0, 0),
              onColorChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(ColorPickerWidget), findsOneWidget);
      // Color preview should be visible
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('triggers callback on color change', (WidgetTester tester) async {
      Color? changedColor;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ColorPickerWidget(
              initialColor: const Color.fromARGB(255, 255, 0, 0),
              onColorChanged: (color) {
                changedColor = color;
              },
            ),
          ),
        ),
      );

      // Simulate color change (implementation varies by picker)
      // After change, callback should be called
      expect(changedColor, isNotNull);
    });
  });
}
```

## Running Tests

```bash
# All tests
flutter test

# Specific folder
flutter test test/features/color_calculation/

# With coverage
flutter test --coverage

# Watch mode (re-run on file changes)
flutter test --watch
```

## Test Data Reference

Use standard color references:

```dart
// Standard Munsell colors for validation
const munsellPureRed = LabColor(l: 53.24, a: 80.09, b: 67.20);
const munsellPureGreen = LabColor(l: 51.97, a: -58.48, b: 58.48);
const munsellPureBlue = LabColor(l: 32.30, a: 79.19, b: -107.86);

// Vallejo primary paint approximations
const vallejoRed = LabColor(l: 40, a: 60, b: 40);
const vallejoYellow = LabColor(l: 80, a: -5, b: 80);
const vallejoBlue = LabColor(l: 40, a: -10, b: -50);
```

## Critical Test Areas

1. **Color Conversions** - Accuracy determines entire app value
2. **Delta E Calculations** - Used for quality scoring
3. **Mixing Algorithm** - Core business logic
4. **Paint Inventory CRUD** - Data integrity
5. **Widget Display** - User experience

## Best Practices

- ✅ Test real scenarios first
- ✅ Use known reference values
- ✅ Test edge cases and constraints
- ✅ Mock external dependencies
- ✅ Keep tests focused (one assertion per test when possible)
- ❌ Don't test framework code
- ❌ Don't skip because coverage is "hard"

## References

- **Color Science:** [color-science.md](color-science.md)
- **Build Commands:** [build-commands.md](build-commands.md)
