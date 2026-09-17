import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/customer_api_service.dart';
import '../../../app/localization/t.dart';

class AddressesController extends GetxController {
  AddressesController(this._api);

  final CustomerApiService _api;
  final name = TextEditingController();
  final mobile = TextEditingController();
  final addressLine = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final pincode = TextEditingController();
  final isLoading = false.obs;

  Future<void> save() async {
    if (name.text.trim().isEmpty ||
    mobile.text.trim().length < 10 ||
    addressLine.text.trim().isEmpty ||
    city.text.trim().isEmpty ||
    state.text.trim().isEmpty ||
    pincode.text.trim().isEmpty) {
  Get.snackbar(
    t('address.required'),
    t('address.required_message'),
  );
  return;
}
    isLoading.value = true;
    try {
      await _api.saveAddress({
        'name': name.text.trim(),
        'mobile': mobile.text.trim(),
        'address_line1': addressLine.text.trim(),
        'city': city.text.trim(),
        'state': state.text.trim(),
        'pincode': pincode.text.trim(),
      });
      Get.back<void>();
      Get.snackbar(t('address.saved_title'), t('address.saved_message'));
    } catch (error) {
      Get.snackbar(t('address.save_failed'), error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose(); mobile.dispose(); addressLine.dispose(); city.dispose(); state.dispose(); pincode.dispose();
    super.onClose();
  }
}
