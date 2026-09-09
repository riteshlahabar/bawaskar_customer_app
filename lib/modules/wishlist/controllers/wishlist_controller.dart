import 'package:get/get.dart';

import '../../../app/data/models/wishlist_item_model.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/wishlist_api_service.dart';

/// Owns the saved-products list and nothing else.
class WishlistController extends GetxController {
  WishlistController(this._api, this._session);

  final WishlistApiService _api;
  final AuthStorage _session;

  final items = <WishlistItemModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  bool get isEmpty => items.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    // A guest has no wishlist. Calling the endpoint anyway would 401 and the
    // session handler would bounce them to login just for opening the app.
    if (!_session.isLoggedIn) {
      items.clear();
      return;
    }

    isLoading.value = true;
    error.value = '';
    try {
      items.assignAll(await _api.list());
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }

  bool contains(int productId) =>
      items.any((item) => item.productId == productId);

  /// Adds or removes depending on current membership, so a single heart icon
  /// can call one method.
  Future<void> toggle(int productId) async {
    final wasSaved = contains(productId);

    // Optimistic: the row disappears immediately and is restored on failure,
    // which keeps the list responsive on a slow connection.
    if (wasSaved) {
      items.removeWhere((item) => item.productId == productId);
    }

    try {
      if (wasSaved) {
        await _api.remove(productId);
      } else {
        await _api.add(productId);
        await load();
      }
    } catch (failure) {
      if (wasSaved) await load();
      Get.snackbar('Wishlist', failure.toString());
    }
  }

  Future<void> remove(int productId) async {
    if (!contains(productId)) return;
    await toggle(productId);
  }
}
