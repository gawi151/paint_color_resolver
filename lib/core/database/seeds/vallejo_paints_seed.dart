import 'dart:ui' show Color;
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/features/color_calculation/domain/services/color_converter.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';

final _log = Logger('VallekoPaintsSeed');

/// Curated collection of Vallejo paint colors for seeding the database.
///
/// This provides a realistic, diverse paint collection that gives good
/// coverage for testing the color mixing algorithm. Colors are selected
/// to provide variety across the color spectrum and multiple tones.
///
/// Vallejo Model Color series is used as the base (their most popular line).
/// RGB values are from official Vallejo color documentation.
class VallekoPaintsSeed {
  /// All seed paints as RGB hex values (will be converted to LAB).
  ///
  /// Format: (name, RGB hex, brandMakerId)
  static const List<(String, String, String)> _paintDefinitions = [
    // Primary Colors & Neutrals
    ('White', '0xFFFFFF', 'vallejo_70951'),
    ('Black', '0x000000', 'vallejo_70950'),
    ('Gray', '0x808080', 'vallejo_70875'),
    ('Off-White', '0xF5F5DC', 'vallejo_70952'),

    // Reds
    ('Red Gore', '0xC30000', 'vallejo_70926'),
    ('Vermillion', '0xFF4D00', 'vallejo_70821'),
    ('Scarlet Red', '0xFF1B17', 'vallejo_70817'),
    ('Dark Flesh', '0xD4604D', 'vallejo_70927'),
    ('Burnt Red', '0x852D23', 'vallejo_70908'),
    ('Gory Red', '0xA30F00', 'vallejo_70819'),

    // Oranges & Yellows
    ('Orange', '0xFF8000', 'vallejo_70818'),
    ('Golden Yellow', '0xFFCC00', 'vallejo_70801'),
    ('Lemon Yellow', '0xFFFB00', 'vallejo_70806'),
    ('Golden Olive', '0xD4AF37', 'vallejo_70983'),
    ('Ochre', '0xCC8844', 'vallejo_70983'),

    // Greens
    ('Green', '0x006B3F', 'vallejo_70916'),
    ('Dark Green', '0x004D26', 'vallejo_70915'),
    ('Olive Green', '0x6B8E23', 'vallejo_70915'),
    ('Goblin Green', '0x3C7C3C', 'vallejo_70917'),
    ('Sick Green', '0x99CC33', 'vallejo_70881'),

    // Blues
    ('Ultramarine Blue', '0x001EFF', 'vallejo_70880'),
    ('Electric Blue', '0x0099FF', 'vallejo_70818'),
    ('Dark Blue', '0x000055', 'vallejo_70944'),
    ('Prussian Blue', '0x003366', 'vallejo_70960'),
    ('Ice Blue', '0x99CCFF', 'vallejo_70904'),
    ('Cold Blue', '0x0066CC', 'vallejo_70901'),

    // Purples & Magentas
    ('Purple', '0x663399', 'vallejo_70888'),
    ('Deep Purple', '0x330066', 'vallejo_70810'),
    ('Magenta', '0xFF00FF', 'vallejo_70873'),
    ('Violet Red', '0x8B0000', 'vallejo_70814'),

    // Browns & Flesh Tones
    ('Brown', '0x664411', 'vallejo_70984'),
    ('Dark Brown', '0x331100', 'vallejo_70984'),
    ('Flat Brown', '0x663333', 'vallejo_70874'),
    ('Desert Yellow', '0xCC9966', 'vallejo_70927'),
    ('Tan', '0xD2B48C', 'vallejo_70876'),

    // Metallics (converted to base color for mixing purposes)
    ('Gunmetal Gray', '0x708090', 'vallejo_70861'),
    ('Boltgun Metal', '0x4C4C4C', 'vallejo_70862'),
    ('Verdigris', '0x43B5A3', 'vallejo_70882'),
  ];

  /// Generates the complete seed data with LAB conversions.
  ///
  /// Returns a list of [PaintColor] objects ready to insert into the database.
  /// This method converts RGB hex strings to LAB color space using the
  /// [ColorConverter] from the domain layer.
  static List<PaintColor> generateSeedPaints() {
    final paints = <PaintColor>[];
    final converter = ColorConverter();

    for (final (name, hexColor, brandId) in _paintDefinitions) {
      try {
        // Convert hex string to Color
        final colorInt = int.parse(hexColor);
        final color = Color(colorInt);

        // Convert RGB to LAB
        final labColor = converter.rgbToLab(color);

        // Create paint entry
        final paint = PaintColor(
          id: 0, // Will be auto-generated on insert
          name: name,
          brand: PaintBrand.vallejo,
          brandMakerId: brandId,
          labColor: labColor,
          addedAt: DateTime.now(),
        );

        paints.add(paint);
      } on Exception catch (e) {
        // Skip paints that fail conversion (shouldn't happen with valid hex)
        _log.warning('Failed to seed paint "$name": $e');
      }
    }

    return paints;
  }

  /// Returns just the paint count for debugging/logging.
  static int get paintCount => _paintDefinitions.length;
}
