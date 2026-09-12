import 'package:get/get.dart';

import '../../../app/data/mock/mock_catalog.dart';
import '../../../app/data/models/category_model.dart';
import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/customer_api_service.dart';
import 'catalog_response_parser.dart';

class CatalogController extends GetxController {
  CatalogController(this._api);

  final CustomerApiService _api;

  final isLoading = false.obs;

  final categories = <CategoryModel>[].obs;
  final products = <ProductModel>[].obs;

  final selectedCategoryId = 0.obs;
  final search = ''.obs;

  List<ProductModel> get filteredProducts {
    final term = search.value.trim().toLowerCase();

    if (term.isEmpty) {
      return products;
    }

    return products.where((product) {
      return product.name.toLowerCase().contains(term) ||
          product.categoryName.toLowerCase().contains(term) ||
          product.sku.toLowerCase().contains(term);
    }).toList();
  }

  @override
  void onReady() {
    super.onReady();
    loadCatalog();
  }

  Future<void> loadCatalog() async {
    isLoading.value = true;

    try {
      await _loadCategories();

      await _loadProductsForSelectedCategory();
    } catch (_) {
      await _loadFallback();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCategories() async {
    // Home API is already showing the correct category images.
    // Use the same category source first so Home and Category
    // tab cannot show different category images.
    try {
      final homepageResponse = await _api.homepage();

      final homepageCategories =
          CatalogResponseParser.categories(homepageResponse);

      if (homepageCategories.isNotEmpty) {
        categories.assignAll(homepageCategories);
        return;
      }
    } catch (_) {
      // Fall through to normal categories API.
    }

    final categoryResponse = await _api.categories();

    final categoryList =
        CatalogResponseParser.categories(categoryResponse);

    if (categoryList.isNotEmpty) {
      categories.assignAll(categoryList);
    } else {
      categories.assignAll(MockCatalog.categories);
    }
  }

  Future<void> selectCategory(int id) async {
    if (selectedCategoryId.value == id &&
        products.isNotEmpty) {
      return;
    }

    selectedCategoryId.value = id;
    search.value = '';

    isLoading.value = true;

    try {
      await _loadProductsForSelectedCategory();
    } catch (error) {
      products.clear();

      Get.snackbar(
        'Products',
        error.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadProductsForSelectedCategory() async {
    final selectedId = selectedCategoryId.value;

    final response = await _api.products(
      audience: 'customer',
      categoryId: selectedId == 0
          ? null
          : selectedId,
      perPage: 100,
    );

    final loadedProducts = CatalogResponseParser.products(response);

    products.assignAll(loadedProducts);

    // Only use local sample products when "All" itself
    // could not return anything.
    if (products.isEmpty && selectedId == 0) {
      products.assignAll(MockCatalog.products);
    }
  }

  Future<void> _loadFallback() async {
    try {
      final categoryResponse = await _api.categories();

      final loadedCategories =
          CatalogResponseParser.categories(categoryResponse);

      categories.assignAll(
        loadedCategories.isNotEmpty
            ? loadedCategories
            : MockCatalog.categories,
      );
    } catch (_) {
      categories.assignAll(MockCatalog.categories);
    }

    try {
      await _loadProductsForSelectedCategory();
    } catch (_) {
      if (selectedCategoryId.value == 0) {
        products.assignAll(MockCatalog.products);
      } else {
        products.clear();
      }
    }
  }
}