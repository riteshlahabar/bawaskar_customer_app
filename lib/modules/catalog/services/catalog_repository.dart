import 'dart:async';

import '../../../app/data/cache/json_cache_store.dart';
import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../../app/localization/localized_cache_key.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/catalog_response_parser.dart';

/// A page of catalog products plus whether more pages exist.
class CatalogPage {
  const CatalogPage(this.products, {required this.hasMore});

  final List<ProductModel> products;
  final bool hasMore;
}

/// Loads catalog categories and product pages, and keeps the saved copies
/// that let the Category tab show instantly on the next app open.
class CatalogRepository {
  CatalogRepository(this._api, this._cache);

  static const pageSize = 20;

  final CustomerApiService _api;
  final JsonCacheStore _cache;

  /// Categories saved with the homepage, or empty.
  Future<List<CategoryModel>> savedCategories() async {
    final cached = await _cache.read(localizedCacheKey(HomeController.homepageCacheKey));

    return cached == null ? const [] : CatalogResponseParser.categories(cached);
  }

  /// Homepage categories first (so Home and the Category tab show the same
  /// images), then the categories API. Empty when both fail.
  Future<List<CategoryModel>> loadCategories({bool fresh = false}) async {
    try {
      final response = await _api.homepage();
      final list = CatalogResponseParser.categories(response);

      if (list.isNotEmpty) {
        unawaited(_cache.write(localizedCacheKey(HomeController.homepageCacheKey), response));
        return list;
      }
    } catch (_) {
      // Fall through to the categories API.
    }

    try {
      return CatalogResponseParser.categories(await _api.categories(fresh: fresh));
    } catch (_) {
      return const [];
    }
  }

  /// The saved first page for a category, or null when none is saved.
  Future<List<ProductModel>?> savedFirstPage(int categoryId) async {
    final cached = await _cache.read(_productsKey(categoryId));

    return cached == null ? null : CatalogResponseParser.products(cached);
  }

  /// One page from the server. An unfiltered first page is also saved.
  Future<CatalogPage> fetchPage({
    required int categoryId,
    required String query,
    required int page,
    bool fresh = false,
  }) async {
    final response = await _api.products(
      audience: 'customer',
      categoryId: categoryId == 0 ? null : categoryId,
      search: query.isEmpty ? null : query,
      page: page,
      perPage: pageSize,
      fresh: fresh,
    );

    if (page == 1 && query.isEmpty) {
      unawaited(_cache.write(_productsKey(categoryId), response));
    }

    return CatalogPage(
      CatalogResponseParser.products(response),
      hasMore: page < CatalogResponseParser.lastPage(response),
    );
  }

  String _productsKey(int categoryId) =>
      localizedCacheKey('customer_catalog_products_$categoryId');
}
