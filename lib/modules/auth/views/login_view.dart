import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/localization/t.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/email_login_form.dart';
import 'widgets/login_mode_switch.dart';
import 'widgets/mobile_login_form.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: '',
      subtitle: '',
      showBranding: false,
      footer: AuthFooter(
        prompt: t('auth.new_customer'),
        action: t('auth.create_account'),
        onTap: () => Get.toNamed(AppRoutes.signup),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginModeSwitch(
            mode: controller.loginMode,
            onChanged: (index) => controller.loginMode.value = index,
          ),
          const SizedBox(height: 20),
          Obx(
            () => controller.loginMode.value == 0
                ? MobileLoginForm(
                    mobileController: controller.mobileController,
                    isLoading: controller.isLoading,
                    onSubmit: controller.requestOtp,
                  )
                : EmailLoginForm(
                    emailController: controller.emailController,
                    passwordController: controller.passwordController,
                    isLoading: controller.isLoading,
                    onSubmit: controller.loginWithEmail,
                  ),
          ),
        ],
      ),
    );
  }
}
