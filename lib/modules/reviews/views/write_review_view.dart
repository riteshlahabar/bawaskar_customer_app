import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../controllers/write_review_controller.dart';

class WriteReviewView extends GetView<WriteReviewController> {
  const WriteReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.productName,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Your rating',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                ),
                const SizedBox(height: 6),
                Obx(() => Row(
                      children: List.generate(5, (index) {
                        final star = index + 1;
                        final filled = star <= controller.rating.value;

                        return IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
                          onPressed: () => controller.setRating(star),
                          icon: Icon(
                            filled ? Icons.star_rounded : Icons.star_border_rounded,
                            color: filled ? AppColors.accent : AppColors.border,
                            size: 32,
                          ),
                        );
                      }),
                    )),
                const SizedBox(height: 14),
                TextField(
                  controller: controller.titleInput,
                  decoration: const InputDecoration(labelText: 'Title (optional)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller.bodyInput,
                  minLines: 4,
                  maxLines: 7,
                  decoration: const InputDecoration(
                    labelText: 'What did you think? (optional)',
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(
                      onPressed: controller.isSubmitting.value ? null : controller.submit,
                      child: Text(
                        controller.isSubmitting.value ? 'Submitting...' : 'Submit Review',
                      ),
                    )),
                const SizedBox(height: 8),
                const Text(
                  'Reviews are published after a quick moderation check.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
