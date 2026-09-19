import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/localization/t.dart';
import '../../../../app/theme/app_colors.dart';
import 'auth_submit_button.dart';
import 'password_field.dart';

/// Email + password login fields.
class EmailLoginForm extends StatelessWidget {
  const EmailLoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSubmit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final RxBool isLoading;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email_outlined),
            labelText: t('auth.email_address'),
          ),
        ),
        const SizedBox(height: 14),
        PasswordField(controller: passwordController, onSubmitted: onSubmit),
        const SizedBox(height: 24),
        Obx(
          () => AuthSubmitButton(
            label: t('common.login'),
            isLoading: isLoading.value,
            onPressed: onSubmit,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          t('auth.otp_primary_note'),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5, height: 1.4),
        ),
      ],
    );
  }
}
