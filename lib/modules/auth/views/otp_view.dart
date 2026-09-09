import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 68),
          const SizedBox(height: 18),
          const Text('OTP Verification', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Obx(() => Text('Enter OTP sent to ${controller.mobile.value}', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13))),
          const SizedBox(height: 26),
          TextField(
            controller: controller.otpController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: 8),
            decoration: const InputDecoration(counterText: '', labelText: '6 Digit OTP'),
          ),
          const SizedBox(height: 20),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.verifyOtp,
                child: Text(controller.isLoading.value ? 'Verifying...' : 'Verify & Continue'),
              )),
          TextButton(onPressed: controller.requestOtp, child: const Text('Resend OTP')),
        ],
      ),
    );
  }
}
