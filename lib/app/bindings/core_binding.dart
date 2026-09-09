import 'package:get/get.dart';

import '../core/security/get_session_expiry_handler.dart';
import '../core/security/session_expiry_handler.dart';
import '../data/services/api_client.dart';
import '../data/services/auth_storage.dart';
import '../data/services/cart_service.dart';
import '../data/services/customer_api_service.dart';
import '../data/services/notification_api_service.dart';
import '../data/services/wishlist_api_service.dart';
import '../../modules/notifications/controllers/notifications_controller.dart';
import '../../modules/wishlist/controllers/wishlist_controller.dart';

/// Wires the app-wide singletons.
///
/// Every dependency is registered against the type its consumers ask for, so a
/// test (or a future rewrite) can substitute an implementation without editing
/// the modules that use it.
class CoreBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(), permanent: true);
    }

    Get.lazyPut<SessionExpiryHandler>(
      () => GetSessionExpiryHandler(Get.find<AuthStorage>()),
      fenix: true,
    );

    Get.lazyPut<ApiClient>(
      () => ApiClient(
        Get.find<AuthStorage>(),
        onExpired: Get.find<SessionExpiryHandler>(),
      ),
      fenix: true,
    );

    Get.lazyPut<CustomerApiService>(
      () => CustomerApiService(Get.find<ApiClient>()),
      fenix: true,
    );

    // The wishlist lives app-wide because the heart icon appears on every
    // product tile, not just on the wishlist screen.
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

    // Global so the shell's bell can carry an unread badge on every tab.
    Get.lazyPut<NotificationApiService>(
      () => NotificationApiService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(
        Get.find<NotificationApiService>(),
        Get.find<AuthStorage>(),
      ),
      fenix: true,
    );
  }
}
