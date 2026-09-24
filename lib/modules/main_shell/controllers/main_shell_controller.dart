import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/utils/auth_guard.dart';
import '../../../app/localization/t.dart';

class MainShellController extends GetxController {
  MainShellController(this._storage);

  final AuthStorage _storage;

  final selectedIndex = 0.obs;

  /// Tabs opened so far. A tab's screen — and its API calls — is created the
  /// first time it is opened, instead of all five on app start.
  final visitedTabs = <int>{0};

  /// Tabs opened before the current one, newest last. The phone's back button
  /// walks back through them one step at a time instead of closing the app.
  final _tabHistory = <int>[];

  /// Keeps the history from growing without bound when the customer toggles
  /// between two tabs for a long time.
  static const _maxHistory = 20;

  /// Translation keys, resolved in [currentTitle].
  final titles = const ['shell.shop', 'shell.categories', 'cart.title', 'orders.current', 'menu.order_history'];

  String get currentTitle {
    final index = selectedIndex.value;

    // Home greets a signed-in customer by name; guests keep "Shop".
    if (index == 0 && _storage.isLoggedIn) {
      final name = _storage.userName?.trim() ?? '';

      if (name.isNotEmpty) return t('shell.welcome', {'name': name});
    }

    return t(titles[index]);
  }

  void changeTab(int index) {
    // Home and Categories are public guest screens.
    // Cart, Orders and Profile need login/signup like Amazon/Flipkart.
    if (index >= 2) {
      final allowed = AuthGuard.ensureLoggedIn(
        message: index == 2
            ? t('login.before_cart')
            : t('login.before_section'),
      );
      if (!allowed) return;
    }

    // Recorded only once the guard has passed, so a blocked tab never lands
    // in the back history.
    if (index != selectedIndex.value) {
      _tabHistory.add(selectedIndex.value);

      if (_tabHistory.length > _maxHistory) {
        _tabHistory.removeAt(0);
      }
    }

    visitedTabs.add(index);
    selectedIndex.value = index;
  }

  /// Shows the tab opened before this one. Returns false when no earlier tab
  /// is left, which is when the back button should leave the app.
  bool goBackTab() {
    if (_tabHistory.isEmpty) {
      return false;
    }

    final previous = _tabHistory.removeLast();

    visitedTabs.add(previous);
    selectedIndex.value = previous;

    return true;
  }
}
