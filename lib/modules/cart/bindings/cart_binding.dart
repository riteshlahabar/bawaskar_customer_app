import 'package:get/get.dart';

import '../../../app/data/cache/json_cache_store.dart';
import '../../../app/data/services/address_selection_service.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(Get.find<JsonCacheStore>()), permanent: true);
    }
    Get.lazyPut<CartController>(
      () => CartController(
        Get.find<CartService>(),
        Get.find<AddressSelectionService>(),
        Get.find<CustomerApiService>(),
        Get.find<AuthStorage>(),
      ),
    );
  }
}
