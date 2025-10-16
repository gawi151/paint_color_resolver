import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:paint_color_resolver/features/paint_library/presentation/screens/add_paint_screen.dart';
import 'package:paint_color_resolver/features/paint_library/presentation/screens/edit_paint_screen.dart';
import 'package:paint_color_resolver/features/paint_library/presentation/screens/paint_library_screen.dart';

part 'app_router.gr.dart';

/// Main router configuration for Paint Color Resolver app.
///
/// Defines all navigation routes for the application using code generation.
///
/// ## Route Structure
/// - `/` → Paint library (home/initial route)
/// - `/paint-library` → Paint inventory list
/// - `/paint-library/add` → Add new paint form
/// - `/paint-library/edit/:paintId` → Edit paint form
///
/// ## Navigation Examples
///
/// ```dart
/// // Navigate to add paint
/// context.router.push(const PaintLibraryRoute());
/// context.router.push(const AddPaintRoute());
/// context.router.push(EditPaintRoute(paintId: 123));
///
/// // Pop back
/// context.router.pop();
/// ```
@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: PaintLibraryRoute.page,
      path: '/',
      initial: true,
    ),
    AutoRoute(
      page: AddPaintRoute.page,
      path: '/paint-library/add',
    ),
    AutoRoute(
      page: EditPaintRoute.page,
      path: '/paint-library/edit/:paintId',
    ),
  ];
}
