import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/address_selection_service.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/auth_guard.dart';
import '../../../app/utils/order_products.dart';
import '../../../app/localization/t.dart';

class CartController extends GetxController {
  CartController(this.cart, this.addresses, this._api, this._storage);

  final CartService cart;
  final AddressSelectionService addresses;
  final CustomerApiService _api;
  final AuthStorage _storage;

  /// Products from past orders, shown on the empty cart.
  final recentProducts = <ProductModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    load();
  }

  Future<void> load() async {
    await Future.wait([addresses.load(), _loadRecentProducts()]);
  }

  void increase(ProductModel product) => cart.add(product);
  void decrease(ProductModel product) => cart.decrease(product);
  void remove(ProductModel product) => cart.remove(product);
  void saveForLater(ProductModel product) => cart.saveForLater(product);
  void moveToCart(ProductModel product) => cart.moveToCart(product);
  void removeSaved(ProductModel product) => cart.removeSaved(product);

  void addToCart(ProductModel product) {
    cart.add(product);
    Get.snackbar(t('common.added'), t('common.added_to_cart', {'name': product.name}), snackPosition: SnackPosition.BOTTOM);
  }

  void checkout() {
    if (cart.items.isEmpty) {
      Get.snackbar(t('cart.empty_checkout_title'), t('cart.empty_checkout_message'));
      return;
    }
    final allowed = AuthGuard.ensureLoggedIn(
      message: t('login.before_checkout'),
    );
    if (!allowed) return;
    Get.toNamed(AppRoutes.checkout);
  }

  Future<void> _loadRecentProducts() async {
    // Order history needs a login; guests just see "Shop Now".
    if (!_storage.isLoggedIn) return;

    try {
      recentProducts.assignAll(OrderProducts.fromOrdersResponse(await _api.orders()).take(10));
    } catch (_) {
      // Empty cart still shows "Shop Now".
    }
  }
}
