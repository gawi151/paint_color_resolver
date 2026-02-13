import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:paint_color_resolver/shared/widgets/paint_form.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
  const EditPaintScreen(@PathParam('paintId') this.paintId, {super.key});

  /// The ID of the paint being edited
  final int paintId;

  @override
  ConsumerState<EditPaintScreen> createState() => _EditPaintScreenState();
}

class _EditPaintScreenState extends ConsumerState<EditPaintScreen> {
  /// Gets the current paintId from RouteData.
  /// Using RouteData ensures we always read the latest URL parameter value,
  /// especially important when the URL changes manually in the browser.
  int get _paintId => context.routeData.params.getInt('paintId');

  Future<void> _handleSubmit(PaintFormData formData) async {
    final paintId = _paintId;

    try {
      _log.info('Updating paint ID $paintId: ${formData.name}');

      // Call the provider notifier to edit the paint
      await ref
          .read(paintInventoryProvider.notifier)
          .editPaint(
            paintId: paintId,
            name: formData.name,
            brand: formData.brand,
            labColor: formData.labColor,
            brandMakerId: formData.brandMakerId,
          );

      _log.info('Paint updated successfully ID $paintId');

      if (mounted) {
        // Show success message
        ShadToaster.of(context).show(
          ShadToast(
            title: Text('Updated ${formData.name}'),
            duration: const Duration(seconds: 2),
          ),
        );

        // Pop back to paint library screen
        context.router.pop();
      }
    } on Exception catch (e, stackTrace) {
      _log.severe('Failed to update paint', e, stackTrace);

      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Error updating paint'),
            description: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleDelete() async {
    final paintId = _paintId;

    // Show confirmation dialog
    await showShadDialog<void>(
      context: context,
      builder: (context) => ShadDialog(
        title: const Text('Delete Paint?'),
        description: const Text(
          'This action cannot be undone. The paint will be permanently '
          'removed from your inventory.',
        ),
        actions: [
          ShadButton.outline(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ShadButton.destructive(
            onPressed: () async {
              Navigator.pop(context);

              try {
                _log.info('Deleting paint ID $paintId');

                // Call the provider notifier to delete the paint
                await ref
                    .read(paintInventoryProvider.notifier)
                    .removePaint(paintId);

                _log.info('Paint deleted successfully ID $paintId');

                if (!context.mounted) return;

                // Show success message
                ShadToaster.of(context).show(
                  const ShadToast(
                    title: Text('Paint deleted'),
                    duration: Duration(seconds: 2),
                  ),
                );

                // Pop back to paint library screen
                context.router.pop();
              } on Exception catch (e, stackTrace) {
                _log.severe('Failed to delete paint', e, stackTrace);

                if (!context.mounted) return;

                ShadToaster.of(context).show(
                  ShadToast.destructive(
                    title: const Text('Error deleting paint'),
                    description: Text(e.toString()),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paintId = _paintId;

    // Watch the paint inventory to find this specific paint
    final inventoryAsync = ref.watch(paintInventoryProvider);

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
          child: Row(
            children: [
              ShadButton.ghost(
                leading: const Icon(LucideIcons.arrowLeft),
                onPressed: () => context.router.pop(),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Edit Paint',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ShadButton.ghost(
                leading: const Icon(LucideIcons.trash, size: 18),
                onPressed: _handleDelete,
              ),
            ],
          ),
        ),
        Expanded(
          child: inventoryAsync.when(
            data: (paints) {
              // Find the paint by ID
              final matchingPaints = paints
                  .where((p) => p.id == paintId)
                  .toList();
              final paint = matchingPaints.isNotEmpty
                  ? matchingPaints.first
                  : null;

              if (paint == null) {
                _log.warning('Paint ID $paintId not found in inventory');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.circleX,
                        size: 64,
                        color: Color(0xFF9E9E9E),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Paint not found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'The paint may have been deleted.',
                        style: TextStyle(color: Color(0xFF9E9E9E)),
                      ),
                      const SizedBox(height: 24),
                      ShadButton(
                        onPressed: () => context.router.pop(),
                        child: const Text('Go Back'),
                      ),
                    ],
                  ),
                );
              }

              return ShadToaster(
                child: PaintForm(
                  initialPaint: paint,
                  allAvailableBrands: PaintBrand.values,
                  onSubmit: _handleSubmit,
                  submitLabel: 'Update Paint',
                  // Optimistic updates - no local loading state needed
                  onCancel: () {
                    context.router.pop();
                  },
                ),
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
                      'Error loading paint',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: const TextStyle(color: Color(0xFF9E9E9E)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ShadButton(
                      onPressed: () => context.router.pop(),
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
