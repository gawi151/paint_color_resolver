# Plan: ZERO Material Design - Complete Scaffold Replacement

## Goal

**ELIMINATE ALL MATERIAL IMPORTS** from screen files. Create a pure shadcn_ui app using only basic Flutter widgets (Column, Row, Stack) + shadcn_ui components.

---

## Architecture

### Current Problem
- Every screen uses `Scaffold` from material.dart
- Scaffold requires material import
- This keeps Material theming and styling in the app

### Solution
Create a custom `AppLayout` widget that replaces Scaffold entirely, using only:
- `Column` for layout
- `SafeArea` for padding
- `ShadButton` for navigation
- `Container` for backgrounds
- ShadTheme for colors

NO Material widgets, NO material.dart import in screen files.

---

## NEW COMPONENT: AppLayout

**File**: `lib/shared/widgets/app_layout.dart`

This is the CORE replacement for Scaffold. It handles:
- Top app bar with back button
- Body content
- Bottom navigation (optional)
- Floating action button (optional, as positioned button)

```dart
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Complete Scaffold replacement using only shadcn_ui + basic Flutter widgets
class AppLayout extends StatelessWidget {
  const AppLayout({
    required this.body,
    this.title,
    this.actions,
    this.bottomNav,
    this.floatingAction,
    this.showBackButton = true,
    this.backgroundColor,
    super.key,
  });

  /// Main content of the screen
  final Widget body;

  /// Title shown in the top bar
  final Widget? title;

  /// Action buttons shown on the right of the top bar
  final List<Widget>? actions;

  /// Bottom navigation bar
  final Widget? bottomNav;

  /// Floating action button (will be positioned absolutely)
  final Widget? floatingAction;

  /// Whether to show back button in top bar
  final bool showBackButton;

  /// Optional background color override
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ColoredBox(
      color: backgroundColor ?? theme.colorScheme.background,
      child: Column(
        children: [
          // Top App Bar
          _AppBar(
            title: title,
            actions: actions,
            showBackButton: showBackButton,
          ),

          // Body content
          Expanded(child: body),

          // Bottom navigation (if provided)
          if (bottomNav != null) bottomNav!,
        ],
      ),
    );
  }
}

/// Custom app bar widget (no Material dependency)
class _AppBar extends StatelessWidget {
  const _AppBar({
    this.title,
    this.actions,
    this.showBackButton = true,
  });

  final Widget? title;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.border,
            width: 1,
          ),
        ),
        color: theme.colorScheme.background,
      ),
      child: Row(
        children: [
          // Back button
          if (showBackButton)
            ShadButton.ghost(
              icon: const Icon(LucideIcons.chevronLeft, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          const SizedBox(width: 8),
          // Title
          if (title != null)
            Expanded(
              child: DefaultTextStyle(
                style: theme.textTheme.h4.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                child: title!,
              ),
            ),
          // Actions
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
```

---

## MODIFIED COMPONENT: ResponsiveBottomNav (pure shadcn_ui)

**File**: `lib/shared/widgets/responsive_bottom_nav.dart`

