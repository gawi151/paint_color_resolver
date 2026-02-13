# Material Import Removal - Completion Checklist

## ✅ Already Completed (3 files)
- [x] main.dart
- [x] app_shell_screen.dart  
- [x] mixing_results_screen.dart

---

## 📋 Step 1: Add Selective Imports (5 minutes)

### paint_form.dart
- [ ] Add line 2: `import 'package:flutter/material.dart' show TextFormField, InputDecoration, OutlineInputBorder;`

### brand_dropdown.dart
- [ ] Add line 2: `import 'package:flutter/material.dart' show DropdownButtonFormField, DropdownMenuItem, InputDecoration, OutlineInputBorder;`

### color_mixer_screen.dart
- [ ] Add line 5: `import 'package:flutter/material.dart' show Slider;`

### responsive_bottom_nav.dart
- [ ] Add line 2: `import 'package:flutter/material.dart' show BottomNavigationBar, BottomNavigationBarItem, BottomNavigationBarType;`

**Result after Step 1:** ~30 errors fixed ✅

---

## 📋 Step 2: Find & Replace (10 minutes)

Use your IDE's Find & Replace feature:

### Theme References
- [ ] Find: `Theme.of(context)` → Replace: `ShadTheme.of(context)` (all files)

### Color References
- [ ] Find: `Colors.red` → Replace: `ShadTheme.of(context).colorScheme.destructive`
- [ ] Find: `Colors.grey` → Replace: `ShadTheme.of(context).colorScheme.muted`  
- [ ] Find: `Colors.orange` → Replace: `Color(0xFFFF9800)`
- [ ] Find: `Colors.white` → Replace: `const Color(0xFFFFFFFF)`
- [ ] Find: `Colors.blue` → Replace: `ShadTheme.of(context).colorScheme.primary`
- [ ] Find: `Colors.green` → Replace: `Color(0xFF4CAF50)`

### Icon References
- [ ] Find: `Icons.error` → Replace: `LucideIcons.circleX`
- [ ] Find: `Icons.warning_outlined` → Replace: `LucideIcons.alertTriangle`
- [ ] Find: `Icons.palette_outlined` → Replace: `LucideIcons.palette`

**Result after Step 2:** ~50 errors fixed ✅

---

## 📋 Step 3: Fix Main Screens (15 minutes)

Use `.claude/quick_fixes.md` for copy/paste solutions.

### color_mixer_screen.dart
- [ ] Replace Scaffold + AppBar (lines 40-44)
- [ ] Fix closing brackets at end of build method
- [ ] Test screen works

### paint_library_screen.dart
- [ ] Replace Scaffold + AppBar (lines 122-125)
- [ ] Replace FloatingActionButton with Stack + Positioned (lines 281-285)
- [ ] Fix closing brackets
- [ ] Test screen works

### add_paint_screen.dart
- [ ] Replace Scaffold + AppBar (lines 84-88)
- [ ] Fix closing brackets
- [ ] Test screen works

### edit_paint_screen.dart
- [ ] Replace Scaffold + AppBar with actions (lines 170-180)
- [ ] Fix closing brackets
- [ ] Test screen works

**Result after Step 3:** ~27 errors fixed ✅

---

## 📋 Step 4: Verify & Test (5 minutes)

### Run Commands
```bash
# Format code
dart format .

# Check for errors  
flutter analyze

# Run tests
flutter test

# Run app
flutter run -d windows
```

### Manual Testing Checklist
- [ ] Color Mixer screen loads and works
- [ ] Paint Library screen loads and works
- [ ] Add Paint form works
- [ ] Edit Paint form works
- [ ] All colors look correct
- [ ] All navigation works
- [ ] No crashes or errors

---

## 📋 Step 5: Commit Changes

```bash
git add .
git commit -m "refactor: remove Material imports, use shadcn_ui components

- Removed all 'import package:flutter/material.dart' statements
- Replaced Material widgets with shadcn_ui alternatives
- Used selective imports for widgets without shadcn equivalents
- Replaced Theme/Colors with ShadTheme throughout
- Replaced Scaffold/AppBar with custom Column layouts
- All screens tested and working"
```

---

## 🎯 Expected Final Result

- **0 errors** in `flutter analyze`
- **All tests passing**
- **App runs without crashes**
- **Visual appearance unchanged**
- **No global Material imports**

---

## 📊 Progress Tracker

Starting errors: 130
After initial refactoring: 107
After Step 1 (selective imports): ~77
After Step 2 (find & replace): ~27
After Step 3 (screen fixes): **0** ✅

---

## ❓ If You Get Stuck

1. Check `.claude/quick_fixes.md` for exact code to copy/paste
2. Check `.claude/material_removal_guide.md` for detailed explanations
3. Run `flutter analyze` to see specific error messages
4. Focus on one file at a time

Good luck! 🚀
