import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:paint_color_resolver/shared/widgets/paint_form.dart';

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
/// - Converts color picker RGB → LAB using domain layer
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
  bool _isLoading = false;

  Future<void> _handleSubmit(PaintFormData formData) async {
    setState(() {
      _isLoading = true;
    });

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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${formData.name}'),
            duration: const Duration(seconds: 2),
          ),
        );

        // Pop back to paint library screen
        if (mounted) context.router.pop();
      }
    } on Exception catch (e, stackTrace) {
      _log.severe('Failed to add paint', e, stackTrace);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding paint: $e'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Paint'),
        elevation: 0,
      ),
      body: PaintForm(
        allAvailableBrands: PaintBrand.values,
        onSubmit: _handleSubmit,
        submitLabel: 'Add Paint',
        isLoading: _isLoading,
        onCancel: () {
          context.router.pop();
        },
      ),
    );
  }
}
