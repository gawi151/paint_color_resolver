import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_search_provider.dart';
import 'package:paint_color_resolver/shared/widgets/paint_card.dart';

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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _navigateToEditPaint(int paintId) {
    unawaited(context.router.push(EditPaintRoute(paintId: paintId)));
  }

  void _navigateToAddPaint() {
    unawaited(context.router.push(const AddPaintRoute()));
  }

  void _navigateToColorMixer() {
    unawaited(context.router.push(const ColorMixerRoute()));
  }

  Future<void> _showDeleteConfirmation({
    required int paintId,
    required String paintName,
    required VoidCallback onConfirm,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Paint?'),
        content: Text(
          'Are you sure you want to delete "$paintName"? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the filtered search results
    final searchParams = PaintSearchParams(query: _searchQuery);
    final searchResults = ref.watch(paintSearchProvider(searchParams));

    // Also watch inventory for loading/error states
    final inventoryAsync = ref.watch(paintInventoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint Inventory'),
        elevation: 0,
        actions: [
          Tooltip(
            message: 'Mix Colors',
            child: IconButton(
              icon: const Icon(Icons.palette),
              onPressed: _navigateToColorMixer,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search paints by name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Paint list or empty state
          Expanded(
            child: inventoryAsync.when(
              data: (_) {
                if (searchResults.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isNotEmpty
                              ? Icons.search_off
                              : Icons.palette_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No paints found'
                              : 'No paints in inventory',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'Try a different search term'
                              : 'Add your first paint to get started',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _navigateToAddPaint,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Paint'),
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
                                  .read(paintInventoryProvider.notifier)
                                  .removePaint(paint.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Deleted ${paint.name}'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
                            } on Exception catch (e) {
                              _log.severe('Failed to delete paint', e);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting paint: $e'),
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: Colors.red,
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
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
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
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Trigger a refresh by invalidating the provider
                        ref.invalidate(paintInventoryProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddPaint,
        tooltip: 'Add Paint',
        child: const Icon(Icons.add),
      ),
    );
  }
}
