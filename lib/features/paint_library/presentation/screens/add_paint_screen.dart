import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Add Paint screen - form for adding new paint to inventory.
///
/// Features:
/// - Input fields: name, brand dropdown, color picker, notes
/// - Color picker integration with LAB value display
/// - Form validation
/// - Save button to add paint to inventory
/// - Cancel button to go back
///
/// State Management:
/// - Uses `paintInventoryProvider.notifier.addPaint()` to persist
/// - Converts color picker RGB → LAB using domain layer
///
/// Navigation:
/// - Pushes on top of paint library screen
/// - Pops back after successful save
@RoutePage()
class AddPaintScreen extends StatelessWidget {
  const AddPaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Paint'),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Add New Paint',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Form placeholder - implementation in progress',
              style: TextStyle(color: Colors.grey),
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
                    // TODO(painter-inventory): Save paint to inventory
                    //  via provider
                    context.router.pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
