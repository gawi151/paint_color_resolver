import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Desktop navigation rail widget for the Paint Color Resolver app.
///
/// Displays a vertical sidebar with navigation items for desktop/tablet screens.
/// Uses Lucide icons for a clean, modern appearance and highlights the
/// currently active tab.
///
/// ## Features:
/// - Fixed width sidebar (~80px with labels)
/// - Lucide icon library for consistency
/// - Active tab highlighting
/// - Smooth transitions between screens
/// - Index-based tab callbacks for AutoTabsRouter
///
/// ## Layout:
/// ```text
/// ┌─────────────┬───────────────────┐
/// │ [Icon] Name │  Screen Content   │
/// │ [Icon] Name │                   │
/// │             │                   │
/// └─────────────┴───────────────────┘
/// ```
class ResponsiveNavigationRail extends StatelessWidget {
  const ResponsiveNavigationRail({
    required this.activeIndex,
    required this.currentRoute,
    required this.onTabChanged,
    super.key,
  });

  /// The currently selected tab index (0 = Mixer, 1 = Library)
  final int activeIndex;

  /// The current route/location in the app (used for active state)
  final String currentRoute;

  /// Callback when a navigation item is tapped
  final ValueChanged<int> onTabChanged;

  /// Checks if a tab index is currently active
  bool _isActive(int index) {
    return activeIndex == index;
  }

  /// Builds a navigation rail destination item
  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isActive = _isActive(index);
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ShadButton.ghost(
        onPressed: onTap,
        width: double.infinity,
        leading: Icon(icon, size: 20),
        // Highlight active state
        backgroundColor: isActive
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : null,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Container(
      width: 80,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: theme.colorScheme.border),
        ),
        color: theme.colorScheme.background,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Tab 0: Color Mixer - Main mixing functionality
              _buildNavItem(
                context,
                index: 0,
                label: 'Mixer',
                icon: LucideIcons.palette,
                onTap: () => onTabChanged(0),
              ),

              // Tab 1: Paint Library - Inventory management
              _buildNavItem(
                context,
                index: 1,
                label: 'Library',
                icon: LucideIcons.list,
                onTap: () => onTabChanged(1),
              ),

              const SizedBox(height: 8),
              const ShadSeparator.horizontal(
                margin: EdgeInsets.symmetric(horizontal: 8),
              ),
              const SizedBox(height: 8),

              // History - Future feature
              _buildNavItem(
                context,
                index: 2,
                label: 'History',
                icon: LucideIcons.history,
                onTap: () {
                  ShadToaster.of(context).show(
                    const ShadToast(
                      description: Text('History feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),

              // Favorites - Future feature
              _buildNavItem(
                context,
                index: 3,
                label: 'Favorites',
                icon: LucideIcons.star,
                onTap: () {
                  ShadToaster.of(context).show(
                    const ShadToast(
                      description: Text('Favorites feature coming soon'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
