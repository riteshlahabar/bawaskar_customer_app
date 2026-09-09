import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/review_api_service.dart';
import '../../reviews/controllers/product_reviews_controller.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CartService>()) {
      Get.put<CartService>(CartService(), permanent: true);
    }

    Get.lazyPut<ProductDetailController>(
      () => ProductDetailController(Get.find<CartService>()),
    );

    Get.lazyPut<ReviewApiService>(
      () => ReviewApiService(Get.find<ApiClient>()),
      fenix: true,
    );
    Get.lazyPut<ProductReviewsController>(
      () => ProductReviewsController(Get.find<ReviewApiService>()),
    );
  }
}
