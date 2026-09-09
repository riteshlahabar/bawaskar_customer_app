import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../controllers/support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<CustomerApiService>(() => CustomerApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<SupportController>(() => SupportController(Get.find<CustomerApiService>()));
  }
}