```dart
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Mobile bottom navigation - NO Material components
class ResponsiveBottomNav extends StatelessWidget {
  const ResponsiveBottomNav({
    required this.activeIndex,
    required this.onTabChanged,
    this.onMoreTapped,
    super.key,
  });

  final int activeIndex;
  final ValueChanged<int> onTabChanged;
  final VoidCallback? onMoreTapped;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.colorScheme.border),
        ),
        color: theme.colorScheme.background,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: LucideIcons.palette,
                label: 'Mixer',
                isActive: activeIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              _NavItem(
                icon: LucideIcons.list,
                label: 'Library',
                isActive: activeIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              _NavItem(
                icon: LucideIcons.moreHorizontal,
                label: 'More',
                isActive: activeIndex == 2,
                onTap: onMoreTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Expanded(
      child: ShadButton.ghost(
        onPressed: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.mutedForeground,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.small.copyWith(
                fontSize: 11,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.mutedForeground,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## SCREEN REWRITES

### 1. paint_library_screen.dart

**REMOVE**: `import 'package:flutter/material.dart';`
**ADD**: `import 'package:paint_color_resolver/shared/widgets/app_layout.dart';`

**Complete build method replacement**:

```dart
@override
Widget build(BuildContext context) {
  final searchParams = PaintSearchParams(query: _searchQuery);
  final searchResultsAsync = ref.watch(paintSearchProvider(searchParams));

  return ShadToaster(
    child: AppLayout(
      title: const Text('Paint Inventory'),
      floatingAction: ShadButton(
        icon: const Icon(LucideIcons.plus),
        onPressed: _navigateToAddPaint,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: ShadInput(
              controller: _searchController,
              placeholder: const Text('Search paints...'),
              leading: const Icon(LucideIcons.search),
              trailing: _searchQuery.isNotEmpty
                  ? ShadButton.ghost(
                      leading: const Icon(LucideIcons.x, size: 16),
                      onPressed: () {
                        _debounce?.cancel();
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
            ),
          ),
          // Paint list
          Expanded(
            child: searchResultsAsync.when(
              data: (results) {
                if (results.isEmpty) {
                  return _buildEmptyState(context);
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final paint = results[index];
                    return PaintCard(
                      paint: paint,
                      onEdit: () => _navigateToEditPaint(paint.id),
                      onDelete: () => _showDeleteConfirmation(
                        paintId: paint.id,
                        paintName: paint.name,
                        onConfirm: () async {
                          try {
                            await ref
                                .read(paintInventoryProvider.notifier)
                                .removePaint(paint.id);
                            if (context.mounted) {
                              ShadToaster.of(context).show(
                                ShadToast(title: Text('Deleted ${paint.name}')),
                              );
                            }
                          } on Exception catch (e) {
                            if (context.mounted) {
                              ShadToaster.of(context).show(
                                ShadToast.destructive(
                                  title: const Text('Error'),
                                  description: Text(e.toString()),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: ShadProgress()),
              error: (error, _) => _buildErrorState(context, error),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyState(BuildContext context) {
  final theme = ShadTheme.of(context);
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LucideIcons.palette, size: 64, color: theme.colorScheme.mutedForeground),
        const SizedBox(height: 16),
        Text('No paints in inventory', style: theme.textTheme.h4),
        const SizedBox(height: 8),
        Text('Add your first paint', style: theme.textTheme.muted),
        const SizedBox(height: 24),
        ShadButton(
          onPressed: _navigateToAddPaint,
          leading: const Icon(LucideIcons.plus),
          child: const Text('Add Paint'),
        ),
      ],
    ),
  );
}

Widget _buildErrorState(BuildContext context, Object error) {
  final theme = ShadTheme.of(context);
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(LucideIcons.circleX, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        Text('Error loading paints', style: theme.textTheme.h4),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(error.toString(), style: theme.textTheme.muted, textAlign: TextAlign.center),
        ),
        const SizedBox(height: 24),
        ShadButton(
          onPressed: () => ref.invalidate(paintInventoryProvider),
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
```

### 2. edit_paint_screen.dart

**REMOVE**: `import 'package:flutter/material.dart';`
**ADD**: `import 'package:paint_color_resolver/shared/widgets/app_layout.dart';`

```dart
@override
Widget build(BuildContext context) {
  final paintId = _paintId;
  final inventoryAsync = ref.watch(paintInventoryProvider);

  return AppLayout(
    title: const Text('Edit Paint'),
    actions: [
      ShadButton.ghost(
        leading: const Icon(LucideIcons.trash, size: 18),
        onPressed: _handleDelete,
      ),
    ],
    body: inventoryAsync.when(
      data: (paints) {
        final paint = paints.where((p) => p.id == paintId).firstOrNull;
        if (paint == null) {
          return _buildNotFound(context);
        }
        return ShadToaster(
          child: PaintForm(
            initialPaint: paint,
            allAvailableBrands: PaintBrand.values,
            onSubmit: _handleSubmit,
            submitLabel: 'Update',
            onCancel: () => context.router.pop(),
          ),
        );
      },
      loading: () => const Center(child: ShadProgress()),
      error: (error, _) => _buildError(context, error),
    ),
  );
}

Widget _buildNotFound(BuildContext context) {
  final theme = ShadTheme.of(context);
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(LucideIcons.circleX, size: 64),
        const SizedBox(height: 16),
        Text('Paint not found', style: theme.textTheme.h4),
        const SizedBox(height: 8),
        Text('It may have been deleted', style: theme.textTheme.muted),
        const SizedBox(height: 24),
        ShadButton(
          onPressed: () => context.router.pop(),
          child: const Text('Go Back'),
        ),
      ],
    ),
  );
}

Widget _buildError(BuildContext context, Object error) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(LucideIcons.circleX, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        Text('Error loading paint', style: ShadTheme.of(context).textTheme.h4),
        const SizedBox(height: 8),
        Text(error.toString(), style: ShadTheme.of(context).textTheme.muted),
        const SizedBox(height: 24),
        ShadButton(
          onPressed: () => context.router.pop(),
          child: const Text('Go Back'),
        ),
      ],
    ),
  );
}
```

### 3. add_paint_screen.dart

**REMOVE**: `import 'package:flutter/material.dart';`
**ADD**: `import 'package:paint_color_resolver/shared/widgets/app_layout.dart';`

```dart
@override
Widget build(BuildContext context) {
  return AppLayout(
    title: const Text('Add Paint'),
    body: ShadToaster(
      child: PaintForm(
        allAvailableBrands: PaintBrand.values,
        onSubmit: _handleSubmit,
        submitLabel: 'Add Paint',
        onCancel: () => context.router.pop(),
      ),
    ),
  );
}
```

### 4. color_mixer_screen.dart

**REMOVE**: `import 'package:flutter/material.dart';`
**ADD**: `import 'package:paint_color_resolver/shared/widgets/app_layout.dart';`

For Slider, create a custom widget:

**NEW**: `lib/shared/widgets/shad_slider.dart`

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ShadSlider extends StatefulWidget {
  const ShadSlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.label,
    super.key,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? Function(double)? label;

  @override
  State<ShadSlider> createState() => _ShadSliderState();
}

class _ShadSliderState extends State<ShadSlider> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final normalizedValue = (widget.value - widget.min) / (widget.max - widget.min);

    return Column(
      children: [
        SizedBox(
          height: 24,
          child: Stack(
            children: [
              // Track
              Positioned.fill(
                top: 11,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.mutedForeground.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              // Filled track
              Positioned(
                left: 0,
                right: MediaQuery.of(context).size.width * (1 - normalizedValue) - 32,
                top: 11,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              // Thumb
              Positioned(
                left: MediaQuery.of(context).size.width * normalizedValue - 32,
                top: 5,
                child: GestureDetector(
                  onHorizontalDragStart: (_) => setState(() => _isDragging = true),
                  onHorizontalDragEnd: (_) => setState(() => _isDragging = false),
                  onHorizontalDragUpdate: (details) {
                    final box = context.findRenderObject() as RenderBox;
                    final local = box.globalToLocal(details.globalPosition);
                    final newValue = widget.min +
                        (local.dx / box.size.width) * (widget.max - widget.min);
                    final clamped = newValue.clamp(widget.min, widget.max);
                    if (widget.divisions != null) {
                      final step = (widget.max - widget.min) / widget.divisions!;
                      final stepped = (clamped - widget.min) / step;
                      widget.onChanged((stepped.roundToDouble() * step) + widget.min);
                    } else {
                      widget.onChanged(clamped);
                    }
                  },
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (_isDragging)
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(alpha: 0.3),
                            blurRadius: 8,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(widget.label!(widget.value), style: theme.textTheme.small),
          ),
      ],
    );
  }
}
```

**color_mixer_screen.dart build method**:

```dart
@override
Widget build(BuildContext context) {
  final targetColor = ref.watch(targetColorProvider);

  return AppLayout(
    title: const Text('Color Mixer'),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Target Color
          Text('Target Color', style: ShadTheme.of(context).textTheme.h4),
          const SizedBox(height: 12),
          ColorPickerInput(
            initialHex: targetColor != null
                ? ColorConversionUtils.labToHex(targetColor)
                : '#FF0000',
            onColorChanged: (lab, {required isValidGamut}) {
              Future.microtask(() {
                ref.read(targetColorProvider.notifier).setTargetColor(lab);
              });
            },
          ),
          const SizedBox(height: 32),

          // Paint count selector
          Text('Number of Paints', style: ShadTheme.of(context).textTheme.h4),
          const SizedBox(height: 12),
          _buildPaintCountSelector(),
          const SizedBox(height: 32),

          // Quality threshold
          Text('Quality Threshold', style: ShadTheme.of(context).textTheme.h4),
          const SizedBox(height: 12),
          _buildQualitySlider(),
          const SizedBox(height: 32),

          // Calculate button
          ShadButton(
            onPressed: targetColor != null && !_isCalculating
                ? () => _calculateAndNavigate()
                : null,
            leading: _isCalculating
                ? const SizedBox(width: 16, height: 16, child: ShadProgress())
                : const Icon(LucideIcons.slidersHorizontal),
            child: Text(_isCalculating ? 'Calculating...' : 'Calculate Mixing'),
          ),
        ],
      ),
    ),
  );
}
```

### 5. mixing_results_screen.dart

**REMOVE**: `import 'package:flutter/material.dart';`
**ADD**: `import 'package:paint_color_resolver/shared/widgets/app_layout.dart';`

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final targetColor = ref.watch(targetColorProvider);
  final resultsAsync = ref.watch(sortedMixingResultsProvider);

  return AppLayout(
    title: const Text('Mixing Recommendations'),
    body: resultsAsync.when(
      data: (results) {
        if (results.isEmpty) {
          return _buildEmptyState(context);
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              if (targetColor != null) _buildTargetHeader(context, targetColor),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: results.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) => MixingResultCard(
                  result: results[index],
                  index: index + 1,
                  targetColor: targetColor,
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadProgress(),
            SizedBox(height: 16),
            Text('Calculating...'),
          ],
        ),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.circleX, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Calculation failed', style: ShadTheme.of(context).textTheme.h4),
            const SizedBox(height: 8),
            Text(error.toString(), style: ShadTheme.of(context).textTheme.muted),
            const SizedBox(height: 24),
            ShadButton(
              onPressed: () => context.router.pop(),
              leading: const Icon(LucideIcons.arrowLeft),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    ),
  );
}
```

### 6. paint_form.dart

**REMOVE**: `import 'package:flutter/material.dart';`

Replace TextFormField with ShadInput:

```dart
// Paint name field
ShadInput(
  controller: _nameController,
  placeholder: const Text('Paint Name'),
  enabled: !widget.isLoading,
)

// Product code field
ShadInput(
  controller: _brandMakerIdController,
  placeholder: const Text('Product Code (Optional)'),
  enabled: !widget.isLoading,
)
```

### 7. app_shell_screen.dart

**REMOVE**: `import 'package:flutter/material.dart';`

Mobile layout becomes:

```dart
} else {
  // Mobile layout - NO Scaffold
  return ShadToaster(
    child: Column(
      children: [
        Expanded(child: child),
        ResponsiveBottomNav(
          activeIndex: activeIndex,
          onTabChanged: tabsRouter.setActiveIndex,
          onMoreTapped: () {
            ShadToaster.of(context).show(
              const ShadToast(
                description: Text('More menu coming soon'),
              ),
            );
          },
        ),
      ],
    ),
  );
}
```

---

## EXECUTION ORDER

1. Create `app_layout.dart` - the core scaffold replacement
2. Create `shad_slider.dart` - custom slider component
3. Update `responsive_bottom_nav.dart` - remove Material
4. Update `paint_form.dart` - replace TextFormField
5. Update `app_shell_screen.dart` - remove Scaffold
6. Update screen files (paint_library, edit_paint, add_paint, color_mixer, mixing_results)
7. Verify no material imports in screen files

---

## FILES CHANGED SUMMARY

| File | Remove Import | Add Import |
|------|---------------|------------|
| paint_library_screen.dart | material.dart | app_layout.dart |
| edit_paint_screen.dart | material.dart | app_layout.dart |
| add_paint_screen.dart | material.dart | app_layout.dart |
| color_mixer_screen.dart | material.dart | app_layout.dart |
| mixing_results_screen.dart | material.dart | app_layout.dart |
| paint_form.dart | material.dart | - |
| responsive_bottom_nav.dart | - | - (no import change) |
| app_shell_screen.dart | material.dart | - |

NEW FILES:
- app_layout.dart
- shad_slider.dart
