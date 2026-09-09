import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/customer_api_service.dart';
import '../../../app/routes/app_routes.dart';

class ProfileController extends GetxController {
  ProfileController(this._api, this._storage);

  final CustomerApiService _api;
  final AuthStorage _storage;
  final isLoading = false.obs;
  final profile = <String, dynamic>{}.obs;

  String get name => _storage.userName ?? 'Customer';
  String get mobile => _storage.mobile ?? '';
  String get email => _storage.email ?? '';

  @override
  void onReady() {
    super.onReady();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final response = await _api.profile();
      profile.value = Map<String, dynamic>.from((response['data'] ?? const {}) as Map);
    } catch (_) {
      profile.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try { await _api.logout(); } catch (_) {}
    await _storage.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
