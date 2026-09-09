import 'package:flutter/foundation.dart';

/// Backend endpoint catalogue for the customer app.
///
/// The host is supplied at build time (`--dart-define=API_BASE_URL=...`) so a
/// staging build never ships pointing at production, and vice versa.
class ApiConfig {
  ApiConfig._();

  // Android emulator: http://10.0.2.2:8000/api/v1
  // Physical device: your PC/server IP, or the live domain below.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://drbawasakar.turnkeyinfotech.live/api/v1',
  );

  static const int timeoutSeconds = 30;

  /// Refuses to start a release build that would send bearer tokens over
  /// plaintext HTTP. Debug builds may still target a local `http://` server.
  static void assertSecureBaseUrl() {
    if (kReleaseMode && !baseUrl.startsWith('https://')) {
      throw StateError(
        'Insecure API_BASE_URL "$baseUrl": release builds require HTTPS.',
      );
    }
  }

  // --- Auth -----------------------------------------------------------------
  static const String requestOtp = '/auth/otp/request';
  static const String verifyCustomerOtp = '/auth/customer/otp/verify';
  static const String emailLogin = '/auth/customer/login';
  static const String signup = '/auth/customer/register';
  static const String logout = '/auth/logout';

  // --- Public catalogue -----------------------------------------------------
  static const String categories = '/catalog/categories';
  static const String products = '/catalog/products';
  static const String homepage = '/catalog/homepage';
  static const String translations = '/translations';

  // --- Account --------------------------------------------------------------
  static const String customerDashboard = '/customer/dashboard';
  static const String customerProfile = '/customer/profile';
  static const String customerAddresses = '/customer/addresses';
  static const String customerOrders = '/customer/orders';
  static const String customerSupport = '/customer/support';

  static String customerOrder(int id) => '/customer/orders/$id';
  static String customerAddress(int id) => '/customer/addresses/$id';

  // --- Wishlist -------------------------------------------------------------
  static const String wishlist = '/customer/wishlist';
  static String wishlistItem(int productId) => '/customer/wishlist/$productId';

  // --- Order tracking, invoices, returns ------------------------------------
  static String orderTracking(int orderId) =>
      '/customer/orders/$orderId/tracking';
  static const String invoices = '/customer/invoices';
  static String invoice(int id) => '/customer/invoices/$id';
  static const String returns = '/customer/returns';
  static String returnRequest(int id) => '/customer/returns/$id';

  // --- Offers ---------------------------------------------------------------
  static const String offers = '/customer/offers';
  static const String validateCoupon = '/customer/offers/validate';

  // --- Notifications --------------------------------------------------------
  static const String notifications = '/customer/notifications';
  static const String notificationsRead = '/customer/notifications/read';

  // --- Reviews --------------------------------------------------------------
  static String productReviews(int productId) =>
      '/catalog/products/$productId/reviews';
  static const String reviews = '/customer/reviews';

  // --- Support --------------------------------------------------------------
  static const String supportTickets = '/customer/support/tickets';
  static String supportTicket(int id) => '/customer/support/tickets/$id';
}
