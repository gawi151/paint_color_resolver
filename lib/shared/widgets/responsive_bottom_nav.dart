import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Mobile bottom navigation bar widget for the Paint Color Resolver app.
///
/// Displays a bottom navigation bar suitable for mobile/small screens with
/// tabs for the main app features. Uses Phosphor icons and adapts to the
/// current active tab.
///
/// ## Features:
/// - Fixed bottom position with safe area awareness
/// - Phosphor icon library for consistency
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
    return BottomNavigationBar(
      currentIndex: activeIndex,
      onTap: (index) {
        if (index == 2) {
          // More menu
          onMoreTapped?.call();
        } else {
          // Tab navigation (Mixer or Library)
          onTabChanged(index);
        }
      },
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      items: [
        // Tab 0: Color Mixer - Main mixing functionality
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.palette()),
          label: 'Mixer',
        ),

        // Tab 1: Paint Library - Inventory management
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.list()),
          label: 'Library',
        ),

        // More - Settings and other options
        BottomNavigationBarItem(
          icon: Icon(PhosphorIcons.dotsThree()),
          label: 'More',
        ),
      ],
    );
  }
}
