import 'package:get/get.dart';

import '../../../app/data/mock/mock_catalog.dart';
import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/homepage_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/customer_api_service.dart';

class HomeController extends GetxController {
  HomeController(this._api);

  final CustomerApiService _api;
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

  Future<void> loadHome() async {
    isLoading.value = true;
    try {
      final homepageResponse = await _api.homepage();
      final payload = _payload(homepageResponse);

      banners.assignAll(_parseHomepageItems(payload['banners']));
      categories.assignAll(_parseCategories(payload['categories']));
      sections.assignAll(_parseSections(payload['rows']));

      final homepageProducts = sections.expand((section) => section.products).toList();
      products.assignAll(_uniqueProducts(homepageProducts));

      if (categories.isEmpty || products.isEmpty) {
        await _loadCatalogFallback(keepHomepageRows: true);
      }
    } catch (_) {
      await _loadCatalogFallback(keepHomepageRows: false);
    } finally {
      if (categories.isEmpty) categories.assignAll(MockCatalog.categories);
      if (products.isEmpty) products.assignAll(MockCatalog.products);
      isLoading.value = false;
    }
  }

  Future<void> _loadCatalogFallback({required bool keepHomepageRows}) async {
    try {
      final categoryResponse = await _api.categories();
      final productResponse = await _api.products(audience: 'customer');
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
