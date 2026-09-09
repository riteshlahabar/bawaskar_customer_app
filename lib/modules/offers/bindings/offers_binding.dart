import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/offer_api_service.dart';
import '../controllers/offers_controller.dart';

class OffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfferApiService>(() => OfferApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<OffersController>(() => OffersController(Get.find<OfferApiService>()));
  }
}
