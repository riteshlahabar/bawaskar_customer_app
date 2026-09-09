import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/models/product_model.dart';
import '../data/services/cart_service.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';
import '../utils/auth_guard.dart';
import 'product_image.dart';
import 'wishlist_button.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.compact = false});

  final ProductModel product;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartService>();
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .03),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                      child: Container(
                        width: double.infinity,
                        color: AppColors.primarySoft,
                        child: ProductImage(
                          imageUrl: product.imageUrl,
                          assetPath: product.assetPath,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: WishlistButton(productId: product.id, size: 18),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.25),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFFFB321), size: 14),
                      const SizedBox(width: 2),
                      Text('4.8', style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                      const Spacer(),
                      if (product.unit.isNotEmpty)
                        Text(product.unit, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('₹${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w900, color: AppColors.primary)),
                            if (product.mrp > product.price)
                              Text('₹${product.mrp.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, decoration: TextDecoration.lineThrough)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: ElevatedButton(
                          onPressed: () {
                            final allowed = AuthGuard.ensureLoggedIn(
                              message: 'Please login or sign up before adding products to cart.',
                            );
                            if (!allowed) return;
                            cart.add(product);
                            Get.snackbar('Added', '${product.name} added to cart', snackPosition: SnackPosition.BOTTOM);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
