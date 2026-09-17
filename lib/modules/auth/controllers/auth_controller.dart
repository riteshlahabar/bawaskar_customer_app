import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/localization/t.dart';

class AuthController extends GetxController {
  AuthController(this._api, this._storage);

  final CustomerApiService _api;
  final AuthStorage _storage;

  final loginMode = 0.obs; // 0 mobile OTP, 1 email password
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final otpController = TextEditingController();

  final signupName = TextEditingController();
  final signupMobile = TextEditingController();
  final signupEmail = TextEditingController();
  final signupPassword = TextEditingController();

  final isLoading = false.obs;
  final mobile = ''.obs;
  final nameForOtp = ''.obs;

  Future<void> requestOtp() async {
    final enteredMobile = mobileController.text.trim();
    if (enteredMobile.length < 10) {
      Get.snackbar(t('auth.mobile_required'), t('auth.enter_valid_mobile'));
      return;
    }
    isLoading.value = true;
    try {
      await _api.requestOtp(enteredMobile);
      mobile.value = enteredMobile;
      nameForOtp.value = nameController.text.trim();
      Get.toNamed(AppRoutes.otp);
    } catch (error) {
      Get.snackbar(t('auth.otp_failed'), error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().length != 6) {
      Get.snackbar(t('auth.otp_required'), t('auth.enter_otp'));
      return;
    }
    isLoading.value = true;
    try {
      final response = await _api.verifyOtp(
        mobile: mobile.value,
        otp: otpController.text.trim(),
        name: nameForOtp.value,
      );
      await _saveFromResponse(response, fallbackMobile: mobile.value);
      Get.offAllNamed(AppRoutes.main);
    } catch (error) {
      Get.snackbar(t('auth.login_failed'), error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(t('auth.email_required'), t('auth.enter_valid_email'));
      return;
    }
    if (password.length < 6) {
      Get.snackbar(t('auth.password_required'), t('auth.password_min'));
      return;
    }
    isLoading.value = true;
    try {
      final response = await _api.emailLogin(email: email, password: password);
      await _saveFromResponse(response, fallbackEmail: email);
      Get.offAllNamed(AppRoutes.main);
   } catch (error) {
  Get.snackbar(
    t('auth.login_failed'),
    error.toString(),
  );
}finally {
      isLoading.value = false;
    }
  }

  Future<void> signup({Map<String, dynamic> location = const {}}) async {
    final name = signupName.text.trim();
    final mobileNo = signupMobile.text.trim();
    final email = signupEmail.text.trim();
    if (name.length < 3) {
      Get.snackbar(t('auth.name_required'), t('auth.enter_full_name'));
      return;
    }
    if (mobileNo.length < 10) {
      Get.snackbar(t('auth.mobile_required'), t('auth.enter_valid_mobile'));
      return;
    }
    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      Get.snackbar(t('auth.invalid_email'), t('auth.email_or_blank'));
      return;
    }
    isLoading.value = true;
    try {
      await _api.signup(
        name: name,
        mobile: mobileNo,
        email: email,
        password: signupPassword.text.trim(),
        location: location,
      );
      mobileController.text = mobileNo;
      nameController.text = name;
      await requestOtp();
    } catch (error) {
  Get.snackbar(
    t('auth.signup_failed'),
    error.toString(),
  );
} finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveFromResponse(
  Map<String, dynamic> response, {
  String fallbackMobile = '',
  String fallbackEmail = '',
}) async {
  final rawData =
      response['data'] ?? response;

  if (rawData is! Map) {
    throw FormatException(
      t('auth.invalid_response'),
    );
  }

  final data =
      Map<String, dynamic>.from(rawData);

  final token =
      (data['token'] ??
              data['access_token'])
          ?.toString()
          .trim() ??
      '';

  if (token.isEmpty) {
    throw FormatException(
      t('auth.token_missing'),
    );
  }

  final rawUser = data['user'];

  final user = rawUser is Map
      ? Map<String, dynamic>.from(rawUser)
      : <String, dynamic>{};

  await _storage.saveSession(
    token: token,
    name:
        user['name']?.toString() ??
        (nameForOtp.value.isNotEmpty
            ? nameForOtp.value
            : t('common.customer')),
    mobile:
        user['mobile']?.toString() ??
        fallbackMobile,
    email:
        user['email']?.toString() ??
        fallbackEmail,
  );
}

  @override
  void onClose() {
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    otpController.dispose();
    signupName.dispose();
    signupMobile.dispose();
    signupEmail.dispose();
    signupPassword.dispose();
    super.onClose();
  }
}
