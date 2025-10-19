# Architecture

## Project Structure

```
lib/
├── core/
│   ├── theme/              # shadcn_ui, colors, typography
│   ├── constants/          # App-wide constants
│   ├── router/             # auto_route configuration
│   └── database/           # Drift setup, DAOs, seeds
├── features/
│   ├── color_calculation/  # PRIORITY: Mixing algorithm
│   │   ├── data/           # Results storage
│   │   ├── domain/         # Color logic, LAB operations
│   │   └── presentation/   # UI, providers (NEW)
│   ├── paint_library/      # Paint collection management
│   ├── mixing_history/     # Past calculations
│   └── settings/           # App preferences
├── shared/
│   ├── widgets/            # Reusable UI components
│   ├── utils/              # Helpers, extensions
│   └── models/             # Shared data models
└── main.dart
```

## Pattern: Feature-First with Simplified Internal Structure

Each feature module contains:
- **data/** - Local persistence, mappers, repositories
- **domain/** - Pure logic, models, interfaces
- **presentation/** - UI widgets, screens, providers

## Technologies

- **State Management:** Riverpod 3.0 (with code generation)
- **Navigation:** auto_route (type-safe routing)
- **Database:** Drift (SQLite + type-safe queries)
- **Design:** shadcn_ui + custom theming
- **Models:** dart_mappable (not freezed)

## Development Flow

1. Domain layer → Business logic (testable, independent)
2. Data layer → Persistence (DAOs, repositories)
3. Presentation layer → UI + State management (providers)

See [riverpod.md](riverpod.md) for state management patterns.

## Component Unification Pattern

### Problem: Inconsistent UX Across Screens

When the same feature (color picking, form input, data display) appears on multiple screens with different implementations:
- Users experience inconsistency
- Bugs require fixes in multiple places
- Testing and maintenance becomes harder
- Code duplication increases

### Solution: Facade Components in `shared/widgets/`

Create reusable components that unify the UI/UX:

```
Before (Inconsistent):
├── ColorMixerScreen → Custom HSV sliders + preview
├── AddPaintScreen → flutter_colorpicker dialog
└── EditPaintScreen → Different picker

After (Unified):
└── ColorPickerInput (facade)
    ├── ColorMixerScreen ✓
    ├── AddPaintScreen (via PaintForm) ✓
    └── EditPaintScreen (via PaintForm) ✓
```

### Real Example: Color Picking Unification

**Pattern:** `lib/shared/widgets/color_picker_input.dart`

Benefits:
- **Single source of truth** - All color pickers behave identically
- **Consistent gamut validation** - Warnings shown everywhere
- **Easy improvements** - HueRingPicker enhancement applies to all screens
- **Testable in isolation** - Test once, works everywhere
- **Maintainable** - Bug fixes don't need to be replicated

**Key Principle:** Extract components to `shared/widgets/` when they're used in 2+ places with the goal of unifying UX across the app.
