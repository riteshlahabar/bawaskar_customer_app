import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/offer_model.dart';
import '../../../app/data/services/offer_api_service.dart';

/// Lists live offers and applies a coupon code against a cart value.
///
/// The discount always comes back from the server; this controller only
/// carries the answer, it never derives one.
class OffersController extends GetxController {
  OffersController(this._api);

  final OfferApiService _api;

  final offers = <OfferModel>[].obs;
  final isLoading = false.obs;
  final isApplying = false.obs;
  final error = ''.obs;
  final applied = Rxn<AppliedCouponModel>();
  final codeInput = TextEditingController();

  bool get isEmpty => offers.isEmpty && !isLoading.value;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      offers.assignAll(await _api.list());
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void useCode(String code) {
    codeInput.text = code;
  }

  Future<bool> apply(double orderValue) async {
    final code = codeInput.text.trim();
    if (code.isEmpty) {
      Get.snackbar('Coupon', 'Enter a coupon code.');
      return false;
    }

    isApplying.value = true;
    try {
      applied.value = await _api.validate(code: code, orderValue: orderValue);
      return true;
    } catch (failure) {
      applied.value = null;
      Get.snackbar('Coupon', failure.toString());
      return false;
    } finally {
      isApplying.value = false;
    }
  }

  void clear() {
    applied.value = null;
    codeInput.clear();
  }

  @override
  void onClose() {
    codeInput.dispose();
    super.onClose();
  }
}
