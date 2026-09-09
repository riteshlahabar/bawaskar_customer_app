import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/cart_service.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../cart/views/cart_view.dart';
import '../../catalog/views/catalog_view.dart';
import '../../home/views/home_view.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../orders/views/orders_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_shell_controller.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeView(),
      CatalogView(),
      _ProtectedTab(
        title: 'Login Required',
        message: 'Please login or create an account to view your cart.',
        child: CartView(),
      ),
      _ProtectedTab(
        title: 'Login Required',
        message: 'Please login or create an account to view your orders.',
        child: OrdersView(),
      ),
      _ProtectedTab(
        title: 'Login Required',
        message: 'Please login or create an account to manage your profile.',
        child: ProfileView(),
      ),
    ];
    final cart = Get.find<CartService>();
    final auth = Get.find<AuthStorage>();

    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(controller.currentTitle),
            actions: [
              if (!auth.isLoggedIn)
                TextButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: const Text('Login', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                )
              else
                IconButton(
                  onPressed: () => Get.toNamed<void>(AppRoutes.notifications),
                  icon: Obx(() {
                    final unread = Get.find<NotificationsController>().unreadCount.value;
                    return Badge(
                      isLabelVisible: unread > 0,
                      label: Text(unread.toString()),
                      backgroundColor: AppColors.orange,
                      child: const Icon(Icons.notifications_none_rounded),
                    );
                  }),
                ),
              const SizedBox(width: 4),
            ],
          ),
          body: IndexedStack(index: controller.selectedIndex.value, children: pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: controller.changeTab,
            destinations: [
              const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
              const NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view_rounded), label: 'Category'),
              NavigationDestination(
                icon: Obx(() => Badge(
                      isLabelVisible: cart.totalItems > 0,
                      label: Text(cart.totalItems.toString()),
                      backgroundColor: AppColors.orange,
                      child: const Icon(Icons.shopping_cart_outlined),
                    )),
                selectedIcon: const Icon(Icons.shopping_cart_rounded),
                label: 'Cart',
              ),
              const NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long_rounded), label: 'Orders'),
              const NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
            ],
          ),
        ));
  }
}

class _ProtectedTab extends StatelessWidget {
  const _ProtectedTab({required this.title, required this.message, required this.child});

  final String title;
  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (Get.find<AuthStorage>().isLoggedIn) return child;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.lock_outline_rounded, color: AppColors.primary, size: 34),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.45)),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              child: const Text('Login / Signup'),
            ),
          ],
        ),
      ),
    );
  }
}
