import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Mobile bottom navigation bar widget for the Paint Color Resolver app.
///
/// Displays a bottom navigation bar suitable for mobile/small screens with
/// tabs for the main app features. Uses Lucide icons and adapts to the
/// current active tab.
///
/// ## Features:
/// - Fixed bottom position with safe area awareness
/// - Lucide icon library for consistency
/// - 3 tabs: Mixer, Library, More
/// - Active tab highlighting with color change
/// - Index-based tab callbacks for AutoTabsRouter
///
/// ## Layout:
/// ```text
/// ┌─────────────────────────────────┐
/// │  Screen Content                 │
/// │                                 │
/// ├─────────────────────────────────┤
/// │  [Icon] [Icon] [Icon]           │
/// │ Mixer  Library More             │
/// └─────────────────────────────────┘
/// ```
class ResponsiveBottomNav extends StatelessWidget {
  const ResponsiveBottomNav({
    required this.activeIndex,
    required this.onTabChanged,
    this.onMoreTapped,
    super.key,
  });

  /// The currently selected tab index (0 = Mixer, 1 = Library, 2 = More)
  final int activeIndex;

  /// Callback when a tab navigation item is tapped
  final ValueChanged<int> onTabChanged;

  /// Callback for the "More" menu (settings, about, etc.)
  final VoidCallback? onMoreTapped;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.border,
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
                isActive: activeIndex == 0,
                onTap: () => onTabChanged(0),
              ),
              _buildNavItem(
                context: context,
                icon: LucideIcons.list,
                label: 'Library',
                isActive: activeIndex == 1,
                onTap: () => onTabChanged(1),
              ),
              _buildNavItem(
                context: context,
                icon: LucideIcons.ellipsis,
                label: 'More',
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
}
