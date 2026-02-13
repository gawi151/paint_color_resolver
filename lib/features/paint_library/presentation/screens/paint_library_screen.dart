import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_search_provider.dart';
import 'package:paint_color_resolver/shared/widgets/paint_card.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final _log = Logger('PaintLibrary');

/// Paint Library screen - displays all paints in user's inventory.
///
/// Features:
/// - View all paints in a scrollable list
/// - Search/filter paints by name or brand
/// - Add new paint (FAB button)
/// - Edit existing paint (tap on list item)
/// - Delete paint (swipe or context menu)
/// - Color preview for each paint
/// - Mix colors using available paints (palette icon in AppBar)
///
/// State Management:
/// - Consumes `paintInventoryProvider` for full inventory
/// - Consumes `paintSearchProvider` for filtered results
/// - Updates via provider methods
///
/// Navigation:
/// - Routes to AddPaintScreen via FAB
/// - Routes to EditPaintScreen on list item tap
/// - Routes to ColorMixerRoute via palette icon (AppBar action)
@RoutePage()
class PaintLibraryScreen extends ConsumerStatefulWidget {
  const PaintLibraryScreen({super.key});

  @override
  ConsumerState<PaintLibraryScreen> createState() => _PaintLibraryScreenState();
}

class _PaintLibraryScreenState extends ConsumerState<PaintLibraryScreen> {
  late TextEditingController _searchController;
  String _searchQuery = '';
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Cancel previous timer
    _debounce?.cancel();
    // Start new timer - only update search query after user stops typing
    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        if (mounted) {
          setState(() {
            _searchQuery = _searchController.text;
          });
        }
      },
    );
  }

  void _navigateToEditPaint(int paintId) {
    unawaited(context.router.push(EditPaintRoute(paintId: paintId)));
  }

  void _navigateToAddPaint() {
    unawaited(context.router.push(const AddPaintRoute()));
  }

  Future<void> _showDeleteConfirmation({
    required int paintId,
    required String paintName,
    required VoidCallback onConfirm,
  }) async {
    await showShadDialog<void>(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Delete Paint?'),
        description: Text(
          'Are you sure you want to delete "$paintName"? '
          'This action cannot be undone.',
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the filtered search results (includes loading/error states)
    final searchParams = PaintSearchParams(query: _searchQuery);
    final searchResultsAsync = ref.watch(paintSearchProvider(searchParams));

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ShadTheme.of(context).colorScheme.card,
            border: Border(
              bottom: BorderSide(
                color: ShadTheme.of(context).colorScheme.border,
              ),
            ),
          ),
          child: const Text(
            'Paint Inventory',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: ShadInput(
                  controller: _searchController,
                  placeholder: const Text('Search paints by name...'),
                  leading: const Icon(LucideIcons.search),
                  trailing: _searchQuery.isNotEmpty
                      ? ShadButton.ghost(
                          leading: const Icon(LucideIcons.x, size: 16),
                          onPressed: () {
                            // Cancel any pending debounce and clear immediately
                            _debounce?.cancel();
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
              ),

              // Paint list or empty state
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: searchResultsAsync.when(
                        data: (searchResults) {
                          if (searchResults.isEmpty) {
                            final theme = ShadTheme.of(context);
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _searchQuery.isNotEmpty
                                        ? LucideIcons.search
                                        : LucideIcons.palette,
                                    size: 64,
                                    color: theme.colorScheme.mutedForeground,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'No paints found'
                                        : 'No paints in inventory',
                                    style: theme.textTheme.h4,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Try a different search term'
                                        : 'Add your first paint to get started',
                                    style: theme.textTheme.muted,
                                  ),
                                  if (_searchQuery.isEmpty) ...[
                                    const SizedBox(height: 24),
                                    ShadButton(
                                      onPressed: _navigateToAddPaint,
                                      leading: const Icon(LucideIcons.plus),
                                      child: const Text('Add Paint'),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            itemCount: searchResults.length,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemBuilder: (context, index) {
                              final paint = searchResults[index];

                              return PaintCard(
                                paint: paint,
                                onEdit: () => _navigateToEditPaint(paint.id),
                                onDelete: () async {
                                  _log.info('Deleting paint: ${paint.name}');
                                  await _showDeleteConfirmation(
                                    paintId: paint.id,
                                    paintName: paint.name,
                                    onConfirm: () async {
                                      try {
                                        await ref
                                            .read(
                                              paintInventoryProvider.notifier,
                                            )
                                            .removePaint(paint.id);
                                        if (context.mounted) {
                                          ShadToaster.of(context).show(
                                            ShadToast(
                                              title: Text(
                                                'Deleted ${paint.name}',
                                              ),
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                          );
                                        }
                                      } on Exception catch (e) {
                                        _log.severe(
                                          'Failed to delete paint',
                                          e,
                                        );
                                        if (context.mounted) {
                                          ShadToaster.of(context).show(
                                            ShadToast.destructive(
                                              title: const Text(
                                                'Error deleting paint',
                                              ),
                                              description: Text(e.toString()),
                                              duration: const Duration(
                                                seconds: 3,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                        loading: () => const Center(
                          child: ShadProgress(),
                        ),
                        error: (error, stackTrace) {
                          final theme = ShadTheme.of(context);
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.circleX,
                                  size: 64,
                                  color: theme.colorScheme.destructive,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Error loading paints',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  error.toString(),
                                  style: const TextStyle(
                                    color: Color(0xFF9E9E9E),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                ShadButton(
                                  onPressed: () {
                                    // Trigger a refresh by invalidating
                                    // the provider
                                    ref.invalidate(
                                      paintInventoryProvider,
                                    );
                                  },
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: ShadButton(
                        leading: const Icon(LucideIcons.plus),
                        onPressed: _navigateToAddPaint,
                        size: ShadButtonSize.lg,
                        child: const Text('Add Paint'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
