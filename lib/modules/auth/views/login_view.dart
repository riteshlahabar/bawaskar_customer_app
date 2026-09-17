import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../../../app/localization/t.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
          children: [
            const SizedBox(height: 8),
            _brandHeader(),
            const SizedBox(height: 28),
            Text(t('auth.welcome_back'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(t('auth.customer_login_subtitle'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 24),
            _modeSwitch(),
            const SizedBox(height: 18),
            Obx(() => controller.loginMode.value == 0 ? _mobileLogin() : _emailLogin()),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t('auth.new_customer'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.signup),
                  child: Text(t('auth.create_account'), style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _brandHeader() {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 30),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bawaskar Customer', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              SizedBox(height: 2),
              Text(t('auth.brand_tagline'), style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _modeSwitch() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            _modeItem(t('auth.mobile_otp'), 0),
            _modeItem(t('auth.email_login'), 1),
          ],
        ),
      );
    });
  }

  Widget _modeItem(String title, int index) {
    final active = controller.loginMode.value == index;
    return Expanded(
      child: InkWell(
        onTap: () => controller.loginMode.value = index,
        borderRadius: BorderRadius.circular(13),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: active ? Colors.white : AppColors.primary, fontSize: 12.5, fontWeight: FontWeight.w800),
          ),
        ),
      ),
    );
  }

  Widget _mobileLogin() {
    return Column(
      children: [
        TextField(
          controller: controller.mobileController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(prefixIcon: const Icon(Icons.phone_android_rounded), labelText: t('address.mobile')),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.nameController,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(prefixIcon: const Icon(Icons.person_outline), labelText: t('auth.name_optional')),
        ),
        const SizedBox(height: 20),
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.requestOtp,
              child: Text(controller.isLoading.value ? t('auth.sending_otp') : t('auth.send_otp')),
            )),
      ],
    );
  }

  Widget _emailLogin() {
    return Column(
      children: [
        TextField(
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(prefixIcon: const Icon(Icons.email_outlined), labelText: t('auth.email_address')),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller.passwordController,
          obscureText: true,
          decoration: InputDecoration(prefixIcon: const Icon(Icons.lock_outline), labelText: t('auth.password')),
        ),
        const SizedBox(height: 20),
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.loginWithEmail,
              child: Text(controller.isLoading.value ? t('auth.checking') : t('common.login')),
            )),
        const SizedBox(height: 10),
        Text(t('auth.otp_primary_note'), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5)),
      ],
    );
  }
}
