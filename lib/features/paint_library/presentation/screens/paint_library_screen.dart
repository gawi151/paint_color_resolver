import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:paint_color_resolver/core/router/app_router.dart';

/// Paint Library screen - displays all paints in user's inventory.
///
/// Features:
/// - View all paints in a scrollable list
/// - Search/filter paints by name or brand
/// - Add new paint (FAB button)
/// - Edit existing paint (tap on list item)
/// - Delete paint (swipe or context menu)
/// - Color preview for each paint
///
/// State Management:
/// - Consumes `paintInventoryProvider` for full inventory
/// - Consumes `paintSearchProvider` for filtered results
/// - Updates via provider methods
///
/// Navigation:
/// - Routes to AddPaintScreen via FAB
/// - Routes to EditPaintScreen on list item tap
@RoutePage()
class PaintLibraryScreen extends StatelessWidget {
  const PaintLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint Inventory'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.palette, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Paint Inventory',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Placeholder - implementation in progress',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.router.push(AddPaintRoute());
              },
              child: const Text('Add Paint'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(AddPaintRoute());
        },
        tooltip: 'Add Paint',
        child: const Icon(Icons.add),
      ),
    );
  }
}
