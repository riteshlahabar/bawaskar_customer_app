import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/localization/t.dart';
import 'auth_submit_button.dart';
import 'mobile_number_field.dart';

/// Mobile OTP login — customers sign in with their mobile number alone. The
/// name still travels with the OTP request when signup filled it in; it is
/// just not asked for here.
class MobileLoginForm extends StatelessWidget {
  const MobileLoginForm({
    super.key,
    required this.mobileController,
    required this.isLoading,
    required this.onSubmit,
  });

  final TextEditingController mobileController;
  final RxBool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileNumberField(controller: mobileController),
        const SizedBox(height: 20),
        Obx(
          () => AuthSubmitButton(
            label: t('auth.send_otp'),
            isLoading: isLoading.value,
            onPressed: onSubmit,
          ),
        ),
      ],
    );
  }
}
