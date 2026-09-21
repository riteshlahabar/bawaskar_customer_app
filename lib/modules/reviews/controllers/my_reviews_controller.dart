import 'package:get/get.dart';

import '../../../app/data/models/review_model.dart';
import '../../../app/data/services/review_api_service.dart';

/// The customer's own submitted reviews, with their moderation status — a
/// review never appears on a product page until an admin approves it, so
/// this is the only place a customer can see that it was received at all.
class MyReviewsController extends GetxController {
  MyReviewsController(this._api);

  final ReviewApiService _api;

  final reviews = <ReviewModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  bool get isEmpty => reviews.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      reviews.assignAll(await _api.mine());
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
