import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:paint_color_resolver/shared/widgets/paint_form.dart';

final _log = Logger('EditPaintScreen');

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
class EditPaintScreen extends ConsumerStatefulWidget {
  const EditPaintScreen({required this.paintId, super.key});

  /// The ID of the paint being edited
  final int paintId;

  @override
  ConsumerState<EditPaintScreen> createState() => _EditPaintScreenState();
}

class _EditPaintScreenState extends ConsumerState<EditPaintScreen> {
  bool _isLoading = false;

  Future<void> _handleSubmit(PaintFormData formData) async {
    setState(() {
      _isLoading = true;
    });

    try {
      _log.info('Updating paint ID ${widget.paintId}: ${formData.name}');

      // Call the provider notifier to edit the paint
      await ref.read(paintInventoryProvider.notifier).editPaint(
            paintId: widget.paintId,
            name: formData.name,
            brand: formData.brand,
            labColor: formData.labColor,
            brandMakerId: formData.brandMakerId,
          );

      _log.info('Paint updated successfully ID ${widget.paintId}');

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated ${formData.name}'),
            duration: const Duration(seconds: 2),
          ),
        );

        // Pop back to paint library screen
        if (mounted) context.router.pop();
      }
    } on Exception catch (e, stackTrace) {
      _log.severe('Failed to update paint', e, stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating paint: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleDelete() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Paint?'),
        content: const Text(
          'This action cannot be undone. The paint will be permanently '
          'removed from your inventory.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      _log.info('Deleting paint ID ${widget.paintId}');

      // Call the provider notifier to delete the paint
      await ref.read(paintInventoryProvider.notifier).removePaint(
            widget.paintId,
          );

      _log.info('Paint deleted successfully ID ${widget.paintId}');

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paint deleted'),
            duration: Duration(seconds: 2),
          ),
        );

        // Pop back to paint library screen
        if (mounted) context.router.pop();
      }
    } on Exception catch (e, stackTrace) {
      _log.severe('Failed to delete paint', e, stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting paint: $e'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the paint inventory to find this specific paint
    final inventoryAsync = ref.watch(paintInventoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Paint'),
        elevation: 0,
        actions: [
          // Delete button in app bar
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _handleDelete,
              tooltip: 'Delete paint',
            ),
        ],
      ),
      body: inventoryAsync.when(
        data: (paints) {
          // Find the paint by ID using where() to avoid StateError
          final matchingPaints = paints.where(
            (p) => p.id == widget.paintId,
          ).toList();
          final PaintColor? paint = matchingPaints.isNotEmpty
              ? matchingPaints.first
              : null;

          if (paint == null) {
            _log.warning('Paint ID ${widget.paintId} not found in inventory');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Paint not found',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The paint may have been deleted.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.router.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          return PaintForm(
            initialPaint: paint,
            allAvailableBrands: PaintBrand.values,
            onSubmit: _handleSubmit,
            submitLabel: 'Update Paint',
            isLoading: _isLoading,
            onCancel: () {
              context.router.pop();
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
                'Error loading paint',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.router.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
