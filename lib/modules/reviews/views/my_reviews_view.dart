import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/my_reviews_controller.dart';
import '../../../app/localization/t.dart';

class MyReviewsView extends GetView<MyReviewsController> {
  const MyReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('reviews.my_reviews'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.reviews.isEmpty) {
          return LoadingView(message: t('reviews.loading'));
        }
        if (controller.isEmpty) {
          return EmptyState(
            title: t('reviews.empty_title'),
            message: t('reviews.empty_message'),
            icon: Icons.star_outline_rounded,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.reviews.length,
            itemBuilder: (context, index) {
              final review = controller.reviews[index];

              return AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            review.productName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13.5),
                          ),
                        ),
                        _StatusChip(status: review.status),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < review.rating ? Icons.star_rounded : Icons.star_border_rounded,
                          size: 16,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    if (review.title.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(review.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                    ],
                    if (review.body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        review.body,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12.5, height: 1.4, color: AppColors.textSecondary),
                      ),
                    ],
                    if (review.isPending) ...[
                      const SizedBox(height: 8),
                      Text(
                        t('reviews.pending_note'),
                        style: const TextStyle(fontSize: 11, color: AppColors.orange, fontWeight: FontWeight.w600),
                      ),
                    ],
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'approved' => AppColors.success,
      'rejected' => AppColors.danger,
      _ => AppColors.orange,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 10.5),
      ),
    );
  }
}
