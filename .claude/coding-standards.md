# Coding Standards

## Dart/Flutter Conventions

- **Files:** `snake_case.dart` (REQUIRED)
- **Classes:** `UpperCamelCase`
- **Variables/Methods:** `lowerCamelCase`
- **Constants:** `lowerCamelCase` with `const`
- **Prefer `const` constructors** for performance
- **Use `final`** for all immutable properties
- **Follow `very_good_analysis` lints strictly** - zero tolerance for errors

## Domain-Specific Names (Avoid Framework Conflicts)

- `PaintColor` (not just `Color`)
- `PaintBrand` (manufacturer enum)
- `MixingRatio` (paint ratios for target)
- `MixingResult` (calculation output)
- `LabColor` (color space model)
- `ColorMatchQuality` (quality assessment)

## Widget Guidelines

- **Keep focused** (build method < 300 lines)
- **Use `const` constructors**
- **Always include `key` parameter**
- **Extract reusable components** to `shared/widgets/`
- **Use responsive design** (no hardcoded sizes)
- **Document with dartdoc** (complex widgets)

See [riverpod.md](riverpod.md) for ConsumerWidget pattern.

### Facade Pattern for Component Unification

When the same functionality appears on multiple screens with inconsistent UX, use the **Facade Pattern** to unify:

**Problem:**
```dart
// ❌ Inconsistent color pickers across screens
ColorMixerScreen → Custom HSV sliders
AddPaintScreen → flutter_colorpicker dialog
EditPaintScreen → Different picker again
```

**Solution: Create a facade component**
```dart
// ✅ GOOD: ColorPickerInput facade wraps HueRingPicker
// - Consistent UX everywhere
// - Single maintenance point
// - Easy to swap implementations

ColorPickerInput(
  initialHex: '#FF5733',
  onColorChanged: (labColor, isValidGamut) { ... },
)
```

**Benefits:**
- Users see the same intuitive interface everywhere
- Bugs fixed once, fixed everywhere
- Future picker improvements automatically apply to all screens
- Easier to test in isolation

**Pattern in codebase:**
- `lib/shared/widgets/color_picker_input.dart` - Unifies all color picking
- Used in: ColorMixerScreen, PaintForm (AddPaint, EditPaint)

## State Management (Riverpod 3.0)

- ✅ Use `@riverpod` annotation (code generation)
- ✅ `AsyncNotifier` for async, `Notifier` for sync
- ✅ Separate files: `[feature]_provider.dart`
- ✅ One provider per logical state concept
- ✅ Never expose mutable state directly
- ✅ Use `Family` for parameterized providers

**Never:** Read providers in async functions (watch instead).

See [riverpod.md](riverpod.md) for provider chain pattern.

## Logging

- Use `logging` package (not print/debugPrint)
- `final _log = Logger('FeatureName');`
- Levels: SEVERE (errors), WARNING (issues), INFO (events), FINE (debug)
- Format: `_log.info('Context: $variable');`

## Styling

- **All styling** in theme configuration (no hardcoded colors)
- Use `shadcn_ui` components
- Support light/dark themes
- Color constants in `lib/core/theme/app_colors.dart`
- Typography in `lib/core/theme/app_text_styles.dart`

## Exception Handling

- ✅ Use typed exceptions: `on Exception catch (e) { }`
- ❌ Avoid bare catch clauses

See [common-issues.md](common-issues.md) for examples.

## Code Quality Before Committing

```bash
flutter analyze           # 0 errors
dart format .
dart fix --apply
```
