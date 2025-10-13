# Flutter Project: Paint Color Resolver

## Project Overview

**Paint Color Resolver** is a desktop and web application designed to help miniature and figurine painters achieve their desired colors by calculating optimal paint mixing ratios based on their available paint inventory.

**Target Platforms:** Windows, Web
**Target Users:** Miniature painters, hobbyists, tabletop gaming enthusiasts
**Primary Paint Brand:** Vallejo (initially, expandable to other brands)

**Core Value Proposition:** Given a target color and a user's available paint collection, calculate the precise ratios needed to mix paints and achieve the desired color.

## Development Priority

**PRIMARY FOCUS:** Core color calculation engine - this is the most critical component. All other features (UI, paint library management, history) depend on accurate color mixing calculations.

## Architecture

- **Pattern**: Feature-First with simplified internal structure
- **State Management**: Riverpod 3.0 with code generation
- **Navigation**: auto_route (type-safe routing)
- **Local Storage**: drift (SQLite with type-safe queries)
- **Design System**: shadcn_ui with custom theming
- **Code Generation**: dart_mappable for models (not freezed)

## Flutter/Dart Environment

- **Flutter SDK**: 3.35.6 (stable)
- **Dart SDK**: Bundled with Flutter
- **FVM**: Not used

## Project Structure

```
lib/
├── core/
│   ├── theme/              # shadcn_ui theme configuration, colors, text styles
│   ├── constants/          # App-wide constants, color space constants
│   ├── config/             # App configuration, environment settings
│   ├── router/             # auto_route configuration
│   └── database/           # drift database setup and DAOs
├── features/               # Feature modules
│   ├── color_calculation/  # PRIORITY: Core mixing algorithm
│   │   ├── data/           # Local paint data, calculation results
│   │   ├── domain/         # Color mixing logic, LAB color space operations
│   │   └── presentation/   # UI for color picker and results
│   ├── paint_library/      # Paint collection management
│   │   ├── data/           # Paint models, drift tables
│   │   ├── domain/         # Paint CRUD operations
│   │   └── presentation/   # Paint list, add/edit UI
│   ├── mixing_history/     # Past calculation results
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── settings/           # App preferences, theme switching
│       ├── data/
│       ├── domain/
│       └── presentation/
├── shared/
│   ├── widgets/            # Reusable UI components
│   ├── utils/              # Helper functions, extensions
│   └── models/             # Shared data models
└── main.dart
```

## Critical Coding Standards

### Dart/Flutter Conventions

- **File Naming**: Always use `snake_case` for all Dart files (required)
- **Class Naming**: Use `UpperCamelCase` for classes
- **Variables/Methods**: Use `lowerCamelCase`
- **Constants**: Use `lowerCamelCase` with `const` keyword
- **Always prefer `const` constructors** where possible for performance
- **Use `final`** for all immutable properties
- **Follow very_good_analysis lints strictly** - zero tolerance for warnings

### Domain-Specific Naming Patterns

Use descriptive suffixes to avoid conflicts with Dart/Flutter classes:

- `PaintColor` - Individual paint color data (not just `Color`)
- `PaintBrand` - Paint manufacturer (Vallejo, Citadel, etc.)
- `MixingRatio` - Calculated paint ratios for target color
- `ColorMatch` - Quality/accuracy of color match result
- `PaintInventory` - User's available paint collection
- `ColorSpace` - LAB, RGB color space representations
- `MixingResult` - Complete calculation output with ratios and match quality

### Widget Guidelines

- **Keep widgets focused and small** (under 300 lines per build method)
- Extract reusable components to `shared/widgets/`
- Use responsive design - avoid hardcoded pixel sizes
- **Always include `key` parameter** in custom widgets
- Use `const` constructors to prevent unnecessary rebuilds
- Document complex widgets with dartdoc comments

### State Management (Riverpod 3.0)

- Use `@riverpod` annotation for all providers (code generation)
- Implement `AsyncNotifier` for async state operations
- Use `Notifier` for synchronous state
- Keep providers in separate files: `[feature]_provider.dart`
- Use `dart_mappable` for immutable state classes (not freezed)
- **Never expose mutable state directly** - use methods for state mutations
- Use `Family` modifier for parameterized providers
- Keep providers focused - one provider per logical state concept

Example Riverpod 3.0 pattern:
```dart
// example of modifiable (Notifier) provider with Async state
@riverpod
class PaintInventory extends _$PaintInventory {
  @override
  Future<List<PaintColor>> build() async {
    return await ref.read(paintDatabaseProvider).getAllPaints();
  }
  
  Future<void> addPaint(PaintColor paint) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(paintDatabaseProvider).insertPaint(paint);
      return ref.read(paintDatabaseProvider).getAllPaints();
    });
  }
}
```

