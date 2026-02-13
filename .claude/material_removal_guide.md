# Material Widget Removal - Complete Guide

## Status: 107 errors remaining

Successfully removed all `import 'package:flutter/material.dart';` statements.
Now need to replace Material widgets with shadcn_ui alternatives.

---

## Quick Reference Table

| Material | Replacement | Notes |
|----------|------------|-------|
| `Scaffold` | Custom Column layout | See pattern below |
| `AppBar` | Custom Container | See pattern below |
| `Theme.of(context)` | `ShadTheme.of(context)` | Direct replacement |
| `Colors.red` | `ShadTheme.of(context).colorScheme.destructive` | Or use `Color(0xFFFF0000)` |
| `Colors.grey` | `ShadTheme.of(context).colorScheme.muted` | - |
| `Colors.blue` | `ShadTheme.of(context).colorScheme.primary` | - |
| `Colors.orange` | `Color(0xFFFF9800)` | No direct Shad equivalent |
| `Icons.xxx` | `LucideIcons.xxx` | Check Lucide icons docs |
| `Card` | `ShadCard` | Already mostly done |
| `CircularProgressIndicator` | `ShadProgress()` | Direct replacement |
| `Divider` | `ShadSeparator.horizontal()` | Direct replacement |
| `TextFormField` | `ShadInput` | See form pattern below |
| `DropdownButtonFormField` | Custom or `ShadSelect` | See form pattern below |
| `Slider` | Custom widget | No Shad equivalent yet |
| `FloatingActionButton` | Positioned `ShadButton` | See pattern below |
| `BottomNavigationBar` | Custom widget | Already done |

---

## Common Patterns

### 1. Scaffold + AppBar Replacement

**Before:**
```dart
return Scaffold(
  appBar: AppBar(
    title: const Text('My Title'),
    elevation: 0,
  ),
  body: MyContent(),
);
```

**After:**
```dart
return Column(
  children: [
    // Custom AppBar
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
            'My Title',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
    // Body
    Expanded(
      child: MyContent(),
    ),
  ],
);
```

### 2. Theme References

**Replace:**
```dart
Theme.of(context).textTheme.titleMedium  → ShadTheme.of(context).textTheme.large
Theme.of(context).textTheme.bodyMedium   → ShadTheme.of(context).textTheme.p
Theme.of(context).textTheme.bodySmall    → ShadTheme.of(context).textTheme.small
Theme.of(context).primaryColor           → ShadTheme.of(context).colorScheme.primary
```

### 3. Colors Mapping

**Common Colors:**
```dart
Colors.red             → ShadTheme.of(context).colorScheme.destructive
Colors.grey            → ShadTheme.of(context).colorScheme.muted
Colors.grey.shade50    → ShadTheme.of(context).colorScheme.muted
Colors.blue            → ShadTheme.of(context).colorScheme.primary
Colors.green           → Color(0xFF4CAF50)
Colors.orange          → Color(0xFFFF9800)
Colors.white           → ShadTheme.of(context).colorScheme.background
```

**For .shade variations:**
```dart
Colors.grey.shade50    → ShadTheme.of(context).colorScheme.muted
Colors.grey.shade300   → ShadTheme.of(context).colorScheme.border
Colors.orange.shade700 → Color(0xFFF57C00)
```

### 4. Form Widgets

**TextFormField → ShadInput:**

**Before:**
```dart
TextFormField(
  controller: _controller,
  decoration: InputDecoration(
    labelText: 'Label',
    hintText: 'Hint',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
)
```

**After:**
```dart
ShadInput(
  controller: _controller,
  placeholder: const Text('Hint'),
  // Note: ShadInput doesn't have built-in label
  // Add a Text widget above it for the label
)

// Or wrap with proper structure:
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Label', style: ShadTheme.of(context).textTheme.small),
    const SizedBox(height: 8),
    ShadInput(
      controller: _controller,
      placeholder: const Text('Hint'),
    ),
  ],
)
```

**DropdownButtonFormField:**

This is complex. Options:
1. Use `ShadSelect` if available in your shadcn_ui version
2. Keep as custom widget with basic styling
3. Create a custom dropdown using `ShadButton` + overlay

For now, you can import Material just for form fields:
```dart
import 'package:flutter/material.dart' show DropdownButtonFormField, DropdownMenuItem, InputDecoration, OutlineInputBorder, Icons;
```

### 5. Slider Replacement

**Option 1:** Import Material just for Slider
```dart
import 'package:flutter/material.dart' show Slider;
```

