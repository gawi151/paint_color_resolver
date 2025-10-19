import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paint_color_resolver/core/database/providers/database_provider.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return MaterialApp.router(
      title: 'Paint Color Resolver',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
      loading: () => const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing paint library...'),
            ],
          ),
        ),
      ),
      // Initialization failed
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
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
