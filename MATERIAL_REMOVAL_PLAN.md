# Material Package Removal Plan

**Project**: Paint Color Resolver  
**Date**: February 13, 2026  
**Goal**: Completely remove Material package dependency and replace all Material widgets with shadcn_ui alternatives

---

## Executive Summary

The app currently uses several Material widgets (TextFormField, DropdownButtonFormField, Slider, BottomNavigationBar) which require Material widget ancestors in the widget tree. This causes runtime errors when used within the shadcn_ui-only app structure. This plan outlines a complete migration to shadcn_ui components.

---

## Current State Analysis

### Material Widget Usage

| File | Material Widgets Used | Line Numbers |
|------|----------------------|--------------|
| `lib/shared/widgets/paint_form.dart` | TextFormField (2x), Material wrapper | 224-236, 255-267 |
| `lib/shared/widgets/brand_dropdown.dart` | DropdownButtonFormField, Material wrapper | 94-130 |
| `lib/features/color_calculation/presentation/screens/color_mixer_screen.dart` | Slider, Material wrapper | 226-238 |
| `lib/shared/widgets/responsive_bottom_nav.dart` | BottomNavigationBar, BottomNavigationBarItem, Material wrapper | 52-86 |
| `lib/core/database/seeds/vallejo_paints_seed.dart` | Color class import | 1 |

### Total Material Imports: 5 files

---

## Implementation Decisions

Following user consultation, these decisions were made:

1. **Form Validation Strategy**: Switch to `ShadInputFormField` with built-in validation (more idiomatic shadcn approach)
2. **Brand Dropdown**: Keep as wrapper component around `ShadSelect` to maintain existing API
3. **Slider Styling**: Use `ShadSlider` default styling (clean shadcn look)
4. **Icon Replacement**: Use `LucideIcons.paintBucket` for brand dropdown
5. **Bottom Navigation**: Build custom component using Container + Row + ShadButton

---

## Detailed Implementation Plan

### Task 1: Refactor paint_form.dart ✅ Priority: HIGH

**File**: `lib/shared/widgets/paint_form.dart`

**Changes Required**:

1. **Update Imports**:
   - ❌ Remove: `import 'package:flutter/material.dart' show InputDecoration, Material, OutlineInputBorder, TextFormField;`
   - ✅ Ensure: `import 'package:shadcn_ui/shadcn_ui.dart';` is present

2. **Replace Paint Name Field** (Lines 224-236):
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
     id: 'name',
     controller: _nameController,
     label: const Text('Paint Name'),
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

