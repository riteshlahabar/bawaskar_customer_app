import 'package:get/get.dart';

import '../../../app/utils/auth_guard.dart';

class MainShellController extends GetxController {
  final selectedIndex = 0.obs;

  final titles = const ['Shop', 'Categories', 'Cart', 'Orders', 'Profile'];
  String get currentTitle => titles[selectedIndex.value];

  void changeTab(int index) {
    // Home and Categories are public guest screens.
    // Cart, Orders and Profile need login/signup like Amazon/Flipkart.
    if (index >= 2) {
      final allowed = AuthGuard.ensureLoggedIn(
        message: index == 2
            ? 'Please login or sign up before using your cart.'
            : 'Please login or sign up to view this section.',
      );
      if (!allowed) return;
    }
    selectedIndex.value = index;
  }
}
