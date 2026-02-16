import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paint_color_resolver/core/database/providers/database_provider.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return ShadApp.router(
      title: 'Paint Color Resolver',
      // Light theme
      theme: ShadThemeData(
        colorScheme: const ShadZincColorScheme.light(),
      ),
      // Dark theme
      darkTheme: ShadThemeData(
        colorScheme: const ShadZincColorScheme.dark(),
      ),
      routerConfig: appRouter.config(),
      builder: (context, child) => _AppInitializer(child: child),
    );
  }
}

/// Initializes the app by ensuring database seeding completes before showing
/// UI.
///
/// Uses a builder wrapper to run initialization logic while preserving
/// the MaterialApp routing configuration.
class _AppInitializer extends ConsumerWidget {
  const _AppInitializer({
    required this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the database initialization provider to ensure seeding completes
    final dbInitialization = ref.watch(databaseInitializationProvider);

    return dbInitialization.when(
      // Database initialized successfully - show the router's child
      data: (_) => child ?? const SizedBox.shrink(),
      // Still initializing
      loading: () => ColoredBox(
        color: ShadTheme.of(context).colorScheme.background,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShadProgress(),
              SizedBox(height: 16),
              Text('Initializing paint library...'),
            ],
          ),
        ),
      ),
      // Initialization failed
      error: (error, stackTrace) => ColoredBox(
        color: ShadTheme.of(context).colorScheme.background,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.circleX,
                size: 64,
                color: ShadTheme.of(context).colorScheme.destructive,
              ),
              const SizedBox(height: 16),
              const Text('Failed to initialize database'),
              const SizedBox(height: 8),
              Text(error.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
