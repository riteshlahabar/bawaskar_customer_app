import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../../../app/widgets/product_image.dart';
import '../controllers/wishlist_controller.dart';

class WishlistView extends GetView<WishlistController> {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const LoadingView(message: 'Loading your wishlist...');
        }
        if (controller.isEmpty) {
          return const EmptyState(
            title: 'Nothing saved yet',
            message: 'Tap the heart on any product to keep it here for later.',
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
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Text(
                                'Currently unavailable',
                                style: TextStyle(color: AppColors.danger, fontSize: 11.5),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove',
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
