import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Desktop navigation rail widget for the Paint Color Resolver app.
///
/// Displays a vertical sidebar with navigation items for desktop/tablet screens.
/// Uses Phosphor icons for a clean, modern appearance and highlights the
/// currently active tab.
///
/// ## Features:
/// - Fixed width sidebar (~80px with labels)
/// - Phosphor icon library for consistency
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

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
        color: Colors.white,
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
                icon: PhosphorIcons.palette(),
                onTap: () => onTabChanged(0),
              ),

              // Tab 1: Paint Library - Inventory management
              _buildNavItem(
                context,
                index: 1,
                label: 'Library',
                icon: PhosphorIcons.list(),
                onTap: () => onTabChanged(1),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1, indent: 8, endIndent: 8),
              const SizedBox(height: 8),

              // History - Future feature
              _buildNavItem(
                context,
                index: 2,
                label: 'History',
                icon: PhosphorIcons.clockClockwise(),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('History feature coming soon'),
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
                icon: PhosphorIcons.star(),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favorites feature coming soon'),
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
