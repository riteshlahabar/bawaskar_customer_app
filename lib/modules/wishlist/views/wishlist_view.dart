import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../../../app/widgets/product_image.dart';
import '../controllers/wishlist_controller.dart';
import '../../../app/localization/t.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('menu.wishlist'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return LoadingView(message: t('wishlist.loading'));
        }
        if (controller.isEmpty) {
          return EmptyState(
            title: t('wishlist.empty_title'),
            message: t('wishlist.empty_message'),
            icon: Icons.favorite_border,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.items.length,
            itemBuilder: (context, index) {
              final item = controller.items[index];

              return AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                onTap: () => Get.toNamed<void>(
                  AppRoutes.productDetail,
                  arguments: item.toProduct(),
                ),
                child: Row(
                  children: [
                    ProductImage(
                      imageUrl: item.imageUrl,
                      width: 64,
                      height: 64,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${item.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          if (!item.isActive)
                            Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                t('wishlist.unavailable'),
                                style: TextStyle(color: AppColors.danger, fontSize: 11.5),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: t('common.remove'),
                      icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                      onPressed: () => controller.remove(item.productId),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
