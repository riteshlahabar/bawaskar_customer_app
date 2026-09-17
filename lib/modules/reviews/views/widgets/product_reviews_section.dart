import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/auth_guard.dart';
import '../../controllers/product_reviews_controller.dart';
import '../../../../app/localization/t.dart';

/// Ratings summary, recent reviews and the "write a review" entry point.
class ProductReviewsSection extends StatelessWidget {
  const ProductReviewsSection({
    super.key,
    required this.productId,
    required this.productName,
  });

  final int productId;
  final String productName;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductReviewsController>();

    return Obx(() {
      final reviews = controller.reviews;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                t('reviews.title'),
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  final allowed = AuthGuard.ensureLoggedIn(
                    message: t('login.write_review'),
                  );
                  if (!allowed) return;
                  Get.toNamed<void>(
                    AppRoutes.writeReview,
                    arguments: {
                      'product_id': productId,
                      'product_name': productName,
                    },
                  )?.then((_) => controller.loadFor(productId));
                },
                child: Text(t('reviews.write')),
              ),
            ],
          ),
          if (controller.total > 0)
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColors.accent, size: 18),
                const SizedBox(width: 4),
                Text(
                  controller.average.toStringAsFixed(1),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                ),
                const SizedBox(width: 6),
                Text(
                  t('reviews.count', {'n': '${controller.total}'}),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            )
          else
            Text(
              t('reviews.empty'),
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
            ),
          const SizedBox(height: 10),
          // Only the most recent few: the product page is not a review list.
          ...reviews.take(3).map(
                (review) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < review.rating
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              size: 14,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            review.reviewer.isEmpty ? t('common.customer') : review.reviewer,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                          if (review.verifiedPurchase) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded,
                                size: 13, color: AppColors.primary),
                          ],
                        ],
                      ),
                      if (review.body.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            review.body,
                            style: const TextStyle(fontSize: 12.5, height: 1.4),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
        ],
      );
    });
  }
}
