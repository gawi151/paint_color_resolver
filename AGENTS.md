# AGENTS.md

Guidelines for agentic coding agents working in this Flutter/Riverpod paint color mixing app.

---

## Build, Lint & Test Commands

### Running Tests
```bash
flutter test                          # Run all tests
flutter test test/path/file_test.dart # Run a SINGLE test
flutter test --coverage              # With coverage report
```

### Code Quality
```bash
flutter analyze                      # Check lints and errors (zero tolerance)
dart format .                        # Format all files
dart fix --apply                     # Auto-fix issues
```

### Build & Run
```bash
dart run build_runner build --delete-conflicting-outputs  # Generate code
flutter run -d windows              # Windows
flutter run -d chrome               # Web
```

### Clean Rebuild (when stuck)
```bash
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs
```

---

## Code Style Guidelines

### Naming Conventions
- **Files:** `snake_case.dart`
- **Classes:** `UpperCamelCase`
- **Variables/Methods:** `lowerCamelCase`
- **Constants:** `lowerCamelCase` with `const`

### Import Rules
```dart
// 1. Dart/Flutter SDK imports
import 'dart:math';
import 'package:flutter/material.dart';

// 2. Third-party packages
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

// 3. Project imports (use package: prefix)
import 'package:paint_color_resolver/core/router/app_router.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
```

### Type Safety
- **Always use `final`** for immutable properties
- **Use `const` constructors** everywhere possible
- **Explicit types** on all public APIs
- **Follow `very_good_analysis` lints strictly**

### State Management (Riverpod 3.0)
```dart
// ✅ Use @riverpod annotation with code generation
@riverpod
class PaintInventory extends _$PaintInventory {
  @override
  Future<List<PaintColor>> build() async { ... }
}

// ✅ Use AsyncNotifier for async operations
// ✅ Never expose mutable state directly
```

### Error Handling
```dart
// ✅ Always use typed exceptions
on Exception catch (e) {
  _log.severe('Failed to delete paint', e);
  throw StateError('Database error: $e');
}

// ❌ Never use bare catch clauses
catch (e) { ... }  // FORBIDDEN
```

### Widget Patterns
```dart
// ✅ ConsumerWidget for simple cases
class PaintList extends ConsumerWidget {
  const PaintList({super.key});  // Always include key
  
  @override
  Widget build(BuildContext context, WidgetRef ref) { ... }
}

// ✅ ConsumerStatefulWidget for complex state
class PaintLibraryScreen extends ConsumerStatefulWidget {
  const PaintLibraryScreen({super.key});
  @override
  ConsumerState createState() => _PaintLibraryScreenState();
}

// ✅ Build methods < 300 lines
// ✅ Use const constructors for all children
```

### Color Science Safety (CRITICAL)
```dart
// ✅ LAB for calculations, RGB for display only
final labColor = LabColor(l: 50, a: 20, b: -10);  // Calculation
final rgbColor = converter.labToRgb(labColor);    // Display only

// ❌ NEVER map LAB components to RGB directly
// L is NOT Red, a is NOT Green, b is NOT Blue
```

### Facade Pattern (Component Unification)
When the same UI appears on multiple screens, create a facade:
```dart
// ✅ GOOD: ColorPickerInput wraps HueRingPicker
ColorPickerInput(
  initialHex: '#FF5733',
  onColorChanged: (labColor, isValidGamut) { ... },
)
// Used consistently across ColorMixerScreen, PaintForm, etc.
```

### Logging
```dart
final _log = Logger('FeatureName');  // Use logging package, not print
_log.info('Processing paint: $paintName');
_log.severe('Database error', error);
```

### Styling
- **All colors from theme** - NEVER hardcode
- **Use shadcn_ui components** - No Material widgets directly
- **Responsive design** - No hardcoded pixel sizes
- **Zero print/debugPrint** - Use Logger instead

---

## Pre-Commit Checklist

Before every commit:
1. `flutter analyze` - must have 0 errors
2. `dart format .`
3. `dart fix --apply`
4. `flutter test` - all tests passing
5. Code generation up-to-date: `dart run build_runner build --delete-conflicting-outputs`

---

## Domain-Specific Terms

- `PaintColor` (not just `Color`) - avoids conflict with Flutter Color
- `PaintBrand` - manufacturer enum
- `MixingRatio` - paint ratios for target
- `MixingResult` - calculation output
- `LabColor` - CIELAB color space model
- `DeltaE` - color difference metric

---

## Tech Stack

- **Flutter 3.41.0**, Dart ^3.10.0
- **Riverpod 3.0** (code generation with @riverpod)
- **Drift** (SQLite ORM, type-safe)
- **auto_route** (type-safe navigation)
- **dart_mappable** (serialization, NOT freezed)
- **shadcn_ui** (design system)
- **very_good_analysis** (lint rules)

---

## References

- Detailed docs in `.claude/` directory
- Test examples in `test/` - follow existing patterns
- Architecture: feature-first organization
- Priority: Color calculation accuracy is the app's core value
