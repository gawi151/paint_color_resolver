# Material Package Removal Plan - UPDATED

**Project**: Paint Color Resolver  
**Date**: February 13, 2026 (Updated after comprehensive gap analysis)  
**Goal**: Completely remove Material package dependency and replace all Material widgets with shadcn_ui alternatives

---

## Executive Summary

The app currently uses Material widgets across **7 files** (2 more than initially documented). This plan outlines complete migration to shadcn_ui components with **TDD approach** - we'll write widget tests first, then implement changes.

**Key Decisions**:
- ✅ Use `ShadInputFormField` with built-in validation
- ✅ Use `ShadSelectFormField` directly (remove BrandDropdown wrapper)
- ✅ Self-validating form fields (consistent pattern)
- ✅ Default ShadButton.ghost animations for bottom nav
- ✅ TDD: Write widget tests before migration

---

## Pre-Implementation Checklist

**Before starting ANY tasks**, complete these steps:

- [ ] **Create feature branch**: `git checkout -b feature/remove-material-package`
- [ ] **Verify dependencies**: `flutter pub get` completes successfully
- [ ] **Baseline screenshots**: Capture current UI (all screens)
- [ ] **Baseline behavior**: Record screen interactions (form validation, navigation)
- [ ] **Verify shadcn_ui version**: Check `pubspec.yaml` has latest compatible version
- [ ] **Run current tests**: `flutter test` (should pass - only 4 domain tests exist)
- [ ] **Clean build**: `flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs`

---

## Current State Analysis - CORRECTED

### Material Widget Usage (COMPLETE LIST)

| File | Material Widgets Used | Line Numbers |
|------|----------------------|--------------|
| `lib/shared/widgets/paint_form.dart` | TextFormField (2x), Material wrapper | 224-236, 255-267 |
| `lib/shared/widgets/brand_dropdown.dart` | DropdownButtonFormField, Material wrapper | 94-130 |
| `lib/features/color_calculation/presentation/screens/color_mixer_screen.dart` | Slider, Material wrapper | 226-238 |
| `lib/shared/widgets/responsive_bottom_nav.dart` | BottomNavigationBar, BottomNavigationBarItem, Material wrapper | 52-86 |
| `lib/features/paint_library/presentation/screens/edit_paint_screen.dart` | Navigator.pop (lines 113, 118) | 4 (import), 113, 118 |
| `lib/features/paint_library/presentation/screens/paint_library_screen.dart` | Navigator.pop (lines 101, 106) | 4 (import), 101, 106 |
| `lib/core/database/seeds/vallejo_paints_seed.dart` | Color class import | 1 |

### Total Material Imports: **7 files** (corrected from 5)

### Current Import Patterns

**Pattern 1 - Selective show (widgets)**:
```dart
import 'package:flutter/material.dart'
    show InputDecoration, Material, OutlineInputBorder, TextFormField;
```

**Pattern 2 - Hide specific (screens)**:
```dart
import 'package:flutter/material.dart' hide TextButton;
```

**Pattern 3 - Selective show (seed)**:
```dart
import 'package:flutter/material.dart' show Color;
```

---

## Implementation Decisions - UPDATED

Following user consultation and gap analysis:

1. **Form Validation Strategy**: Use `ShadInputFormField` with built-in `validator` callbacks
2. **Brand Dropdown**: **CHANGED** - Use `ShadSelectFormField` directly, remove wrapper pattern
3. **Self-Validating Pattern**: All form fields manage their own validation (consistent approach)
4. **Slider Styling**: Use `ShadSlider` default styling
5. **Bottom Navigation**: Custom component using Container + Row + ShadButton.ghost
6. **Navigator Usage**: Import from `flutter/widgets.dart` (not material)
7. **Color Import**: Change to `dart:ui` (already compatible)
8. **Test Strategy**: **TDD** - Write widget tests before each migration task

---

## Detailed Implementation Plan

### Task 0: Set Up Widget Testing Infrastructure ✅ Priority: CRITICAL

**Goal**: Establish widget test framework before migration

