import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/review_api_service.dart';
import '../controllers/write_review_controller.dart';

class WriteReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewApiService>(() => ReviewApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<WriteReviewController>(() => WriteReviewController(Get.find<ReviewApiService>()));
  }
}
