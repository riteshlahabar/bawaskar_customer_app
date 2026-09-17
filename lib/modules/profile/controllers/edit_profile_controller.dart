import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/customer_api_service.dart';
import '../../../app/utils/profile_fields.dart';
import '../../location/controllers/location_form_controller.dart';
import 'profile_controller.dart';
import '../../../app/localization/t.dart';

class EditProfileController extends GetxController {
  EditProfileController(this._api, this._profile, this.location);

  final CustomerApiService _api;
  final ProfileController _profile;
  final LocationFormController location;

  final name = TextEditingController();
  final email = TextEditingController();
  final birthDate = Rxn<DateTime>();

  /// Language code (en / mr / hi), or empty when not chosen.
  final language = ''.obs;
  final isSaving = false.obs;

  String get mobile {
    final value = ProfileFields.text(_profile.user['mobile']);
    return value.isNotEmpty ? value : _profile.mobile;
  }

  @override
  void onInit() {
    super.onInit();
    final user = _profile.user;
    final customer = ProfileFields.map(user['customer_profile']);

    name.text = ProfileFields.text(user['name']).isNotEmpty ? ProfileFields.text(user['name']) : _profile.name;
    email.text = ProfileFields.realEmail(ProfileFields.text(user['email']));
    birthDate.value = DateTime.tryParse(ProfileFields.text(customer['date_of_birth']));

    final code = ProfileFields.text(customer['preferred_language']);
    language.value = ProfileFields.languages.containsKey(code) ? code : '';
    location.prefill(user);
  }

  Future<void> pickBirthDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate.value ?? DateTime(now.year - 25),
      firstDate: DateTime(1920),
      lastDate: now.subtract(const Duration(days: 1)),
    );
    if (picked != null) birthDate.value = picked;
  }

  Future<void> save() async {
    if (name.text.trim().isEmpty) {
      Get.snackbar(t('common.required'), t('profile.enter_name'));
      return;
    }
    if (email.text.trim().isNotEmpty && !GetUtils.isEmail(email.text.trim())) {
      Get.snackbar(t('auth.invalid_email'), t('auth.enter_valid_email'));
      return;
    }
    if (!location.ensureValid()) return;

    final date = birthDate.value;

    isSaving.value = true;
    try {
      await _api.updateProfile({
        'name': name.text.trim(),
        'email': email.text.trim().isEmpty ? null : email.text.trim(),
        'date_of_birth': date == null
            ? null
            : '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'preferred_language': language.value.isEmpty ? null : language.value,
        ...location.payload,
      });
      await _profile.loadProfile();
      Get.back<void>();
      Get.snackbar(t('profile.updated'), t('profile.updated_message'));
    } catch (error) {
      Get.snackbar(t('profile.update_failed'), error.toString());
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    super.onClose();
  }
}
