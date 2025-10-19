import 'package:flutter/material.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';

/// A dropdown widget for selecting a paint brand.
///
/// Features:
/// - Configurable brand list (no hardcoding)
/// - Display name formatting for each brand
/// - Validation for selected value
/// - Error state display
///
/// ## Usage:
/// ```dart
/// BrandDropdown(
///   brands: [PaintBrand.vallejo, PaintBrand.citadel],
///   selectedBrand: currentBrand,
///   onChanged: (brand) => setState(() => currentBrand = brand),
///   label: 'Paint Brand',
/// )
/// ```
class BrandDropdown extends StatelessWidget {
  const BrandDropdown({
    required this.brands,
    required this.selectedBrand,
    required this.onChanged,
    this.label = 'Brand',
    this.errorText,
    this.isRequired = true,
    this.helperText,
    super.key,
  });

  /// List of brands to display in the dropdown.
  /// Configurable - the widget doesn't make assumptions about which brands
  /// to show.
  final List<PaintBrand> brands;

  /// Currently selected brand.
  /// Can be null if no selection is made.
  final PaintBrand? selectedBrand;

  /// Callback when selection changes.
  final ValueChanged<PaintBrand> onChanged;

  /// Label text for the dropdown field.
  /// Defaults to 'Brand' if not provided.
  final String label;

  /// Error text to display below the dropdown.
  /// Shown in red if provided.
  final String? errorText;

  /// Whether the field is required (shows * in label).
  /// Defaults to true.
  final bool isRequired;

  /// Helper text displayed below the field.
  final String? helperText;

  /// Returns user-friendly display name for a brand.
  ///
  /// Example: `PaintBrand.armyPainter` → `"Army Painter"`
  static String getBrandDisplayName(PaintBrand brand) {
    return switch (brand) {
      PaintBrand.vallejo => 'Vallejo',
      PaintBrand.citadel => 'Citadel',
      PaintBrand.armyPainter => 'Army Painter',
      PaintBrand.reaper => 'Reaper',
      PaintBrand.scale75 => 'Scale75',
      PaintBrand.other => 'Other',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (brands.isEmpty) {
      return Center(
        child: Text(
          'No brands available',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      );
    }

    return DropdownButtonFormField<PaintBrand>(
      initialValue: selectedBrand,
      items: brands
          .map(
            (brand) => DropdownMenuItem<PaintBrand>(
              value: brand,
              child: Text(getBrandDisplayName(brand)),
            ),
          )
          .toList(),
      onChanged: (PaintBrand? newBrand) {
        if (newBrand != null) {
          onChanged(newBrand);
        }
      },
      decoration: InputDecoration(
        labelText: isRequired ? '$label *' : label,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: const Icon(Icons.palette_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      validator: (value) {
        if (isRequired && value == null) {
          return 'Please select a brand';
        }
        return null;
      },
    );
  }
}