**Option 2:** Create custom slider using GestureDetector + CustomPaint (complex)

**Recommended for now:** Use Option 1 with selective import

### 6. FloatingActionButton Replacement

**Before:**
```dart
floatingActionButton: FloatingActionButton(
  onPressed: _navigateToAddPaint,
  tooltip: 'Add Paint',
  child: const Icon(LucideIcons.plus),
)
```

**After:**
```dart
// Remove floatingActionButton property
// Add button in the body or as a fixed positioned widget

Stack(
  children: [
    // Your main content
    MyContent(),
    // FAB replacement
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
)
```

---

## Files to Fix (Priority Order)

### HIGH PRIORITY (Main Screens)

#### 1. color_mixer_screen.dart
**Errors:** Scaffold, AppBar, Theme refs, Colors refs, Slider
**Lines to fix:**
- Line 40-44: Replace Scaffold + AppBar (use pattern above)
- Line 54, 84, 93: Replace `Theme.of(context)` → `ShadTheme.of(context)`
- Line 126, 131: Replace `Colors.orange` → `Color(0xFFFF9800)`
- Line 187, 199, 221: Replace Theme refs
- Line 207-214: **Slider widget** - use selective import or custom
- Line 222: Replace `Colors.grey` → `ShadTheme.of(context).colorScheme.muted`

**Slider fix (easiest):**
Add at top of file:
```dart
import 'package:flutter/material.dart' show Slider;
```

#### 2. paint_library_screen.dart  
**Errors:** Scaffold, AppBar, Theme refs, Colors refs, FloatingActionButton
**Lines to fix:**
- Line 122-125: Replace Scaffold + AppBar
- Line 252, 265: Replace `Colors.red` → `ShadTheme.of(context).colorScheme.destructive`
- Line 281-285: Replace FloatingActionButton (use Stack + Positioned pattern)

#### 3. add_paint_screen.dart
**Errors:** Scaffold, AppBar
**Lines to fix:**
- Line 84-87: Replace Scaffold + AppBar (simple - just screen title)

#### 4. edit_paint_screen.dart
**Errors:** Scaffold, AppBar, Colors refs
**Lines to fix:**
- Line 170-180: Replace Scaffold + AppBar
- Line 197, 207, 242, 252: Replace `Colors.grey` → `ShadTheme.of(context).colorScheme.muted`
- Line 197, 207, 242, 252: Replace `Colors.red` → `ShadTheme.of(context).colorScheme.destructive`

### MEDIUM PRIORITY (Widgets)

#### 5. paint_form.dart
**Errors:** TextFormField (2 instances), form decorations
**Lines to fix:**
- Line 222-232: Replace first TextFormField (paint name)
- Line 251-261: Replace second TextFormField (product code)
- These use `InputDecoration`, `OutlineInputBorder` from Material

**Quick fix:**
Add selective import:
```dart
import 'package:flutter/material.dart' show TextFormField, InputDecoration, OutlineInputBorder;
```

#### 6. brand_dropdown.dart
**Errors:** DropdownButtonFormField, Icons, Theme refs
**Lines to fix:**
- Line 87-121: DropdownButtonFormField usage
- Line 106: Replace `Icons.palette_outlined` → `LucideIcons.palette`
- Line 80-81: Replace Theme refs

**Quick fix:**
Add selective import:
```dart
import 'package:flutter/material.dart' show DropdownButtonFormField, DropdownMenuItem, InputDecoration, OutlineInputBorder;
```

#### 7. color_picker_input.dart
**Errors:** Theme refs, Icons
**Lines to fix:**
- Line 115, 118, 125, 132, 133: Replace Theme refs
- Line 124: Replace `Icons.warning_outlined` → `LucideIcons.alertTriangle`

#### 8. responsive_bottom_nav.dart
**Errors:** BottomNavigationBar, BottomNavigationBarType
**Quick fix:**
Add selective import:
```dart
import 'package:flutter/material.dart' show BottomNavigationBar, BottomNavigationBarItem, BottomNavigationBarType;
```

#### 9. debug_lab_display.dart
**Errors:** Theme refs (7 instances)
**Lines to fix:**
- Lines 60, 65, 74, 76, 84, 90, 96: Replace all `Theme.of(context)` → `ShadTheme.of(context)`

### LOW PRIORITY (Display Widgets)

#### 10. mixing_result_card.dart
**Errors:** Card, Colors refs, Theme refs
**Lines to fix:**
- Line 37: Replace `Card` → `ShadCard`
- Lines with Colors/Theme: Replace with ShadTheme equivalents

