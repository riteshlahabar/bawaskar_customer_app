import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/auth_guard.dart';

class ProductDetailController extends GetxController {
  ProductDetailController(this._cart);

  final CartService _cart;
  final quantity = 1.obs;

  ProductModel get product => Get.arguments as ProductModel;

  void increase() => quantity.value++;
  void decrease() {
    if (quantity.value > 1) quantity.value--;
  }

  void addToCart() {
    final allowed = AuthGuard.ensureLoggedIn(
      message: 'Please login or sign up before adding products to cart.',
    );
    if (!allowed) return;

    for (var i = 0; i < quantity.value; i++) {
      _cart.add(product);
    }
    Get.snackbar('Added', '${product.name} added to cart', snackPosition: SnackPosition.BOTTOM);
  }

  void buyNow() {
    final allowed = AuthGuard.ensureLoggedIn(
      message: 'Please login or sign up before buying this product.',
    );
    if (!allowed) return;

    _cart.clear();
    for (var i = 0; i < quantity.value; i++) {
      _cart.add(product);
    }
    Get.toNamed(AppRoutes.checkout);
  }

  void openCart() {
    final allowed = AuthGuard.ensureLoggedIn(
      message: 'Please login or sign up before opening cart.',
    );
    if (!allowed) return;
    Get.toNamed(AppRoutes.cart);
  }
}
