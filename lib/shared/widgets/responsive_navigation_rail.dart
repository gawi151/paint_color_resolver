import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Desktop navigation rail widget for the Paint Color Resolver app.
///
/// Displays a vertical sidebar with navigation items for desktop/tablet screens.
/// Uses Lucide icons for a clean, modern appearance and highlights the
/// currently active tab.
///
/// ## Features:
/// - **Collapsible sidebar:** Toggle between icon-only (88px) and expanded 
/// (10% width)
/// - **Responsive width:** Expanded state adapts to screen size (100-200px)
/// - **Smooth animations:** 200ms transition between states with overflow 
/// clipping
/// - **Lucide icon library** for consistency
/// - **Active tab highlighting** with visual feedback
/// - **State self-contained:** Manages collapse/expand internally
/// - **Full-height divider:** Border extends to true edge of screen
///
/// ## Layout States:
///
/// ### Collapsed (Icon-Only)
/// ```text
/// ┌─────────┬───────────────────┐
/// │ [▐]     │  Screen Content   │
/// │   🎨    │                   │
/// │   📋    │                   │
/// │         │                   │
/// └─────────┴───────────────────┘
/// 88px wide
/// ```
///
/// ### Expanded (Icon + Labels)
/// ```text
/// ┌─────────────┬───────────────────┐
/// │ [◀]         │  Screen Content   │
/// │ 🎨 Mixer    │                   │
/// │ 📋 Library  │                   │
/// │             │                   │
/// └─────────────┴───────────────────┘
/// 100-200px wide (responsive)
/// ```
class ResponsiveNavigationRail extends StatefulWidget {
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

  @override
  State<ResponsiveNavigationRail> createState() =>
      _ResponsiveNavigationRailState();
}

class _ResponsiveNavigationRailState extends State<ResponsiveNavigationRail> {
  /// Sidebar expansion state (true = expanded with text, false = icon-only)
  bool _isExpanded = true;

  /// Toggle sidebar between collapsed and expanded states
  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Discover available width from parent constraints
        final availableWidth = constraints.maxWidth;

        // Calculate responsive sidebar width (10% of available width)
        final sidebarWidth = _isExpanded
            ? (availableWidth * 0.1).clamp(
                100.0,
                200.0,
              ) // 10%, min 100, max 200
            : 88.0; // Collapsed: icon-only (88px fits icon + button padding)

        return Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: theme.colorScheme.border),
            ),
          ),
          child: ClipRect(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200), // Snappy transition
              curve: Curves.easeInOut, // Smooth in/out
              width: sidebarWidth,
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Toggle button (panel icon)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ShadButton.ghost(
                          onPressed: _toggleExpanded,
                          child: Icon(
                            _isExpanded
                                ? LucideIcons.panelLeftClose
                                : LucideIcons.panelLeft,
                            size: 18,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),
                      const ShadSeparator.horizontal(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      const SizedBox(height: 8),

                      // Tab 0: Color Mixer
                      _NavigationRailItem(
                        index: 0,
                        label: 'Mixer',
                        icon: LucideIcons.palette,
                        onTap: () => widget.onTabChanged(0),
                        activeIndex: widget.activeIndex,
                        isExpanded: _isExpanded,
                      ),

                      // Tab 1: Paint Library
                      _NavigationRailItem(
                        index: 1,
                        label: 'Library',
                        icon: LucideIcons.list,
                        onTap: () => widget.onTabChanged(1),
                        activeIndex: widget.activeIndex,
                        isExpanded: _isExpanded,
                      ),

                      const SizedBox(height: 8),
                      const ShadSeparator.horizontal(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      const SizedBox(height: 8),

                      // History - Future feature
                      _NavigationRailItem(
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
                        activeIndex: widget.activeIndex,
                        isExpanded: _isExpanded,
                      ),

                      // Favorites - Future feature
                      _NavigationRailItem(
                        index: 3,
                        label: 'Favorites',
                        icon: LucideIcons.star,
                        onTap: () {
                          ShadToaster.of(context).show(
                            const ShadToast(
                              description: Text(
                                'Favorites feature coming soon',
                              ),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        activeIndex: widget.activeIndex,
                        isExpanded: _isExpanded,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Individual navigation rail item with conditional label rendering.
///
/// Displays icon only when sidebar is collapsed, icon + label when expanded.
/// Highlights active state with subtle background color.
class _NavigationRailItem extends StatelessWidget {
  const _NavigationRailItem({
    required this.index,
    required this.label,
    required this.icon,
    required this.onTap,
    required this.activeIndex,
    required this.isExpanded,
  });

  final int index;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final int activeIndex;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final isActive = activeIndex == index;
    final theme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ShadButton.ghost(
        onPressed: onTap,
        leading: Icon(icon, size: 20),
        // Highlight active state
        backgroundColor: isActive
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : null,
        child:
            isExpanded // ← Conditional text rendering
            ? Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              )
            : null, // Icon-only when collapsed
      ),
    );
  }
}
