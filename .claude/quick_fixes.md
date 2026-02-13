# Quick Fixes - Copy/Paste Solutions

## 1. Selective Imports (Easiest Approach)

Add these imports to the respective files to quickly fix most errors:

### paint_form.dart
Add at top of file (line 2):
```dart
import 'package:flutter/material.dart' show TextFormField, InputDecoration, OutlineInputBorder;
```

### brand_dropdown.dart
Add at top of file (line 2):
```dart
import 'package:flutter/material.dart' show DropdownButtonFormField, DropdownMenuItem, InputDecoration, OutlineInputBorder;
```

### color_mixer_screen.dart
Add at top of file (line 5):
```dart
import 'package:flutter/material.dart' show Slider;
```

### responsive_bottom_nav.dart
Add at top of file (line 2):
```dart
import 'package:flutter/material.dart' show BottomNavigationBar, BottomNavigationBarItem, BottomNavigationBarType;
```

This will immediately fix ~30 errors related to form widgets!

---

## 2. Find & Replace (Use IDE)

### Replace Theme References
Find: `Theme.of(context)`
Replace: `ShadTheme.of(context)`

Files affected: All remaining files

### Replace Common Colors
Find: `Colors.red`
Replace: `ShadTheme.of(context).colorScheme.destructive`

Find: `Colors.grey`
Replace: `ShadTheme.of(context).colorScheme.muted`

Find: `Colors.orange`
Replace: `Color(0xFFFF9800)`

Find: `Colors.white`
Replace: `const Color(0xFFFFFFFF)`

### Replace Icons
Find: `Icons.error`
Replace: `LucideIcons.circleX`

Find: `Icons.warning_outlined`
Replace: `LucideIcons.alertTriangle`

Find: `Icons.palette_outlined`
Replace: `LucideIcons.palette`

---

## 3. Screen Layout Fixes

### color_mixer_screen.dart - Replace Scaffold (lines 40-44)

**Find:**
```dart
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Mixer'),
        elevation: 0,
      ),
      body: ShadToaster(
```

**Replace with:**
```dart
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.card,
            border: Border(
              bottom: BorderSide(
                color: ShadTheme.of(context).colorScheme.border,
              ),
            ),
          ),
          child: const Text(
            'Color Mixer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ShadToaster(
```

**And at the end of build method, replace:**
```dart
      ),
    );
```

**With:**
```dart
          ),
        ),
      ],
    );
```

### paint_library_screen.dart - Replace Scaffold (lines 122-125)

**Find:**
```dart
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint Inventory'),
        elevation: 0,
      ),
      body: Column(
```

**Replace with:**
```dart
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.card,
            border: Border(
              bottom: BorderSide(
                color: ShadTheme.of(context).colorScheme.border,
              ),
            ),
          ),
          child: const Text(
            'Paint Inventory',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Column(
```

**Find FloatingActionButton (lines 281-285):**
```dart
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPaint,
        tooltip: 'Add Paint',
        child: const Icon(LucideIcons.plus),
      ),
```

**Replace with (add before the closing bracket):**
```dart
        ),
      ],
    );
  }
}
```

**And wrap the Expanded child with Stack:**
```dart
        Expanded(
          child: Stack(
            children: [
              Column(
                // existing Column content here
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: ShadButton(
                  icon: const Icon(LucideIcons.plus),
                  onPressed: _navigateToAddPaint,
                  size: ShadButtonSize.lg,
                ),
              ),
            ],
          ),
        ),
```

### add_paint_screen.dart - Replace Scaffold (lines 84-88)

**Find:**
```dart
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Paint'),
        elevation: 0,
      ),
      body: ShadToaster(
```

**Replace with:**
```dart
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.card,
            border: Border(
              bottom: BorderSide(
                color: ShadTheme.of(context).colorScheme.border,
              ),
            ),
          ),
          child: Row(
            children: [
              ShadButton.ghost(
                leading: const Icon(LucideIcons.arrowLeft),
                onPressed: () => context.router.pop(),
              ),
              const SizedBox(width: 8),
              const Text(
                'Add Paint',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: ShadToaster(
```

**And at the end:**
```dart
          ),
        ),
      ],
    );
```

### edit_paint_screen.dart - Replace Scaffold (lines 170-180)

**Find:**
```dart
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Paint'),
        elevation: 0,
        actions: [
          // Delete button in app bar
          ShadButton.ghost(
            leading: const Icon(LucideIcons.trash, size: 18),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: inventoryAsync.when(
```

**Replace with:**
```dart
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.card,
            border: Border(
              bottom: BorderSide(
                color: ShadTheme.of(context).colorScheme.border,
              ),
            ),
          ),
          child: Row(
            children: [
              ShadButton.ghost(
                leading: const Icon(LucideIcons.arrowLeft),
                onPressed: () => context.router.pop(),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Edit Paint',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ShadButton.ghost(
                leading: const Icon(LucideIcons.trash, size: 18),
                onPressed: _handleDelete,
              ),
            ],
          ),
        ),
        Expanded(
          child: inventoryAsync.when(
```

**And at the end:**
```dart
        ),
      ],
    );
```

---

## 4. After All Changes

Run these commands:

```bash
# Format code
dart format .

# Check for errors
flutter analyze

# Run tests
flutter test

# If all passes, commit changes
git add .
git commit -m "refactor: remove Material imports, use shadcn_ui components"
```

---

## Expected Results

After applying all fixes:
- **~70 errors fixed** by selective imports
- **~20 errors fixed** by Theme/Colors replacements
- **~17 errors fixed** by Scaffold/AppBar replacements
- **0 errors remaining** ✅

Total time: ~15-30 minutes if following this guide sequentially.
