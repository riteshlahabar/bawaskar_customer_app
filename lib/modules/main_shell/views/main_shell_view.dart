import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/auth_storage.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../cart/views/cart_view.dart';
import '../../catalog/views/catalog_view.dart';
import '../../home/views/home_view.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../orders/views/orders_view.dart';
import '../controllers/main_shell_controller.dart';
import 'widgets/main_nav_bar.dart';
import 'widgets/order_history_tab.dart';
import '../../../app/localization/t.dart';

class MainShellView extends GetView<MainShellController> {
  const MainShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeView(),
      CatalogView(),
      _ProtectedTab(
        title: t('login.required_title'),
        message: t('login.view_cart'),
        child: CartView(),
      ),
      _ProtectedTab(
        title: t('login.required_title'),
        message: t('login.view_orders'),
        child: OrdersView(),
      ),
      _ProtectedTab(
        title: t('login.required_title'),
        message: t('login.view_history'),
        child: OrderHistoryTab(),
      ),
    ];
    final auth = Get.find<AuthStorage>();

    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              controller.currentTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            actions: [
              if (!auth.isLoggedIn)
                TextButton.icon(
                  onPressed: () => Get.toNamed(AppRoutes.login),
                  // White so it stays visible on the green app bar.
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: Text(t('common.login'), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
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
          // Unopened tabs stay empty placeholders, so their screens and API
          // calls only start when the customer first opens them.
          body: IndexedStack(
            index: controller.selectedIndex.value,
            children: [
              for (var i = 0; i < pages.length; i++)
                controller.visitedTabs.contains(i) ? pages[i] : const SizedBox.shrink(),
            ],
          ),
          bottomNavigationBar: MainNavBar(
            selectedIndex: controller.selectedIndex.value,
            onSelected: controller.changeTab,
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
              child: Text(t('login.button')),
            ),
          ],
        ),
      ),
    );
  }
}
