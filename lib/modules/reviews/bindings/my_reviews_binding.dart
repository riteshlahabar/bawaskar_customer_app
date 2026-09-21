import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/review_api_service.dart';
import '../controllers/my_reviews_controller.dart';

class MyReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewApiService>(() => ReviewApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<MyReviewsController>(() => MyReviewsController(Get.find<ReviewApiService>()));
  }
}
