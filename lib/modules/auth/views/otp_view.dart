import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../../../app/localization/t.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('auth.verify_otp'))),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 68),
          const SizedBox(height: 18),
          Text(t('auth.otp_verification'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Obx(() => Text(t('auth.otp_sent_to', {'mobile': controller.mobile.value}), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
          const SizedBox(height: 26),
          TextField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 8),
            decoration: InputDecoration(counterText: '', labelText: t('auth.otp_label')),
          ),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.verifyOtp,
                child: Text(controller.isLoading.value ? t('auth.verifying') : t('auth.verify_continue')),
              )),
          TextButton(onPressed: controller.requestOtp, child: Text(t('auth.resend_otp'))),
        ],
      ),
    );
  }
}
