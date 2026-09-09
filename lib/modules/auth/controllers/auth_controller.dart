import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../../app/routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this._api, this._storage);

  final CustomerApiService _api;
  final AuthStorage _storage;

  final loginMode = 0.obs; // 0 mobile OTP, 1 email password
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final otpController =
    TextEditingController();

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
      Get.snackbar('Mobile Required', 'Enter valid mobile number.');
      return;
    }
    isLoading.value = true;
    try {
      await _api.requestOtp(enteredMobile);
      mobile.value = enteredMobile;
      nameForOtp.value = nameController.text.trim();
      Get.toNamed(AppRoutes.otp);
    } catch (error) {
      Get.snackbar('OTP Failed', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().length != 6) {
      Get.snackbar('OTP Required', 'Enter 6 digit OTP.');
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
      Get.snackbar('Login Failed', error.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmail() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Email Required', 'Enter a valid email address.');
      return;
    }
    if (password.length < 6) {
      Get.snackbar('Password Required', 'Password must be at least 6 characters.');
      return;
    }
    isLoading.value = true;
    try {
      final response = await _api.emailLogin(email: email, password: password);
      await _saveFromResponse(response, fallbackEmail: email);
      Get.offAllNamed(AppRoutes.main);
   } catch (error) {
  Get.snackbar(
    'Login Failed',
    error.toString(),
  );
}finally {
      isLoading.value = false;
    }
  }

  Future<void> signup() async {
    final name = signupName.text.trim();
    final mobileNo = signupMobile.text.trim();
    final email = signupEmail.text.trim();
    if (name.length < 3) {
      Get.snackbar('Name Required', 'Enter customer full name.');
      return;
    }
    if (mobileNo.length < 10) {
      Get.snackbar('Mobile Required', 'Enter valid mobile number.');
      return;
    }
    if (email.isNotEmpty && !GetUtils.isEmail(email)) {
      Get.snackbar('Invalid Email', 'Enter valid email address or leave it blank.');
      return;
    }
    isLoading.value = true;
    try {
      await _api.signup(
        name: name,
        mobile: mobileNo,
        email: email,
        password: signupPassword.text.trim(),
      );
      mobileController.text = mobileNo;
      nameController.text = name;
      await requestOtp();
    } catch (error) {
  Get.snackbar(
    'Signup Failed',
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
    throw const FormatException(
      'Invalid login response from server.',
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
    throw const FormatException(
      'Login token missing from server response.',
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
            : 'Customer'),
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
