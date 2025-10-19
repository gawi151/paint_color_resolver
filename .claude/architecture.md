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
