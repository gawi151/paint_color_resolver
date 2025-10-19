# Styling & Theme

## Core Principle: Zero Hardcoded Colors

**All styling lives in theme configuration.** Widgets never hardcode colors, sizes, or fonts.

## Theme Configuration

- **Location:** `lib/core/theme/`
- **Files:**
  - `app_colors.dart` - Color constants
  - `app_text_styles.dart` - Typography
  - `theme_extension.dart` - Custom theme properties

## Dark Mode Support

The app supports both light and dark themes with automatic switching.

```dart
// In app setup (main.dart or app_config)
MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  themeMode: ThemeMode.system, // Respects system preference
)
```

**Custom color usage:**
```dart
// ✅ CORRECT: Use theme colors
final color = Theme.of(context).colorScheme.primary;
final customColor = Theme.of(context).extension<AppThemeExtension>()!.accentColor;

// ❌ WRONG: Hardcoded colors
const Color.fromARGB(255, 255, 87, 51)
```

## Color Constants

File: `lib/core/theme/app_colors.dart`

```dart
// Color space constants (NOT for UI display)
const labColorspaceL = 100;
const labColorspaceAMin = -128;
const labColorspaceAMax = 127;
const labColorspaceBMin = -128;
const labColorspaceBMax = 127;

// UI color tokens (use in theme, not directly in widgets)
const primary = Color(0xFF..);
const secondary = Color(0xFF..);
```

See [color-science.md](color-science.md) for critical color space information.

## Typography

File: `lib/core/theme/app_text_styles.dart`

```dart
class AppTextStyles {
  static const titleLarge = TextStyle(...);
  static const bodyMedium = TextStyle(...);
  static const labelSmall = TextStyle(...);
}
```

**Usage:**
```dart
// ✅ CORRECT
Text('Mixing Results', style: AppTextStyles.titleLarge)

// ❌ WRONG
Text('Mixing Results', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
```

## shadcn_ui Components

Use `shadcn_ui` design system for consistent UI.

```dart
import 'package:shadcn_ui/shadcn_ui.dart';

// Button
ShadButton(child: Text('Mix'), onPressed: () {})

// Card
ShadCard(
  title: const Text('Results'),
  description: const Text('Color mixing calculations'),
  child: content,
)

// Input
ShadInput(placeholder: Text('Color name'))
```

**Benefits:**
- Consistent design across platforms
- Built-in light/dark theme support
- Accessible components

## Responsive Design

**Never hardcode pixel sizes.** Use relative sizes and constraints.

```dart
// ❌ WRONG
Container(width: 300, height: 200)

// ✅ CORRECT
SizedBox(
  width: MediaQuery.of(context).size.width * 0.8,
  height: 200,
)

// ✅ EVEN BETTER: Use Flexible/Expanded in Row/Column
Expanded(
  flex: 2,
  child: Container(), // Takes 2/3 of width
)
```

## Theme Extension Pattern

For custom properties not in Material theme:

```dart
// lib/core/theme/theme_extension.dart
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color paintSwatchBorder;
  final Color deltaEWarning;

  const AppThemeExtension({
    required this.paintSwatchBorder,
    required this.deltaEWarning,
  });

  @override
  AppThemeExtension copyWith({Color? paintSwatchBorder, Color? deltaEWarning}) {
    return AppThemeExtension(
      paintSwatchBorder: paintSwatchBorder ?? this.paintSwatchBorder,
      deltaEWarning: deltaEWarning ?? this.deltaEWarning,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    // Animation support
    return this;
  }
}
```

**Usage:**
```dart
final extension = Theme.of(context).extension<AppThemeExtension>()!;
Container(
  decoration: BoxDecoration(
    border: Border.all(color: extension.paintSwatchBorder),
  ),
)
```

## References

- **Color Safety:** [color-science.md](color-science.md)
- **Widget Guidelines:** [coding-standards.md](coding-standards.md)
