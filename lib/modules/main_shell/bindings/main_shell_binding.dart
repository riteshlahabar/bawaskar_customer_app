import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../catalog/controllers/catalog_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/main_shell_controller.dart';

class MainShellBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(), permanent: true);
    }
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<CustomerApiService>(() => CustomerApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<MainShellController>(() => MainShellController());
    Get.lazyPut<HomeController>(() => HomeController(Get.find<CustomerApiService>()));
    Get.lazyPut<CatalogController>(() => CatalogController(Get.find<CustomerApiService>()));
    Get.lazyPut<CartController>(() => CartController(Get.find<CartService>()), fenix: true);
    Get.lazyPut<OrdersController>(() => OrdersController(Get.find<CustomerApiService>()));
    Get.lazyPut<ProfileController>(() => ProfileController(Get.find<CustomerApiService>(), Get.find<AuthStorage>()));
  }
}