**Files to Create**:
- `test/shared/widgets/paint_form_test.dart`
- `test/shared/widgets/responsive_bottom_nav_test.dart`
- `test/features/color_calculation/presentation/screens/color_mixer_screen_test.dart`
- `test/features/paint_library/presentation/screens/edit_paint_screen_test.dart`
- `test/features/paint_library/presentation/screens/paint_library_screen_test.dart`

**Test Scenarios** (write tests that currently PASS with Material widgets):

#### paint_form_test.dart
```dart
group('PaintForm Validation', () {
  testWidgets('shows error when name is empty', (tester) async {
    // Arrange: Render form
    // Act: Tap submit without entering name
    // Assert: Error toast appears OR error text shows
  });
  
  testWidgets('shows error when brand not selected', (tester) async {
    // Arrange: Render form with name
    // Act: Tap submit without selecting brand
    // Assert: Error toast appears
  });
  
  testWidgets('shows error when color not selected', (tester) async {
    // Arrange: Render form with name and brand
    // Act: Tap submit without selecting color
    // Assert: Error toast appears
  });
  
  testWidgets('calls onSubmit with valid data', (tester) async {
    // Arrange: Render form
    // Act: Fill all fields, tap submit
    // Assert: onSubmit callback called with correct data
  });
  
  testWidgets('pre-populates fields in edit mode', (tester) async {
    // Arrange: Render form with initialPaint
    // Assert: Fields show initial values
  });
  
  testWidgets('disables fields when loading', (tester) async {
    // Arrange: Render form with isLoading: true
    // Assert: All fields disabled
  });
});
```

#### responsive_bottom_nav_test.dart
```dart
group('ResponsiveBottomNav', () {
  testWidgets('renders three navigation items', (tester) async {
    // Assert: Finds 'Mixer', 'Library', 'More'
  });
  
  testWidgets('highlights active tab', (tester) async {
    // Arrange: activeIndex: 1
    // Assert: Library tab has primary color
  });
  
  testWidgets('calls onTabChanged when tab tapped', (tester) async {
    // Act: Tap Library tab
    // Assert: onTabChanged(1) called
  });
  
  testWidgets('calls onMoreTapped when More tapped', (tester) async {
    // Act: Tap More tab
    // Assert: onMoreTapped() called
  });
});
```

#### color_mixer_screen_test.dart
```dart
group('ColorMixerScreen Slider', () {
  testWidgets('displays current Delta E value', (tester) async {
    // Assert: Shows formatted value (e.g., "5.0")
  });
  
  testWidgets('updates value on slider drag', (tester) async {
    // Act: Drag slider to new position
    // Assert: Value updates in UI
  });
  
  testWidgets('updates provider on slider change', (tester) async {
    // Act: Drag slider
    // Assert: maxDeltaEThresholdProvider updated
  });
});
```

**Acceptance Criteria**:
- [ ] All baseline tests written
- [ ] All tests PASS with current Material implementation
- [ ] `flutter test` returns 0 failures
- [ ] Code coverage includes widget rendering paths

**Commit**: `test: add baseline widget tests for Material components`

---

### Task 1: Migrate paint_form.dart Text Fields ✅ Priority: HIGH

