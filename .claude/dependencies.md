# Dependencies & Package Management

## Core Dependencies (Locked)

These packages are strategically chosen and should not be changed without careful consideration:

| Package | Version | Purpose | Score |
|---------|---------|---------|-------|
| `flutter_riverpod` | ^3.0.3 | State management | 150+ |
| `riverpod_annotation` | ^3.0.3 | Provider code generation | 150+ |
| `auto_route` | ^10.1.2 | Type-safe navigation | 145+ |
| `drift` | ^2.28.2 | Type-safe database | 148+ |
| `sqlite3_flutter_libs` | ^0.5.40 | SQLite driver | 145+ |
| `path_provider` | ^2.1.5 | File system access | 148+ |
| `dart_mappable` | ^4.6.1 | Model generation | 140+ |
| `flutter_color` | ^2.1.0 | Color space conversions | 138+ |
| `flutter_colorpicker` | ^1.1.0 | Color picker UI | 135+ |
| `shadcn_ui` | ^0.37.4 | Design system | 140+ |
| `logging` | ^1.3.0 | Logging framework | 150+ |

**Dev Dependencies:**

| Package | Version | Purpose |
|---------|---------|---------|
| `build_runner` | ^2.7.1 | Code generation runner |
| `riverpod_generator` | ^3.0.3 | Riverpod codegen |
| `riverpod_lint` | ^3.0.3 | Riverpod linting |
| `auto_route_generator` | ^10.2.4 | auto_route codegen |
| `drift_dev` | ^2.28.3 | Drift codegen |
| `dart_mappable_builder` | ^4.6.0 | dart_mappable codegen |
| `very_good_analysis` | ^10.0.0 | Lint rules |
| `test` | ^1.26.2 | Test framework |

## Before Adding New Packages

**Checklist:**

1. **pub.dev Score Check**
   - Minimum: 130 (indicates good quality/maintenance)
   - Check: Points, Popularity, Pub score at top of package page

2. **Compatibility**
   - Flutter: 3.35+ (current project version)
   - Dart: Latest bundled with Flutter
   - No conflicts with existing dependencies (check pubspec)

3. **Maintenance Status**
   - Recent updates (within last 3 months)
   - Active issue resolution
   - Clear documentation

4. **Alternative Evaluation**
   - Is this the best solution for the problem?
   - Compare similar packages (e.g., state management options)
   - Document why chosen in this file

5. **Size Impact**
   - Check download count (increasing = healthy)
   - Web: Consider bundle size implications
   - Native: Check binary size impact

## Adding a Package

```bash
# Add to production dependencies
flutter pub add package_name

# Add to dev dependencies
flutter pub add --dev package_name

# Update pubspec.lock
flutter pub get
```

**After adding:**
1. Regenerate code: `dart run build_runner build --delete-conflicting-outputs`
2. Run analysis: `flutter analyze`
3. Run tests: `flutter test`
4. Document the addition in this file with rationale

## Package Groups

### State Management

**Current:** Riverpod 3.0 (chosen for code generation, async support, type safety)

**Alternatives Evaluated:**
- BLoC: More verbose, older patterns
- GetX: Less type-safe, tightly coupled
- Provider (older): Riverpod 3.0 is successor with better features

### Navigation

**Current:** auto_route (type-safe, compiler-verified routes)

**Why not:** Navigator 2.0 (too verbose), go_router (less type-safe)

### Database

**Current:** Drift (type-safe queries, auto migrations, SQLite)

**Why not:** Hive (less type-safe), Isar (newer, less stable)

### UI Components

**Current:** shadcn_ui (comprehensive, dark mode support)

**Considered:** Material 3 (only), Fluent (Windows-only)

### Color Science

**Current:** flutter_color (comprehensive LAB support)

**Considerations:**
- flutter_color has LAB to RGB conversion
- Future: Consider FFI to Little CMS for higher accuracy

### Models

**Current:** dart_mappable (lightweight code generation)

**Why not:** Freezed (more complex, generates more code)

## Platform-Specific Dependencies

### Web

**No special requirements** - drift, auto_route, and shadcn_ui all support web.

**Note:** SQLite in browser uses IndexedDB backend (transparent to code).

### Windows

**Current Setup:** flutter_lints included in very_good_analysis

**No native dependencies** for core features (yet).

## Dependency Commands Cheat Sheet

```bash
# Check for outdated packages
flutter pub outdated

# Check for compatibility issues
flutter pub audit

# Upgrade all packages (careful!)
flutter pub upgrade

# Upgrade specific package
flutter pub upgrade package_name

# Get latest allowed by constraints
flutter pub get

# Remove unused packages
flutter pub remove package_name
```

## Troubleshooting

### Build Runner Issues

```bash
# Clean and rebuild code generation
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Conflicting Dependencies

**Error:** `version conflict for xyz`

**Solution:**
1. Check `pubspec.lock` for unexpected versions
2. Delete `pubspec.lock`
3. Run `flutter pub get`
4. If still broken, investigate which package introduced conflict

### Version Constraints

**Format:** `^1.2.3` means `>=1.2.3 <2.0.0`

- Use `^` for normal dependencies (prefer minimum maintenance release)
- Use `~` for pinned versions (rarely needed)
- Use exact version (no symbol) only for critical dependencies

Example:
```yaml
dependencies:
  flutter_riverpod: ^3.0.3   # Allow 3.x.x updates
  drift: ^2.28.2             # Allow 2.x.x updates
```

## Adding vs. Not Adding

**Add if:**
- Solves real problem not in standard library
- High pub.dev score (130+)
- Active maintenance
- Minimal dependencies (depends on few other packages)
- Team familiar with it

**Don't add if:**
- Only 5-10 lines of code needed (build in-house)
- Low pub.dev score
- Abandoned/unmaintained
- Heavy dependency tree
- Unnecessary complexity

## Future Package Candidates

**To Evaluate:**
- **FFI to Little CMS** - Professional color library for spectral-based mixing
- **Image package** - Photo color extraction feature
- **Local notifications** - Reminder features
- **File picker** - Paint collection import/export

**Not Needed Yet:**
- Firebase (no cloud sync planned)
- Animation libraries (shadcn_ui covers)
- HTTP (no remote data)

## References

- **pub.dev:** https://pub.dev
- **Build Commands:** [build-commands.md](build-commands.md)
- **Architecture:** [architecture.md](architecture.md)
