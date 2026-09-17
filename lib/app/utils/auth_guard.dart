import 'package:get/get.dart';

import '../data/services/auth_storage.dart';
import '../routes/app_routes.dart';
import '../localization/t.dart';

class AuthGuard {
  AuthGuard._();

  static bool get isLoggedIn => Get.find<AuthStorage>().isLoggedIn;

  static bool ensureLoggedIn({String? message}) {
    if (isLoggedIn) return true;

    Get.snackbar(
      t('login.required_title'),
      message ?? t('login.required_message'),
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.toNamed(AppRoutes.login);
    return false;
  }
}
