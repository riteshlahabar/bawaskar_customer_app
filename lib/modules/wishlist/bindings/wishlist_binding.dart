import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/wishlist_api_service.dart';
import '../controllers/wishlist_controller.dart';

/// The wishlist is registered globally by [CoreBinding] so the heart icon
/// works on any product tile; this route binding only guarantees it exists if
/// the screen is opened directly (a deep link, for example).
class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<WishlistController>()) return;

    Get.lazyPut<WishlistApiService>(
      () => WishlistApiService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<WishlistController>(
      () => WishlistController(
        Get.find<WishlistApiService>(),
        Get.find<AuthStorage>(),
      ),
      fenix: true,
    );
  }
}
