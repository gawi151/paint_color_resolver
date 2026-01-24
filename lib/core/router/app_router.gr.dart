// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AddPaintScreen]
class AddPaintRoute extends PageRouteInfo<void> {
  const AddPaintRoute({List<PageRouteInfo>? children})
    : super(AddPaintRoute.name, initialChildren: children);

  static const String name = 'AddPaintRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AddPaintScreen();
    },
  );
}

/// generated route for
/// [AppShellScreen]
class AppShellRoute extends PageRouteInfo<void> {
  const AppShellRoute({List<PageRouteInfo>? children})
    : super(AppShellRoute.name, initialChildren: children);

  static const String name = 'AppShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AppShellScreen();
    },
  );
}

/// generated route for
/// [ColorMixerScreen]
class ColorMixerRoute extends PageRouteInfo<void> {
  const ColorMixerRoute({List<PageRouteInfo>? children})
    : super(ColorMixerRoute.name, initialChildren: children);

  static const String name = 'ColorMixerRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ColorMixerScreen();
    },
  );
}

/// generated route for
/// [EditPaintScreen]
class EditPaintRoute extends PageRouteInfo<EditPaintRouteArgs> {
  EditPaintRoute({
    required int paintId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         EditPaintRoute.name,
         args: EditPaintRouteArgs(paintId: paintId, key: key),
         rawPathParams: {'paintId': paintId},
         initialChildren: children,
       );

  static const String name = 'EditPaintRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<EditPaintRouteArgs>(
        orElse: () => EditPaintRouteArgs(paintId: pathParams.getInt('paintId')),
      );
      return EditPaintScreen(args.paintId, key: args.key);
    },
  );
}

class EditPaintRouteArgs {
  const EditPaintRouteArgs({required this.paintId, this.key});

  final int paintId;

  final Key? key;

  @override
  String toString() {
    return 'EditPaintRouteArgs{paintId: $paintId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditPaintRouteArgs) return false;
    return paintId == other.paintId && key == other.key;
  }

  @override
  int get hashCode => paintId.hashCode ^ key.hashCode;
}

/// generated route for
/// [MixingResultsScreen]
class MixingResultsRoute extends PageRouteInfo<void> {
  const MixingResultsRoute({List<PageRouteInfo>? children})
    : super(MixingResultsRoute.name, initialChildren: children);

  static const String name = 'MixingResultsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MixingResultsScreen();
    },
  );
}

/// generated route for
/// [PaintLibraryScreen]
class PaintLibraryRoute extends PageRouteInfo<void> {
  const PaintLibraryRoute({List<PageRouteInfo>? children})
    : super(PaintLibraryRoute.name, initialChildren: children);

  static const String name = 'PaintLibraryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PaintLibraryScreen();
    },
  );
}