3. **Replace Brand Maker ID Field** (Lines 255-267):
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
     // No validator needed - this field is optional
   ),
   ```

4. **Refactor Validation Logic** in `_handleSubmit()` method:
   ```dart
   // FROM: Manual validation with toast messages
   void _handleSubmit() {
     var isValid = true;
     if (_nameController.text.trim().isEmpty) {
       ShadToaster.of(context).show(...);
       isValid = false;
     }
     // ... more manual checks
   }
   
   // TO: Use ShadForm validation
   void _handleSubmit() {
     if (!_formKey.currentState!.saveAndValidate()) {
       // Form validation failed, errors shown on fields
       return;
     }
     
     // Validate brand (not in form fields)
     if (_selectedBrand == null) {
       ShadToaster.of(context).show(
         const ShadToast(
           title: Text('Validation Error'),
           description: Text('Please select a brand'),
         ),
       );
       return;
     }
     
     // Validate color (not in form fields)
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
     final formData = PaintFormData(...);
     widget.onSubmit(formData);
   }
   ```

**Testing Checklist**:
- [ ] Paint name validation triggers on empty input
- [ ] Optional product code accepts empty values
- [ ] Form submission works correctly
- [ ] Loading state disables fields properly

---

### Task 2: Update brand_dropdown.dart ✅ Priority: HIGH

**File**: `lib/shared/widgets/brand_dropdown.dart`

**Changes Required**:

1. **Update Imports**:
   - ❌ Remove: `import 'package:flutter/material.dart' show DropdownButtonFormField, DropdownMenuItem, InputDecoration, Material, OutlineInputBorder;`
   - ✅ Add: `import 'package:shadcn_ui/shadcn_ui.dart';`
   - ✅ Keep: `import 'package:flutter/widgets.dart';`

2. **Replace DropdownButtonFormField with ShadSelect** (Lines 94-130):
   ```dart
   // FROM:
   return Material(
     child: DropdownButtonFormField<PaintBrand>(
       initialValue: selectedBrand,
       items: brands.map((brand) => DropdownMenuItem<PaintBrand>(
         value: brand,
         child: Text(getBrandDisplayName(brand)),
       )).toList(),
       onChanged: (newBrand) {
         if (newBrand != null) {
           onChanged(newBrand);
         }
       },
       decoration: InputDecoration(
         labelText: isRequired ? '$label *' : label,
         helperText: helperText,
         errorText: errorText,
         prefixIcon: const Icon(IconData(0xe3b8, fontFamily: 'MaterialIcons')),
         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
       ),
     ),
   );
   
   // TO:
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     mainAxisSize: MainAxisSize.min,
     children: [
       if (label.isNotEmpty)
         Padding(
           padding: const EdgeInsets.only(bottom: 8),
           child: Text(
             isRequired ? '$label *' : label,
             style: ShadTheme.of(context).textTheme.small,
           ),
         ),
       ShadSelect<PaintBrand>(
         placeholder: Text('Select ${label.toLowerCase()}'),
         initialValue: selectedBrand,
         options: brands.map(
           (brand) => ShadOption(
             value: brand,
             child: Row(
               children: [
                 const Icon(LucideIcons.paintBucket, size: 16),
                 const SizedBox(width: 8),
                 Text(getBrandDisplayName(brand)),
               ],
             ),
           ),
         ).toList(),
         selectedOptionBuilder: (context, value) {
           return Row(
             children: [
               const Icon(LucideIcons.paintBucket, size: 16),
               const SizedBox(width: 8),
               Text(getBrandDisplayName(value)),
             ],
           );
         },
         onChanged: (value) {
           if (value != null) {
             onChanged(value);
           }
         },
       ),
       if (helperText != null)
         Padding(
           padding: const EdgeInsets.only(top: 4),
           child: Text(
             helperText!,
             style: ShadTheme.of(context).textTheme.muted,
           ),
         ),
       if (errorText != null)
         Padding(
           padding: const EdgeInsets.only(top: 4),
           child: Text(
             errorText!,
             style: ShadTheme.of(context).textTheme.small.copyWith(
               color: ShadTheme.of(context).colorScheme.destructive,
             ),
           ),
         ),
     ],
   );
   ```

**Testing Checklist**:
- [ ] Dropdown displays all brands correctly
- [ ] Brand selection callback works
- [ ] Label, helper text, and error text display properly
- [ ] Paint bucket icon shows correctly
- [ ] Maintains same API for existing usage sites

---

### Task 3: Replace Slider in color_mixer_screen.dart ✅ Priority: HIGH

**File**: `lib/features/color_calculation/presentation/screens/color_mixer_screen.dart`

**Changes Required**:

1. **Update Imports**:
   - ❌ Remove: `import 'package:flutter/material.dart' show Material, Slider;`
   - ✅ Ensure: `import 'package:shadcn_ui/shadcn_ui.dart';` is present

2. **Replace Slider Widget** in `_buildQualityThresholdSlider()` method (Lines 226-238):
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
- ShadSlider uses default shadcn styling (cleaner look)
- `divisions` and `label` parameters not needed with shadcn approach
- Value display is already handled by the Container above the slider (lines 207-222)

**Testing Checklist**:
- [ ] Slider adjusts quality threshold correctly
- [ ] Value updates in real-time
- [ ] Provider state updates properly
- [ ] Visual appearance matches shadcn design system

---

### Task 4: Build Custom Bottom Navigation ✅ Priority: HIGH

**File**: `lib/shared/widgets/responsive_bottom_nav.dart`

**Changes Required**:

1. **Update Imports**:
   - ❌ Remove: `import 'package:flutter/material.dart' show BottomNavigationBar, BottomNavigationBarItem, BottomNavigationBarType, Material;`
   - ✅ Keep: `import 'package:flutter/widgets.dart';`
   - ✅ Keep: `import 'package:shadcn_ui/shadcn_ui.dart';`

2. **Replace BottomNavigationBar with Custom Implementation** (Lines 52-86):
   ```dart
   // FROM:
   return Material(
     child: BottomNavigationBar(
       currentIndex: activeIndex,
       onTap: (index) { ... },
       type: BottomNavigationBarType.fixed,
       elevation: 8,
       items: const [
         BottomNavigationBarItem(icon: Icon(LucideIcons.palette), label: 'Mixer'),
         BottomNavigationBarItem(icon: Icon(LucideIcons.list), label: 'Library'),
         BottomNavigationBarItem(icon: Icon(LucideIcons.ellipsis), label: 'More'),
       ],
     ),
   );
   
   // TO:
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
- Uses `Container` with border and shadow for visual separation
- `SafeArea` ensures proper spacing on devices with notches/home indicators
- `Row` with `MainAxisAlignment.spaceAround` for equal spacing
- `ShadButton.ghost` for each nav item (minimal background, hover effects)
- Active state highlighted with primary color
- Maintains exact same API: `activeIndex`, `onTabChanged`, `onMoreTapped`