**Test-First Approach**:
1. Update `paint_form_test.dart` to use `find.byType(ShadInputFormField)`
2. Run tests - they should FAIL (ShadInputFormField doesn't exist yet)
3. Implement migration
4. Run tests - they should PASS

**File**: `lib/shared/widgets/paint_form.dart`

**Changes Required**:

**1. Update Imports**:
```dart
// REMOVE:
import 'package:flutter/material.dart'
    show InputDecoration, Material, OutlineInputBorder, TextFormField;

// Already has shadcn_ui - no add needed
```

**2. Replace Paint Name Field** (Lines 224-236):
```dart
// FROM:
Material(
  child: TextFormField(
    controller: _nameController,
    decoration: InputDecoration(
      labelText: 'Paint Name',
      hintText: 'e.g., Red Gore, Ultramarine Blue',
      border: OutlineInputBorder(borderRadius: theme.radius),
    ),
    enabled: !widget.isLoading,
  ),
),

// TO:
ShadInputFormField(
  id: 'paintName',
  controller: _nameController,
  label: const Text('Paint Name *'),
  placeholder: const Text('e.g., Red Gore, Ultramarine Blue'),
  enabled: !widget.isLoading,
  validator: (v) {
    if (v.trim().isEmpty) {
      return 'Paint name is required';
    }
    return null;
  },
),
```

**3. Replace Brand Maker ID Field** (Lines 255-267):
```dart
// FROM:
Material(
  child: TextFormField(
    controller: _brandMakerIdController,
    decoration: InputDecoration(
      labelText: 'Product Code (Optional)',
      hintText: 'e.g., vallejo_70926, citadel_51-01',
      border: OutlineInputBorder(borderRadius: theme.radius),
    ),
    enabled: !widget.isLoading,
  ),
),

// TO:
ShadInputFormField(
  id: 'brandMakerId',
  controller: _brandMakerIdController,
  label: const Text('Product Code (Optional)'),
  placeholder: const Text('e.g., vallejo_70926, citadel_51-01'),
  enabled: !widget.isLoading,
  // No validator - field is optional
),
```

**4. Update Validation Logic** in `_handleSubmit()` (Lines 158-209):
```dart
// FROM: Manual validation with toast messages
void _handleSubmit() {
  var isValid = true;
  if (_nameController.text.trim().isEmpty) {
    ShadToaster.of(context).show(
      const ShadToast(
        title: Text('Validation Error'),
        description: Text('Paint name is required'),
      ),
    );
    isValid = false;
  }
  // ... more manual checks
}

// TO: Use ShadForm validation for text fields, manual for brand/color
void _handleSubmit() {
  // Validate form fields (name, brandMakerId)
  if (!_formKey.currentState!.saveAndValidate()) {
    // ShadInputFormField validators will show inline errors
    return;
  }
  
  // Validate brand (not a form field - still use toast)
  if (_selectedBrand == null) {
    ShadToaster.of(context).show(
      const ShadToast(
        title: Text('Validation Error'),
        description: Text('Please select a brand'),
      ),
    );
    return;
  }
  
  // Validate color (not a form field - still use toast)
  if (_selectedLabColor == null) {
    ShadToaster.of(context).show(
      const ShadToast(
        title: Text('Validation Error'),
        description: Text('Please select a color'),
      ),
    );
    return;
  }
  
  // All validations passed - create form data and submit
  final formData = PaintFormData(
    name: _nameController.text.trim(),
    brand: _selectedBrand!,
    labColor: _selectedLabColor!,
    isValidGamut: _isValidGamut,
    brandMakerId: _brandMakerIdController.text.trim().isEmpty
        ? null
        : _brandMakerIdController.text.trim(),
  );
  
  widget.onSubmit(formData);
}
```

**Testing Checklist**:
- [ ] `flutter test test/shared/widgets/paint_form_test.dart` - all tests pass
- [ ] Paint name validation shows inline error (not toast)
- [ ] Brand validation still shows toast (not form field)
- [ ] Color validation still shows toast (not form field)
- [ ] Optional product code accepts empty values
- [ ] Form submission works with valid data
- [ ] Loading state disables fields properly
- [ ] Pre-population works in edit mode

**Commit**: `refactor(paint_form): migrate text fields to ShadInputFormField`

---

### Task 2: Replace BrandDropdown with ShadSelectFormField ✅ Priority: HIGH

**Test-First Approach**:
1. Update tests to find ShadSelectFormField instead of BrandDropdown
2. Tests FAIL
3. Implement migration
4. Tests PASS

**Strategy**: Remove `brand_dropdown.dart` wrapper entirely, use `ShadSelectFormField` directly at usage sites.

**Files to Update**:
- `lib/shared/widgets/paint_form.dart` (usage site)
- DELETE: `lib/shared/widgets/brand_dropdown.dart` (remove file)

**Changes in paint_form.dart** (Lines 240-250):

```dart
// FROM:
BrandDropdown(
  brands: widget.allAvailableBrands,
  selectedBrand: _selectedBrand,
  onChanged: (brand) {
    setState(() {
      _selectedBrand = brand;
    });
  },
  helperText: 'Select the paint manufacturer',
),

// TO:
ShadSelectFormField<PaintBrand>(
  id: 'brand',
  label: const Text('Brand *'),
  placeholder: const Text('Select paint brand'),
  initialValue: _selectedBrand,
  options: widget.allAvailableBrands.map(
    (brand) => ShadOption(
      value: brand,
      child: Row(
        children: [
          const Icon(LucideIcons.paintBucket, size: 16),
          const SizedBox(width: 8),
          Text(_getBrandDisplayName(brand)),
        ],
      ),
    ),
  ).toList(),
  selectedOptionBuilder: (context, value) {
    return Row(
      children: [
        const Icon(LucideIcons.paintBucket, size: 16),
        const SizedBox(width: 8),
        Text(_getBrandDisplayName(value)),
      ],
    );
  },
  onChanged: (value) {
    if (value != null) {
      setState(() {
        _selectedBrand = value;
      });
    }
  },
  validator: (value) {
    if (value == null) {
      return 'Please select a brand';
    }
    return null;
  },
  enabled: !widget.isLoading,
),
```

**Add helper method to _PaintFormState** (after line 156):
```dart
/// Returns user-friendly display name for a brand.
String _getBrandDisplayName(PaintBrand brand) {
  return switch (brand) {
    PaintBrand.vallejo => 'Vallejo',
    PaintBrand.citadel => 'Citadel',
    PaintBrand.armyPainter => 'Army Painter',
    PaintBrand.reaper => 'Reaper',
    PaintBrand.scale75 => 'Scale75',
    PaintBrand.other => 'Other',
  };
}
```

**Update paint_form.dart Imports**:
```dart
// REMOVE:
import 'package:paint_color_resolver/shared/widgets/brand_dropdown.dart';
```

**Update validation in _handleSubmit()** (Lines 173-182):
```dart
// REMOVE manual brand validation - now handled by ShadSelectFormField validator
// DELETE THESE LINES:
if (_selectedBrand == null) {
  ShadToaster.of(context).show(
    const ShadToast(
      title: Text('Validation Error'),
      description: Text('Please select a brand'),
    ),
  );
  return;
}

// Brand validation now happens in saveAndValidate() call
```

**Delete file**:
```bash
rm lib/shared/widgets/brand_dropdown.dart
```

**Testing Checklist**:
- [ ] `flutter test` - all tests pass
- [ ] Brand dropdown displays all brands with icons
- [ ] Brand selection updates state
- [ ] Inline validation error shows when not selected
- [ ] Paint bucket icon displays correctly
- [ ] Form submission validates brand

**Commit**: `refactor: replace BrandDropdown with ShadSelectFormField`

---

### Task 3: Replace Slider in color_mixer_screen.dart ✅ Priority: HIGH

**Test-First**: Update slider tests to find ShadSlider

**File**: `lib/features/color_calculation/presentation/screens/color_mixer_screen.dart`

**Changes Required**:

**1. Update Imports**:
```dart
// REMOVE:
import 'package:flutter/material.dart' show Material, Slider;

// shadcn_ui already imported - no add needed
```

**2. Replace Slider** (Lines 226-238):
```dart
// FROM:
Material(
  child: Slider(
    value: maxDeltaE,
    min: 1,
    max: 20,
    divisions: 19,
    label: maxDeltaE.toStringAsFixed(1),
    onChanged: (value) {
      ref.read(maxDeltaEThresholdProvider.notifier).setMaxDeltaE(value);
      _log.fine('Set max Delta E to: $value');
    },
  ),
),

// TO:
ShadSlider(
  value: maxDeltaE,
  min: 1,
  max: 20,
  onChanged: (value) {
    ref.read(maxDeltaEThresholdProvider.notifier).setMaxDeltaE(value);
    _log.fine('Set max Delta E to: $value');
  },
),
```

**Note**: 
- Value display already exists in Container (lines 207-222) ✅
- `divisions` and `label` not needed with shadcn approach
- User sees value in persistent Container, not thumb tooltip

**Testing Checklist**:
- [ ] `flutter test test/features/color_calculation/.../color_mixer_screen_test.dart` passes
- [ ] Slider adjusts quality threshold correctly
- [ ] Value updates in real-time in Container display
- [ ] Provider state updates properly
- [ ] Visual appearance matches shadcn design

**Commit**: `refactor(color_mixer): migrate Slider to ShadSlider`

---

### Task 4: Build Custom Bottom Navigation ✅ Priority: HIGH

**Test-First**: Update nav tests to find custom implementation

**File**: `lib/shared/widgets/responsive_bottom_nav.dart`

**Changes Required**:

**1. Update Imports**:
```dart
// REMOVE:
import 'package:flutter/material.dart'
    show
        BottomNavigationBar,
        BottomNavigationBarItem,
        BottomNavigationBarType,
        Material;

// KEEP:
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
```

**2. Replace Entire build() Method** (Lines 50-87):
```dart
@override
Widget build(BuildContext context) {
  final theme = ShadTheme.of(context);
  
  return Container(
    decoration: BoxDecoration(
      color: theme.colorScheme.card,
      border: Border(
        top: BorderSide(
          color: theme.colorScheme.border,
          width: 1,
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.foreground.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              icon: LucideIcons.palette,
              label: 'Mixer',
              index: 0,
              isActive: activeIndex == 0,
              onTap: () => onTabChanged(0),
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.list,
              label: 'Library',
              index: 1,
              isActive: activeIndex == 1,
              onTap: () => onTabChanged(1),
            ),
            _buildNavItem(
              context: context,
              icon: LucideIcons.ellipsis,
              label: 'More',
              index: 2,
              isActive: activeIndex == 2,
              onTap: () {
                if (onMoreTapped != null) {
                  onMoreTapped!();
                } else {
                  onTabChanged(2);
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}
```

**3. Add Helper Method** (after build method):
```dart
Widget _buildNavItem({
  required BuildContext context,
  required IconData icon,
  required String label,
  required int index,
  required bool isActive,
  required VoidCallback onTap,
}) {
  final theme = ShadTheme.of(context);
  
  return Expanded(
    child: ShadButton.ghost(
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.mutedForeground,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.small.copyWith(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.mutedForeground,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
```

**Design Notes**:
- Uses `Container` with border/shadow for visual separation
- `SafeArea` ensures proper spacing on devices with notches
- `Row` with `MainAxisAlignment.spaceAround` for equal spacing
- `ShadButton.ghost` provides default hover effects (per user decision)
- Active state uses primary color
- Maintains exact API: `activeIndex`, `onTabChanged`, `onMoreTapped`

**Testing Checklist**:
- [ ] `flutter test test/shared/widgets/responsive_bottom_nav_test.dart` passes
- [ ] Three nav items display correctly
- [ ] Active tab highlights with primary color
- [ ] Tap callbacks work for all tabs
- [ ] More button triggers correct callback
- [ ] Safe area respected on different screen sizes

**Commit**: `refactor: build custom bottom navigation with shadcn components`

---

### Task 5: Fix Navigator Imports in Screen Files ✅ Priority: HIGH

**Files**:
- `lib/features/paint_library/presentation/screens/edit_paint_screen.dart`
- `lib/features/paint_library/presentation/screens/paint_library_screen.dart`

**Changes Required**:

**Both files** (Line 4):
```dart
// FROM:
import 'package:flutter/material.dart' hide TextButton;

// TO:
// (REMOVE - flutter/widgets.dart already imported and contains Navigator)
```

**Verification**:
- Both files already have: `import 'package:flutter/widgets.dart';` (contains Navigator)
- `Navigator.pop(context)` works identically from `widgets.dart`
- No code changes needed beyond import removal

**Testing Checklist**:
- [ ] `flutter analyze` - 0 issues
- [ ] Edit paint screen: Delete confirmation works
- [ ] Library screen: Delete confirmation works
- [ ] Navigation back works correctly

**Commit**: `refactor: remove Material imports from screen files`

---

### Task 6: Fix vallejo_paints_seed.dart Color Import ✅ Priority: MEDIUM

**File**: `lib/core/database/seeds/vallejo_paints_seed.dart`

**Changes Required** (Line 1):
```dart
// FROM:
import 'package:flutter/material.dart' show Color;

// TO:
import 'dart:ui' show Color;
```

**Verification**: 
- `dart:ui` Color is compatible (verified - no `.withOpacity()` usage)
- All color manipulation uses `.withValues(alpha:)` ✅

**Testing Checklist**:
- [ ] `flutter analyze` - 0 issues
- [ ] Database seed still works
- [ ] Colors parse correctly
- [ ] Run app, check Vallejo paints display

**Commit**: `refactor: change Color import to dart:ui in seed file`

---

## Verification & Testing

### Step 1: Code Analysis
```bash
cd D:\lukasz\dev\projects\paint_color_resolver\paint_color_resolver
flutter analyze
# Expected: 0 issues
```

### Step 2: Search for Remaining Material Usage
```bash
# Windows PowerShell:
Get-ChildItem -Recurse -Filter "*.dart" lib\ | Select-String "package:flutter/material.dart"
# Expected: No results
```

### Step 3: Run All Tests (Widget + Unit)
```bash
flutter test
# Expected: All tests pass (4 unit + new widget tests)
```

### Step 4: Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
# Expected: 0 issues after codegen
```

### Step 5: Manual Testing on Windows
```bash
flutter run -d windows
```

**Detailed Test Scenarios**:

#### 1. Paint Form Tests

| Test Case | Steps | Expected Result | Pass/Fail |
|-----------|-------|-----------------|-----------|
| Name validation | 1. Open Add Paint<br>2. Leave name empty<br>3. Click submit | Inline error "Paint name is required" below field | ☐ |
| Brand validation | 1. Enter name<br>2. Leave brand unselected<br>3. Click submit | Inline error "Please select a brand" below dropdown | ☐ |
| Color validation | 1. Enter name<br>2. Select brand<br>3. Leave color default<br>4. Click submit | Toast "Please select a color" | ☐ |
| Valid submission | 1. Enter all fields<br>2. Click submit | Paint added, navigates back, success toast | ☐ |
| Pre-population | 1. Edit existing paint | All fields show current values | ☐ |
| Loading state | 1. Submit form<br>2. Check during async operation | All fields disabled, button shows spinner | ☐ |
| Optional field | 1. Leave product code empty<br>2. Submit valid form | Submission succeeds (no error) | ☐ |

#### 2. Brand Dropdown Tests

| Test Case | Steps | Expected Result | Pass/Fail |
|-----------|-------|-----------------|-----------|
| Display all brands | Open dropdown | Shows Vallejo, Citadel, Army Painter, Reaper, Scale75, Other | ☐ |
| Brand icons | Open dropdown | Paint bucket icon shows for each option | ☐ |
| Selection | Select "Vallejo" | Dropdown shows "Vallejo" with icon | ☐ |
| Required indicator | View label | Shows "Brand *" (asterisk) | ☐ |
| Validation error | Submit without selecting | Inline error below dropdown | ☐ |

#### 3. Slider Tests

| Test Case | Steps | Expected Result | Pass/Fail |
|-----------|-------|-----------------|-----------|
| Value display | View mixer screen | Shows "Max Delta E" with current value in badge | ☐ |
| Drag slider | Drag to different position | Badge value updates in real-time | ☐ |
| Value persistence | Change value, navigate away, return | Value persists (from provider) | ☐ |
| Visual style | View slider | Matches shadcn design (no Material styling) | ☐ |

#### 4. Bottom Navigation Tests

| Test Case | Steps | Expected Result | Pass/Fail |
|-----------|-------|-----------------|-----------|
| Three tabs | View bottom nav | Shows Mixer, Library, More with icons | ☐ |
| Active highlight | Navigate to Library | Library tab shows primary color, others muted | ☐ |
| Tap navigation | Tap Mixer tab | Navigates to Mixer screen, tab highlighted | ☐ |
| More button | Tap More | Triggers More callback/menu | ☐ |
| Safe area | Test on device with notch | Bottom nav respects safe area | ☐ |

#### 5. Screen Navigation Tests

| Test Case | Steps | Expected Result | Pass/Fail |
|-----------|-------|-----------------|-----------|
| Edit paint delete | 1. Edit paint<br>2. Tap delete<br>3. Confirm | Dialog shows, paint deleted, navigates back | ☐ |
| Library delete | 1. Delete paint from library<br>2. Confirm | Dialog shows, paint deleted, list updates | ☐ |

#### 6. Overall UI Consistency

| Test Case | Steps | Expected Result | Pass/Fail |
|-----------|-------|-----------------|-----------|
| No Material styling | Navigate all screens | No Material design elements visible | ☐ |
| Consistent theme | View all components | All use shadcn_ui theme colors/styles | ☐ |
| No errors | Use app normally | No console errors or warnings | ☐ |
| Performance | Navigate, interact | Smooth, no lag (similar to before) | ☐ |

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Form validation UX differs | High | Medium | Manual testing of all validation scenarios |
| Bottom nav UX differs | Medium | Medium | Side-by-side comparison with baseline screenshots |
| Tests reveal regressions | Medium | High | TDD approach catches issues before production |
| Build failures | Low | High | flutter clean + regenerate after each task |
| Missed Material import | Low | High | Comprehensive search in Step 2 |
| Navigator.pop breaks | Very Low | Medium | Verified Navigator is in widgets.dart |

---

## Success Criteria

✅ **Must Have**:
- [ ] Zero Material imports (except dart:ui Color)
- [ ] All functionality identical to baseline
- [ ] `flutter analyze`: 0 issues
- [ ] All tests pass (widget + unit)
- [ ] App runs on Windows without errors
- [ ] Manual test scenarios: 100% pass

✅ **Should Have**:
- [ ] Consistent shadcn design across all components
- [ ] Improved code maintainability (less wrappers)
- [ ] Comprehensive widget test coverage
- [ ] Documentation updated (AGENTS.md if needed)

---

## Timeline Estimate

| Task | Time | Priority |
|------|------|----------|
| 0. Set up widget tests | 2-3 hours | CRITICAL |
| 1. paint_form.dart text fields | 45-60 min | HIGH |
| 2. Replace BrandDropdown | 30-45 min | HIGH |
| 3. color_mixer_screen.dart slider | 15-20 min | HIGH |
| 4. responsive_bottom_nav.dart | 60-75 min | HIGH |
| 5. Fix Navigator imports | 5-10 min | HIGH |
| 6. vallejo_paints_seed.dart | 2-5 min | MEDIUM |
| Verification & search | 15 min | HIGH |
| Manual testing | 45-60 min | HIGH |

**Total**: 5-7 hours (including test writing)

---

## Git Strategy

**Branch**: `feature/remove-material-package`

**Commit Pattern**:
- After each task completion
- Separate commits for tests vs implementation
- Descriptive messages following conventional commits

**Example Commits**:
```
test: add baseline widget tests for Material components
test: update paint_form tests for ShadInputFormField
refactor(paint_form): migrate text fields to ShadInputFormField
test: update brand dropdown tests for ShadSelectFormField
refactor: replace BrandDropdown with ShadSelectFormField
refactor(color_mixer): migrate Slider to ShadSlider
refactor: build custom bottom navigation with shadcn components
refactor: remove Material imports from screen files
refactor: change Color import to dart:ui in seed file
docs: update AGENTS.md with Material removal notes
```

**Final PR**:
- Title: "feat: complete Material package removal, migrate to shadcn_ui"
- Include before/after screenshots
- Reference this plan document

---

**End of Updated Plan**
