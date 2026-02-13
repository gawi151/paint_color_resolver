import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:paint_color_resolver/shared/widgets/paint_form.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final _log = Logger('AddPaintScreen');

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
/// - Optimistic updates provide instant UI feedback
///
/// Navigation:
/// - Pushes on top of paint library screen
/// - Pops back after successful save
@RoutePage()
class AddPaintScreen extends ConsumerStatefulWidget {
  const AddPaintScreen({super.key});

  @override
  ConsumerState<AddPaintScreen> createState() => _AddPaintScreenState();
}

class _AddPaintScreenState extends ConsumerState<AddPaintScreen> {
  Future<void> _handleSubmit(PaintFormData formData) async {
    try {
      _log.info('Adding paint: ${formData.name}');

      // Call the provider notifier to add the paint
      await ref
          .read(paintInventoryProvider.notifier)
          .addPaint(
            name: formData.name,
            brand: formData.brand,
            labColor: formData.labColor,
            brandMakerId: formData.brandMakerId,
          );

      _log.info('Paint added successfully: ${formData.name}');

      if (mounted) {
        // Show success message
        ShadToaster.of(context).show(
          ShadToast(
            title: Text('Added ${formData.name}'),
            duration: const Duration(seconds: 2),
          ),
        );

        // Pop back to paint library screen
        context.router.pop();
      }
    } on Exception catch (e, stackTrace) {
      _log.severe('Failed to add paint', e, stackTrace);

      if (mounted) {
        ShadToaster.of(context).show(
          ShadToast.destructive(
            title: const Text('Error adding paint'),
            description: Text(e.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'Add Paint',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: ShadToaster(
            child: PaintForm(
              allAvailableBrands: PaintBrand.values,
              onSubmit: _handleSubmit,
              submitLabel: 'Add Paint',
              // Optimistic updates - no local loading state needed
              onCancel: () {
                context.router.pop();
              },
            ),
          ),
        ),
      ],
    );
  }
}
