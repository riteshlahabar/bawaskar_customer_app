import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/product_model.dart';

/// Parses category/product lists out of a homepage/categories/products
/// API response, tolerating a few different response shapes
/// (`{categories: [...]}`, `{data: [...]}`, `{data: {items: [...]}}`, ...).
class CatalogResponseParser {
  const CatalogResponseParser._();

  static List<CategoryModel> categories(Map<String, dynamic> response) {
    final list = _extractList(response, const [
      'categories',
      'data',
      'items',
    ]);

    return list
        .whereType<Map>()
        .map(
          (item) => CategoryModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.id > 0)
        .toList();
  }

  static List<ProductModel> products(Map<String, dynamic> response) {
    final list = _extractList(response, const [
      'products',
      'data',
      'items',
    ]);

    return list
        .whereType<Map>()
        .map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.id > 0)
        .toList();
  }

  /// Last page number of a paginated products response (1 when unknown).
  static int lastPage(Map<String, dynamic> response) {
    dynamic data = response['data'];

    if (data is Map && data['products'] is Map) {
      data = data['products'];
    }

    return data is Map ? int.tryParse(data['last_page']?.toString() ?? '') ?? 1 : 1;
  }

  static List<dynamic> _extractList(dynamic source, List<String> keys) {
    if (source is List) {
      return source;
    }

    if (source is! Map) {
      return const [];
    }

    for (final key in keys) {
      final value = source[key];

      if (value is List) {
        return value;
      }

      if (value is Map) {
        final nested = _extractList(value, keys);

        if (nested.isNotEmpty) {
          return nested;
        }
      }
    }

    return const [];
  }
}
