import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/localization/t.dart';
import 'auth_info_note.dart';
import 'auth_submit_button.dart';
import 'mobile_number_field.dart';

/// Mobile OTP login — customers sign in with their mobile number, name optional.
class MobileLoginForm extends StatelessWidget {
  const MobileLoginForm({
    super.key,
    required this.mobileController,
    required this.nameController,
    required this.isLoading,
    required this.onSubmit,
  });

  final TextEditingController mobileController;
  final TextEditingController nameController;
  final RxBool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MobileNumberField(controller: mobileController),
        const SizedBox(height: 14),
        TextField(
          controller: nameController,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline_rounded),
            labelText: t('auth.name_optional'),
          ),
        ),
        const SizedBox(height: 14),
        AuthInfoNote(
          icon: Icons.sms_outlined,
          text: t('auth.otp_subtitle'),
        ),
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
