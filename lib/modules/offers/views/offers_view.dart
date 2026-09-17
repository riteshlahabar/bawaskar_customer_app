import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_card.dart';
import '../../../app/widgets/empty_state.dart';
import '../../../app/widgets/loading_view.dart';
import '../controllers/offers_controller.dart';
import '../../../app/localization/t.dart';

class OffersView extends GetView<OffersController> {
  const OffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(t('menu.offers'))),
      body: Obx(() {
        if (controller.isLoading.value && controller.offers.isEmpty) {
          return LoadingView(message: t('offers.loading'));
        }
        if (controller.isEmpty) {
          return EmptyState(
            title: t('offers.empty_title'),
            message: t('offers.empty_message'),
            icon: Icons.local_offer_outlined,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.load,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.offers.length,
            itemBuilder: (context, index) {
              final offer = controller.offers[index];

              return AppCard(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            offer.badge,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 11.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            controller.useCode(offer.code);
                            Get.snackbar(t('offers.coupon'), t('offers.code_copied', {'code': offer.code}));
                          },
                          child: Text(t('common.use')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      offer.title,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                    ),
                    if (offer.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        offer.description,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.confirmation_number_outlined,
                            size: 15, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          offer.code,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 12.5,
                            letterSpacing: 1,
                          ),
                        ),
                        const Spacer(),
                        if (offer.minOrderValue > 0)
                          Text(
                            t('offers.min_order', {'amount': '₹${offer.minOrderValue.toStringAsFixed(0)}'}),
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.5,
                            ),
                          ),
                      ],
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
