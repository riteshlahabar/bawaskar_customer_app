import 'package:get/get.dart';

import '../../modules/addresses/bindings/addresses_binding.dart';
import '../../modules/addresses/views/addresses_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/otp_view.dart';
import '../../modules/auth/views/signup_view.dart';
import '../../modules/cart/bindings/cart_binding.dart';
import '../../modules/cart/views/cart_view.dart';
import '../../modules/checkout/bindings/checkout_binding.dart';
import '../../modules/checkout/views/checkout_view.dart';
import '../../modules/invoices/bindings/invoices_binding.dart';
import '../../modules/invoices/views/invoices_view.dart';
import '../../modules/main_shell/bindings/main_shell_binding.dart';
import '../../modules/main_shell/views/main_shell_view.dart';
import '../../modules/notifications/bindings/notifications_binding.dart';
import '../../modules/notifications/views/notifications_view.dart';
import '../../modules/offers/bindings/offers_binding.dart';
import '../../modules/offers/views/offers_view.dart';
import '../../modules/order_tracking/bindings/order_tracking_binding.dart';
import '../../modules/order_tracking/views/order_tracking_view.dart';
import '../../modules/product_detail/bindings/product_detail_binding.dart';
import '../../modules/product_detail/views/product_detail_view.dart';
import '../../modules/returns/bindings/returns_binding.dart';
import '../../modules/returns/views/returns_view.dart';
import '../../modules/reviews/bindings/write_review_binding.dart';
import '../../modules/reviews/views/write_review_view.dart';
import '../../modules/splash/bindings/splash_binding.dart';
import '../../modules/splash/views/splash_view.dart';
import '../../modules/support/bindings/support_binding.dart';
import '../../modules/support/views/support_view.dart';
import '../../modules/wishlist/bindings/wishlist_binding.dart';
import '../../modules/wishlist/views/wishlist_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashView(), binding: SplashBinding()),
    GetPage(name: AppRoutes.login, page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.signup, page: () => const SignupView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.otp, page: () => const OtpView(), binding: AuthBinding()),
    GetPage(name: AppRoutes.main, page: () => const MainShellView(), binding: MainShellBinding()),
    GetPage(name: AppRoutes.productDetail, page: () => const ProductDetailView(), binding: ProductDetailBinding()),
    GetPage(name: AppRoutes.cart, page: () => const CartView(), binding: CartBinding()),
    GetPage(name: AppRoutes.checkout, page: () => const CheckoutView(), binding: CheckoutBinding()),
    GetPage(name: AppRoutes.addresses, page: () => const AddressesView(), binding: AddressesBinding()),
    GetPage(name: AppRoutes.support, page: () => const SupportView(), binding: SupportBinding()),
    GetPage(name: AppRoutes.wishlist, page: () => const WishlistView(), binding: WishlistBinding()),
    GetPage(name: AppRoutes.notifications, page: () => const NotificationsView(), binding: NotificationsBinding()),
    GetPage(name: AppRoutes.offers, page: () => const OffersView(), binding: OffersBinding()),
    GetPage(name: AppRoutes.orderTracking, page: () => const OrderTrackingView(), binding: OrderTrackingBinding()),
    GetPage(name: AppRoutes.invoices, page: () => const InvoicesView(), binding: InvoicesBinding()),
    GetPage(name: AppRoutes.returns, page: () => const ReturnsView(), binding: ReturnsBinding()),
    GetPage(name: AppRoutes.writeReview, page: () => const WriteReviewView(), binding: WriteReviewBinding()),
  ];
}
