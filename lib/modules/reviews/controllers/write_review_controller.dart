import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/review_api_service.dart';
import '../../../app/localization/t.dart';

/// Captures a star rating and optional text for one product.
///
/// The product (and optionally the order that proves the purchase) arrives as
/// a route argument.
class WriteReviewController extends GetxController {
  WriteReviewController(this._api);

  final ReviewApiService _api;

  final rating = 0.obs;
  final isSubmitting = false.obs;
  final titleInput = TextEditingController();
  final bodyInput = TextEditingController();

  late final Map<String, dynamic> _arguments = _resolveArguments();

  int get productId => int.tryParse('${_arguments['product_id']}') ?? 0;
  int get orderId => int.tryParse('${_arguments['order_id']}') ?? 0;
  String get productName => _arguments['product_name']?.toString() ?? 'this product';

  Map<String, dynamic> _resolveArguments() {
    final argument = Get.arguments;
    return argument is Map
        ? Map<String, dynamic>.from(argument)
        : <String, dynamic>{};
  }

  void setRating(int value) => rating.value = value;

  Future<void> submit() async {
    if (productId <= 0) {
      Get.snackbar(t('orders.review'), t('reviews.no_product'));
      return;
    }
    if (rating.value < 1) {
      Get.snackbar(t('orders.review'), t('reviews.tap_star'));
      return;
    }

    isSubmitting.value = true;
    try {
      await _api.submit(
        productId: productId,
        rating: rating.value,
        orderId: orderId > 0 ? orderId : null,
        title: titleInput.text,
        body: bodyInput.text,
      );
      Get.back<bool>(result: true);
      Get.snackbar(t('orders.review'), t('reviews.thanks'));
    } catch (failure) {
      Get.snackbar(t('orders.review'), failure.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    titleInput.dispose();
    bodyInput.dispose();
    super.onClose();
  }
}
