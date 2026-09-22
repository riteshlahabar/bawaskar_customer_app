import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/data/services/cart_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/product_image.dart';
import '../../../app/widgets/wishlist_button.dart';
import '../../reviews/controllers/product_reviews_controller.dart';
import '../../reviews/views/widgets/product_reviews_section.dart';
import '../controllers/product_detail_controller.dart';
import '../../../app/localization/t.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;
    final cart = Get.find<CartService>();

    // Fired once the first frame is scheduled so the network call never blocks
    // the product page from painting.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Get.find<ProductReviewsController>().loadFor(product.id),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(t('catalog.product_details')),
        actions: [
          WishlistButton(productId: controller.product.id, size: 22, unsavedColor: Colors.white),
          IconButton(
            onPressed: controller.openCart,
            icon: Obx(() => Badge(
                  isLabelVisible: cart.totalItems > 0,
                  label: Text(cart.totalItems.toString()),
                  backgroundColor: AppColors.orange,
                  child: const Icon(Icons.shopping_cart_outlined),
                )),
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 320,
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(24), border: Border.all(color: AppColors.border)),
            clipBehavior: Clip.antiAlias,
            child: ProductImage(imageUrl: product.imageUrl, assetPath: product.assetPath, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(20)),
                      child: Text(product.categoryName.isNotEmpty ? product.categoryName : product.type, style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
                    const Spacer(),
                    const Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                    const Text('4.8', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(product.name, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, height: 1.2)),
                const SizedBox(height: 8),
                Text(product.shortDescription.isNotEmpty ? product.shortDescription : t('catalog.default_short_description'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    const SizedBox(width: 8),
                    if (product.mrp > product.price)
                      Text('₹${product.mrp.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
                    const Spacer(),
                    Text(product.unit, style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 18),
                Text(t('common.description'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const SizedBox(height: 7),
                Text(product.description.isNotEmpty ? product.description : t('catalog.default_description'), style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.6)),
                const SizedBox(height: 22),
                const Divider(color: AppColors.border),
                const SizedBox(height: 10),
                ProductReviewsSection(
                  productId: product.id,
                  productName: product.name,
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
          child: Row(
            children: [
              Obx(() => Container(
                    height: 48,
                    decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(14)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: controller.decrease,
                          icon: const Icon(Icons.remove, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(controller.quantity.value.toString(), style: const TextStyle(fontWeight: FontWeight.w800)),
                        IconButton(
                          onPressed: controller.increase,
                          icon: const Icon(Icons.add, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  )),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.addToCart,
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                  child: Text(
                    t('catalog.add_to_cart'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.buyNow,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4)),
                  child: Text(
                    t('catalog.buy_now'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
