import 'package:get/get.dart';

import '../../../app/data/models/review_model.dart';
import '../../../app/data/services/review_api_service.dart';

/// Loads the public review feed for one product.
///
/// Separate from [WriteReviewController] because reading and writing have
/// different lifetimes: this one lives with the product page, that one with
/// the compose screen.
class ProductReviewsController extends GetxController {
  ProductReviewsController(this._api);

  final ReviewApiService _api;

  final reviews = <ReviewModel>[].obs;
  final summary = Rxn<ReviewSummaryModel>();
  final isLoading = false.obs;

  double get average => summary.value?.average ?? 0;
  int get total => summary.value?.total ?? 0;

  Future<void> loadFor(int productId) async {
    if (productId <= 0) return;

    isLoading.value = true;
    try {
      final result = await _api.forProduct(productId);
      reviews.assignAll(result.reviews);
      summary.value = result.summary;
    } catch (_) {
      // A product page must still render if the review feed is unavailable,
      // so a failure here is silent and simply leaves the section empty.
      reviews.clear();
      summary.value = null;
    } finally {
      isLoading.value = false;
    }
  }
}
