import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class SignupView extends GetView<AuthController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(20)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer Registration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                SizedBox(height: 6),
                Text('Register free. Product purchase and order tracking will be available after login.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextField(controller: controller.signupName, decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupMobile, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone_android))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupEmail, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email Address (optional)', prefixIcon: Icon(Icons.email_outlined))),
          const SizedBox(height: 12),
          TextField(controller: controller.signupPassword, obscureText: true, decoration: const InputDecoration(labelText: 'Password (optional)', prefixIcon: Icon(Icons.lock_outline))),
          const SizedBox(height: 22),
          Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.signup,
                child: Text(controller.isLoading.value ? 'Creating...' : 'Create & Verify OTP'),
              )),
        ],
      ),
    );
  }
}