**Testing Checklist**:
- [ ] Navigation items display correctly
- [ ] Active tab highlights properly
- [ ] Tap callbacks work for all tabs
- [ ] Safe area respected on different devices
- [ ] Visual appearance matches design expectations
- [ ] More button triggers correct callback

---

### Task 5: Fix vallejo_paints_seed.dart ✅ Priority: MEDIUM

**File**: `lib/core/database/seeds/vallejo_paints_seed.dart`

**Changes Required**:

1. **Update Import** (Line 1):
   ```dart
   // FROM:
   import 'package:flutter/material.dart' show Color;
   
   // TO:
   import 'dart:ui' show Color;
   ```

**Note**: The `Color` class is available in `dart:ui` and doesn't require Material package.

**Testing Checklist**:
- [ ] Database seed still works correctly
- [ ] Colors parse properly
- [ ] No import errors

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
grep -r "from 'package:flutter/material.dart'" lib/
# Expected: No results (empty output)
```

### Step 3: Run Unit Tests
```bash
flutter test
# Expected: All tests pass
```

### Step 4: Run with Code Generation
```bash
dart run build_runner build --delete-conflicting-outputs
flutter analyze
```

### Step 5: Manual Testing on Windows
```bash
flutter run -d windows
```

**Test Scenarios**:
1. Paint Form: validation, submission, pre-population
2. Brand Dropdown: display, selection, icons
3. Slider: smooth movement, value updates
4. Bottom Navigation: tab switching, active highlighting
5. Overall UI: consistent styling, no errors

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Form validation differs | Medium | High | Thorough testing of all scenarios |
| Bottom nav UX differs | Medium | Medium | Iterate on spacing/sizing |
| ShadSlider differs | Low | Low | Test thoroughly |
| Tests fail | High | Medium | Update test finders |
| Build failures | Low | High | flutter clean + regenerate |

---

## Success Criteria

✅ **Must Have**:
- [ ] Zero Material imports (except dart:ui Color)
- [ ] All functionality identical
- [ ] flutter analyze: 0 issues
- [ ] All tests pass
- [ ] App runs on Windows

✅ **Should Have**:
- [ ] Consistent shadcn design
- [ ] Improved maintainability
- [ ] Updated documentation

---

## Timeline Estimate

| Task | Time | Priority |
|------|------|----------|
| 1. paint_form.dart | 30-45 min | HIGH |
| 2. brand_dropdown.dart | 20-30 min | HIGH |
| 3. color_mixer_screen.dart | 10-15 min | HIGH |
| 4. responsive_bottom_nav.dart | 45-60 min | HIGH |
| 5. vallejo_paints_seed.dart | 2-5 min | MEDIUM |
| 6. Analysis & search | 10 min | HIGH |
| 7. Tests | 20-30 min | HIGH |
| 8. Manual testing | 30-45 min | HIGH |

**Total**: 2.5 - 4 hours

---

**End of Plan**
