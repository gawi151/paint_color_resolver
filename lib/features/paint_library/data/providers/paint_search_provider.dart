import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:paint_color_resolver/features/paint_library/data/providers/paint_inventory_provider.dart';
import 'package:paint_color_resolver/shared/models/paint_color.dart';

final _searchLog = Logger('PaintSearch');

/// Filters the paint inventory by search query and optional brand filter.
///
/// This is a functional provider that watches the paint inventory and
/// applies client-side filtering based on the provided parameters.
///
/// ## Features:
/// - Case-insensitive name search
/// - Optional brand filtering
/// - Automatically sorted by paint name
/// - Reactive updates when inventory changes
///
/// ## Usage in Widgets:
/// ```dart
/// Consumer(
///   builder: (context, ref, _) {
///     // Search for "blue" paints
///     final blueResults = ref.watch(
///       paintSearchProvider(query: 'blue'),
///     );
///
///     // Filter by brand only
///     final vallejoResults = ref.watch(
///       paintSearchProvider(
///         query: '',
///         brandFilter: 'vallejo',
///       ),
///     );
///
///     // Combined search and brand filter
///     final filteredResults = ref.watch(
///       paintSearchProvider(
///         query: 'red',
///         brandFilter: 'citadel',
///       ),
///     );
///
///     return ListView.builder(
///       itemCount: filteredResults.length,
///       itemBuilder: (context, index) => Text(filteredResults[index].name),
///     );
///   },
/// )
/// ```
///
/// ## Performance Notes:
/// - Filtering is performed client-side (suitable for small-medium collections)
/// - For large collections (1000+ paints), consider server-side filtering
/// - Provider automatically caches results per unique query/brand combination
/// - Debounce search input in UI to reduce excessive provider calls
final paintSearchProvider =
    Provider.family<List<PaintColor>, PaintSearchParams>(
      (ref, params) {
        final inventoryAsync = ref.watch(paintInventoryProvider);

        return inventoryAsync.when(
          data: (paints) {
            _searchLog.fine(
              'Filtering ${paints.length} paints with query="${params.query}", '
              'brandFilter=${params.brandFilter}',
            );

            var filtered = paints;

            // Apply name search filter (case-insensitive substring match)
            if (params.query.trim().isNotEmpty) {
              final lowerQuery = params.query.trim().toLowerCase();
              filtered = filtered
                  .where(
                    (paint) => paint.name.toLowerCase().contains(lowerQuery),
                  )
                  .toList();
            }

            // Apply brand filter (exact match)
            if (params.brandFilter != null &&
                params.brandFilter!.trim().isNotEmpty) {
              filtered = filtered
                  .where(
                    (paint) => paint.brand.name == params.brandFilter!.trim(),
                  )
                  .toList();
            }

            // Sort by paint name (alphabetical)
            filtered.sort((a, b) => a.name.compareTo(b.name));

            _searchLog.fine('Filtered results: ${filtered.length} paints');
            return filtered;
          },
          loading: () {
            _searchLog.fine(
              'Inventory loading, returning empty search results',
            );
            return <PaintColor>[];
          },
          error: (error, stackTrace) {
            _searchLog.warning(
              'Inventory error, returning empty search results',
              error,
              stackTrace,
            );
            return <PaintColor>[];
          },
        );
      },
    );

/// Parameters for paint search filtering.
///
/// Used with [paintSearchProvider] family provider to filter paints.
///
/// ## Example:
/// ```dart
/// final results = ref.watch(
///   paintSearchProvider(
///     const PaintSearchParams(
///       query: 'blue',
///       brandFilter: 'vallejo',
///     ),
///   ),
/// );
/// ```
@immutable
class PaintSearchParams {
  /// Creates search parameters.
  const PaintSearchParams({
    this.query = '',
    this.brandFilter,
  });

  /// Search query for paint name (case-insensitive).
  final String query;

  /// Optional brand filter (exact match).
  final String? brandFilter;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaintSearchParams &&
          runtimeType == other.runtimeType &&
          query == other.query &&
          brandFilter == other.brandFilter;

  @override
  int get hashCode => query.hashCode ^ brandFilter.hashCode;

  @override
  String toString() =>
      'PaintSearchParams(query: $query, brandFilter: $brandFilter)';
}
