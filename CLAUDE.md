# Paint Color Resolver

**Desktop/Web application** helping miniature painters achieve desired colors through optimal paint mixing calculations.

**Target Platforms:** Windows, Web
**Target Users:** Miniature painters, hobbyists, tabletop gaming enthusiasts
**Primary Paint Brand:** Vallejo (expandable to others)

## Development Priority

**PRIMARY FOCUS:** Core color calculation engine - this is the most critical component. All other features (UI, paint library management, history) depend on accurate color mixing calculations.

---

## 🎯 Quick Navigation by Task

### Debugging Issues
- **Color looks wrong?** → [color-science.md](./.claude/color-science.md) - LAB/RGB safety, conversions
- **State management confusion?** → [riverpod.md](./.claude/riverpod.md) - Provider patterns & async handling
- **Build or runtime error?** → [common-issues.md](./.claude/common-issues.md) - Solutions & troubleshooting

### Building Features
- **Starting a new feature?** → [architecture.md](./.claude/architecture.md) - Feature structure, then [coding-standards.md](./.claude/coding-standards.md)
- **Need a database feature?** → [database.md](./.claude/database.md) - Tables, DAOs, type-safe queries
- **Writing UI?** → [styling.md](./.claude/styling.md) - Theme config, dark mode, responsive design
- **Adding dependencies?** → [dependencies.md](./.claude/dependencies.md) - Evaluation criteria, compatibility

### Development Workflow
- **CLI commands?** → [build-commands.md](./.claude/build-commands.md) - All dev/test/build commands
- **Writing tests?** → [testing.md](./.claude/testing.md) - Test organization, coverage strategy
- **Code review checklist?** → [coding-standards.md](./.claude/coding-standards.md) - Standards & patterns

---

## Quick Commands

```bash
# Run app
flutter run -d windows    # Windows
flutter run -d chrome     # Web

# Code generation (Riverpod, Drift, auto_route, dart_mappable)
dart run build_runner build --delete-conflicting-outputs

# Testing & code quality
flutter test
flutter analyze
dart format .
dart fix --apply

# Clean rebuild (if stuck)
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs
```

See [build-commands.md](./.claude/build-commands.md) for all commands.

---

## Tech Stack

| Component | Technology |
|-----------|------------|
| **State Management** | Riverpod 3.0 (code generation) |
| **Navigation** | auto_route (type-safe) |
| **Database** | Drift + SQLite (type-safe queries) |
| **Design System** | shadcn_ui with custom theming |
| **Models** | dart_mappable (not freezed) |
| **SDK** | Flutter 3.35.6, Dart (bundled) |
| **Platforms** | Windows 10+, Modern browsers |

---

## Project Structure

```
lib/
├── core/                 # Shared infrastructure
│   ├── theme/           # shadcn_ui, colors, typography
│   ├── constants/       # App-wide constants
│   ├── router/          # auto_route config
│   └── database/        # Drift setup, DAOs
├── features/            # Feature modules (feature-first)
│   ├── color_calculation/  # ⭐ PRIORITY: mixing algorithm
│   ├── paint_library/      # Paint inventory management
│   ├── mixing_history/     # Calculation history
│   └── settings/           # App preferences
├── shared/              # Reusable components
│   ├── widgets/
│   ├── utils/
│   └── models/
└── main.dart
```

---

## 🎯 Key Reminders for Claude Code

1. **Color Accuracy First** - Color calculation is the core value proposition
2. **LAB Color Space** - Always use LAB for mixing, RGB only for display
   - ⚠️ Never map LAB components directly to RGB (L ≠ Red, a ≠ Green, b ≠ Blue)
   - See [color-science.md](./.claude/color-science.md) for safety guidelines
3. **Provider Chains** - Watch inputs, run calculations, transform outputs
   - See [riverpod.md](./.claude/riverpod.md) for patterns
4. **Type Safety** - Use Drift, auto_route, dart_mappable for compile-time guarantees
5. **Zero Hardcoded Colors** - All styling via theme configuration
   - See [styling.md](./.claude/styling.md)

---

## 📚 Documentation Index

All detailed documentation is in the `.claude/` directory:

- **[architecture.md](./.claude/architecture.md)** - Feature-first pattern, project structure
- **[riverpod.md](./.claude/riverpod.md)** - Provider chains, ConsumerWidget, async patterns
- **[color-science.md](./.claude/color-science.md)** - ⚠️ CRITICAL: LAB/RGB safety, conversions
- **[coding-standards.md](./.claude/coding-standards.md)** - Naming, conventions, best practices
- **[styling.md](./.claude/styling.md)** - Theme config, dark mode, responsive design
- **[database.md](./.claude/database.md)** - Drift tables, DAOs, queries, migrations
- **[testing.md](./.claude/testing.md)** - Test organization, unit/widget tests, coverage
- **[build-commands.md](./.claude/build-commands.md)** - All CLI commands (run, test, build)
- **[dependencies.md](./.claude/dependencies.md)** - Package management, evaluation criteria
- **[common-issues.md](./.claude/common-issues.md)** - Bug solutions, debugging, troubleshooting

---

## Platform-Specific Notes

- **Windows:** Target 10+ (x64). No special setup needed.
- **Web:** Modern browsers. SQLite uses IndexedDB backend (transparent to code).

---

## Future Enhancements

- Professional color library integration (Little CMS 2 via FFI)
- Subtractive color mixing model (more accurate)
- Support for additional paint brands (Citadel, Army Painter, Reaper, Scale75)
- Photo color picker
- Recipe sharing & batch calculations
- Mobile apps (iOS, Android, macOS)

---

**Last Updated:** October 2025
**Related Files:** See `.claude/` directory for comprehensive documentation
