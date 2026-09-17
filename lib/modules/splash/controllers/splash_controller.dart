import 'dart:async';

import 'package:get/get.dart';

import '../../../app/localization/translation_service.dart';
import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _loadTranslations();
    Future<void>.delayed(const Duration(seconds: 5), () {
      // Customer app works like Amazon/Flipkart.
      // Always show storefront/products first. Login is required only for
      // cart, checkout, orders, profile, address and support actions.
      Get.offAllNamed(AppRoutes.main);
    });
  }

  /// The splash already waits five seconds, so the cached strings load and the
  /// server refresh runs before the first real screen is drawn.
  Future<void> _loadTranslations() async {
    if (!Get.isRegistered<TranslationService>()) return;

    final translations = Get.find<TranslationService>();
    await translations.load();
    unawaited(translations.refresh());
  }
}