```dart
// example of unmodifiable (functional) future provider which caches value - results in userProvider
@riverpod
Future<User> user(Ref ref) async {
  final response = await http.get('https://api.example.com/user/123');
  return User.fromJson(response.body);
}

```dart
// example of unmodifiable (functional) provider for String (can provide any object) - gives us helloWorldProvider
@riverpod
String helloWorld(Ref ref) {
  return 'Hello world';
}
```

```dart
// example of consuming provider
class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        // Obtain the value of the provider
        final helloWorld = ref.watch(helloWorldProvider);

        // Use the value in the UI
        return Text(helloWorld);
      },
    );
  }
}
``` 

### Logging and Debugging

- **Use `logging` package from Dart team** (not print or debugPrint)
- Configure loggers per feature: `final _log = Logger('ColorCalculation');`
- Log levels: SEVERE for errors, WARNING for issues, INFO for key events, FINE for debug
- Format: `_log.info('Calculating color match for target: $targetColor');`
- **Never commit debug logs** in production code

### Theme and Styling

- **All styling lives in theme configuration** - zero hardcoded colors in widgets
- Use shadcn_ui design system components
- Support both light and dark themes with theme switching
- Define color constants in `lib/core/theme/app_colors.dart`
- Use theme extensions for custom properties
- Typography defined in `lib/core/theme/app_text_styles.dart`
- **Color-related constants** (LAB color space bounds, etc.) in `lib/core/constants/color_constants.dart`

### Data Persistence (drift)

- Define tables in `lib/core/database/tables/`
- Use DAOs for data access: `lib/core/database/daos/`
- All queries must be type-safe through drift code generation
- Use transactions for multi-table operations
- **Never use raw SQL strings** - use drift's Dart API
- Schema migrations in `lib/core/database/migrations/`

Example drift table:
```dart
class PaintColors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get brand => text()();
  IntColumn get labL => integer()(); // LAB L* value (0-100)
  IntColumn get labA => integer()(); // LAB a* value (-128 to 127)
  IntColumn get labB => integer()(); // LAB b* value (-128 to 127)
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}
```

### Code Generation (dart_mappable)

- Use `@MappableClass()` annotation for all models
- Models are immutable with `final` fields
- Run code generation: `dart run build_runner build --delete-conflicting-outputs`
- Generated files: `*.mapper.dart` (not .freezed.dart or .g.dart)
- **Never manually edit generated files**

Example model:
```dart
import 'package:dart_mappable/dart_mappable.dart';

part 'paint_color.mapper.dart';

@MappableClass()
class PaintColor with PaintColorMappable {
  final String id;
  final String name;
  final PaintBrand brand;
  final LabColor labColor; // LAB color space representation
  final DateTime addedAt;

  const PaintColor({
    required this.id,
    required this.name,
    required this.brand,
    required this.labColor,
    required this.addedAt,
  });
  
  // fromJson, toJson, copyWith, ==, hashCode auto-generated
}
```

### File Naming Conventions

- **Dart files**: `snake_case.dart` (REQUIRED)
- Test files: `snake_case_test.dart` (matching source file)
- Generated files: `*.mapper.dart`, `*.g.dart`, `*.gr.dart` (never edit manually)
- Route files: `*.gr.dart` (auto_route generated)

## Color Science & Calculation Engine

### Color Space: LAB

**Why LAB over RGB:**
- LAB is perceptually uniform - distances match human color perception
- RGB mixing does not accurately represent physical paint mixing
- LAB is industry standard for color matching and paint formulation
- Better for calculating color differences (Delta E)

### Core Color Packages

**Primary:**
- `flutter_color` - Comprehensive color space conversions (RGB, LAB, LCH, etc.)
- `flutter_colorpicker` - UI for color selection

**Usage:**
```dart
import 'package:flutter_color/flutter_color.dart';

// Convert RGB to LAB
final rgbColor = Color(0xFFFF5733);
final labColor = LabColor.fromRgb(rgbColor.red, rgbColor.green, rgbColor.blue);

// Calculate color difference (Delta E)
final deltaE = labColor.deltaE(targetLabColor);
```

### Color Mixing Algorithm Recommendations

**Initial Implementation (MVP):**
1. **Brute Force Search** - Try all combinations of available paints
   - For 2-3 paint mixes: O(n²) or O(n³) is acceptable
   - Calculate LAB average weighted by ratios
   - Use Delta E (ΔE2000) to measure color difference
   - Find combination with minimum Delta E

2. **Constraints:**
   - Limit to 2-3 paints per mix (keep it practical for users)
   - Ratio increments: 10% steps (0%, 10%, 20%, ..., 100%)
   - Maximum Delta E threshold: < 5 (considered "good match")

**Future Enhancements:**
- **Genetic Algorithm** for larger paint collections (4+ paints)
- **K-nearest neighbors** to pre-filter candidate paints
- **Subtractive Color Mixing Model** (more accurate than additive LAB averaging)
- **FFI Integration** with professional color libraries (Little CMS, ColorAide)

### Color Calculation Priority Tasks

1. Implement LAB color space utilities
2. Create Delta E 2000 calculation function
3. Build basic 2-paint mixing algorithm
4. Extend to 3-paint combinations
5. Add ratio optimization
6. Performance testing with 50+ paint inventory

## Essential Build Commands

```bash
# Run app
flutter run -d windows
flutter run -d chrome

