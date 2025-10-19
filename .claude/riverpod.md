# Riverpod State Management

## Provider Chain Pattern (Complex Reactive State)

When state depends on multiple inputs and triggers expensive calculations:

```
Input Providers (state holders)
    ↓
Calculation Provider (watches inputs, runs algorithm)
    ↓
Filter/Sort Providers (optional enrichment)
    ↓
UI consumes final provider
```

### Example: Color Mixing

```dart
@riverpod
class TargetColor extends _$TargetColor {
  @override
  LabColor? build() => null;

  void setTargetColor(LabColor color) => state = color;
}

@riverpod
Future<List<MixingResult>> mixingResults(Ref ref) async {
  final targetColor = ref.watch(targetColorProvider);      // Watch inputs
  final numberOfPaints = ref.watch(numberOfPaintsProvider);
  final maxDeltaE = ref.watch(maxDeltaEThresholdProvider);

  if (targetColor == null) return [];

  // Runs automatically when ANY input changes
  return await calculator.findBestMixes(
    targetColor: targetColor,
    numberOfPaints: numberOfPaints,
    maxDeltaE: maxDeltaE,
  );
}
```

**Key principle:** Watch inputs, don't mutate across async gaps.

**Benefits:**
- Automatic recalculation when any dependency changes
- Single responsibility per provider
- Testable in isolation
- Clean UI layer

**See:** `color_mixing_provider.dart` (lines 158-213)

---

## Conventions

- ✅ Use `@riverpod` annotation for code generation
- ✅ `AsyncNotifier` for async state, `Notifier` for sync
- ✅ Keep in separate file: `[feature]_provider.dart`
- ✅ One provider per logical state concept
- ❌ Never expose mutable state directly (use methods)
- ❌ Don't read providers during async operations (watch instead)

---

## ConsumerWidget vs Consumer

Use `ConsumerWidget` for multi-provider complexity:

```dart
// ✅ GOOD
class MixingResultCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paints = ref.watch(paintInventoryProvider);
    final settings = ref.watch(userSettingsProvider);
    return Card(/*...*/);
  }
}

// ❌ AVOID: Nested Consumer builders
return Consumer(
  builder: (context, ref, _) => Consumer(
    builder: (context, ref, _) => Card(/*...*/),
  ),
);
```

**See:** `mixing_result_card.dart` (line 18)