#### 11. quality_badge.dart
**Errors:** Colors refs (15 instances)
**Lines to fix:**
- Lines 82-122: Replace all `Colors.xxx` with direct Color values or theme colors

#### 12. color_conversion_utils.dart
**Errors:** Colors ref
**Line to fix:**
- Line 171: Replace `Colors.white` → `const Color(0xFFFFFFFF)`

---

## Step-by-Step Instructions

### Quick Win Approach (Recommended)

For complex widgets that don't have shadcn equivalents, use **selective imports**:

1. **For Form Widgets** (paint_form.dart, brand_dropdown.dart):
```dart
import 'package:flutter/material.dart' show 
    TextFormField, 
    InputDecoration, 
    OutlineInputBorder,
    DropdownButtonFormField,
    DropdownMenuItem;
```

2. **For Slider** (color_mixer_screen.dart):
```dart
import 'package:flutter/material.dart' show Slider;
```

3. **For BottomNavigationBar** (responsive_bottom_nav.dart):
```dart
import 'package:flutter/material.dart' show 
    BottomNavigationBar, 
    BottomNavigationBarItem, 
    BottomNavigationBarType;
```

4. **Replace all other references:**
   - Use Find & Replace in your IDE:
     - `Theme.of(context)` → `ShadTheme.of(context)`
     - `Colors.red` → `ShadTheme.of(context).colorScheme.destructive`
     - `Colors.grey` → `ShadTheme.of(context).colorScheme.muted`
     - `Icons.xxx` → `LucideIcons.xxx`

### Full Refactor Approach (More Work)

Replace everything with custom widgets:
1. Create `CustomSlider` widget using GestureDetector
2. Create `CustomDropdown` using ShadButton + overlay
3. Create `CustomTextFormField` wrapper around ShadInput
4. Replace all Scaffold/AppBar instances with custom layout

---

## Testing After Changes

1. **Run analyzer:**
```bash
flutter analyze
```

2. **Run tests:**
```bash
flutter test
```

3. **Build and run app:**
```bash
flutter run -d windows
```

4. **Check for visual issues:**
   - Colors might look different
   - Spacing might need adjustment
   - Test all screens and interactions

---

## Common Issues & Solutions

### Issue: "Undefined name 'Icons'"
**Solution:** Replace with `LucideIcons.xxx` or add selective import

### Issue: "The method 'Scaffold' isn't defined"
**Solution:** Replace with Column layout (see pattern above)

### Issue: "Colors doesn't have exact match"
**Solution:** Use direct Color value: `Color(0xFFRRGGBB)`

### Issue: Form validation doesn't work with ShadInput
**Solution:** Either:
- Use selective Material import for form fields
- Implement custom validation logic with setState

### Issue: Layout looks different after Scaffold removal
**Solution:** 
- Ensure you have `Expanded` around the body content
- Check padding/margins match original design
- Test on different screen sizes

---

## Quick Command Cheat Sheet

```bash
# Find all remaining errors
flutter analyze 2>&1 | grep "error -"

# Count errors by type
flutter analyze 2>&1 | grep "Undefined name 'Theme'" | wc -l
flutter analyze 2>&1 | grep "Undefined name 'Colors'" | wc -l

# Format code after changes
dart format .

# Run specific test
flutter test test/path/to/test.dart

# Clean rebuild if needed
flutter clean && flutter pub get
```

---

## Notes

- **Const constructors:** Many const widgets became non-const after adding `ShadTheme.of(context)`. This is expected - context access requires runtime evaluation.

- **Icons:** LucideIcons is the icon library used by shadcn_ui. Check available icons: https://lucide.dev/icons/

- **Color values:** For colors without direct shadcn equivalents, use hex values:
  - Red: `Color(0xFFFF0000)` or `Color(0xFFF44336)`
  - Orange: `Color(0xFFFF9800)`
  - Green: `Color(0xFF4CAF50)`

- **Performance:** Removing Material import doesn't significantly affect performance. The main benefit is cleaner dependencies and consistent design system usage.

---

## Completed Files ✅

1. main.dart
2. app_shell_screen.dart  
3. mixing_results_screen.dart

---

## Priority Order for Maximum Impact

1. **color_mixer_screen.dart** - Main feature screen
2. **paint_library_screen.dart** - Main feature screen
3. **add_paint_screen.dart** - Common user flow
4. **edit_paint_screen.dart** - Common user flow
5. All other files can use selective imports as quick fix

Good luck! 🚀
