import 'package:get/get.dart';

import '../../../app/data/models/product_model.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/utils/auth_guard.dart';
import '../../../app/localization/t.dart';

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
      message: t('login.before_cart_add'),
    );
    if (!allowed) return;

    for (var i = 0; i < quantity.value; i++) {
      _cart.add(product);
    }
    Get.snackbar(t('common.added'), t('common.added_to_cart', {'name': product.name}), snackPosition: SnackPosition.BOTTOM);
  }

  void buyNow() {
    final allowed = AuthGuard.ensureLoggedIn(
      message: t('login.before_buy'),
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
      message: t('login.before_open_cart'),
    );
    if (!allowed) return;
    Get.toNamed(AppRoutes.cart);
  }
}
