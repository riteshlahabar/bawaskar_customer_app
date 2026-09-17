import 'dart:io';

import 'package:get/get.dart' show FormData, MultipartFile;

import '../../config/api_config.dart';
import '../models/address_model.dart';
import 'api_client.dart';

class CustomerApiService {
  CustomerApiService(this._client);

  final ApiClient _client;

  Future<Map<String, dynamic>> requestOtp(String mobile) {
    return _client.postJson(ApiConfig.requestOtp, {
      'mobile': mobile,
      'purpose': 'customer_login',
    });
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
    String? name,
  }) {
    return _client.postJson(ApiConfig.verifyCustomerOtp, {
      'mobile': mobile,
      'otp': otp,
      if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
    });
  }

  Future<Map<String, dynamic>> emailLogin({
    required String email,
    required String password,
  }) {
    return _client.postJson(ApiConfig.emailLogin, {
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String mobile,
    required String email,
    String? password,
    Map<String, dynamic> location = const {},
  }) {
    return _client.postJson(ApiConfig.signup, {
      ...location,
      'name': name,
      'mobile': mobile,
      'email': email,
      if (password != null && password.isNotEmpty) 'password': password,
      'role': 'customer',
    });
  }

  Future<Map<String, dynamic>> dashboard() =>
      _client.getJson(ApiConfig.customerDashboard);
  Future<Map<String, dynamic>> profile() =>
      _client.getJson(ApiConfig.customerProfile);
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) =>
      _client.postJson(ApiConfig.customerProfile, data);

  Future<Map<String, dynamic>> uploadProfilePhoto(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final filename = filePath.split(RegExp(r'[\\/]')).last;

    return _client.postForm(ApiConfig.profilePhoto, FormData({'photo': MultipartFile(bytes, filename: filename)}));
  }

  Future<Map<String, dynamic>> products({
    String audience = 'customer',
    String? search,
    int? categoryId,
    String? categorySlug,
    int page = 1,
    int perPage = 20,
    // true bypasses the server cache — only for pull-to-refresh.
    bool fresh = false,
  }) {
    return _client.getJson(
      ApiConfig.products,
      query: {
        'audience': audience,
        if (fresh) 'fresh': 1,
        'page': page,
        'per_page': perPage,
        if (search != null && search.trim().isNotEmpty)
          'search': search.trim(),
        if (categoryId != null && categoryId > 0)
          'category_id': categoryId,
        if (categorySlug != null && categorySlug.trim().isNotEmpty)
          'category': categorySlug.trim(),
      },
    );
  }

  Future<Map<String, dynamic>> categories({bool fresh = false}) =>
    _client.getJson(
      ApiConfig.categories,
      query: {
        'audience': 'customer',
        if (fresh) 'fresh': 1,
      },
    );
  Future<Map<String, dynamic>> homepage() =>
      _client.getJson(ApiConfig.homepage, query: {'audience': 'customer'});
  Future<Map<String, dynamic>> orders() =>
      _client.getJson(ApiConfig.customerOrders);

  Future<Map<String, dynamic>> createOrder(
  List<Map<String, dynamic>> items, {
  required String contactName,
  required String contactMobile,
  required String addressLine1,
  required String city,
  required String state,
  required String pincode,
  String addressType = 'shipping',
  String? addressLine2,
  String paymentMethod = 'cod',
  String? notes,
}) {
  return _client.postJson(
    ApiConfig.customerOrders,
    {
      'items': items,

      'contact_name':
          contactName.trim(),

      'contact_mobile':
          contactMobile.trim(),

      'address_type':
          addressType.trim().isEmpty
              ? 'shipping'
              : addressType.trim(),

      'address_line1':
          addressLine1.trim(),

      if (addressLine2 != null &&
          addressLine2.trim().isNotEmpty)
        'address_line2':
            addressLine2.trim(),

      'city': city.trim(),
      'state': state.trim(),
      'pincode': pincode.trim(),

      'payment_method':
          paymentMethod
              .trim()
              .toLowerCase(),

      if (notes != null &&
          notes.trim().isNotEmpty)
        'notes': notes.trim(),
    },
  );
}

  Future<Map<String, dynamic>> saveAddress(Map<String, dynamic> data) =>
      _client.postJson(ApiConfig.customerAddresses, data);

  /// Saved delivery addresses, default first.
  Future<List<AddressModel>> addresses() async {
    final response = await _client.getJson(ApiConfig.customerAddresses);
    final raw = response['data']?['addresses'];

    if (raw is! List) return const [];

    return raw.whereType<Map>().map((item) => AddressModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  Future<Map<String, dynamic>> support({
    required String subject,
    required String message,
  }) {
    return _client.postJson(ApiConfig.customerSupport, {
      'subject': subject,
      'message': message,
    });
  }

  /// False for accounts created by mobile OTP that never set a password.
  Future<bool> hasPassword() async {
    final response = await _client.getJson(ApiConfig.changePassword);
    final value = response['data']?['has_password'];

    return value == true || value == 1;
  }

  Future<Map<String, dynamic>> changePassword({
    String? currentPassword,
    required String password,
    required String confirmation,
  }) {
    return _client.postJson(ApiConfig.changePassword, {
      if (currentPassword != null && currentPassword.isNotEmpty) 'current_password': currentPassword,
      'password': password,
      'password_confirmation': confirmation,
    });
  }

  Future<Map<String, dynamic>> logout() =>
      _client.postJson(ApiConfig.logout, {});
}
