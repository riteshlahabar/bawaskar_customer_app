import 'dart:async';

import 'package:get/get.dart';

import '../../../app/data/cache/json_cache_store.dart';
import '../../../app/data/mock/mock_catalog.dart';
import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/homepage_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../../app/localization/localized_cache_key.dart';

class HomeController extends GetxController {
  HomeController(this._api, this._cache);

  /// Shared with the catalog tab, which reads its categories from it.
  static const homepageCacheKey = 'customer_homepage';

  final CustomerApiService _api;
  final JsonCacheStore _cache;
  final isLoading = false.obs;
  final categories = <CategoryModel>[].obs;
  final products = <ProductModel>[].obs;
  final banners = <HomepageItemModel>[].obs;
  final sections = <HomepageSectionModel>[].obs;
  final searchText = ''.obs;

  List<ProductModel> get featuredProducts {
    final data = products.where((item) => item.isFeatured).toList();
    return data.isEmpty ? products.take(8).toList() : data;
  }

  List<ProductModel> get topSellingProducts {
    final data = products.where((item) => item.isTopSelling).toList();
    return data.isEmpty ? products.skip(1).take(8).toList() : data;
  }

  List<ProductModel> get newArrivals {
    final data = products.where((item) => item.isNewArrival).toList();
    return data.isEmpty ? products.take(8).toList() : data;
  }

  @override
  void onReady() {
    super.onReady();
    loadHome();
  }

  /// Shows the last saved homepage instantly, then refreshes it from the
  /// server. [fresh] (pull-to-refresh) skips the saved copy and server cache.
  Future<void> loadHome({bool fresh = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      if (!fresh && sections.isEmpty && products.isEmpty) {
        final cached = await _cache.read(localizedCacheKey(homepageCacheKey));
        if (cached != null) _applyHomepage(cached);
      }

      final homepageResponse = await _api.homepage();
      _applyHomepage(homepageResponse);
      unawaited(_cache.write(localizedCacheKey(homepageCacheKey), homepageResponse));

      if (categories.isEmpty || products.isEmpty) {
        await _loadCatalogFallback(keepHomepageRows: true, fresh: fresh);
      }
    } catch (_) {
      // A saved homepage stays on screen when the network fails.
      if (sections.isEmpty && products.isEmpty) {
        await _loadCatalogFallback(keepHomepageRows: false, fresh: fresh);
      }
    } finally {
      if (categories.isEmpty) categories.assignAll(MockCatalog.categories);
      if (products.isEmpty) products.assignAll(MockCatalog.products);
      isLoading.value = false;
    }
  }

  void _applyHomepage(Map<String, dynamic> response) {
    final payload = _payload(response);

    banners.assignAll(_parseHomepageItems(payload['banners']));
    categories.assignAll(_parseCategories(payload['categories']));
    sections.assignAll(_parseSections(payload['rows']));

    final homepageProducts = sections.expand((section) => section.products).toList();
    products.assignAll(_uniqueProducts(homepageProducts));
  }

  Future<void> _loadCatalogFallback({required bool keepHomepageRows, required bool fresh}) async {
    try {
      final categoryResponse = await _api.categories(fresh: fresh);
      final productResponse = await _api.products(audience: 'customer', fresh: fresh);
      if (categories.isEmpty) categories.assignAll(_parseCategories(_payload(categoryResponse)['categories'] ?? categoryResponse));
      if (products.isEmpty) products.assignAll(_parseProducts(_payload(productResponse)['products'] ?? productResponse));
      if (!keepHomepageRows) sections.clear();
    } catch (_) {
      if (!keepHomepageRows) sections.clear();
    }
  }

  Map<String, dynamic> _payload(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return response;
  }

  List<CategoryModel> _parseCategories(dynamic source) {
    final list = _extractList(source, const ['categories', 'data', 'items']);
    return list.whereType<Map>().map((item) => CategoryModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  List<ProductModel> _parseProducts(dynamic source) {
    final list = _extractList(source, const ['products', 'data', 'items']);
    return list.whereType<Map>().map((item) => ProductModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  List<HomepageItemModel> _parseHomepageItems(dynamic source) {
    final list = _extractList(source, const ['banners', 'items', 'data']);
    return list.whereType<Map>().map((item) => HomepageItemModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  List<HomepageSectionModel> _parseSections(dynamic source) {
    final list = _extractList(source, const ['rows', 'sections', 'data']);
    return list.whereType<Map>().map((item) => HomepageSectionModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  List<dynamic> _extractList(dynamic source, List<String> keys) {
    if (source is List) return source;
    if (source is! Map) return const [];

    dynamic current = source;
    for (final key in keys) {
      if (current is Map && current[key] is List) return current[key] as List;
      if (current is Map && current[key] is Map) current = current[key];
    }

    if (source['data'] is Map) return _extractList(source['data'], keys);
    return const [];
  }

  List<ProductModel> _uniqueProducts(List<ProductModel> items) {
    final seen = <int>{};
    final unique = <ProductModel>[];
    for (final item in items) {
      if (seen.add(item.id)) unique.add(item);
    }
    return unique;
  }
}
