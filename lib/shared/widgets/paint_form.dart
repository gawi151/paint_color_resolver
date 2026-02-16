import 'package:flutter/material.dart'
    show InputDecoration, Material, OutlineInputBorder, TextFormField;
import 'package:flutter/widgets.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/models/lab_color.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';
import 'package:paint_color_resolver/shared/utils/color_conversion_utils.dart';
import 'package:paint_color_resolver/shared/widgets/brand_dropdown.dart';
import 'package:paint_color_resolver/shared/widgets/color_picker_input.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Form data submitted by PaintForm.
class PaintFormData {
  PaintFormData({
    required this.name,
    required this.brand,
    required this.labColor,
    required this.isValidGamut,
    this.brandMakerId,
  });

  /// Paint name (required, non-empty).
  final String name;

  /// Selected paint brand (required).
  final PaintBrand brand;

  /// Paint color in LAB color space (required).
  final LabColor labColor;

  /// Whether the color is within valid sRGB gamut.
  final bool isValidGamut;

  /// Optional product code/SKU from the brand maker.
  final String? brandMakerId;

  @override
  String toString() =>
      'PaintFormData(name: $name, brand: ${brand.name}, '
      'brandMakerId: $brandMakerId, labColor: $labColor)';
}

/// A reusable form for adding or editing paint colors.
///
/// Features:
/// - Paint name input (required, real-time validation)
/// - Brand selection dropdown
/// - Color picker with HEX input
/// - Form validation
/// - Loading state support
/// - Customizable submit button label
///
/// ## For Adding Paints:
/// ```dart
/// PaintForm(
///   allAvailableBrands: [PaintBrand.vallejo, PaintBrand.citadel, ...],
///   onSubmit: (formData) => addPaintToInventory(formData),
///   submitLabel: 'Add Paint',
/// )
/// ```
///
/// ## For Editing Paints:
/// ```dart
/// PaintForm(
///   initialPaint: existingPaint,
///   allAvailableBrands: [PaintBrand.vallejo, PaintBrand.citadel, ...],
///   onSubmit: (formData) => updatePaintInInventory(formData),
///   submitLabel: 'Update Paint',
/// )
/// ```
class PaintForm extends StatefulWidget {
  const PaintForm({
    required this.allAvailableBrands,
    required this.onSubmit,
    this.initialPaint,
    this.submitLabel = 'Save Paint',
    this.isLoading = false,
    this.onCancel,
    super.key,
  });

  /// List of all available paint brands to show in dropdown.
  /// The form doesn't make assumptions about which brands to display.
  final List<PaintBrand> allAvailableBrands;

  /// Callback when form is submitted with valid data.
  /// Receives the form data as [PaintFormData].
  final ValueChanged<PaintFormData> onSubmit;

  /// Optional initial paint data (for edit mode).
  /// If provided, the form will be pre-populated with this paint's data.
  final PaintColor? initialPaint;

  /// Label for the submit button.
  /// Defaults to 'Save Paint' if not provided.
  final String submitLabel;

  /// Whether the form is currently processing (shows loading state on button).
  /// Defaults to false.
  final bool isLoading;

  /// Optional callback when form is cancelled.
  /// If provided, a cancel button will be shown.
  final VoidCallback? onCancel;

  @override
  State<PaintForm> createState() => _PaintFormState();
}

class _PaintFormState extends State<PaintForm> {
  final _formKey = GlobalKey<ShadFormState>();
  late TextEditingController _nameController;
  late TextEditingController _brandMakerIdController;
  late PaintBrand? _selectedBrand;
  late LabColor? _selectedLabColor;
  late bool _isValidGamut;

  @override
  void initState() {
    super.initState();

    // Initialize from existing paint (edit mode) or defaults (add mode)
    if (widget.initialPaint != null) {
      _nameController = TextEditingController(text: widget.initialPaint!.name);
      _brandMakerIdController = TextEditingController(
        text: widget.initialPaint!.brandMakerId ?? '',
      );
      _selectedBrand = widget.initialPaint!.brand;
      _selectedLabColor = widget.initialPaint!.labColor;
    } else {
      _nameController = TextEditingController();
      _brandMakerIdController = TextEditingController();
      _selectedBrand = null;
      _selectedLabColor = null;
    }

    _isValidGamut = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandMakerIdController.dispose();
    super.dispose();
  }

