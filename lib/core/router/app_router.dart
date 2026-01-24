import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:paint_color_resolver/core/layout/app_shell_screen.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/screens/color_mixer_screen.dart';
import 'package:paint_color_resolver/features/color_calculation/presentation/screens/mixing_results_screen.dart';
import 'package:paint_color_resolver/features/paint_library/presentation/screens/add_paint_screen.dart';
import 'package:paint_color_resolver/features/paint_library/presentation/screens/edit_paint_screen.dart';
import 'package:paint_color_resolver/features/paint_library/presentation/screens/paint_library_screen.dart';

part 'app_router.gr.dart';

/// Main router configuration for Paint Color Resolver app.
///
/// Defines all navigation routes for the application using code generation.
/// Uses a shell route to wrap all pages with responsive navigation.
///
/// ## Route Structure
///
/// ```dart
/// AppRouter (root)
/// ├── / → MainShell (responsive navigation: desktop rail / mobile bottom nav)
/// │   ├── /color-mixer → Color target selection and mix calculation
/// │   └── /paint-library → Paint library (home/initial route)
/// ├── /paint-library/add → Add new paint form (pushed on top of shell)
/// ├── /paint-library/edit/:paintId → Edit paint form (pushed on top of shell)
/// └── /mixing-results → Display calculated mixing recommendations (pushed on top of shell)
/// ```
///
/// ## Navigation Examples
///
/// ```dart
/// // Navigate to color mixer
/// context.router.push(const ColorMixerRoute());
///
/// // Navigate to results
/// context.router.push(const MixingResultsRoute());
///
/// // Pop back
/// context.router.pop();
/// ```
///
/// ## Responsive Behavior
/// - Desktop (≥768px): Left navigation rail with labels
/// - Mobile (<768px): Bottom navigation bar
/// - Automatic adaptation on window resize
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Shell route that wraps all pages with responsive navigation
    // Uses AutoTabsRouter for tab-style navigation
    // (no back button between tabs)
    AutoRoute(
      page: AppShellRoute.page,
      path: '/',
      children: [
        // Tab 0: Color Mixer (default tab)
        AutoRoute(
          page: ColorMixerRoute.page,
          path: 'color-mixer',
          initial: true,
        ),

        // Tab 1: Paint Library
        AutoRoute(
          page: PaintLibraryRoute.page,
          path: 'paint-library',
        ),
      ],
    ),

    // Add paint - pushed on top of shell (not a child of shell)
    AutoRoute(
      page: AddPaintRoute.page,
      path: 'paint-library/add',
    ),

    // Edit paint - pushed on top of shell (not a child of shell)
    AutoRoute(
      page: EditPaintRoute.page,
      path: 'paint-library/edit/:paintId',
    ),

    // Mixing results - pushed on top of shell (not a child of shell)
    // This allows it to overlay the entire navigation structure
    AutoRoute(
      page: MixingResultsRoute.page,
      path: 'mixing-results',
    ),
  ];
}
