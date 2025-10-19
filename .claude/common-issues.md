# Common Issues & Solutions

## Color Conversion Bugs

### Issue: Wrong Colors Displayed

**Symptom:** Colors look completely wrong, inverted, or washed out.

**Cause:** Naive LAB → RGB mapping
```dart
// ❌ WRONG
Color.fromARGB(255, labColor.l * 2.55, labColor.a + 128, labColor.b + 128)
```

**Solution:** See [Color Science](color-science.md) - Use `ColorConverter.labToRgb()`

---

## Hex Color Issues

### Issue: Color Alpha Channel Lost

**Symptom:** Opaque colors treated as transparent or vice versa.

**Cause:** Stripping alpha with `substring(2)`
```dart
// ❌ WRONG
'#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}'
```

**Solution:** Keep all 8 hex digits
```dart
// ✅ CORRECT
'#${color.value.toRadixString(16).padLeft(8, '0')}'
```

---

## Exception Handling

### Issue: Hard to Debug, Exceptions Silently Fail

**Cause:** Bare catch clauses
```dart
// ❌ WRONG
try {
  final result = converter.labToRgb(labColor);
} catch (e) {
  // Catches everything - hides programming errors
}
```

**Solution:** Type exceptions
```dart
// ✅ CORRECT
try {
  final result = converter.labToRgb(labColor);
} on Exception {
  // Only catches actual exceptions
  return Colors.grey.shade300;  // Graceful fallback
}
```

**Benefits:**
- Prevents hiding programming errors
- Provides explicit fallback behavior
- Clearer intent in code

---

## Data Enrichment Pitfalls

### Issue: Paint Names Show as "Paint ID: 42"

**Cause:** Storing only IDs in domain model, not looking up display data.

**Solution:** Lookup at display time
```dart
// Watch paint inventory
final inventory = ref.watch(paintInventoryProvider);
final paintMap = {for (final p in inventory) p.id: p};

// Display with name and brand
final paint = paintMap[ratio.paintId];
Text('${paint?.name} (${paint?.brand.name})')
```

**See:** `mixing_result_card.dart` (_buildPaintRatios method)

---

## Build Issues

### After pubspec.yaml changes
```bash
flutter pub get
```

### After adding drift tables
```bash
dart run build_runner build --delete-conflicting-outputs
```

### After adding routes
```bash
dart run build_runner build --delete-conflicting-outputs
# Note: Hot restart required for route changes
```

### If stuck
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

---

## Widget Lifecycle & Build Phase Errors

### Issue: `setState() or markNeedsBuild() called during build`

**Symptom:** Red error screen when widget initializes or state changes, mentions "build phase".

**Causes:**
1. Calling `setState()` inside `build()` method
2. Calling `setState()` inside `initState()`
3. Calling `setState()` from callbacks triggered during widget construction
4. Modifying providers during widget build

**Solution:** Defer state changes to after the build phase completes.

#### Pattern 1: Initial State Setup (initState)
```dart
// ❌ WRONG - setState during build phase
@override
void initState() {
  super.initState();
  _selectedColor = Colors.red;
  setState(() => _isValidGamut = true);  // ERROR!
}

// ✅ CORRECT - Defer to post-frame
@override
void initState() {
  super.initState();
  _selectedColor = Colors.red;
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (mounted) {
      setState(() => _isValidGamut = true);
    }
  });
}
```

#### Pattern 2: Callbacks & Event Handlers
```dart
// ❌ WRONG - setState in callback during build
onColorChanged: (Color color) {
  setState(() => _selectedColor = color);  // ERROR if called during build!
}

// ✅ CORRECT - Use microtask to defer
onColorChanged: (Color color) {
  Future.microtask(() {
    if (!mounted) return;
    setState(() => _selectedColor = color);
  });
}
```

#### Pattern 3: Provider Modifications (Riverpod)
```dart
// ❌ WRONG - Modify provider during build
onColorChanged: (LabColor color) {
  ref.read(targetColorProvider.notifier).setTargetColor(color);  // ERROR!
}

// ✅ CORRECT - Defer with microtask
onColorChanged: (LabColor color) {
  Future.microtask(() {
    ref.read(targetColorProvider.notifier).setTargetColor(color);
  });
}
```

**Key Methods:**
- `WidgetsBinding.instance.addPostFrameCallback()` - Run after first frame renders
- `Future.microtask()` - Run in next microtask cycle (safe from callbacks)
- Always check `if (!mounted)` before setState

**See:** `lib/shared/widgets/color_picker_input.dart` for real-world example

---

## Code Quality Checklist

Before committing:
```bash
flutter analyze           # Should show 0 errors
dart format .            # Format code
dart fix --apply         # Auto-fix issues
flutter test             # Run tests
```

**Target:** 0 compilation errors, <10 lint warnings (non-critical only)
