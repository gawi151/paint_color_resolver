# Build Commands

## Run App

```bash
flutter run -d windows    # Windows
flutter run -d chrome     # Web
```

## Code Generation

```bash
# One-time build
dart run build_runner build --delete-conflicting-outputs

# Watch mode (continuous during development)
dart run build_runner watch
```

Generates:
- Riverpod providers
- drift database code
- auto_route routes
- dart_mappable models

## Code Quality

```bash
flutter analyze           # Check for errors/lints
dart format .            # Format code
dart fix --apply         # Auto-fix issues
```

## Testing

```bash
flutter test                               # Run all tests
flutter test --coverage                    # With coverage
flutter test test/features/color_calculation/  # Specific folder
```

## Clean & Rebuild

If stuck:
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Database

Drift generates SQL from Dart. Schema updates trigger automatic migrations - no separate migration commands needed.
