import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../location/controllers/location_form_controller.dart';
import '../../location/views/location_form_fields.dart';
import '../controllers/auth_controller.dart';
import '../../../app/localization/t.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    final location = Get.find<LocationFormController>();

    return Scaffold(
      appBar: AppBar(title: Text(t('auth.create_account_title'))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('auth.customer_registration'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                Text(t('auth.register_free'), style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextField(controller: controller.signupName, decoration: InputDecoration(labelText: t('address.full_name'), prefixIcon: const Icon(Icons.person_outline))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupMobile, keyboardType: TextInputType.phone, decoration: InputDecoration(labelText: t('address.mobile'), prefixIcon: const Icon(Icons.phone_android))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupEmail, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(labelText: t('auth.email_address_optional'), prefixIcon: const Icon(Icons.email_outlined))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupPassword, obscureText: true, decoration: InputDecoration(labelText: t('auth.password_optional'), prefixIcon: const Icon(Icons.lock_outline))),
          const SizedBox(height: 12),
          LocationFormFields(controller: location),
          const SizedBox(height: 22),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (location.ensureValid()) controller.signup(location: location.payload);
                      },
                child: Text(controller.isLoading.value ? t('auth.creating') : t('auth.create_verify')),
              )),
        ],
      ),
    );
  }
}
