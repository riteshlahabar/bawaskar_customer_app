import 'package:get/get.dart';

import '../data/services/auth_storage.dart';
import '../routes/app_routes.dart';

class AuthGuard {
  AuthGuard._();

  static bool get isLoggedIn => Get.find<AuthStorage>().isLoggedIn;

  static bool ensureLoggedIn({String message = 'Please login or create an account to continue.'}) {
    if (isLoggedIn) return true;

    Get.snackbar(
      'Login Required',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.toNamed(AppRoutes.login);
    return false;
  }
}
