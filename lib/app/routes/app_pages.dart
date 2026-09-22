import 'package:get/get.dart';

import '../../modules/addresses/bindings/addresses_binding.dart';
import '../../modules/addresses/views/addresses_view.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/otp_view.dart';
import '../../modules/auth/views/signup_view.dart';
import '../../modules/cart/bindings/cart_binding.dart';
import '../../modules/change_password/bindings/change_password_binding.dart';
import '../../modules/change_password/views/change_password_view.dart';
import '../../modules/cart/views/cart_view.dart';
import '../../modules/checkout/bindings/checkout_binding.dart';
import '../../modules/checkout/views/checkout_view.dart';
import '../../modules/invoices/bindings/invoice_detail_binding.dart';
import '../../modules/invoices/bindings/invoices_binding.dart';
import '../../modules/invoices/views/invoice_detail_view.dart';
import '../../modules/invoices/views/invoices_view.dart';
import '../../modules/language/bindings/language_binding.dart';
import '../../modules/language/views/language_view.dart';
import '../../modules/main_shell/bindings/main_shell_binding.dart';
import '../../modules/main_shell/views/main_shell_view.dart';
import '../../modules/main_shell/views/widgets/menu_shell.dart';
import '../../modules/notifications/bindings/notifications_binding.dart';
import '../../modules/notifications/views/notifications_view.dart';
import '../../modules/offers/bindings/offers_binding.dart';
import '../../modules/offers/views/offers_view.dart';
import '../../modules/order_tracking/bindings/order_tracking_binding.dart';
import '../../modules/order_tracking/views/order_details_view.dart';
import '../../modules/order_tracking/views/order_tracking_view.dart';
import '../../modules/profile/bindings/edit_profile_binding.dart';
import '../../modules/profile/views/account_view.dart';
import '../../modules/profile/views/edit_profile_view.dart';
import '../../modules/product_detail/bindings/product_detail_binding.dart';
import '../../modules/product_detail/views/product_detail_view.dart';
import '../../modules/returns/bindings/returns_binding.dart';
import '../../modules/returns/views/returns_view.dart';
import '../../modules/reviews/bindings/my_reviews_binding.dart';
import '../../modules/reviews/bindings/write_review_binding.dart';
import '../../modules/reviews/views/my_reviews_view.dart';
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
    GetPage(name: AppRoutes.orderTracking, page: () => const OrderTrackingView(), binding: OrderTrackingBinding()),
    GetPage(name: AppRoutes.orderDetails, page: () => const OrderDetailsView(), binding: OrderTrackingBinding()),

    // Menu screens (Order History chips): MenuShell keeps the chips and the
    // bottom navigation bar visible. ProfileController lives in MainShellBinding.
    GetPage(name: AppRoutes.account, page: () => const MenuShell(route: AppRoutes.account, child: AccountView())),
    GetPage(name: AppRoutes.editProfile, page: () => const MenuShell(route: AppRoutes.account, child: EditProfileView()), binding: EditProfileBinding()),
    GetPage(name: AppRoutes.wishlist, page: () => const MenuShell(route: AppRoutes.wishlist, child: WishlistView()), binding: WishlistBinding()),
    GetPage(name: AppRoutes.offers, page: () => const MenuShell(route: AppRoutes.offers, child: OffersView()), binding: OffersBinding()),
    GetPage(name: AppRoutes.invoices, page: () => const MenuShell(route: AppRoutes.invoices, child: InvoicesView()), binding: InvoicesBinding()),
    GetPage(name: AppRoutes.invoiceDetail, page: () => const InvoiceDetailView(), binding: InvoiceDetailBinding()),
    GetPage(name: AppRoutes.returns, page: () => const MenuShell(route: AppRoutes.returns, child: ReturnsView()), binding: ReturnsBinding()),
    GetPage(name: AppRoutes.notifications, page: () => const MenuShell(route: AppRoutes.notifications, child: NotificationsView()), binding: NotificationsBinding()),
    GetPage(name: AppRoutes.addresses, page: () => const MenuShell(route: AppRoutes.addresses, child: AddressesView()), binding: AddressesBinding()),
    GetPage(name: AppRoutes.support, page: () => const MenuShell(route: AppRoutes.support, child: SupportView()), binding: SupportBinding()),
    GetPage(name: AppRoutes.changePassword, page: () => const MenuShell(route: AppRoutes.changePassword, child: ChangePasswordView()), binding: ChangePasswordBinding()),
    GetPage(name: AppRoutes.language, page: () => const MenuShell(route: AppRoutes.language, child: LanguageView()), binding: LanguageBinding()),
    GetPage(name: AppRoutes.writeReview, page: () => const WriteReviewView(), binding: WriteReviewBinding()),
    GetPage(name: AppRoutes.myReviews, page: () => const MenuShell(route: AppRoutes.myReviews, child: MyReviewsView()), binding: MyReviewsBinding()),
  ];
}
