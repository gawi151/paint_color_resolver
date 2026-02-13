import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';
import 'package:paint_color_resolver/shared/widgets/responsive_bottom_nav.dart';
import 'package:paint_color_resolver/shared/widgets/responsive_navigation_rail.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Main app shell providing responsive navigation with AutoTabsRouter.
///
/// Uses AutoTabsRouter for proper tab state management:
/// - No back button when switching tabs
/// - Tab state preserved on resize
/// - activeIndex automatically tracked
///
/// ## Responsive Breakpoint
/// - **Desktop (≥768px):** Navigation Rail + Body (horizontal layout)
/// - **Mobile (<768px):** Body + Bottom Navigation Bar (vertical layout)
///
/// ## Shell Route Implementation
/// This is a wrapper page that renders nested child routes via
/// [AutoTabsRouter]. The AutoTabsRouter widget manages tab state and
/// renders the active tab.
@RoutePage()
class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 768;

        return AutoTabsRouter(
          routes: const [
            ColorMixerRoute(),
            PaintLibraryRoute(),
          ],
          transitionBuilder: (context, child, animation) => child,
          builder: (context, child) {
            final tabsRouter = AutoTabsRouter.of(context);
            final activeIndex = tabsRouter.activeIndex;
            final routeName = context.topRoute.name;

            if (isDesktop) {
              // Desktop layout: Navigation Rail + Body (horizontal)
              return ShadToaster(
                child: Row(
                  children: [
                    // Navigation Rail (fixed width sidebar)
                    ResponsiveNavigationRail(
                      activeIndex: activeIndex,
                      currentRoute: routeName,
                      onTabChanged: tabsRouter.setActiveIndex,
                    ),
                    // Main content area (flexible)
                    Expanded(child: child),
                  ],
                ),
              );
            } else {
              // Mobile layout: Body + Bottom Navigation (vertical)
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
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }
}
