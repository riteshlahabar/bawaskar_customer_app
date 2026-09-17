import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../location/controllers/location_form_controller.dart';
import '../../location/services/location_api_service.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<CustomerApiService>(() => CustomerApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<LocationApiService>(() => LocationApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<LocationFormController>(() => LocationFormController(Get.find<LocationApiService>()), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(Get.find<CustomerApiService>(), Get.find<AuthStorage>()), fenix: true);
  }
}
