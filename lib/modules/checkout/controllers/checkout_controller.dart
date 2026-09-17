import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/models/address_model.dart';
import '../../../app/data/services/address_selection_service.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/localization/t.dart';

class CheckoutController extends GetxController {
  CheckoutController(this._api, this.cart, this.addresses);

  final CustomerApiService _api;
  final CartService cart;
  final AddressSelectionService addresses;

  final name = TextEditingController();
  final mobile = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final pincode = TextEditingController();
  final notes = TextEditingController();
  final paymentMethod = 'COD'.obs;
  final isLoading = false.obs;

  Worker? _addressWorker;

  @override
  void onInit() {
    super.onInit();
    // The chosen saved address fills the delivery form; it stays editable.
    _addressWorker = ever<AddressModel?>(addresses.selected, _fill);
    _fill(addresses.selected.value);
  }

  @override
  void onReady() {
    super.onReady();
    if (addresses.addresses.isEmpty) addresses.load();
  }

  void _fill(AddressModel? selected) {
    if (selected == null) return;
    name.text = selected.name;
    mobile.text = selected.mobile;
    address.text = [selected.line1, selected.line2].where((part) => part.isNotEmpty).join(', ');
    city.text = selected.city;
    state.text = selected.state;
    pincode.text = selected.pincode;
  }

  Future<void> placeOrder() async {
    if (name.text.trim().isEmpty ||
        mobile.text.trim().length < 10 ||
        address.text.trim().isEmpty ||
        city.text.trim().isEmpty ||
        state.text.trim().isEmpty ||
        pincode.text.trim().isEmpty) {
      Get.snackbar(
        t('address.required'),
        t('checkout.address_required_message'),
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
      Get.snackbar(t('checkout.order_placed'), t('checkout.order_placed_message'));
    } catch (error) {
      Get.snackbar(t('checkout.order_failed'), error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _addressWorker?.dispose();
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