# Code generation (drift + dart_mappable + auto_route)
dart run build_runner build --delete-conflicting-outputs
dart run build_runner watch  # Continuous generation during development

# Testing
flutter test
flutter test --coverage
flutter test test/features/color_calculation/

# Code quality
flutter analyze
dart format .
dart fix --apply

# Database
# drift generates SQL from Dart - no separate migration commands needed
# Schema updates trigger automatic migrations
```

## Dependencies Management

**Core Dependencies (already decided):**
```yaml
dependencies:
  flutter_riverpod: ^3.0.3  # State management
  riverpod_annotation: ^3.0.3
  auto_route: ^10.1.2  # Navigation
  drift: ^2.28.2  # Local database
  sqlite3_flutter_libs: ^0.5.40  # SQLite for drift
  path_provider: ^2.1.5
  dart_mappable: ^4.6.1  # Models
  flutter_color: ^2.1.0  # Color science
  flutter_colorpicker: ^1.1.0  # Color picker UI
  shadcn_ui: ^0.37.4  # Design system
  logging: ^1.3.0  # Logging

dev_dependencies:
  build_runner: ^2.7.1
  riverpod_generator: ^3.0.3
  riverpod_lint: ^3.0.3
  auto_route_generator: ^10.2.4
  drift_dev: ^2.28.3
  dart_mappable_builder: ^4.6.0
  very_good_analysis: ^10.0.0
  test: ^1.26.2
```

**Before adding new packages:**
- Check pub.dev score (prefer >130)
- Verify Flutter 3.35+ compatibility
- Check maintenance status (recent updates)
- Document why the package was chosen in CLAUDE.md

## Platform-Specific Requirements

**Windows:**
- Target Windows 10+ (x64)
- No special configuration required for core features
- Test on actual Windows machines

**Web:**
- Target modern browsers (Chrome, Firefox, Safari, Edge)
- Test color rendering across browsers (color profiles can differ)
- Consider web-specific limitations for file I/O (if needed later)

## Testing Strategy

**Coverage Target:** 75%

**Focus Areas:**
- **Unit Tests:** All color calculation logic, LAB conversions, Delta E calculations
- **Widget Tests:** Color picker widgets, paint list UI, mixing results display
- **Integration Tests:** Not yet (defer to later phases)

**Critical Tests:**
- Color space conversions (RGB ↔ LAB) with known reference values
- Delta E calculations against reference implementations
- Mixing ratio calculations with edge cases
- Paint inventory CRUD operations

**Test File Organization:**
```
test/
├── features/
│   ├── color_calculation/
│   │   ├── domain/
│   │   │   ├── lab_color_test.dart
│   │   │   ├── delta_e_test.dart
│   │   │   └── mixing_algorithm_test.dart
│   │   └── presentation/
│   │       └── color_picker_widget_test.dart
│   └── paint_library/
│       ├── data/
│       │   └── paint_repository_test.dart
│       └── presentation/
│           └── paint_list_test.dart
└── shared/
    └── utils/
        └── color_utils_test.dart
```

## Common Issues and Solutions

**After pubspec.yaml changes:**
```bash
flutter pub get
```

**After adding drift tables:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**After adding routes:**
```bash
dart run build_runner build --delete-conflicting-outputs
# Note: Hot restart required for route changes to take effect
```

**Color conversion issues:**
- Verify color values are in correct ranges (LAB L: 0-100, a/b: -128 to 127)
- Check for color space gamut limits (some RGB colors can't be represented in LAB)
- Use reference test data from known color science sources

**Build issues:**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Future Enhancements

**Color Science:**
- FFI integration with professional color libraries (Little CMS 2)
- Subtractive color mixing model (more accurate for physical paints)
- Spectral reflectance-based mixing (highest accuracy)
- Support for paint opacity/transparency

**Paint Brands:**
- Citadel (Games Workshop)
- Army Painter
- Reaper Master Series
- Scale75
- Cross-reference between brands

**Features:**
- Photo color picker (extract colors from miniature photos)
- Recipe sharing community
- Paint cost optimization
- Batch mixing calculations

**Platform Expansion:**
- iOS and Android mobile apps
- macOS desktop app
- Linux desktop app

## Notes for Claude Code

- **Always prioritize color calculation accuracy** over UI polish
- When implementing color mixing, include references to color science principles
- Suggest test cases with known reference colors (Munsell color chips, etc.)
- For color-related bugs, ask for actual LAB values and Delta E to debug
- Remember: LAB color space, not RGB, for all mixing calculations
- Paint ratios should be practical (10% increments, 2-3 paints maximum initially)
- When suggesting UI, remember shadcn_ui components are available