  /// Handles color selection from ColorPickerInput.
  void _onColorChanged(
    LabColor labColor, {
    required bool isValidGamut,
  }) {
    setState(() {
      _selectedLabColor = labColor;
      _isValidGamut = isValidGamut;
    });
  }

  /// Validates entire form and submits if valid.
  void _handleSubmit() {
    // Validate required fields
    var isValid = true;

    // Validate name
    if (_nameController.text.trim().isEmpty) {
      ShadToaster.of(context).show(
        const ShadToast(
          title: Text('Validation Error'),
          description: Text('Paint name is required'),
        ),
      );
      isValid = false;
    }

    // Validate brand
    if (_selectedBrand == null) {
      ShadToaster.of(context).show(
        const ShadToast(
          title: Text('Validation Error'),
          description: Text('Please select a brand'),
        ),
      );
      isValid = false;
    }

    // Validate color
    if (_selectedLabColor == null) {
      ShadToaster.of(context).show(
        const ShadToast(
          title: Text('Validation Error'),
          description: Text('Please select a color'),
        ),
      );
      isValid = false;
    }

    if (!isValid) return;

    // All validations passed - create form data and submit
    final formData = PaintFormData(
      name: _nameController.text.trim(),
      brand: _selectedBrand!,
      labColor: _selectedLabColor!,
      isValidGamut: _isValidGamut,
      brandMakerId: _brandMakerIdController.text.trim().isEmpty
          ? null
          : _brandMakerIdController.text.trim(),
    );

    widget.onSubmit(formData);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadForm(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Paint name field
              Material(
                child: TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Paint Name',
                    hintText: 'e.g., Red Gore, Ultramarine Blue',
                    border: OutlineInputBorder(
                      borderRadius: theme.radius,
                    ),
                  ),
                  enabled: !widget.isLoading,
                ),
              ),

              const SizedBox(height: 20),

              // Brand dropdown
              BrandDropdown(
                brands: widget.allAvailableBrands,
                selectedBrand: _selectedBrand,
                onChanged: (brand) {
                  setState(() {
                    _selectedBrand = brand;
                  });
                },
                helperText: 'Select the paint manufacturer',
              ),

              const SizedBox(height: 20),

              // Brand maker ID field
              Material(
                child: TextFormField(
                  controller: _brandMakerIdController,
                  decoration: InputDecoration(
                    labelText: 'Product Code (Optional)',
                    hintText: 'e.g., vallejo_70926, citadel_51-01',
                    border: OutlineInputBorder(
                      borderRadius: theme.radius,
                    ),
                  ),
                  enabled: !widget.isLoading,
                ),
              ),

              const SizedBox(height: 20),

              // Color picker
              Text(
                'Paint Color *',
                style: theme.textTheme.p,
              ),
              const SizedBox(height: 8),
              ColorPickerInput(
                onColorChanged: _onColorChanged,
                initialHex: _selectedLabColor != null
                    ? ColorConversionUtils.labToHex(_selectedLabColor!)
                    : '#FFFFFF',
              ),

              const SizedBox(height: 24),

              // Submit and cancel buttons
              Row(
                children: [
                  // Submit button
                  Expanded(
                    child: ShadButton(
                      onPressed: widget.isLoading ? null : _handleSubmit,
                      child: widget.isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: ShadProgress(),
                                ),
                                const SizedBox(width: 8),
                                Text(widget.submitLabel),
                              ],
                            )
                          : Text(widget.submitLabel),
                    ),
                  ),

                  // Cancel button (if callback provided)
                  if (widget.onCancel != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShadButton.outline(
                        onPressed: widget.isLoading ? null : widget.onCancel,
                        child: const Text('Cancel'),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 8),

              // Helper text
              Text(
                'All fields marked with * are required',
                style: theme.textTheme.small,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
