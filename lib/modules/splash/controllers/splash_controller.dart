import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Future<void>.delayed(const Duration(milliseconds: 850), () {
      // Customer app works like Amazon/Flipkart.
      // Always show storefront/products first. Login is required only for
      // cart, checkout, orders, profile, address and support actions.
      Get.offAllNamed(AppRoutes.main);
    });
  }
}
