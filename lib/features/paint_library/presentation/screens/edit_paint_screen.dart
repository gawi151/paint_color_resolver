import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Edit Paint screen - form for editing existing paint in inventory.
///
/// Parameters:
/// - paintId (int): The ID of the paint to edit
///
/// Features:
/// - Pre-populated form fields with current paint data
/// - Input fields: name, brand dropdown, color picker, notes
/// - Color picker integration with LAB value display
/// - Form validation
/// - Update button to save changes
/// - Delete button to remove paint
/// - Cancel button to go back
///
/// State Management:
/// - Loads paint data from inventory
/// - Uses `paintInventoryProvider.notifier.editPaint()` to update
/// - Uses `paintInventoryProvider.notifier.removePaint()` to delete
///
/// Navigation:
/// - Receives paintId as route parameter
/// - Pops back after successful save/delete
@RoutePage()
class EditPaintScreen extends StatelessWidget {
  const EditPaintScreen({required this.paintId, super.key});

  /// The ID of the paint being edited
  final int paintId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Paint'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Edit Paint',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Paint ID: $paintId (form placeholder - implementation in progress)',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: context.router.pop,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    /// TODO(painter-inventory): Update paint in inventory via provider
                    context.router.pop();
                  },
                  child: const Text('Update'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    /// TODO(painter-inventory): Delete paint from inventory via provider
                    context.router.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
