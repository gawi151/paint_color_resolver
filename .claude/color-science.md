# Color Science & Conversions

## ⚠️ CRITICAL: Color Space Safety

**LAB and RGB are completely different color spaces. Never map components directly.**

### What Components Mean

| Component | LAB Meaning | RGB Mistake |
|-----------|-------------|------------|
| L (0-100) | Lightness | ≠ Red intensity |
| a (-128 to 127) | Green-Red axis | ≠ Green channel |
| b (-128 to 127) | Yellow-Blue axis | ≠ Blue channel |

### ❌ WRONG: Naive Component Mapping

```dart
// Produces completely wrong colors!
Color.fromARGB(
  255,
  (labColor.l * 2.55).toInt(),      // L is NOT Red!
  (labColor.a + 128).toInt(),       // a is NOT Green!
  (labColor.b + 128).toInt(),       // b is NOT Blue!
)
```

### ✅ CORRECT: Use ColorConverter

```dart
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';

final converter = ColorConverter();
final rgbColor = converter.labToRgb(labColor);  // Proper color science
```

**Always use converter classes. Never approximate the math.**

---

## Color Space: LAB

**Why LAB over RGB:**
- Perceptually uniform - distances match human color perception
- RGB doesn't accurately model paint mixing
- Industry standard for color matching
- Better for Delta E calculations

**Ranges:**
- L: 0-100 (lightness)
- a: -128 to 127 (green/red)
- b: -128 to 127 (yellow/blue)

---

## Hex Color Alpha Channel

When converting `Color.value` to hex, include all 8 digits (ARGB format):

```dart
// ❌ WRONG: Strips alpha channel
final hex = '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}'

// ✅ CORRECT: Keeps full ARGB
final hex = '#${color.value.toRadixString(16).padLeft(8, '0')}'
```

---

## References

- **Conversion**: `color_converter.dart`
- **Usage**: `mixing_result_card.dart` (_getPaintDisplayColor method)
- **LAB Info**: `painting.md` (domain documentation)
