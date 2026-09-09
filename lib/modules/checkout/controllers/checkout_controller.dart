import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../../app/routes/app_routes.dart';

class CheckoutController extends GetxController {
  CheckoutController(this._api, this.cart);

  final CustomerApiService _api;
  final CartService cart;

  final name = TextEditingController();
  final mobile = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final pincode = TextEditingController();
  final notes = TextEditingController();
  final paymentMethod = 'COD'.obs;
  final isLoading = false.obs;

  Future<void> placeOrder() async {
   if (name.text.trim().isEmpty ||
    mobile.text.trim().length < 10 ||
    address.text.trim().isEmpty ||
    city.text.trim().isEmpty ||
    state.text.trim().isEmpty ||
    pincode.text.trim().isEmpty) {
  Get.snackbar(
    'Address Required',
    'Enter delivery name, mobile, address, city, state and pincode.',
  );
  return;
}
    isLoading.value = true;
    try {
      await _api.createOrder(
  cart.toOrderItems(),
  contactName: name.text,
  contactMobile: mobile.text,
  addressLine1: address.text,
  city: city.text,
  state: state.text,
  pincode: pincode.text,
  paymentMethod: paymentMethod.value,
  notes: notes.text,
);
      cart.clear();
      Get.offAllNamed(AppRoutes.main);
      Get.snackbar('Order Placed', 'Your order has been sent to admin for processing.');
    } catch (error) {
      Get.snackbar('Order Failed', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    mobile.dispose();
    address.dispose();
    city.dispose();
    state.dispose();
    pincode.dispose();
    notes.dispose();
    super.onClose();
  }
}
